# KsTU SRC App — React Native Migration & Integration Guide

> This document defines the migration blueprint, integration safeguards, push notification setup, and known backend pitfalls when rewriting the KsTU SRC mobile client from Flutter to React Native.

---

## 1. High-Level Migration Strategy

The current Flutter app (`src_kstu_app`) suffers from architectural fragmentation: three coexisting state management layers, redundant caching implementations, unmounted context navigation crashes, and manual native build configurations.

The React Native rewrite aims to:
1. **Unify state & networking** with TanStack Query (React Query) + Zustand (replacing Riverpod + Provider + raw `setState`).
2. **Preserve existing production identifiers** so students updating via the App Store / Play Store experience zero downtime or session loss.
3. **Eliminate platform-specific bugs** (e.g. Android scoped-storage failures, unmounted route exceptions, and SnackBar timeout quirks).

---

## 2. Push Notification Architecture (`OneSignal`)

### 2.1 Credentials & Identifiers (Already Production Verified)
Because APNs and FCM credentials are authenticated and healthy on the OneSignal dashboard, **do not change or recreate any of the following**:

| Setting | Value |
|---|---|
| **OneSignal App ID** | `a8a3a92a-86cd-41b5-8efe-2e5badaf01d0` |
| **Apple Team ID** | `T6277BM4RJ` (*David Otitiaku*) |
| **Main Bundle ID** | `com.kstu.src` |
| **Notification Service Extension Bundle ID** | `com.kstu.src.OneSignalNotificationServiceExtension` |
| **App Group** | `group.com.kstu.src.onesignal` |
| **Android Package Name** | `com.kstu.src` |

### 2.2 SDK Selection & Setup
Use the official [`react-native-onesignal`](https://documentation.onesignal.com/docs/react-native-sdk-setup) package (**v5.x**):

- **If using Expo (Recommended with Prebuild):**
  Use the official `@onesignal/onesignal-expo-plugin`:
  ```json
  {
    "expo": {
      "plugins": [
        [
          "@onesignal/onesignal-expo-plugin",
          {
            "mode": "production",
            "devTeam": "T6277BM4RJ"
          }
        ]
      ]
    }
  }
  ```
  This automatically generates and signs the `OneSignalNotificationServiceExtension` and App Group in the Xcode project during `npx expo prebuild`.

- **If using Bare React Native:**
  Follow the standard manual integration by adding the Notification Service Extension target in Xcode and enabling Push Notifications & Background Modes (Remote notifications) in Signing & Capabilities.

### 2.3 Initialization & Deep Linking Handler
To ensure notifications open the correct announcement regardless of whether the Admin Dashboard sends the legacy typo key or the corrected key, implement the listener globally:

```typescript
import { OneSignal } from 'react-native-onesignal';
import { navigationRef } from './navigation/navigationRef';

export function initPushNotifications() {
  // Initialize OneSignal
  OneSignal.initialize('a8a3a92a-86cd-41b5-8efe-2e5badaf01d0');

  // Request notification permissions
  OneSignal.Notifications.requestPermission(true);

  // Deep linking on push click
  OneSignal.Notifications.addEventListener('click', (event) => {
    const data = event.notification.additionalData as Record<string, any> | undefined;
    if (!data) return;

    // Supports both corrected 'announcement_id' and legacy backend typo 'announcemet_id'
    const rawId = data.announcement_id ?? data.announcemet_id;
    if (!rawId) return;

    const announcementId = typeof rawId === 'number' ? rawId : parseInt(rawId, 10);
    if (!isNaN(announcementId) && navigationRef.isReady()) {
      navigationRef.navigate('AnnouncementDetail', { id: announcementId });
    }
  });
}
```

---

## 3. Potential Integration Issues & Feature Blockers

### 🔴 Blocker 1: Dynamic Multipart Document Uploads (Scholarships & Claims)
- **The Issue:** The Laravel backend requires dynamic documents to be indexed as nested array parameters:
  - `documents[0][file]`, `documents[0][document_type]`
  - `documents[1][file]`, `documents[1][document_type]`
- **The React Native Pitfall:** On Android, document pickers return `content://...` URIs, while on iOS they return `file://...`. Additionally, standard `fetch` in React Native expects file objects to have `uri`, `name`, and `type`.
- **Solution:**
  ```typescript
  import { Platform } from 'react-native';

  export function createApplicationFormData(fields: Record<string, any>, documents: Array<{ uri: string; name: string; type?: string; documentType: string }>) {
    const formData = new FormData();

    // Append regular form fields
    Object.entries(fields).forEach(([key, val]) => {
      if (val !== undefined && val !== null) {
        formData.append(key, String(val));
      }
    });

    // Append indexed document files and types
    documents.forEach((doc, index) => {
      const fileUri = Platform.OS === 'ios' ? doc.uri.replace('file://', '') : doc.uri;
      formData.append(`documents[${index}][file]`, {
        uri: doc.uri,
        name: doc.name,
        type: doc.type || 'application/pdf',
      } as any);

      formData.append(`documents[${index}][document_type]`, doc.documentType);
    });

    return formData;
  }
  ```

---

### 🟠 Blocker 2: The `GET /me` Empty Token Trap
- **The Issue:** Live fixture [`02-get-me.json`](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/review-docs/api-fixtures/02-get-me.json) confirms that while `POST /login` returns the active bearer token, `GET /me` returns:
  ```json
  "authorisation": {
    "token": "",
    "type": "bearer"
  }
  ```
- **The Pitfall:** If the auth state store blindly updates the stored token from the `/me` response, it will wipe out the saved token with `""` and trigger an immediate logout / 401 error.
- **Solution:** Strictly isolate token storage from profile refreshes:
  ```typescript
  interface AuthState {
    token: string | null;
    user: UserProfile | null;
    setAuth: (token: string, user: UserProfile) => void;
    updateUserProfile: (user: UserProfile) => void;
    logout: () => void;
  }

  export const useAuthStore = create<AuthState>((set) => ({
    token: null,
    user: null,
    setAuth: (token, user) => set({ token, user }),
    updateUserProfile: (user) => set({ user }), // Never touches token!
    logout: () => set({ token: null, user: null }),
  }));
  ```

---

### 🟠 Blocker 3: Student Index Numbers Dropping Leading Zeros
- **The Issue:** `user.index_no` is serialized by Laravel as a JSON number (e.g. `52242620003` instead of `"052242620003"`).
- **Solution:** Always format index numbers with 12-digit zero-padding when rendering:
  ```typescript
  export const formatIndexNumber = (indexNo?: number | string | null): string => {
    if (!indexNo) return '';
    return indexNo.toString().padStart(12, '0');
  };
  ```

---

### 🟠 Blocker 4: Scoped Storage & File Downloads
- **The Issue:** The Flutter app attempted to download PDFs and images directly to `/storage/emulated/0/Download/KSTU SRC App`, which fails on Android 10+ due to scoped-storage security restrictions.
- **Solution:** In React Native, download into the application's document/cache directory using `expo-file-system` and present the native iOS/Android share sheet using `expo-sharing`:
  ```typescript
  import * as FileSystem from 'expo-file-system';
  import * as Sharing from 'expo-sharing';

  export async function downloadAndOpenFile(url: string, fileName: string) {
    const destinationUri = `${FileSystem.documentDirectory}${fileName}`;
    
    const downloadResult = await FileSystem.downloadAsync(url, destinationUri);
    
    if (await Sharing.isAvailableAsync()) {
      await Sharing.shareAsync(downloadResult.uri);
    }
  }
  ```
  This requires **zero** external storage permissions on either platform.

---

### 🟡 Blocker 5: Campus Map Coordinate Parsing & Deep Linking
- **The Issue:**
  1. `GET /campus-map/landmark/map/{id}` ([fixture 09](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/review-docs/api-fixtures/09-get-landmark-map-detail.json)) returns:
     ```json
     { "data": { "landmark_url": "https://www.google.com/maps/place/6.691185,-1.610891" } }
     ```
  2. In landmark list fixtures ([07](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/review-docs/api-fixtures/07-get-main-campus-landmarks.json) and [08](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/review-docs/api-fixtures/08-get-adako-landmarks.json)), `latitude` and `longitude` strings contain leading whitespace (e.g. `" -1.610891"`).
- **Solution:** Always trim coordinates and handle fallback deep-linking:
  ```typescript
  import { Linking, Platform } from 'react-native';

  export function openLandmarkMap(latStr: string, lngStr: string, name: string) {
    const lat = parseFloat(latStr.trim());
    const lng = parseFloat(lngStr.trim());

    const scheme = Platform.select({
      ios: `maps:0,0?q=${name}@${lat},${lng}`,
      android: `geo:0,0?q=${lat},${lng}(${name})`,
    });

    const webFallback = `https://www.google.com/maps/search/?api=1&query=${lat},${lng}`;

    Linking.canOpenURL(scheme!).then((supported) => {
      if (supported) {
        Linking.openURL(scheme!);
      } else {
        Linking.openURL(webFallback);
      }
    });
  }
  ```

---

### 🟡 Blocker 6: App Store & Play Store Version Progression
- **The Issue:** App Store Connect will immediately reject any upload where the version and build number are less than or equal to what has already been delivered.
- **Current Production Build:** `1.2.5` (Build `2`).
- **Solution:** Start the React Native repository at:
  - **Version (`CFBundleShortVersionString`):** `1.2.6` or `1.3.0`
  - **Build Number (`CFBundleVersion` / `versionCode`):** `1` (or next sequence)

---

## 4. Recommended React Native Architecture & Stack

| Layer | Recommended Library | Purpose / Benefits |
|---|---|---|
| **Base** | **Expo SDK (Prebuild / Config Plugins)** | Simplifies iOS/Android native configuration and upgrades; supports pure React Native code. |
| **Language** | **TypeScript** | Strict typing based on the 14 schemas in [`review-docs/api-fixtures/`](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_app/review-docs/api-fixtures). |
| **Navigation** | `@react-navigation/native` + `native-stack` | Smooth 60/120fps native transitions; robust push-notification deep linking. |
| **Server State & Caching** | `@tanstack/react-query` | Automatic network-first caching, background revalidation, and retry logic. |
| **Local Auth / Preferences** | `react-native-mmkv` | High-performance synchronous key-value storage (replaces slow asynchronous `SharedPreferences`). |
| **Client UI State** | `zustand` | Minimalist state store for auth session and theme preferences. |
| **Push Notifications** | `react-native-onesignal` | Official OneSignal SDK v5. |
| **File Picker & Sharing** | `expo-document-picker` + `expo-sharing` | Native document selection and cross-platform PDF viewing. |
| **In-App Browser** | `expo-web-browser` | Opens vClass (`vclass.kstu.edu.gh`) and Student Portal in an in-app Safari / Chrome custom tab. |
| **UI Styling** | **Tailwind (NativeWind v4)** or **StyleSheet** | Consistent design matching KsTU SRC brand colors (`#002147` topColor, `#F4B400` headColor). |

---

## 5. Migration Execution Checklist

- [ ] **Step 1: Project Setup**
  - Initialize React Native / Expo project with bundle ID `com.kstu.src`.
  - Configure `react-native-onesignal` with App ID `a8a3a92a-86cd-41b5-8efe-2e5badaf01d0` and Team ID `T6277BM4RJ`.
- [ ] **Step 2: API Client & Auth**
  - Create Axios / Fetch client with base URL `https://app.src-kstu.com/api/v1`.
  - Add auth token interceptor.
  - Guard `GET /me` to prevent token clobbering.
- [ ] **Step 3: Core Announcement & Notice Flows**
  - Implement Notice Board & Trending News with TanStack Query infinite query (`useInfiniteQuery`).
  - Implement Announcement Detail & inline Key Moments parsing.
- [ ] **Step 4: Campus Map**
  - Parse Main and Adako landmarks with `.trim()` coordinate sanitization.
  - Implement Landmark sub-places list and map launch handlers.
- [ ] **Step 5: Dynamic Applications (Scholarships & Claims)**
  - Implement form steppers with proper radio button values (`0/1` booleans).
  - Implement dynamic document file picking and indexed multipart upload (`documents[i][file]`).
- [ ] **Step 6: Status Tracking & Form Downloads**
  - Handle null `from`/`to` in empty Laravel paginators.
  - Implement PDF form downloads via `FileSystem` + `Sharing`.
- [ ] **Step 7: Verification & Release**
  - Verify push notifications on live device using OneSignal test tools.
  - Build release IPA with version `1.2.6+1` and upload to TestFlight via Transporter.
