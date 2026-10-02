#!/usr/bin/env bash
# Setup sekali jalan di RunPod: pasang ComfyUI + custom node, unduh model ke Network Volume.
# Aman dijalankan ulang (yang sudah ada dilewati).
#
# Pemakaian:
#   bash setup.sh            # profil gambar + video
#   bash setup.sh gambar     # hanya model untuk foto (hemat ±30 GB)
set -uo pipefail

PROFIL="${1:-semua}"
WS="/workspace"
COMFY="$WS/ComfyUI"
VENV="$WS/venv"
HERE="$(cd "$(dirname "$0")" && pwd)"

echo "==> Profil: $PROFIL"

# 1. Paket sistem (hilang setiap pod baru, jadi cepat dipasang ulang)
if ! command -v aria2c >/dev/null 2>&1; then
  apt-get update -qq && apt-get install -y -qq aria2 ffmpeg >/dev/null
fi

# 2. ComfyUI
if [ ! -d "$COMFY" ]; then
  git clone --depth 1 https://github.com/comfyanonymous/ComfyUI.git "$COMFY"
else
  git -C "$COMFY" pull --ff-only || true
fi

# 3. Virtualenv di Network Volume, memakai PyTorch bawaan template (tidak perlu unduh ulang torch)
if [ ! -d "$VENV" ]; then
  python3 -m venv --system-site-packages "$VENV"
fi
# shellcheck disable=SC1091
source "$VENV/bin/activate"
pip install -q --upgrade pip
pip install -q -r "$COMFY/requirements.txt"

# 4. Custom node
cd "$COMFY/custom_nodes"
for repo in \
  https://github.com/ltdrdata/ComfyUI-Manager.git \
  https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git \
  https://github.com/kijai/ComfyUI-KJNodes.git \
  https://github.com/rgthree/rgthree-comfy.git \
  https://github.com/Fannovel16/ComfyUI-Frame-Interpolation.git
do
  name="$(basename "$repo" .git)"
  if [ ! -d "$name" ]; then
    git clone --depth 1 "$repo" "$name"
  fi
  if [ -f "$name/requirements.txt" ]; then
    pip install -q -r "$name/requirements.txt" || echo "!! requirements $name gagal, lanjut"
  fi
done

# 5. Unduh model
GAGAL=()
HDR=()
if [ -n "${HF_TOKEN:-}" ]; then
  HDR=(--header="Authorization: Bearer $HF_TOKEN")
fi

while IFS='|' read -r profil folder url; do
  profil="$(echo "$profil" | xargs)"; folder="$(echo "$folder" | xargs)"; url="$(echo "$url" | xargs)"
  [ -z "$profil" ] || [[ "$profil" == \#* ]] && continue
  if [ "$PROFIL" != "semua" ] && [ "$profil" != "$PROFIL" ]; then
    continue
  fi
  dest="$COMFY/models/$folder"
  file="$(basename "$url")"
  mkdir -p "$dest"
  if [ -f "$dest/$file" ] && [ ! -f "$dest/$file.aria2" ]; then
    echo "   sudah ada: $file"
    continue
  fi
  echo "==> Unduh $file"
  if ! aria2c -x 16 -s 16 -c --console-log-level=warn "${HDR[@]}" -d "$dest" -o "$file" "$url"; then
    GAGAL+=("$url")
  fi
done < "$HERE/models.txt"

echo
df -h "$WS" | tail -1
if [ ${#GAGAL[@]} -gt 0 ]; then
  echo "!! Unduhan gagal (cek nama file di Hugging Face lalu perbaiki models.txt):"
  printf '   %s\n' "${GAGAL[@]}"
  exit 1
fi
echo "==> Setup selesai. Jalankan: bash $HERE/start.sh"
