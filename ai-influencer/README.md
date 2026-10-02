# AI Influencer — Proyek Realistis (Instagram & TikTok)

Karakter perempuan virtual dengan tampilan **foto-realistis** (tekstur kulit, gerak, detail),
dibuat sepenuhnya dengan **model open source** yang dijalankan di **GPU sewaan RunPod**.

## Struktur

```
docs/
  01-riset-niche.md      Riset niche Indonesia yang paling banyak endorse
  02-runpod-panduan.md   Cara sewa GPU + Network Volume di RunPod, langkah demi langkah
persona/
  persona-bible.md       "Kitab" karakter: identitas, visual, suara, aturan konten
runpod/
  models.txt             Daftar model yang diunduh (folder | URL)
  setup.sh               Sekali jalan: pasang ComfyUI, custom node, unduh model
  start.sh               Tiap sesi: nyalakan ComfyUI + auto-shutdown
  auto-shutdown.sh       Matikan pod otomatis saat idle (hemat biaya)
```

## Stack inti (semua open source, lisensi boleh komersial)

| Kebutuhan | Model / tool | Lisensi |
|---|---|---|
| Antarmuka | ComfyUI | GPL-3.0 |
| Foto realistis + video | **Wan 2.2 14B** (T2V untuk foto, I2V untuk video) | Apache-2.0 |
| Percepatan (4 langkah) | LoRA lightx2v untuk Wan 2.2 | Apache-2.0 |
| Kunci wajah karakter | LoRA karakter dilatih dengan ai-toolkit | MIT (tool) |
| Suara | RVC (rekam suara sendiri → suara karakter) | MIT |

Alasan memilih **Wan 2.2 untuk foto sekaligus video**: satu LoRA karakter bisa dipakai
untuk keduanya, sehingga wajah di foto Instagram dan video TikTok **identik**.
Model ini juga termasuk yang paling kuat di open source untuk tekstur kulit dan gerak natural.

> Selalu cek ulang lisensi di model card Hugging Face sebelum dipakai komersial.

## Roadmap

- [x] Riset niche & strategi
- [x] Script setup RunPod + auto-shutdown
- [ ] Finalisasi persona (nama, niche, visual)
- [ ] Bootstrap dataset wajah (±40 gambar terkurasi)
- [ ] Latih LoRA karakter Wan 2.2
- [ ] Workflow ComfyUI: foto feed, video TikTok, lip-sync
- [ ] Suara karakter (RVC)
- [ ] 30 ide konten pertama + jadwal posting

## Aturan wajib

1. Label **"AI-generated"** di setiap posting (fitur label AI Instagram & TikTok) dan sebutkan di bio.
2. Wajah dan suara **orisinal**, tidak meniru orang nyata.
3. Karakter **dewasa** (usia 24) dan konten tetap sopan.
4. Tidak membuat klaim testimoni palsu ("kulitku jadi glowing setelah pakai X").
   Karakter AI tidak bisa memakai produk, jadi endorse dibuat sebagai presentasi/styling, bukan testimoni.
