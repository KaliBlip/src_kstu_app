# 04 — Next.js Static Admin Dashboard & Public Landing Page

> Both web apps live in the **`kstu-src` GitHub Organization** and deploy to **Cloudflare Pages (`GH₵ 0/mo`)** with automatic PR previews for all collaborators and zero per-seat fees.

---

## 1. Why Static Next.js (`output: 'export'`) Works Cleanly Here

| Concern | How It Works Without SSR / Server Actions |
|---|---|
| **Auth & Route Security** | Static bundle contains UI only (no secrets or student data). Every API call uses the logged-in executive's Supabase JWT; Postgres RLS blocks every query unless `role IN ('exec', 'admin')`. |
| **Network-Level Hardening** | Optional **Cloudflare Access** (Free for up to 50 users) restricts `admin.src-kstu.com` to `@kstu.edu.gh` executives before the static JS even loads. |
| **Audit Logging** | Postgres `AFTER` triggers automatically write tamper-proof `audit_logs` rows using `auth.uid()`. |
| **Secret Keys (OneSignal, R2)** | Isolated inside **Supabase Edge Functions** (`send-announcement-push`, `r2-presign-upload`). |
| **WhatsApp Rich Previews** | Handled independently on `src-kstu.com/a/:id` by the Share Cloudflare Worker (`03-backend-edge-functions-and-workers.md`). |

---

## 2. Admin Dashboard (`admin.src-kstu.com`)

### 2.1 Configuration (`next.config.ts`)

```ts
import type { NextConfig } from 'next';

const nextConfig: NextConfig = {
  output: 'export',
  images: { unoptimized: true },
};

export default nextConfig;
```

### 2.2 Modules & Data Flow

| Route | Allowed Roles | Supabase / R2 Operations |
|---|---|---|
| `/login`, `/auth/callback` | Public shell | `signInWithOAuth({ provider: 'azure', options: { redirectTo: 'https://admin.src-kstu.com/auth/callback' } })` |
| `/announcements` | `exec`, `admin` | CRUD `announcements` + `announcement_key_moments`; uploads images via `r2-presign-upload` (generates/validates `<300 KB` `featured_image_min` client-side in Canvas/browser before upload!); toggles `status = 1` + sends push |
| `/scholarships` | `exec`, `admin` | Filterable queue (`pending` / `approved` / `rejected`); downloads private `application_documents` via `supabase.storage.from('scholarship_documents').createSignedUrl(path, 120)`; approves/rejects via `rpc('review_scholarship_application')` |
| `/claims` | `exec`, `admin` | Same review workflow using `claim_documents` signed URLs and `rpc('review_claim')` |
| `/campus-map` | `exec`, `admin` | Manage Main & Adako campus landmarks (`latitude`, `longitude`), upload landmark photo to R2, manage nested `landmark_places` |
| `/academics` | `admin` | Manage `faculties`, `departments`, `programs`, `scholarship_types`, `claim_types` |
| `/handover` | `admin` only | Search student by `@kstu.edu.gh` email or `index_no` and promote/demote `exec` via `manage-exec-role` Edge Function |
| `/audit-logs` | `admin` only | Read-only searchable feed of `public.audit_logs` (who approved/rejected what, role changes, deleted announcements) |

### 2.3 Client-Side Thumbnail Generation (Zero Server Cost)
Before uploading a poster to R2:
- Use an HTML5 `<canvas>` helper in the Admin Dashboard to resize the selected poster to two files:
  1. `announcement_imgs/<uuid>.webp` (max 1200px wide) → `featured_image`
  2. `announcement_imgs/<uuid>_min.webp` (max 600px wide, ~50–150 KB) → `featured_image_min`
- Guarantees fast mobile feeds, minimal offline cache disk usage, and reliable `<300 KB` WhatsApp `og:image` previews without needing `sharp` on a Node server.

---

## 3. Public Landing Page (`src-kstu.com`)

Deployed on Cloudflare Pages (`output: 'export'`):
- `/` — App overview, features (Campus Hub, Offline Notices, Map & Wayfinding, Scholarships & Claims), screenshots, App Store & Google Play download buttons.
- `/privacy` — Mandatory Privacy Policy URL required by Apple App Store Connect & Google Play Console (disclosing Microsoft `kstu.edu.gh` SSO, student profile fields, camera/photo/location usage, and OneSignal notifications).
- `/terms` — Terms of Use & SRC Digital Services policy.
- `/support` — SRC tech/helpdesk contact for Apple/Google App Review metadata.

**Coexistence with Share Worker:**
Cloudflare Routes bind the Share Worker specifically to:
- `src-kstu.com/a/*`
- `src-kstu.com/.well-known/*`
All other paths (`/`, `/privacy`, `/terms`, `/support`, `/_next/*`) serve straight from Cloudflare Pages CDN at `GH₵ 0/mo`.

---

## 4. `kstu-src` GitHub Organization CI/CD Workflow

1. Create repos `src-kstu-admin` and `src-kstu-web` inside the `kstu-src` GitHub org.
2. Install the **Cloudflare Pages GitHub App** on `kstu-src` (granting access to those repos).
3. Configure Cloudflare Pages build:
   - **Build command:** `npm run build`
   - **Build output directory:** `out`
   - **Env vars:** `NEXT_PUBLIC_SUPABASE_URL=https://api.src-kstu.com`, `NEXT_PUBLIC_SUPABASE_ANON_KEY=...`, `NEXT_PUBLIC_MEDIA_BASE_URL=https://media.src-kstu.com`
4. **Collaborator flow:**
   - Any student collaborator creates a feature branch and opens a PR → Cloudflare Pages builds an isolated `https://<branch>.kstu-src-admin.pages.dev` preview URL automatically.
   - Merging PR to `main` deploys to `admin.src-kstu.com` (or `src-kstu.com`) in ~60 seconds.
   - Add incoming SRC developers to the Cloudflare account dashboard (`GH₵ 0` per seat) during annual handover.
