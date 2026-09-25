# beeWork OTA Server

Serves the beeWork Windows installer and update manifest via a lightweight Nginx Docker container.

---

## Project Structure

```
ota_test/
├── public/                    ← WEB ROOT — only this folder is served
│   ├── index.html             ← Download landing page (reads manifest.json)
│   ├── manifest.json          ← OTA update manifest (read by the app)
│   ├── beeWhere.png           ← App logo
│   ├── beework-setup-X.X.X.exe  ← Installer file(s)
│   ├── manual/                ← User Manual (step-by-step guide)
│   │   ├── index.html
│   │   └── *.png              ← Manual screenshots
│   └── deck/                  ← Presentation deck (slide show)
│       └── index.html
│
├── Dockerfile                 ← Builds Nginx image (config only, no static files)
├── nginx.conf                 ← Nginx server config
├── docker-compose.yml         ← One-command deployment
├── serve.ps1                  ← Local Windows dev server (no Docker needed)
└── .dockerignore
```

### The three pages

| Page | URL | Purpose |
|---|---|---|
| **Download** | `/` | Landing page. The Download button reads `manifest.json` so it always serves the latest `.exe`. |
| **User Manual** | `/manual/` | Step-by-step guide for end users (login, sessions, logs, updates). |
| **Deck** | `/deck/` | Slide presentation for demos and pitches. |

All three share the same top navbar, so users can move between them freely.

### Presenting the deck

The deck is a self-contained HTML slideshow (no build step, no dependencies):

| Key | Action |
|---|---|
| `→` / `Space` / `PageDown` | Next slide |
| `←` / `PageUp` | Previous slide |
| `Home` / `End` | First / last slide |
| `N` | Toggle speaker notes |
| `G` | Toggle overview grid |
| `F` | Toggle fullscreen |
| `Esc` | Close overview / notes |

You can also deep-link to a slide with a hash, e.g. `/deck/#s7`. Printing the page
(Ctrl+P) exports one slide per page.

> [!IMPORTANT]
> The Docker image contains **only Nginx + config**.
> All files in `public/` are **volume-mounted** at runtime — you NEVER need to
> rebuild the image just to add a new installer or update the manifest.

---

## Quick Start (Docker)

### 1. Build & run
```bash
docker compose up -d --build
```

### 2. Open in browser
```
http://localhost
```

### 3. Check it is running
```bash
docker compose ps
docker compose logs -f
```

### 4. Stop
```bash
docker compose down
```

---

## Deploying a New Version (via MobaXterm / SCP / any SFTP client)

You NEVER need to rebuild the Docker image. Just:

1. Build the new installer (`flutter build windows --release` + Inno Setup)
2. **Upload** the new `.exe` into the `public/` folder on the server
   ```bash
   # Example via SCP — must be LOWERCASE (production is case-sensitive)
   scp beework-setup-1.0.7.exe user@yourserver:/path/to/ota_test/public/
   ```
3. **Edit** `public/manifest.json` on the server:
   ```json
   {
     "latest_version": "1.0.7",
     "download_url": "https://your-domain.com/beework-setup-1.0.7.exe",
     "release_notes": "What changed in this version.",
     "mandatory": false
   }
   ```
4. **Restart** the container — that is all:
   ```bash
   docker compose restart
   ```

The new installer is now live. The beeWork app will detect it on the next update check.

---

## Local Dev (Windows, no Docker)

```powershell
.\serve.ps1
# Open http://localhost:9000
```

---

## Deploying to a VPS / Cloud Server

1. SSH into your server and install Docker + Docker Compose
2. Copy this entire folder to the server:
   ```bash
   scp -r ota_test/ user@yourserver:/opt/beework-ota/
   ```
3. Run:
   ```bash
   cd /opt/beework-ota
   docker compose up -d --build
   ```
4. Point your domain DNS to the server IP
5. Update the Flutter app with your real URL:
   ```dart
   // lib/services/update_service.dart
   static const String manifestUrl = 'https://your-domain.com/manifest.json';
   ```

---

## Ports

| Port | Description |
|---|---|
| `80` | HTTP (default) |

> To use a different port, change `"80:80"` to e.g. `"8080:80"` in `docker-compose.yml`.
