# 03 — Cloudflare Workers & Supabase Edge Functions

> All server-side glue runs serverless at **GH₵ 0/mo** within Cloudflare Workers (100k req/day free) and Supabase Edge Functions (500k invocations/mo on Free, 2M/mo on Pro).

---

## 1. Cloudflare Worker #1: `api.src-kstu.com` Reverse Proxy

**Why this exists:**
- Supabase Cloud Free does not include Custom Domains (`Pro $25 + $10/mo`).
- Hardcoding `https://<project-ref>.supabase.co` inside the React Native APK/IPA locks you to that exact project forever.
- Putting `https://api.src-kstu.com` in front via a free Cloudflare Worker lets you upgrade Free → Pro or later migrate to Self-Hosted Hetzner **with zero mobile app rebuild or Azure callback update**. *(Once on Pro, you may optionally switch to Supabase's native $10/mo Custom Domain and delete this Worker.)*

```ts
// workers/api-proxy/src/index.ts
export interface Env {
  SUPABASE_ORIGIN: string; // e.g. "https://xyzcompany.supabase.co"
}

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const incomingUrl = new URL(request.url);
    const targetOrigin = new URL(env.SUPABASE_ORIGIN);

    const targetUrl = new URL(
      incomingUrl.pathname + incomingUrl.search,
      targetOrigin,
    );

    const headers = new Headers(request.headers);
    headers.set('Host', targetOrigin.host);
    headers.set('X-Forwarded-Host', incomingUrl.host);
    headers.set('X-Forwarded-Proto', 'https');

    const proxiedRequest = new Request(targetUrl.toString(), {
      method: request.method,
      headers,
      body: request.method === 'GET' || request.method === 'HEAD' ? undefined : request.body,
      redirect: 'manual',
    });

    const response = await fetch(proxiedRequest);

    // Rewrite Location redirects if GoTrue returns the raw upstream domain
    const outHeaders = new Headers(response.headers);
    const location = outHeaders.get('Location');
    if (location && location.startsWith(targetOrigin.origin)) {
      outHeaders.set('Location', location.replace(targetOrigin.origin, incomingUrl.origin));
    }

    return new Response(response.body, {
      status: response.status,
      statusText: response.statusText,
      headers: outHeaders,
    });
  },
};
```

> [!WARNING]
> Ensure WebSockets / Realtime aren't broken if used later, and confirm `auth/v1/callback` `Location` headers preserve the `kstusrc://auth/callback` deep link untouched.

---

## 2. Cloudflare Worker #2: `src-kstu.com/a/:id` (WhatsApp Previews + Deep Links)

**Why this exists:**
- Enables **rich WhatsApp/Telegram link cards** (thumbnail + announcement title) without converting your static Next.js Admin Dashboard into SSR.
- Serves Apple Universal Links (`apple-app-site-association`) and Android App Links (`assetlinks.json`) from the same root domain (`src-kstu.com`) so tapping a shared link opens `src_kstu_rn` directly to `/announcement/:id`.

```ts
// workers/share-router/src/index.ts
export interface Env {
  SUPABASE_URL: string;      // https://api.src-kstu.com
  SUPABASE_ANON_KEY: string; // Public anon key (can ONLY execute granted public RPCs)
  MEDIA_BASE_URL: string;    // https://media.src-kstu.com
  IOS_STORE_URL: string;
  ANDROID_STORE_URL: string;
}

function escapeHtml(s: string): string {
  return s
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const url = new URL(request.url);

    // 1. iOS Universal Links manifest (Team: T6277BM4RJ, Bundle: com.kstu.src)
    if (url.pathname === '/.well-known/apple-app-site-association') {
      return Response.json(
        {
          applinks: {
            apps: [],
            details: [{ appID: 'T6277BM4RJ.com.kstu.src', paths: ['/a/*'] }],
          },
        },
        { headers: { 'Cache-Control': 'public, max-age=3600' } },
      );
    }

    // 2. Android App Links manifest
    if (url.pathname === '/.well-known/assetlinks.json') {
      return Response.json(
        [
          {
            relation: ['delegate_permission/common.handle_all_urls'],
            target: {
              namespace: 'android_app',
              package_name: 'com.kstu.src',
              sha256_cert_fingerprints: ['REPLACE_WITH_EAS_PLAY_SIGNING_SHA256'],
            },
          },
        ],
        { headers: { 'Cache-Control': 'public, max-age=3600' } },
      );
    }

    // 3. Share Route: /a/:id
    const match = url.pathname.match(/^\/a\/(\d+)\/?$/);
    if (!match) return fetch(request); // Pass through to Cloudflare Pages landing site

    const id = Number(match[1]);
    // PostgREST allows GET on STABLE SQL functions, enabling Cloudflare edge caching
    const rpcRes = await fetch(
      `${env.SUPABASE_URL}/rest/v1/rpc/get_announcement_share_preview?p_id=${id}`,
      {
        method: 'GET',
        headers: {
          apikey: env.SUPABASE_ANON_KEY,
          Authorization: `Bearer ${env.SUPABASE_ANON_KEY}`,
        },
        cf: { cacheTtl: 3600, cacheEverything: true },
      },
    );

    const rows = (await rpcRes.json()) as Array<{
      id: number;
      title: string;
      featured_image_min: string;
    }>;
    const item = rows?.[0];

    if (!item) {
      return new Response('Announcement not found', { status: 404 });
    }

    const title = escapeHtml(item.title);
    const imgUrl = item.featured_image_min.startsWith('http')
      ? item.featured_image_min
      : `${env.MEDIA_BASE_URL}/announcement_imgs/${item.featured_image_min}`;
    const deepLink = `kstusrc://announcement/${item.id}`;

    const html = `<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>${title} — KsTU SRC</title>
  <meta property="og:type" content="article" />
  <meta property="og:site_name" content="KsTU SRC" />
  <meta property="og:title" content="${title}" />
  <meta property="og:description" content="Tap to read the full notice on the KsTU SRC Mobile App." />
  <meta property="og:image" content="${escapeHtml(imgUrl)}" />
  <meta property="og:url" content="${escapeHtml(url.toString())}" />
  <meta name="twitter:card" content="summary_large_image" />
  <style>
    body { font-family: system-ui, sans-serif; margin: 0; background: #002147; color: #fff; display: grid; place-items: center; min-height: 100vh; padding: 20px; }
    .card { max-width: 420px; width: 100%; background: #fff; color: #111; border-radius: 16px; overflow: hidden; box-shadow: 0 20px 50px rgba(0,0,0,.35); }
    img { width: 100%; height: 220px; object-fit: cover; display: block; }
    .body { padding: 20px; }
    h1 { font-size: 18px; margin: 0 0 12px; }
    .btn { display: block; text-align: center; padding: 12px 16px; border-radius: 10px; text-decoration: none; font-weight: 600; margin-top: 10px; }
    .primary { background: #002147; color: #fff; }
    .secondary { background: #f1f5f9; color: #0f172a; }
  </style>
</head>
<body>
  <div class="card">
    <img src="${escapeHtml(imgUrl)}" alt="${title}" />
    <div class="body">
      <h1>${title}</h1>
      <p style="color:#475569;font-size:14px;">Shared from the KsTU SRC App.</p>
      <a class="btn primary" href="${deepLink}">Open in KsTU SRC App</a>
      <a class="btn secondary" href="${escapeHtml(env.ANDROID_STORE_URL)}">Get on Google Play</a>
      <a class="btn secondary" href="${escapeHtml(env.IOS_STORE_URL)}">Download on App Store</a>
    </div>
  </div>
</body>
</html>`;

    return new Response(html, {
      headers: {
        'Content-Type': 'text/html; charset=utf-8',
        'Cache-Control': 'public, max-age=3600',
      },
    });
  },
};
```

> [!TIP]
> Always use `featured_image_min` (kept under 300 KB) for `og:image`. WhatsApp silently drops preview thumbnails above ~300–600 KB or slow origins.

---

## 3. Supabase Edge Functions (Deno)

### 3.1 `send-announcement-push`
Triggered automatically via a **Supabase Database Webhook** on `public.announcements` (`INSERT` or `UPDATE` where `status = 1` and `push_sent_at IS NULL`), OR invoked explicitly by an executive from the admin UI:
- Verifies webhook secret or JWT (`role IN ('exec', 'admin')`).
- Sends push to OneSignal REST API (`https://api.onesignal.com/notifications`) with:
  - `app_id`: `a8a3a92a-86cd-41b5-8efe-2e5badaf01d0`
  - `included_segments: ["All"]`
  - `headings: { en: "KsTU SRC Notice Board" }` (or `"Trending News"`)
  - `contents: { en: announcement.title }`
  - `data: { announcement_id: announcement.id }`
  - `big_picture` / `ios_attachments` pointing to `media.src-kstu.com/announcement_imgs/<featured_image_min>`
- Stamps `push_sent_at = NOW()` so retries never double-notify 15,000 students.

### 3.2 `r2-presign-upload`
Keeps Cloudflare R2 credentials (`R2_ACCESS_KEY_ID`, `R2_SECRET_ACCESS_KEY`) strictly server-side:
- Accepts `{ folder: 'user_imgs' | 'announcement_imgs' | 'moment_imgs' | 'landmark_imgs', contentType, extension }`.
- Checks JWT via `supabase.auth.getUser()`:
  - **Any authenticated student** may request an upload URL for `user_imgs/` (key forced server-side to `user_imgs/${user.id}_${Date.now()}.${ext}`).
  - **Only `role IN ('exec', 'admin')`** may request upload URLs for `announcement_imgs/`, `moment_imgs/`, or `landmark_imgs/`.
- Enforces allowed MIME types (`image/jpeg`, `image/png`, `image/webp`, `application/pdf` for forms) and returns `{ uploadUrl, objectKey, publicUrl }`. Client uploads binary directly to R2 via HTTP `PUT`, then saves `objectKey` to Postgres.

### 3.3 `manage-exec-role`
Clean annual handover tool restricted strictly to `role = 'admin'`:
- Accepts `{ targetEmailOrId, newRole: 'student' | 'exec' | 'admin' }`.
- Verifies caller is `admin` and refuses to let the last remaining `admin` demote themselves.
- Updates `public.profiles.role`, automatically generating an `audit_logs` entry via the Postgres trigger.
