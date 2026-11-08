# Live Backend API Verification & Fixtures (`https://app.src-kstu.com/api/v1`)

Using the student test account (`052242620003`), all 14 authentication and read endpoints on the live production backend were queried and captured as JSON fixtures in [`review-docs/api-fixtures/`](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/review-docs/api-fixtures) (with the JWT bearer token redacted).

---

## 1. Captured Fixture Index

| # | Endpoint | Status | Fixture File |
|---|---|---|---|
| 01 | `POST /api/v1/login` | `200 OK` | [01-post-login.json](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/review-docs/api-fixtures/01-post-login.json) |
| 02 | `GET /api/v1/me` | `200 OK` | [02-get-me.json](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/review-docs/api-fixtures/02-get-me.json) |
| 03 | `GET /api/v1/announcements/notice-board?page=1` | `200 OK` | [03-get-notice-board.json](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/review-docs/api-fixtures/03-get-notice-board.json) |
| 04 | `GET /api/v1/announcements/trending-news?page=1` | `200 OK` | [04-get-trending-news.json](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/review-docs/api-fixtures/04-get-trending-news.json) |
| 05 | `GET /api/v1/announcement/1128` | `200 OK` | [05-get-announcement-detail.json](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/review-docs/api-fixtures/05-get-announcement-detail.json) |
| 06 | `GET /api/v1/announcement/moments/1128` | `200 OK` | [06-get-announcement-moments.json](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/review-docs/api-fixtures/06-get-announcement-moments.json) |
| 07 | `GET /api/v1/campus-map/main-campus-landmarks` | `200 OK` | [07-get-main-campus-landmarks.json](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/review-docs/api-fixtures/07-get-main-campus-landmarks.json) |
| 08 | `GET /api/v1/campus-map/adako-landmarks` | `200 OK` | [08-get-adako-landmarks.json](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/review-docs/api-fixtures/08-get-adako-landmarks.json) |
| 09 | `GET /api/v1/campus-map/landmark/map/48` | `200 OK` | [09-get-landmark-map-detail.json](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/review-docs/api-fixtures/09-get-landmark-map-detail.json) |
| 10 | `GET /api/v1/campus-map/landmark/places/48` | `200 OK` | [10-get-landmark-places.json](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/review-docs/api-fixtures/10-get-landmark-places.json) |
| 11 | `GET /api/v1/scholarships/types` | `200 OK` | [11-get-scholarship-types.json](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/review-docs/api-fixtures/11-get-scholarship-types.json) |
| 12 | `GET /api/v1/scholarships/applications` | `200 OK` | [12-get-scholarship-applications.json](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/review-docs/api-fixtures/12-get-scholarship-applications.json) |
| 13 | `GET /api/v1/claims/types` | `200 OK` | [13-get-claims-types.json](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/review-docs/api-fixtures/13-get-claims-types.json) |
| 14 | `GET /api/v1/claims/applications` | `200 OK` | [14-get-claims-applications.json](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/review-docs/api-fixtures/14-get-claims-applications.json) |

---

## 2. Critical Discoveries From Live Responses (Must-Know for React Native Rewrite)

### 2.1 Login Accepts Either Index Number or Email in the `email` Field, and Strips Leading Zero on `index_no`
- Sending `email=052242620003` to `POST /api/v1/login` succeeds (`200 OK`).
- However, the returned `user.index_no` is a JSON integer (`52242620003`), which **drops the leading `0`**.
- **React Native recommendation:** Format 11-digit index numbers with `.toString().padStart(12, '0')` when displaying or pre-filling forms if KsTU index numbers are 12 digits starting with `0`.

### 2.2 `GET /api/v1/me` Returns an Empty Token (`""`)
- In [02-get-me.json](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/review-docs/api-fixtures/02-get-me.json), the backend returns the exact same envelope as `/login`, **except**:
  ```json
  "authorisation": {
    "token": "",
    "type": "bearer"
  }
  ```
- **React Native recommendation:** Never overwrite your stored JWT token when refreshing user profile data from `GET /me`. Only update `user` fields.

### 2.3 `GET /api/v1/announcement/{id}` Already Includes Key Moments!
- In [05-get-announcement-detail.json](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/review-docs/api-fixtures/05-get-announcement-detail.json), `response.data` includes `"get_announcement_key_moments": [...]` inline, which is identical to the payload of `GET /api/v1/announcement/moments/{id}` ([06-get-announcement-moments.json](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/review-docs/api-fixtures/06-get-announcement-moments.json)).
- Also note: **`image` inside a key moment can be `null`!**
  ```json
  {
    "id": 6112,
    "announcement_id": 1128,
    "image_sub_title": "JUST TESTING",
    "image": null,
    "image_description": "Disregard the Info."
  }
  ```
- In the Flutter app, `null` is converted to `''`, causing the app to request `https://app.src-kstu.com/storage/moment_imgs/` (a broken image) for text-only key moments.
- **React Native recommendation:** Read `data.get_announcement_key_moments` directly from the announcement detail call (saving a second network round-trip), and only render an `<Image>` when `moment.image` is non-null and non-empty.

### 2.4 `GET /api/v1/campus-map/landmark/map/{id}` Does NOT Return a `CampusMapModel`
- In the Flutter codebase (`CampusMapProvider.fetchMapDetails` / `CampusMapNotifier.fetchMapDetails`), the code tries to parse `data` using `CampusMapModel.fromJson(jsonDecode(response.body)["data"])`.
- The live response ([09-get-landmark-map-detail.json](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/review-docs/api-fixtures/09-get-landmark-map-detail.json)) actually returns:
  ```json
  {
    "status": "success",
    "message": "Landmark Url Response",
    "data": {
      "landmark_url": "https://www.google.com/maps/place/6.691185,-1.610891"
    }
  }
  ```
- Furthermore, in [07-get-main-campus-landmarks.json](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/review-docs/api-fixtures/07-get-main-campus-landmarks.json) and [08-get-adako-landmarks.json](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/review-docs/api-fixtures/08-get-adako-landmarks.json), several `latitude` and `longitude` strings contain **leading spaces** (e.g. `"longitude": " -1.610891"`, `"latitude": " 6.691022"`).
- **React Native recommendation:** Always `.trim()` `latitude` and `longitude` strings before parsing or building Google Maps / Apple Maps deep links.

### 2.5 `GET /api/v1/campus-map/landmark/places/{id}` Returns `landmark_id` as a String
- Confirmed in [10-get-landmark-places.json](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/review-docs/api-fixtures/10-get-landmark-places.json):
  ```json
  {
    "id": 154,
    "name": "Porter's Lodge",
    "landmark_id": "48",
    "status": 1
  }
  ```
  `id` and `status` are `number`, while `landmark_id` is `"48"` (`string`).

### 2.6 Scholarships & Claims Types (`GET /scholarships/types` & `GET /claims/types`)
- Confirmed in [11-get-scholarship-types.json](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/review-docs/api-fixtures/11-get-scholarship-types.json) and [13-get-claims-types.json](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/review-docs/api-fixtures/13-get-claims-types.json):
  - Both endpoints return `{ "success": true, "data": { "current_page": 1, "data": [ ... ], "per_page": 10, ... } }`.
  - Both return both `"pdf_file"` (relative path, e.g. `"scholarship_pdfs/..."` or `"claim_pdfs/..."`) and `"pdf_file_url"` (full URL starting with `"https://app.src-kstu.com/storage/..."`).
  - Document type codes are `UPPER_SNAKE_CASE` strings (e.g. `["COMPLETED_FORM", "EXAM_RESULTS"]`, `["STUDENT_ID", "OTHER"]`), or empty arrays `[]` (as seen on the current SIC Life Insurance Claim type).

### 2.7 Empty Paginator `from` and `to` Are `null`
- Confirmed in [12-get-scholarship-applications.json](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/review-docs/api-fixtures/12-get-scholarship-applications.json) and [14-get-claims-applications.json](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/review-docs/api-fixtures/14-get-claims-applications.json):
  - When `data` is `[]`, Laravel's paginator returns `"from": null, "to": null, "total": 0`.
  - In Flutter's `ClaimsData` model ([claim.dart](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/lib/models/claim.dart#L29-L38)), `from` and `to` are typed as non-nullable `int`, which crashes if `ClaimsResponse.fromJson` is ever called on an empty list.

### 2.8 Page Sizes Vary by Endpoint
| Endpoint | `per_page` |
|---|---|
| `/announcements/notice-board` | `5` |
| `/announcements/trending-news` | `5` |
| `/campus-map/main-campus-landmarks` | `50` |
| `/campus-map/adako-landmarks` | `50` |
| `/scholarships/types`, `/scholarships/applications` | `10` |
| `/claims/types`, `/claims/applications` | `10` |

- **React Native recommendation:** Never hardcode page size `5` when detecting the end of pagination (unlike Flutter's `TrendingComponent`). Always check `current_page < last_page` or `next_page_url !== null` from the Laravel paginator response.

