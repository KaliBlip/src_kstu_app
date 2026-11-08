# KsTU SRC App — Bugs & Code Review Findings

Static review of the full `lib/` tree (plus build config) performed while preparing release `1.2.3 (7)`. Line numbers refer to the code at commit `2c8a784`.

**Severity legend:** 🔴 Critical (data loss / wrong data / crash in main flows) · 🟠 High (feature broken or seriously misleading) · 🟡 Medium (edge-case crash, leak, UX defect) · ⚪ Low (code quality / maintainability)

## Summary

| # | Severity | Area | Title |
|---|---|---|---|
| B-01 | 🔴 | Scholarships | "No" radio buttons set value to **Yes** |
| B-02 | 🔴 | Claims | "Body been buried? No" sets value to **Yes** |
| B-03 | 🔴 | Campus Map | Main & Adako campuses share one cache key → wrong campus shown |
| B-04 | 🔴 | Claims | `Claim.fromJson` crashes on any null optional field → status list fails |
| B-05 | 🔴 | Claims | Missing-document / no-token path pops the whole form (user loses input) |
| B-06 | 🟠 | Auth | Riverpod `authTokenProvider` keeps stale token across login/logout |
| B-07 | 🟠 | Auth | Logout never revokes token server-side & wipes onboarding/caches |
| B-08 | 🟠 | Lists | Pull-to-refresh on Notice Board loads Trending News |
| B-09 | 🟠 | Lists | Infinite scroll loops back to page 1 → endless duplicates |
| B-10 | 🟠 | News detail | Like button doesn't update UI (cached Riverpod future) |
| B-11 | 🟠 | Push | Payload key typo `announcemet_id` + stale `BuildContext` in listener |
| B-12 | 🟠 | Welcome | Connectivity check compares unrelated types; SnackBars never shown |
| B-13 | 🟠 | Profile | `_saveupdatedProfile` crashes when `/me` fails; upload errors leave spinner stuck |
| B-14 | 🟠 | Downloads | Android writes to `/storage/emulated/0/Download` without scoped-storage handling |
| B-15 | 🟠 | Claims/Sch. | `bool` fields typed strictly but Laravel returns `0/1` |
| B-16 | 🟡 | Dates | `createdAtFormatted.split(', ')[1]` RangeError |
| B-17 | 🟡 | Forms | `TextEditingController` created in `build()` (leak) |
| B-18 | 🟡 | Forms | `setState` after `dispose` in submit `finally` blocks |
| B-19 | 🟡 | Forms | No double-submit protection |
| B-20 | 🟡 | Claims | Stepper "Documents" step uses index 3 instead of 2 |
| B-21 | 🟡 | Claims | Copy-pasted validator messages / missing validators |
| B-22 | 🟡 | Password | Confirm-password field visible, no match check, async in `setState` |
| B-23 | 🟡 | Navigation | Pushing new `Dashboard` instances instead of popping |
| B-24 | 🟡 | Models | `LandmarkModel.toJson` writes `campus_id`; `landmark_id` typed `String` |
| B-25 | 🟡 | Models | `PaginationData` overrides `==` without `hashCode` |
| B-26 | 🟡 | Downloads | `form['pdf_file_url']!` crashes for types without PDF |
| B-27 | 🟡 | Auth service | `register()` passes `int` in form body → runtime TypeError; hard-coded IDs |
| B-28 | 🟡 | Campus Map | Legacy service fires network call then ignores it when cache exists |
| B-29 | 🟡 | Forms | `_formatDocumentType` crashes on empty segments |
| B-30 | ⚪ | Architecture | Three parallel state-management layers |
| B-31 | ⚪ | Deps | Two connectivity packages (one discontinued) |
| B-32 | ⚪ | Dead code | Unused pagination provider/service with stale staging URL & 2 s fake delay |
| B-33 | ⚪ | Security | Token in plain SharedPreferences; OneSignal verbose logs in prod |
| B-34 | ⚪ | Quality | Copy-pasted error messages, misspellings, `print` debugging, duplicate components |

---

## 🔴 Critical

### B-01 — Scholarship "No" radio buttons select "Yes"
**File:** [apply_scholarship_form_page.dart](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/lib/feature/pages/apply_scholarship_form_page.dart) (~L298, ~L389)
```dart
Radio<bool>(value: false, groupValue: _isParentAlive,
  onChanged: (value) => setState(() => _isParentAlive = !(value ?? false)));
```
`value` is `false` → `!(false)` = `true`. Choosing **No** for *Is Guardian Alive?* or *Have you benefited before?* keeps/sets **Yes**. Every submitted application reports `is_parent_alive=1` and `benefited_previously=1` whenever the user tried to choose "No" — directly corrupting eligibility data.
**Fix:** `onChanged: (v) => setState(() => _isParentAlive = v ?? false)`. Audit already-submitted applications on the backend.

### B-02 — Claims "Body been buried? No" selects "Yes"
**File:** [apply_claims_form_page.dart:383-388](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/lib/feature/pages/apply_claims_form_page.dart#L383-L388) — identical bug; `has_body_been_buried` is always sent as `1`.
**Fix:** same as B-01.

### B-03 — Campus map cache collision (Main vs Adako)
**Files:** [campus_maps_service.dart:13-48](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/lib/services/campus_maps_service.dart#L13-L48) (live, legacy) and [campus_map_provider.dart](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/lib/providers/campus_map_provider.dart) (Riverpod copy)
- Both URLs (`mainCampusMapUrl`, `adakoMapUrl`) cache under the single key `'cached_map_page'`.
- The legacy service is **cache-first**: if any cache exists it returns it and ignores the network response.
- Result: after the first campus is opened, the other campus permanently shows the first campus's landmarks, and admin updates to landmarks never appear until the app data is cleared/logged out.
**Fix:** key by URL (`'cached_map_${Uri.parse(url).path}'`) and switch to network-first with cache fallback (as the notice/trending services already do).

### B-04 — `Claim.fromJson` crashes on null optional fields
**File:** [claim.dart:156-188](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/lib/models/claim.dart#L156-L188)
The form makes `doctor_name`, `mortuary_name`, `religious_body_name`, `burial_location`, `burial_date`, `date_of_birth`, `date_of_death` optional (no validators), but the model types them as non-nullable `String`. Also `has_body_been_buried` (bool), `file_size` (String), `from`/`to` (int, null on empty page). One such record → `TypeError` → the entire *Check Claim Status* screen errors out for that student.
**Fix:** make these fields nullable / use defaults, and normalize bool/int parsing.

### B-05 — Claims submit pops the form on validation failure
**File:** [apply_claims_form_page.dart:512-546](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/lib/feature/pages/apply_claims_form_page.dart#L512-L546)
`Navigator.pop(context)` is called when a required document is missing or the token is null, but no dialog is open — it pops the **form page itself**, discarding everything the user entered (bereavement details + picked files), then shows a SnackBar on the previous screen.
**Fix:** remove the `Navigator.pop` calls; just show the SnackBar and `return`.

---

## 🟠 High

### B-06 — Stale auth token in Riverpod
**Files:** [auth_provider.dart](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/lib/providers/auth_provider.dart), [login_page.dart:181](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/lib/feature/pages/login_page.dart#L181), [user_service.dart:115-118](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/lib/services/user_service.dart#L115-L118)
Login writes `"token"` straight to SharedPreferences and logout clears SharedPreferences; neither invalidates `authTokenProvider` nor uses `AuthNotifier`. Once read, Riverpod caches the old value → after logout + login as another user (same process), Riverpod-backed screens (Dashboard, Detail) send the **previous user's token** (or empty token → 401).
**Fix:** route login/logout through `AuthNotifier`, or call `ref.invalidate(authTokenProvider)` (and dependent providers) after both.

### B-07 — Logout is client-only and over-broad
**File:** [user_service.dart:115-118](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/lib/services/user_service.dart#L115-L118)
- `logoutUrl` is defined but never called → the bearer token stays valid on the server forever.
- `pref.clear()` also deletes `hasOpended` (onboarding shown again) and all offline caches.
- `return await await pref.clear();` — redundant double await.
**Fix:** `POST /logout` with the token (ignore failures), then remove only auth/profile keys.

### B-08 — Notice Board pull-to-refresh fetches Trending News
**File:** [trending_component.dart:205-215](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/lib/components/trending_component.dart#L205-L215)
```dart
announcements!.clear();
announcements != widget.isTrending ? trendProvider.fetchTrend(1) : noticeboardProvider.fetchNotice(1);
```
Compares a `List<Announcement>?` with a `bool` → always `true` → always fetches trending. Also the future isn't awaited and the result isn't assigned, so the list is cleared and may stay empty.
**Fix:** `final data = widget.isTrending ? await trend.fetchTrend(1) : await notice.fetchNotice(1); setState(() { announcements = data; currentPageNumber = 1; });`

### B-09 — Infinite scroll duplicates items
**File:** [trending_component.dart](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/lib/components/trending_component.dart) (~L119, ~L150, ~L231)
- `announcements` is initialized with the same list instance as `widget.gottenData` (parent's list is mutated).
- When a page returns fewer than 5 items, `currentPageNumber` is reset to `1` instead of marking "no more pages", so the next scroll re-appends page 1, then 2… forever.
- No in-flight guard → multiple overlapping fetches on fast scrolls.
**Fix:** copy the list (`[...widget.gottenData]`), keep a `hasMore` flag, and an `isLoadingMore` guard; dedupe by `id`.

### B-10 — Like button does not refresh detail screen
**File:** [news_details.dart:56-104, ~161](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/lib/feature/pages/news_details.dart#L56-L104)
After `POST /post-interact/...`, `setState` rebuilds but `trendingNewsDetailsProvider(id)` is never invalidated, so the cached `Announcement` (old `likedByAuthUser` / `likesCountFormatted`) is shown. Also `ref.read(...future)` inside `build()` re-creates a `FutureBuilder` future every rebuild.
**Fix:** `ref.invalidate(trendingNewsDetailsProvider(id))` after a successful like, and use `ref.watch(...)` with `.when(...)`. Consider optimistic UI.

### B-11 — Push-notification navigation is fragile
**File:** [dashboard.dart:~130-160](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/lib/feature/pages/dashboard.dart)
- Reads `data['announcemet_id']` (missing "n"). Works only if the sender uses the same typo; any correctly spelled payload is silently ignored.
- The click listener is registered once (static flag) but captures the first `Dashboard`'s `BuildContext`. Dashboard is frequently re-created (`pushReplacement`/`pushAndRemoveUntil` everywhere), so later taps call `Navigator.push` on an unmounted context → exception / no navigation.
**Fix:** accept both keys; navigate via a global `navigatorKey` instead of a captured context.

### B-12 — Welcome screen connectivity logic is dead
**File:** [welcome_screen.dart:~125-131](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/lib/feature/pages/welcome_screen.dart)
`snapshot.data == ConnectivityStatus.Offline` compares a `ConnectivityResult` (from `connectivity`) with a custom enum — always `false`. The following `SnackBar(...)` is constructed but never passed to `ScaffoldMessenger` (same dead statement in [login_page.dart:~270](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/lib/feature/pages/login_page.dart)). Offline users get no feedback.
**Fix:** use one connectivity source (`connectivityProvider`) and actually call `ScaffoldMessenger.of(context).showSnackBar(...)`.

### B-13 — Profile photo update error handling
**Files:** [update_profile.dart:266-313](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/lib/feature/pages/update_profile.dart#L266-L313), [user_service.dart:74-98, 151-169](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/lib/services/user_service.dart#L74-L98)
- `getUserDetails()` swallows exceptions (commented-out error) → returns `ApiResponse` with `data == null` and `error == null`; `_saveupdatedProfile` then does `user.data as User` → crash.
- `updateUserProfile` throws an `ApiResponse` (not an `Exception`) on network errors; `updateUserProfiles` doesn't catch it → unhandled async error and the FAB spinner never stops.
- The success dialog is shown and then immediately removed by `pushAndRemoveUntil`.
- `loading = !loading` toggling in several places is error-prone (double toggles).
- Cancelling the image picker shows an error dialog on top of the still-open bottom sheet.
- Uses discontinued `connectivity` and a `print` statement.

### B-14 — Android download location
**Files:** [scholarship_forms.dart:93-101](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/lib/components/scholarship_forms.dart#L93-L101), [download_scholarship_forms_page.dart:87-95](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/lib/feature/pages/download_scholarship_forms_page.dart#L87-L95), apply pages
Writes directly to `/storage/emulated/0/Download/KSTU SRC App`. On Android 10+ (scoped storage) creating that directory / file fails without `MANAGE_EXTERNAL_STORAGE` or MediaStore → "Download failed".
**Fix:** use `getApplicationDocumentsDirectory()` / `getDownloadsDirectory()` + `share_plus`, or MediaStore via a plugin.

### B-15 — Boolean fields vs Laravel `0/1`
**Files:** [claim.dart](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/lib/models/claim.dart) (`hasBodyBeenBuried`), [scholarship_application_model.dart](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/lib/models/scholarship_application_model.dart) (`isParentAlive`, `benefitedPreviously`), [announcement.dart](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/lib/models/announcement.dart) (`likedByAuthUser`)
The app sends `'0'/'1'`; unless the Eloquent model has `$casts = ['…' => 'boolean']`, the API returns ints and `bool` assignment throws. Verify backend casts or parse defensively.

---

## 🟡 Medium

### B-16 — Unsafe date splitting
[news_details.dart:~314](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/lib/feature/pages/news_details.dart), [trending_component.dart:~347](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/lib/components/trending_component.dart) — `trend.createdAtFormatted.split(', ')[1]` throws `RangeError` when the string is empty (the model defaults it to `''`) or lacks `', '`. `dashboard.dart` already guards with `parts.length > 1`; reuse that helper.

### B-17 — Controllers created in `build()`
`_buildReadOnlyField` in [apply_scholarship_form_page.dart:~245](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/lib/feature/pages/apply_scholarship_form_page.dart) and [apply_claims_form_page.dart:205-217](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/lib/feature/pages/apply_claims_form_page.dart#L205-L217) create a new `TextEditingController` each rebuild and never dispose it. Use `initialValue:` or the existing controllers (they already exist as fields!).

### B-18 — `setState` after dispose
- [apply_claims_form_page.dart:616, 631](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/lib/feature/pages/apply_claims_form_page.dart#L616-L631): pops the page on success, then `finally { setState(...) }` runs on an unmounted state.
- `getUser()` in update profile / claims forms, `getAllScholarshipForms()` (`finally` without `mounted` check), `updatePasswords`, `_forgotPassword` all use `context`/`setState` after `await` without `mounted` checks.
**Fix:** `if (mounted) setState(...)`; `if (!context.mounted) return;`.

### B-19 — Double submission
Apply forms show "Submitting..." but `onStepContinue` remains active, so repeated taps send duplicate multipart applications. Disable the button while `_isSubmitting`.

### B-20 — Claims stepper index bug
[apply_claims_form_page.dart:147-152](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/lib/feature/pages/apply_claims_form_page.dart#L147-L152) — third step uses `isActive: _currentStep >= 3` / `state: _currentStep > 3`; there are only steps 0-2, so the Documents step never shows as active. Use `2`.

### B-21 — Claims form validation gaps
[apply_claims_form_page.dart:219-433](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/lib/feature/pages/apply_claims_form_page.dart#L219-L433)
- "Relation to Deceased" validator says *"Please enter name of deceased"*; "Name of Hospital" says *"Please enter place of death"*.
- Date of Birth, Date of Death and Burial Date have no validators (backend may 422 or store nulls → B-04).
- Burial location/date are not conditionally required when "buried = Yes".
- Validation only runs at final submit; errors on step 2 are invisible while the user is on step 3.
- Date pickers default `initialDate: DateTime.now()` for date of birth.

### B-22 — Update password page
[update_password_page.dart](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/lib/feature/pages/update_password_page.dart)
- Confirm field has `obscureText: false` (password shown in clear text).
- No client-side check that new == confirm, or minimum length.
- Fake 1 s progress dialog **before** validation (L275-282).
- `updatePasswords()` (async) is called inside `setState` (L285-288).
- On success, `push(Dashboard)` stacks a new dashboard on top of the old one.
Same patterns in [forgot_password.dart](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/lib/feature/pages/forgot_password.dart) (plus no email format validation; success text says the password goes to the *phone number*).

### B-23 — Navigation stack misuse
Back buttons in Update Password, Download forms, Update Profile, etc. use `pushReplacement`/`pushAndRemoveUntil(Dashboard())` instead of `pop()`. Each creates a new `Dashboard` (re-fetching data, re-requesting push permission, re-triggering B-11) and breaks the system back gesture on iOS.

### B-24 — `LandmarkModel` serialization
[land-marks-model.dart:333-349](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/lib/models/land-marks-model.dart) — `fromJson` reads `landmark_id`, `toJson` writes `campus_id`; `landmark_id` typed `String` though it is an integer FK.

### B-25 — `PaginationData` equality
[scholarship_type_model.dart](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/lib/models/scholarship_type_model.dart) overrides `operator ==` without `hashCode` (breaks `Set`/`Map` usage; analyzer warning).

### B-26 — Null PDF URL crash
[scholarship_forms.dart:261](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/lib/components/scholarship_forms.dart#L261), [download_scholarship_forms_page.dart:366-367](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/lib/feature/pages/download_scholarship_forms_page.dart#L366-L367) — `form['pdf_file_url']!` throws when a type has no PDF. Hide/disable such items.

### B-27 — Broken `register()`
[user_service.dart:36-72](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/lib/services/user_service.dart#L36-L72) — the `body` map contains ints (`'status': 1`, `'program_id': 3`, `'dept_id': 2`); `http.post` requires `Map<String, String>` → runtime `TypeError`. Also hard-codes department, programme and years. Currently unused (registration is web-based) — delete or fix.

### B-28 — Campus map service wastes requests
[campus_maps_service.dart:13-31](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/lib/services/campus_maps_service.dart#L13-L31) — performs the HTTP request first, then returns the cache if present, discarding the response (also masks 401s). See B-03.

### B-29 — `_formatDocumentType`
[apply_claims_form_page.dart:504-508](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/lib/feature/pages/apply_claims_form_page.dart#L504-L508) (and the scholarship copy) — `word[0]` throws on empty segments (e.g. `"id__card"` or trailing underscore). Guard with `word.isEmpty ? word : ...`.

---

## ⚪ Low / Maintainability

### B-30 — Three state-management layers
Riverpod, `provider` and raw `setState+http` coexist (`main.dart` wraps both `ProviderScope` and `MultiProvider`). `MIGRATION_COMPLETE.md` claims the migration is complete, but Welcome, Login, Notice Board, Trending, TrendingComponent, CampusMap, LandmarkContainer and About still use `provider`; Scholarships/Claims use neither. Duplicate implementations diverge (e.g. caching in B-03). Finish the migration and introduce a single `ApiClient` (base URL, token injection, 401 handling → auto logout).

### B-31 — Duplicate connectivity packages
`connectivity: ^3.0.6` (discontinued, no longer maintained, legacy `ConnectivityStatus`) and `connectivity_plus: ^7.0.0`. Remove `connectivity` and migrate `trending_news.dart`, `update_profile.dart`, `connectivity_helper.dart`, `services/connectivity_provider.dart`.

### B-32 — Dead code with stale backend URL
[announcement_pagination_provider.dart](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/lib/providers/announcement_pagination_provider.dart) and `services/announcement_pagiantion.dart` (misspelled) are not referenced by any screen. They hard-code `https://ask-kstu-backend-v2-kingthrive-com.stackstaging.com`, add an artificial 2 s delay, wrap from the last page back to page 1, replace rather than append items, and run an endless 30 s auto-refresh loop. `KeyMomentProvider` (legacy) is also unregistered/unused. Delete.

### B-33 — Security & privacy hygiene
- Bearer token and full profile (email, phone, index number) stored in plain `SharedPreferences`; prefer `flutter_secure_storage` for the token.
- No global 401 handling — expired tokens produce generic errors instead of returning to login.
- `OneSignal.Debug.setLogLevel(OSLogLevel.verbose)` in production builds.
- OneSignal App ID and all URLs hard-coded; no build flavors (dev/staging/prod).
- `print` statements leak data to device logs (`update_profile.dart`, `trending_news.dart`, download pages).

### B-34 — Code quality
- Copy-pasted error text `'Failed to fetch noticeboard!'` in trending, campus map, landmark and key-moment services.
- Parameter named `category_id` in `likeAnnouncement` (news_details / notice_board / trending_news) actually receives the announcement id — misleading.
- Misspellings: `annoucement_key_moment.dart`, `announcement_pagiantion.dart`, `announcemet_id`, `hasOpended`, `random_qoute_generator.dart`, `_nameofMutuaryController`, "Instition … burrial".
- `DownloadScholarshipFormsPage` duplicates the reusable `ScholarshipForms` component almost verbatim (claims page already uses the component).
- `ApplyClaimsFormPage` reuses `ScholarshipType` for claim types.
- Two SharedPreferences keys (`user_img`, `image`) hold the same value.
- Untyped `var` fields in `UpdateProfilePage`; unused `imageFile_`, `picker_`, `imageConvert`, `TextFormFields` class.
- Deprecated APIs: `withOpacity`, `PickedFile`, `Radio.groupValue/onChanged` (deprecated in recent Flutter in favour of `RadioGroup`).
- No automated tests beyond the default template.

---

## Suggested Fix Order
1. **Data integrity (ship ASAP):** B-01, B-02, B-05, B-04/B-15, B-03.
2. **Session correctness:** B-06, B-07, B-13, add global 401 handling.
3. **Core UX:** B-08, B-09, B-10, B-11, B-12, B-16, B-14.
4. **Hardening:** B-17 – B-29.
5. **Refactor:** B-30 – B-34 (single API client, finish Riverpod migration, generated models, tests).







# 1. Clear npm, pnpm, gradle, playwright, and general CLI caches (~8+ GB)
rm -rf ~/.npm/_cacache ~/.cache/* ~/.gradle/caches \
       ~/Library/Caches/ms-playwright ~/Library/Caches/pnpm \
       ~/Library/Caches/typescript ~/Library/Caches/node-gyp

# 2. Clean up unused/unavailable iOS Simulator devices & caches (up to 18 GB)
xcrun simctl delete unavailable
xcrun simctl erase all

# 3. Install Flutter (re-uses the already-downloaded 2.3 GB zip)
<!-- HOMEBREW_NO_AUTO_UPDATE=1 brew install --cask flutter -->

# 4. Delete all Homebrew download caches (frees another 4.1 GB)
brew cleanup --prune=all -s