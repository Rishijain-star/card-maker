#!/usr/bin/env bash
# ID-Shaydi — Mac/Linux dev launcher
# Backend: Docker | App: Flutter (Android Studio emulator / USB / wireless)
#
# Usage:
#   chmod +x run-dev.sh
#   ./run-dev.sh
#   ./run-dev.sh --backend-only
#   ./run-dev.sh --app-only
#   ./run-dev.sh --device-id emulator-5554

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

PORT="${ADMIN_PORT:-8000}"
DEVICE_ID=""
BACKEND_ONLY=false
APP_ONLY=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --backend-only) BACKEND_ONLY=true; shift ;;
    --app-only) APP_ONLY=true; shift ;;
    --device-id) DEVICE_ID="${2:-}"; shift 2 ;;
    --port) PORT="${2:-8000}"; shift 2 ;;
    -h|--help)
      echo "Usage: ./run-dev.sh [--backend-only] [--app-only] [--device-id ID] [--port 8000]"
      exit 0
      ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

command_exists() { command -v "$1" >/dev/null 2>&1; }

get_lan_ip() {
  local ip=""
  ip="$(ipconfig getifaddr en0 2>/dev/null || true)"
  if [[ -z "$ip" ]]; then
    ip="$(ipconfig getifaddr en1 2>/dev/null || true)"
  fi
  if [[ -z "$ip" ]]; then
    ip="$(hostname -I 2>/dev/null | awk '{print $1}' || true)"
  fi
  echo "${ip:-127.0.0.1}"
}

get_connection_type() {
  if [[ "$1" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+:[0-9]+$ ]]; then
    echo "Wireless"
  elif [[ "$1" == emulator-* ]]; then
    echo "Emulator"
  else
    echo "USB"
  fi
}

wait_for_backend() {
  local i=0
  echo "Waiting for backend on port $PORT..."
  while [[ $i -lt 60 ]]; do
    if curl -sf "http://127.0.0.1:${PORT}/up" >/dev/null 2>&1; then
      echo "(OK) Backend is healthy"
      return 0
    fi
    sleep 2
    i=$((i + 1))
  done
  echo "Backend did not start in time. Run: docker compose logs admin"
  return 1
}

start_backend() {
  if ! command_exists docker; then
    echo "Docker not found. Install Docker Desktop for Mac:"
    echo "  https://www.docker.com/products/docker-desktop/"
    exit 1
  fi

  if ! docker info >/dev/null 2>&1; then
    echo "Docker is installed but not running. Open Docker Desktop first."
    exit 1
  fi

  echo "Starting Laravel admin in Docker..."
  ADMIN_PORT="$PORT" docker compose up -d --build
  wait_for_backend

  echo ""
  echo "Admin login : http://127.0.0.1:${PORT}/admin/login"
  echo "API products: http://127.0.0.1:${PORT}/api/v1/products"
  echo "Credentials : admin / idshaydi@123"
  echo ""
}

get_flutter_android_devices() {
  flutter devices --machine 2>/dev/null | python3 -c "
import json, sys
data = json.load(sys.stdin)
for d in data:
    if str(d.get('targetPlatform', '')).startswith('android'):
        print(json.dumps(d))
" 2>/dev/null || true
}

get_adb_devices() {
  adb devices -l 2>/dev/null | tail -n +2 | grep -E 'device|emulator' || true
}

select_device() {
  if [[ -n "$DEVICE_ID" ]]; then
    echo "$DEVICE_ID"
    return
  fi

  local flutter_json
  local devices=()
  local names=()
  local types=()

  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    local id name is_emu
    id="$(echo "$line" | python3 -c "import json,sys; print(json.load(sys.stdin).get('id',''))")"
    name="$(echo "$line" | python3 -c "import json,sys; print(json.load(sys.stdin).get('name',''))")"
    is_emu="$(echo "$line" | python3 -c "import json,sys; print('1' if json.load(sys.stdin).get('emulator') else '0')")"
    [[ -z "$id" ]] && continue
    devices+=("$id")
    names+=("$name")
    if [[ "$is_emu" == "1" ]]; then types+=("Emulator"); elif [[ "$id" == emulator-* ]]; then types+=("Emulator"); else types+=("$(get_connection_type "$id")"); fi
  done < <(get_flutter_android_devices)

  if [[ ${#devices[@]} -eq 0 ]]; then
    echo ""
    echo "No Android device/emulator found."
    echo ""
    echo "Checklist:"
    echo "  Emulator : Android Studio -> Device Manager -> Pixel 9 -> Play"
    echo "  USB      : Cable + USB debugging ON"
    echo "  Wireless : adb pair IP:PORT && adb connect IP:5555"
    echo "  Verify   : flutter devices"
    echo ""
    exit 1
  fi

  echo "Detected Android targets:"
  local i=0
  while [[ $i -lt ${#devices[@]} ]]; do
    echo "  $((i+1)). ${names[$i]} (${types[$i]}) — ${devices[$i]}"
    i=$((i + 1))
  done
  echo ""

  # Priority: Emulator > USB > Wireless
  i=0
  while [[ $i -lt ${#devices[@]} ]]; do
    if [[ "${types[$i]}" == "Emulator" ]]; then
      echo "Auto-selected: ${names[$i]} (Emulator)"
      echo "${devices[$i]}"
      return
    fi
    i=$((i + 1))
  done
  i=0
  while [[ $i -lt ${#devices[@]} ]]; do
    if [[ "${types[$i]}" == "USB" ]]; then
      echo "Auto-selected: ${names[$i]} (USB)"
      echo "${devices[$i]}"
      return
    fi
    i=$((i + 1))
  done

  echo "Auto-selected: ${names[0]} (${types[0]})"
  echo "${devices[0]}"
}

resolve_api_url() {
  local device_id="$1"
  if [[ "$device_id" == emulator-* ]]; then
    echo "http://10.0.2.2:${PORT}/api/v1"
  else
    echo "http://$(get_lan_ip):${PORT}/api/v1"
  fi
}

run_flutter_app() {
  if ! command_exists flutter; then
    echo "Flutter not found. Install Flutter SDK (Android Studio already has SDK tools)."
    echo "  https://docs.flutter.dev/get-started/install/macos"
    exit 1
  fi

  echo "Checking Flutter dependencies..."
  flutter pub get

  local selection selected_id selected_name api_url conn
  selection="$(select_device)"
  selected_id="$(echo "$selection" | tail -1)"
  selected_name="$(echo "$selection" | head -1 | sed 's/Auto-selected: //')"
  conn="$(get_connection_type "$selected_id")"
  api_url="$(resolve_api_url "$selected_id")"

  echo ""
  echo "Device ID : $selected_id"
  echo "API URL   : $api_url"
  echo ""

  if [[ "$conn" == "Emulator" ]]; then
    echo "Tip: Emulator uses 10.0.2.2 to reach Mac localhost (Docker backend)."
  else
    echo "Tip: Physical device needs same Wi-Fi as Mac for API."
  fi
  echo ""

  flutter run -d "$selected_id" --dart-define="APP_API_BASE_URL=${api_url}"
}

echo ""
echo "========================================"
echo "  ID-Shaydi Dev Launcher (Mac)"
echo "========================================"
echo ""
echo "Project: $SCRIPT_DIR"
echo "Port   : $PORT"
echo ""

if [[ "$APP_ONLY" == false ]]; then
  start_backend
fi

if [[ "$BACKEND_ONLY" == false ]]; then
  if [[ "$APP_ONLY" == true ]]; then
    if ! curl -sf "http://127.0.0.1:${PORT}/up" >/dev/null 2>&1; then
      echo "Backend not running. Start with: ./run-dev.sh --backend-only"
      exit 1
    fi
  fi
  run_flutter_app
fi

if [[ "$BACKEND_ONLY" == true ]]; then
  echo "Backend running in Docker. Logs: docker compose logs -f admin"
fi
