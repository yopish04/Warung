# Panduan RunPod (GPU + Network Volume)

> Harga di bawah adalah perkiraan dan bisa berubah, jadi cek di runpod.io.

## Konsep
- **GPU Pod** = mesin yang disewa **per jam**. Saat di-*terminate*, isi mesin hilang.
- **Network Volume** = penyimpanan permanen yang disewa **per bulan** (±$0,07/GB).
  Semua model dan hasil kerja disimpan di sini, muncul sebagai folder `/workspace`.

## Sekali di awal

1. Daftar di runpod.io, isi saldo $10–25.
2. **Storage → New Network Volume**
   - Datacenter: pilih yang punya **RTX 4090** (atau L40S) tersedia.
   - Ukuran: **100 GB** (model Wan 2.2 lengkap ±65 GB + ruang dataset/LoRA/hasil).
3. **Pods → Deploy**
   - GPU: **RTX 4090 (24 GB)**
   - Network Volume: pilih volume tadi
   - Template: **RunPod PyTorch** (versi terbaru)
   - Expose HTTP port: **8188** (ComfyUI)
4. Setelah pod jalan, buka **Connect → Web Terminal**, lalu jalankan:
   ```bash
   cd /workspace
   git clone https://github.com/<akun-anda>/ai-influencer.git
   # repo private: buat Personal Access Token di GitHub (izin read-only) lalu
   # git clone https://<TOKEN>@github.com/<akun-anda>/ai-influencer.git
   bash ai-influencer/runpod/setup.sh          # profil: semua (foto + video)
   # atau hemat ruang: bash ai-influencer/runpod/setup.sh gambar
   ```
   Unduhan ±65 GB memakan waktu ±15–30 menit (GPU tetap ditagih, tapi hanya sekali).

## Setiap sesi kerja

1. Deploy pod RTX 4090 dengan Network Volume yang sama.
2. Web Terminal:
   ```bash
   bash /workspace/ai-influencer/runpod/start.sh
   ```
3. Buka **Connect → HTTP 8188** untuk masuk ComfyUI.
4. Selesai → **Terminate** pod. Data tetap aman di Network Volume.
   Kalau lupa, `auto-shutdown.sh` akan menghapus pod setelah 20 menit idle.

## Supaya auto-shutdown bekerja
Pod RunPod biasanya sudah membawa `runpodctl` dan variabel `RUNPOD_POD_ID`.
Kalau perintah `runpodctl` gagal karena izin, buat API key di **Settings → API Keys**,
lalu simpan di Network Volume:
```bash
echo 'export RUNPOD_API_KEY=xxxx' > /workspace/.runpod_env
```

## Perkiraan biaya bulanan
| Item | Biaya |
|---|---|
| Network Volume 100 GB | ±$7 |
| RTX 4090 ±6 jam/minggu | ±$12 |
| **Total** | **±$19 (±Rp300 ribu)** |
