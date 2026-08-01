# ID-Shaydi Card Maker

Flutter app + Laravel admin panel. Design ID cards, save to gallery, premium subscription (Razorpay), and order products from admin-managed catalog.

## Quick start — Mac (Docker + Android Studio)

**Requires:** Docker Desktop, Flutter SDK, Android Studio (Pixel emulator or USB device)

```bash
git clone https://github.com/Rishijain-star/card-maker.git
cd card-maker
chmod +x run-dev.sh
./run-dev.sh
```

- Admin: http://127.0.0.1:8000/admin/login — `admin` / `idshaydi@123`
- Emulator API: `http://10.0.2.2:8000/api/v1`
- More: [DEV-MAC.md](DEV-MAC.md)

## Quick start — Windows

**Requires:** PHP 8.3+, Flutter SDK, Docker optional

```powershell
git clone https://github.com/Rishijain-star/card-maker.git
cd card-maker
.\run-dev.ps1
```

## Project structure

| Path | Description |
|------|-------------|
| `lib/` | Flutter app |
| `admin/` | Laravel admin + REST API |
| `docker-compose.yml` | Backend on Docker (Mac/Linux) |
| `run-dev.sh` | Mac/Linux one-command launcher |
| `run-dev.ps1` | Windows one-command launcher |

## Stack

- **App:** Flutter (Dart), GetX, Razorpay
- **Admin:** Laravel 13, PHP 8.3, SQLite
- **API:** `GET /api/v1/products`

## Docker (backend only)

Flutter/Android Studio run on the host — not inside Docker.

```bash
docker compose up -d --build
docker compose logs -f admin
docker compose down
```

## Admin credentials (demo)

- Username: `admin`
- Password: `idshaydi@123`

Change before production deployment.
