#!/usr/bin/env bash
# Hapus (terminate) pod saat idle supaya tagihan GPU tidak berjalan sia-sia.
# Idle = GPU < 10% DAN antrean ComfyUI kosong selama IDLE_MENIT menit berturut-turut.
# Data di /workspace (Network Volume) tetap aman.
set -uo pipefail

IDLE_MENIT="${IDLE_MENIT:-20}"
CEK_DETIK=60
idle=0

if [ -z "${RUNPOD_POD_ID:-}" ]; then
  echo "RUNPOD_POD_ID tidak ada, berarti bukan di RunPod. Auto-shutdown tidak aktif."
  exit 0
fi

antrean_kosong() {
  local q
  q="$(curl -s --max-time 5 http://127.0.0.1:8188/queue)" || return 0
  # Kosong jika queue_running dan queue_pending sama-sama []
  [[ "$q" == *'"queue_running": []'* && "$q" == *'"queue_pending": []'* ]] ||
  [[ "$q" == *'"queue_running":[]'* && "$q" == *'"queue_pending":[]'* ]]
}

while true; do
  gpu="$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | sort -nr | head -1)"
  if [ "${gpu:-0}" -lt 10 ] && antrean_kosong; then
    idle=$((idle + 1))
  else
    idle=0
  fi
  echo "$(date '+%H:%M') gpu=${gpu}% idle=${idle}/${IDLE_MENIT} menit"

  if [ "$idle" -ge "$IDLE_MENIT" ]; then
    echo "Idle ${IDLE_MENIT} menit, pod dihapus."
    # Pod dengan Network Volume tidak bisa di-stop, hanya di-terminate
    runpodctl remove pod "$RUNPOD_POD_ID" || runpodctl stop pod "$RUNPOD_POD_ID"
    exit 0
  fi
  sleep "$CEK_DETIK"
done
