#!/usr/bin/env bash
# Dijalankan di awal setiap sesi: nyalakan ComfyUI di port 8188 + auto-shutdown saat idle.
set -euo pipefail

WS="/workspace"
HERE="$(cd "$(dirname "$0")" && pwd)"

if [ ! -d "$WS/ComfyUI" ] || [ ! -d "$WS/venv" ]; then
  echo "ComfyUI belum terpasang. Jalankan dulu: bash $HERE/setup.sh"
  exit 1
fi

# Paket sistem hilang di setiap pod baru
command -v ffmpeg >/dev/null 2>&1 || { apt-get update -qq && apt-get install -y -qq ffmpeg >/dev/null; }

[ -f "$WS/.runpod_env" ] && source "$WS/.runpod_env"

# Auto-shutdown di background (ubah menit lewat IDLE_MENIT=30 bash start.sh)
nohup bash "$HERE/auto-shutdown.sh" > "$WS/auto-shutdown.log" 2>&1 &
echo "==> Auto-shutdown aktif (log: $WS/auto-shutdown.log)"

# shellcheck disable=SC1091
source "$WS/venv/bin/activate"
cd "$WS/ComfyUI"
echo "==> ComfyUI berjalan. Buka Connect → HTTP 8188"
exec python main.py --listen 0.0.0.0 --port 8188 --output-directory "$WS/output"
