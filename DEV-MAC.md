# Mac Mini — ID-Shaydi Setup

## Pehle se installed (dobara install mat karo)

- Android Studio + SDK
- Flutter SDK
- Docker Desktop for Mac

## Ek baar setup

```bash
cd "/path/to/card maker"
chmod +x run-dev.sh
```

Docker Desktop open karo, phir:

```bash
./run-dev.sh
```

Yeh automatically:
1. **Docker** mein Laravel admin backend start karega (port 8000)
2. **Pixel emulator / USB / wireless** device detect karega
3. **Flutter app** us device par run karega

## Commands

| Command | Kaam |
|---------|------|
| `./run-dev.sh` | Backend (Docker) + Flutter app |
| `./run-dev.sh --backend-only` | Sirf admin backend |
| `./run-dev.sh --app-only` | Sirf Flutter (backend pehle se chal raha ho) |
| `./run-dev.sh --device-id emulator-5554` | Specific device |

## Admin panel

- Login: http://127.0.0.1:8000/admin/login
- User: `admin` / Pass: `idshaydi@123`

## API URL (auto)

| Device | API |
|--------|-----|
| Android Emulator (Pixel 9) | `http://10.0.2.2:8000/api/v1` |
| Physical phone (same Wi-Fi) | `http://<Mac-LAN-IP>:8000/api/v1` |

## Android Studio — Pixel 9 emulator

1. Android Studio → Device Manager
2. Pixel 9 → Play (▶)
3. `./run-dev.sh` run karo — emulator auto-select hoga

## Useful Docker commands

```bash
docker compose logs -f admin    # backend logs
docker compose down             # backend stop
docker compose up -d --build    # backend restart
```

## Troubleshooting

- **Docker not running** → Docker Desktop kholo
- **No device** → `flutter devices` check karo
- **Products load nahi** → backend health: `curl http://127.0.0.1:8000/up`
