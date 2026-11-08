# KsTU SRC App — Architecture & Backend Reference

> Scope: Flutter mobile client (`src_kstu_app`, version `1.2.3+7`) and the Laravel REST backend it talks to.
> The backend source code is **not** part of this repository; the backend section below is reverse-engineered from the client's network calls.

---

## 1. High-Level System Overview

```mermaid
flowchart LR
    subgraph Device["Mobile Device (iOS / Android)"]
        APP["Flutter App (src_kstu_app)"]
        SP[("SharedPreferences: token, profile, offline caches")]
        FS[("App Documents / Downloads: PDF forms, saved images")]
    end

    subgraph Backend["app.src-kstu.com (Laravel)"]
        API["REST API /api/v1"]
        STORE["Public storage /storage/*"]
        WEB["Web portal /user/register"]
    end

    OS["OneSignal Push Service"]
    KSTU["KsTU external sites: vclass, student portal, kstu.edu.gh"]
    GMAPS["Google Maps / maps URL launcher"]

    APP -- "HTTPS + Bearer token" --> API
    APP -- "Image / PDF downloads" --> STORE
    APP -- "url_launcher" --> WEB
    APP -- "url_launcher" --> KSTU
    APP -- "url_launcher" --> GMAPS
    OS -- "Push notifications (announcement id)" --> APP
    API -. "Triggers pushes (server side)" .-> OS
    APP <--> SP
    APP <--> FS
```

| Layer | Technology |
|---|---|
| Client | Flutter 3.47.x / Dart 3, Material UI, `google_fonts` (Poppins) |
| State | Riverpod 2 (`flutter_riverpod`, `riverpod_annotation` + codegen) **and** legacy `provider` (`ChangeNotifier`) **and** raw `setState` + `http` |
| Networking | `http` ^1.2.0 (primary), `dio` (file downloads) |
| Persistence | `shared_preferences` (auth token, profile, JSON page caches) |
| Push | `onesignal_flutter` (App ID hard-coded in `main.dart`) |
| Connectivity | `connectivity_plus` ^7 (Riverpod) **and** discontinued `connectivity` ^3 (legacy) |
| Files | `file_picker`, `image_picker`, `path_provider`, `share_plus` |
| Backend | Laravel (JWT/Sanctum-style bearer tokens), base `https://app.src-kstu.com/api/v1` |

---

## 2. Repository Layout

```
lib/
├── main.dart                      # Entry: OneSignal init, ProviderScope + MultiProvider, MaterialApp
├── components/                    # Reusable widgets
│   ├── colors.dart                # topColor / bottomColor / headColor palette
│   ├── side_menu.dart             # Drawer: navigation hub + logout + external links
│   ├── trending_component.dart    # Paginated announcement list (used by Notice Board & Trending)
│   ├── scholarship_forms.dart     # Reusable "download PDF forms" list (scholarships & claims)
│   ├── info_card.dart, random_qoute_generator.dart
├── feature/
│   ├── landmark_container.dart    # Landmark "places" list under a campus map landmark
│   └── pages/                     # All screens (see §5)
├── models/                        # Data models + constant.dart (all endpoint URLs)
├── providers/                     # Riverpod providers (new, codegen *.g.dart)
├── services/                      # Legacy ChangeNotifier providers + user_service.dart (auth API)
└── utils/announcement_sort.dart   # Newest-first sorting of announcements
```

Native shells: `ios/` (Runner, bundle display name **KSTU SRC**, team `T6277BM4RJ`) and `android/`.

---

## 3. Application Bootstrap

```mermaid
sequenceDiagram
    participant M as main()
    participant OS as OneSignal
    participant R as ProviderScope (Riverpod)
    participant P as MultiProvider (legacy)
    participant L as LoadingPage
    participant SP as SharedPreferences

    M->>OS: Debug.setLogLevel(verbose), initialize(APP_ID)
    M->>R: runApp(ProviderScope(...))
    R->>P: MultiProvider(Connectivity, NoticeBoard, TrendingNews, CampusMap, Landmark)
    P->>L: MaterialApp(home: LoadingPage)
    L->>SP: read "token" / "hasOpended"
    alt token present
        L->>L: Navigate -> Dashboard
    else first launch (hasOpended == false)
        L->>L: Navigate -> Onboarding
    else
        L->>L: Navigate -> WelcomeScreenPage -> LoginPage
    end
```

Key points:
- Two DI containers wrap the app: Riverpod `ProviderScope` **outside**, `provider`'s `MultiProvider` **inside**. Every screen can reach both.
- Push permission is requested from the `Dashboard` (not at startup). The push click listener is registered once (static `_pushListenerRegistered` guard) and navigates to `DetailNews` using the announcement id from the notification's additional data.

---

## 4. Authentication & Session Model

```mermaid
sequenceDiagram
    participant U as User
    participant LP as LoginPage
    participant US as user_service.login()
    participant API as POST /login
    participant SP as SharedPreferences

    U->>LP: email + password
    LP->>US: login(email, password)
    US->>API: form body {email, password}
    API-->>US: 200 {state, user{...}, authorisation{token, type}}
    US-->>LP: ApiResponse(data: User)
    LP->>SP: setString token, setInt id/index/semester, setString name/email/level/program/department/faculty/phone/user_img/image/yrOfAdmission/yrOfCompletion, setBool hasOpended
    LP->>LP: pushAndRemoveUntil(Dashboard)
```

- **Token storage:** plain `SharedPreferences` key `"token"`. Every request reads it again via `getToken()` (legacy) or `authTokenProvider` (Riverpod).
- **Profile cache:** the full user profile is flattened into individual `SharedPreferences` keys at login and read back by Profile / Scholarship / Claims screens. It is only refreshed after a profile-picture upload (`GET /me`).
- **Logout:** `user_service.logout()` calls `SharedPreferences.clear()` — it does **not** call the backend `/logout` endpoint, and it wipes onboarding flags and offline caches too.
- **Riverpod auth:** `authTokenProvider` (FutureProvider) and `AuthNotifier` exist in `lib/providers/auth_provider.dart`, but Login/Logout bypass them (see bug report).
- **Registration / password reset:** registration is done in the web portal (`$asset_base_url/user/register` via `url_launcher`). Forgot-password posts the email; the backend sends a new password (UI says “to your phone number”).

---

## 5. Feature Modules & Screen Map

```mermaid
flowchart TD
    Loading[LoadingPage] --> Onboard[OnboardingParent]
    Loading --> Welcome[WelcomeScreenPage]
    Loading --> Dash[Dashboard]
    Onboard --> Welcome
    Welcome --> Login[LoginPage]
    Login --> Forgot[ForgotPasswordPage]
    Login --> Dash

    Dash --> Detail[DetailNews]
    Dash --> Menu[SideMenu drawer]
    Detail --> KM[KeyMomentsContainer]

    Menu --> Notice[AllNoticeBoardPage]
    Menu --> Trend[TrendingNewsPage]
    Menu --> Map["CampusMap (Main / Adako)"]
    Menu --> Profile[UserProfilePage]
    Menu --> Pwd[UpdatePasswordPage]
    Menu --> About[AboutPage]
    Menu --> Sch[ApplyScholarshipPage]
    Menu --> SchStatus[CheckScholarshipStatus]
    Menu --> SchForms[DownloadScholarshipFormsPage]
    Menu --> Claim[ApplyClaimsPage]
    Menu --> ClaimStatus[CheckClaimStatusPage]
    Menu --> ClaimForms[DownloadClaimsFormsPage]
    Menu --> Ext["External: vClass, Student Portal, KsTU site"]

    Notice --> TC[TrendingComponent]
    Trend --> TC
    TC --> Detail
    Map --> LM[LandmarkContainer]
    Profile --> UpdProf[UpdateProfilePage]
    Sch --> SchForm[ApplyScholarshipFormPage]
    Claim --> ClaimForm[ApplyClaimsFormPage]
```

| Module | Screens / Widgets | State mechanism | Endpoints |
|---|---|---|---|
| Startup / Onboarding | `LoadingPage`, `OnboardingParent`, `WelcomeScreenPage` | Riverpod (Loading), legacy Provider + `FutureBuilder` (Welcome) | — |
| Auth | `LoginPage`, `ForgotPasswordPage`, `UpdatePasswordPage` | `setState` + `user_service.dart` | `/login`, `/forgot-password`, `/update-password` |
| Dashboard / News | `Dashboard`, `DetailNews`, `KeyMomentsContainer` | Riverpod (`trendingNewsProvider`, `noticeBoardProvider`, `trendingNewsDetailsProvider`, `keyMomentsProvider`) | `/announcements/*`, `/announcement/{id}`, `/announcement/moments/{id}`, `/post-interact/...` |
| Notice Board / Trending lists | `AllNoticeBoardPage`, `TrendingNewsPage`, `TrendingComponent` | Legacy `NoticeBoardProvider`, `TrendingNewsProvider` + local `setState` pagination | `/announcements/notice-board`, `/announcements/trending-news` |
| Campus Map | `CampusMap`, `LandmarkContainer`, shimmer | Legacy `CampusMapProvider`, `LandmarkProvider` | `/campus-map/*` |
| Profile | `UserProfilePage`, `UpdateProfilePage`, `ProfileDetails` | `setState` + SharedPreferences | `/me`, `/me/update-dp` |
| Scholarships | Apply, Apply Form (Stepper), Status, Download Forms | Raw `http` + `setState` | `/scholarships/types`, `/scholarships/apply`, `/scholarships/applications` |
| Insurance Claims | Apply, Apply Form (Stepper), Status, Download Forms | Raw `http` + `setState` | `/claims/types`, `/claims/apply`, `/claims/applications` |
| About / Links | `AboutPage`, side-menu links | Legacy connectivity | external URLs |

---

## 6. State Management — The Three Coexisting Layers

The project is mid-migration (see `MIGRATION_COMPLETE.md`, which overstates completion).

```mermaid
flowchart TB
    subgraph L1["Layer 1: Riverpod (new)"]
        A1[authTokenProvider / AuthNotifier]
        A2[connectivityProvider - connectivity_plus]
        A3[noticeBoardProvider / trendingNewsProvider]
        A4[trendingNewsDetailsProvider family]
        A5[keyMomentsProvider / landmarkProvider / campusMapProvider]
        A6[announcementPaginationNotifier - unused, stale URL]
    end
    subgraph L2["Layer 2: provider ChangeNotifier (legacy, still primary for lists & maps)"]
        B1[ConnectivityProvider - connectivity v3]
        B2[NoticeBoardProvider]
        B3[TrendingNewsProvider]
        B4[CampusMapProvider]
        B5[LandmarkProvider]
        B6[KeyMomentProvider - not registered]
    end
    subgraph L3["Layer 3: Widget-local setState + http"]
        C1[Scholarships pages]
        C2[Claims pages]
        C3[Auth/Profile pages via user_service.dart]
        C4[ScholarshipForms component]
    end

    L1 --> Loading & Dashboard & DetailNews
    L2 --> Welcome & Login & NoticeBoard & Trending & CampusMap & Landmark & About
    L3 --> C1 & C2 & C3
```

Consequences:
- Duplicate implementations of the same fetch logic (e.g. `noticeBoardProvider` vs `NoticeBoardProvider`) with **different caching behavior**.
- Two connectivity packages and two connectivity enums (`ConnectivityResult` vs custom `ConnectivityStatus`) that are compared against each other.
- Token is read from `SharedPreferences` in ~15 places instead of a single auth source.

### Offline caching strategy
| Data | Cache key (SharedPreferences) | Strategy |
|---|---|---|
| Notice board page N | `cached_notices_page_N` | Network-first, cache fallback on error |
| Trending page N | `cached_trend_page_N` | Network-first, cache fallback on error |
| Campus map (any campus) | `cached_map_page` | **Cache-first, single key for both campuses** (bug) |
| Profile | individual keys (`name`, `email`, ...) | Written at login only |

Announcement lists are sorted newest-first client-side by `utils/announcement_sort.dart` (ISO `created_at` → fallback parse of `created_at_formatted` → fallback to `id`).

---

## 7. External Integrations

| Integration | Where | Notes |
|---|---|---|
| OneSignal | `main.dart`, `dashboard.dart` | App ID hard-coded; verbose logging in production; click handler reads `additionalData['announcemet_id']` (sic). |
| url_launcher | `side_menu.dart`, `welcome_screen.dart`, `key_moments_container.dart`, `campus_map.dart` | vClass (`vclass.kstu.edu.gh`), student portal (`student.kstu.edu.gh/login`), `kstu.edu.gh`, web registration, map coordinates. |
| Dio downloads | `news_details.dart`, `scholarship_forms.dart`, `download_scholarship_forms_page.dart`, apply pages | Images / PDFs to app documents (iOS) or `/storage/emulated/0/Download` (Android). |
| share_plus | download pages | Used to "open" downloaded PDFs. |
| file_picker / image_picker | apply forms / update profile | PDF/JPG/PNG document uploads; profile photo. |

---

## 8. Backend (Laravel) — Reverse-Engineered Contract

### 8.1 Environments
| Constant | Value | Status |
|---|---|---|
| `buildUrl` | `https://app.src-kstu.com/api/v1` | **Active (production)** |
| `asset_base_url` | `https://app.src-kstu.com` | Active |
| (commented) | `https://kingthrive-com.stackstaging.com` | Old staging |
| (commented) | `http://16.16.192.97` | Old AWS IP |
| (commented) | `http://10.0.2.2:8000` | Local Android emulator |
| hard-coded | `https://ask-kstu-backend-v2-kingthrive-com.stackstaging.com/api/v1` | **Stale**, used only in unused pagination code |

### 8.2 Conventions
- **Auth:** `Authorization: Bearer <token>`; all requests send `Accept: application/json`.
- **Bodies:** `application/x-www-form-urlencoded` (auth endpoints) or `multipart/form-data` (uploads/applications).
- **Pagination:** standard Laravel `LengthAwarePaginator` (`current_page`, `data[]`, `last_page`, `per_page`, `total`, `links[]`, `next_page_url`, …). Notice/Trending lists appear to use page size 5.
- **Errors:** `422 {message, errors{field:[msg]}}` (client shows first error); `401 {message}`; success for creates = `201 {message, ...}`.
- **Storage:** public disk under `/storage/`: `announcement_imgs/`, `moment_imgs/`, `user_imgs/`, `landmark_imgs/`, plus PDF form files (relative `pdf_file_url` is prefixed with `/storage/`).

### 8.3 Endpoint Catalogue

#### Auth & Profile
| Method | Path | Request | Success response | Client caller |
|---|---|---|---|---|
| POST | `/login` | `email`, `password` | `200 {state, user{…}, authorisation{token, type}}` | `user_service.login` |
| POST | `/register` | `email, password, password_confirmation, name, gender, index_no, status, user_img, program_id, dept_id, yr_of_admission, yr_of_completion` | `201` same shape as login | `user_service.register` (unused; broken) |
| POST | `/logout` | — | — | **Never called** (constant only) |
| GET | `/me` | — | `200 {state?, user{…}, authorisation{…}}` (parsed with `User.fromJson`) | `getUserDetails` |
| POST | `/forgot-password` | `email` | `200 {message}` | `forgotPassword` |
| POST | `/me/update-dp` | multipart `user_img` | `200` | `updateUserProfile` |
| POST | `/update-password` | `old_pass`, `password`, `password_confirmation` | `200 {…}` | `updatePassword` |

#### Announcements
| Method | Path | Response | Notes |
|---|---|---|---|
| GET | `/announcements/notice-board?page=N` | `{announcements: {paginator of Announcement}}` | Notice board |
| GET | `/announcements/trending-news?page=N` | `{announcements: {paginator of Announcement}}` | Trending news |
| GET | `/announcement/{id}` | `{data: Announcement}` | Detail; increments views server-side (likely) |
| GET | `/announcement/moments/{announcementId}` | `{data: [AnnouncementKeyMoments]}` | Image gallery / "key moments" |
| POST | `/post-interact/announcements/{announcementId}/{status}` | `200` | Like (`status=1`) / unlike (`status=0`) |

#### Campus Map
| Method | Path | Response |
|---|---|---|
| GET | `/campus-map/main-campus-landmarks` | `{campus_landmarks: {paginator of CampusMapModel}}` |
| GET | `/campus-map/adako-landmarks` | `{campus_landmarks: {paginator of CampusMapModel}}` |
| GET | `/campus-map/landmark/map/{id}` | `{data: CampusMapModel}` |
| GET | `/campus-map/landmark/places/{landmarkId}` | `{data: [LandmarkModel]}` |

#### Scholarships
| Method | Path | Request | Response |
|---|---|---|---|
| GET | `/scholarships/types` | — | `{data: {paginator of ScholarshipType}}` |
| POST | `/scholarships/apply` | multipart: `scholarship_type_id, student_full_name, contact_number, parent_guardian_name, occupation, needy_reason, is_parent_alive (0/1), number_of_siblings, benefited_previously (0/1), student_department, student_programme, student_number, documents[i][file], documents[i][document_type]` | `201 {message}` |
| GET | `/scholarships/applications` | — | paginator of `ScholarshipApplication` (with `documents[]`) |

#### Insurance Claims
| Method | Path | Request | Response |
|---|---|---|---|
| GET | `/claims/types` | — | `{data: {paginator of ScholarshipType-shaped claim types}}` |
| POST | `/claims/apply` | multipart: `claim_type_id, student_full_name, level, contact_number, name_of_deceased, relation_to_deceased, date_of_death, place_of_death, hospital_name, doctor_name, mortuary_name, religious_body_name, burial_location, burial_date, has_body_been_buried (0/1), date_of_birth, student_department, student_programme, student_number, documents[i][file], documents[i][document_type]` | `201 {message}` |
| GET | `/claims/applications` | — | `{success, data: {paginator of Claim}}` |

### 8.4 Inferred Backend Domain Model

```mermaid
erDiagram
    FACULTY ||--o{ DEPARTMENT : has
    DEPARTMENT ||--o{ PROGRAM : has
    PROGRAM ||--o{ USER : enrolls
    ADMIN ||--o{ ANNOUNCEMENT : posts
    CATEGORY ||--o{ ANNOUNCEMENT : classifies
    ANNOUNCEMENT ||--o{ KEY_MOMENT : has
    ANNOUNCEMENT ||--o{ ANNOUNCEMENT_LIKE : receives
    USER ||--o{ ANNOUNCEMENT_LIKE : gives
    CAMPUS ||--o{ CAMPUS_LANDMARK : contains
    CAMPUS_LANDMARK ||--o{ LANDMARK_PLACE : contains
    SCHOLARSHIP_TYPE ||--o{ SCHOLARSHIP_APPLICATION : receives
    USER ||--o{ SCHOLARSHIP_APPLICATION : submits
    SCHOLARSHIP_APPLICATION ||--o{ APPLICATION_DOCUMENT : attaches
    CLAIM_TYPE ||--o{ CLAIM : receives
    USER ||--o{ CLAIM : submits
    CLAIM ||--o{ CLAIM_DOCUMENT : attaches
```

Notes:
- `category_id` distinguishes Notice Board vs Trending News announcements.
- Applications/claims have a workflow: `application_status` (e.g. pending / approved / rejected), `approved_by_name`, `approved_at`, `rejection_reason`.
- Scholarship and claim types define `required_document_types[]` / `optional_document_types[]`, which the app turns into dynamic upload fields.
- A web admin panel (not in this repo) manages announcements, landmarks, types and application review, and presumably dispatches OneSignal pushes.

---

## 9. Build & Release (iOS)
- Version source of truth: `pubspec.yaml` `version: 1.2.3+7` (also mirrored in `ios/Runner.xcodeproj/project.pbxproj`).
- Build: `flutter build ipa --release` → `build/ios/ipa/KSTU SRC.ipa`; signed with *Apple Distribution: David Otitiaku (T6277BM4RJ)*.
- App Store Connect rejects re-used marketing versions once a train is closed — bump `CFBundleShortVersionString` (the `x.y.z` part) for every new release.
- Dependency constraints that matter for modern Flutter: `font_awesome_flutter ^11`, `google_fonts ^6.2.1`, `http ^1.2.0`.

