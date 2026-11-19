# 05 — Mobile Client (`src_kstu_rn`) Integration Guide

> **Target Repo:** [src_kstu_rn](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_rn) (Expo SDK 58 / React Native 0.88).
> Migrates the 6 files in `src/api/` from Laravel endpoints to Supabase (`api.src-kstu.com`), swaps login to Microsoft Entra SSO, preserves the 20-item offline cache, and adds deep linking from WhatsApp shares.

---

## 1. Dependencies & Config Updates

### 1.1 Install Supabase JS Client
All native auth & storage primitives are already installed (`expo-web-browser`, `expo-secure-store`, `expo-linking`, `expo-local-authentication`, `react-native-mmkv`, `@react-native-community/netinfo`, `react-native-onesignal`, `expo-sharing`). Add:
```bash
npx expo install @supabase/supabase-js
```

### 1.2 Environment Config ([src/config/env.ts](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_rn/src/config/env.ts))

```ts
export const SUPABASE_URL = 'https://api.src-kstu.com';
export const SUPABASE_ANON_KEY = '<PUBLIC_ANON_KEY>';
export const MEDIA_BASE_URL = 'https://media.src-kstu.com';
export const SHARE_BASE_URL = 'https://src-kstu.com';
export const ONESIGNAL_APP_ID = 'a8a3a92a-86cd-41b5-8efe-2e5badaf01d0';

export const StoragePaths = {
  announcementImages: `${MEDIA_BASE_URL}/announcement_imgs/`,
  momentImages: `${MEDIA_BASE_URL}/moment_imgs/`,
  userImages: `${MEDIA_BASE_URL}/user_imgs/`,
  landmarkImages: `${MEDIA_BASE_URL}/landmark_imgs/`,
} as const;
```

### 1.3 Supabase Client ([src/lib/supabase.ts](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_rn/src/lib/supabase.ts) — New)
Configure `createClient` with an `expo-secure-store` storage adapter (and `detectSessionInUrl: false` for React Native, calling `exchangeCodeForSession` explicitly in the OAuth handler).

---

## 2. Universal Links & App Links (`app.json`)

To make `https://src-kstu.com/a/1128` open the app directly when tapped in WhatsApp:

1. **iOS** (`expo.ios` in [app.json](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_rn/app.json)):
   ```json
   "associatedDomains": ["applinks:src-kstu.com"]
   ```
2. **Android** (`expo.android` in [app.json](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_rn/app.json)):
   ```json
   "intentFilters": [
     {
       "action": "VIEW",
       "autoVerify": true,
       "data": [{ "scheme": "https", "host": "src-kstu.com", "pathPrefix": "/a" }],
       "category": ["BROWSABLE", "DEFAULT"]
     }
   ]
   ```
3. **Expo Router Redirect Route** (`src/app/a/[id].tsx` — New):
   Immediately redirects `<Redirect href={{ pathname: '/announcement/[id]', params: { id } }} />` so both `kstusrc://announcement/1128` and `https://src-kstu.com/a/1128` land on the existing detail screen.

---

## 3. File-by-File Migration Map in `src_kstu_rn`

| Area | Current File(s) | Exact Change |
|---|---|---|
| **Types** | [src/api/types.ts](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_rn/src/api/types.ts) | Change `User.id` from `number` to `string` (UUID); add `profile_completed: boolean` and `role: 'student' \| 'exec' \| 'admin'`; change `index_no` to `string \| null`. Remove Laravel `Paginator` envelope dependency where direct lists suffice (or map cleanly inside `announcement-cache.ts`). |
| **Auth Store & Push** | [src/stores/auth-store.ts](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_rn/src/stores/auth-store.ts), [src/services/push.ts](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_rn/src/services/push.ts#L84) | Add `needsProfile` auth status (`hydrating \| signedOut \| needsProfile \| signedIn`); hydrate from `supabase.auth.getSession()` + cached profile; subscribe to `supabase.auth.onAuthStateChange`; update `identifyPushUser(userId: string \| number)` in `push.ts` so `OneSignal.login(String(userId))` accepts the Supabase UUID cleanly. |
| **Login UI** | [src/app/(auth)/login.tsx](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_rn/src/app/%28auth%29/login.tsx) | Replace identifier/password form + `/user/register` link + raw-password `setPasskeyCredentials` with a **"Continue with KsTU Microsoft Account"** button calling `supabase.auth.signInWithOAuth({ provider: 'azure', options: { redirectTo: 'kstusrc://auth/callback', scopes: 'openid profile email', skipBrowserRedirect: true } })` + `WebBrowser.openAuthSessionAsync`. Keep biometrics as an optional local session-unlock prompt on app resume (`settings-store.ts`). |
| **Removed Password Routes** | [forgot-password.tsx](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_rn/src/app/%28auth%29/forgot-password.tsx), `update-password.tsx`, [DrawerContent.tsx](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_rn/src/components/DrawerContent.tsx#L62), [ProfileSettingsMenus.tsx](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_rn/src/components/profile/ProfileSettingsMenus.tsx#L375), [profile.tsx](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_rn/src/app/%28app%29/profile.tsx#L137) | Delete `forgot-password.tsx` and `update-password.tsx` and remove their links; update `app/(auth)/_layout.tsx` & `app/(app)/_layout.tsx`. |
| **New Onboarding** | `src/app/(auth)/complete-profile.tsx` *(New)* | Shown automatically when `status === 'needsProfile'` (`!profile.profile_completed`). Fetches `faculties`, `departments`, `programs` from Supabase and updates `public.profiles` (`profile_completed = true`). |
| **Announcements & Offline Cache** | [src/api/announcements.ts](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_rn/src/api/announcements.ts), [src/hooks/use-announcements.ts](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_rn/src/hooks/use-announcements.ts), [src/lib/announcement-cache.ts](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_rn/src/lib/announcement-cache.ts) | Query `supabase.rpc('get_announcements_feed', { p_category_id, p_page, p_page_size: 10 })`, detail via `announcements` + `announcement_key_moments` + `rpc('increment_announcement_views')`, likes via `insert`/`delete` on `announcement_likes`. Keep the **20-item sliding-window (`ROTATE_BATCH = 5`) offline cache** and disk image prefetching untouched! |
| **WhatsApp Share** | [src/app/(app)/announcement/[id].tsx](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_rn/src/app/%28app%29/announcement/%5Bid%5D.tsx#L84-L94) | Update `handleShare` to include `${SHARE_BASE_URL}/a/${item.id}` so WhatsApp renders the rich OG poster card & deep link. |
| **Avatar Upload** | [src/api/auth.ts](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_rn/src/api/auth.ts) | Call `r2-presign-upload` Edge Function (`folder: 'user_imgs'`), `PUT` image to R2, then update `profiles.user_img`. |
| **Campus Map** | [src/api/campus-map.ts](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_rn/src/api/campus-map.ts) | Query `campus_landmarks` (`eq('campus_id', ...)` + `eq('status', 1)`) and `landmark_places` directly; remove `.trim()` coordinate string workarounds. |
| **Scholarships & Claims** | [src/api/services.ts](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_rn/src/api/services.ts) | Insert parent row (`scholarship_applications` or `claims`), upload supporting files to private Supabase Storage bucket `<uid>/<app_id>/<filename>`, insert `application_documents`/`claim_documents` metadata rows; use `createSignedUrl()` when student views their own uploaded document. |
| **Index Formatting** | [src/lib/format.ts](file:///Users/kaliblip/Developer/KsTU%20SRC/src_kstu_rn/src/lib/format.ts#L4-L7) | Return string directly when already padded (`index_no` is now `VARCHAR(20)` in Postgres). |

---

## 4. Cutover & Store Submission Checklist

1. Build and test with EAS **Development Client** first (`kstusrc://auth/callback` does not work in Expo Go).
2. Test `https://src-kstu.com/a/<id>` in a real WhatsApp chat to confirm `featured_image_min` thumbnail rendering and tap-to-open deep linking on both iOS & Android.
3. Verify offline mode: load feeds once online (20 items cached + images prefetched to disk), enable Airplane Mode, force-quit and reopen app → feeds and details still load seamlessly.
4. Submit new React Native build (`com.kstu.src`) to Apple App Store & Google Play to supersede the legacy Flutter client, including demo reviewer credentials and Apple Guideline 4.8 institutional exemption notes.
