# WarungKu — Kasir & Stok Sembako

Aplikasi PWA (Progressive Web App) untuk warung sembako Indonesia. **100% offline**, jalan di HP Android tanpa internet, data tersimpan lokal di HP.

![Version](https://img.shields.io/badge/version-2.1-c4432b)
![Type](https://img.shields.io/badge/type-PWA-1a1410)
![Offline](https://img.shields.io/badge/offline-first-2d5f3f)

## ✨ Fitur

- 📦 **Manajemen Stok** — produk dengan harga beli, jual, margin otomatis, alert stok menipis
- 💰 **Kasir** — keranjang, scan barcode, multi-harga (eceran/grosir), profit per transaksi
- 📒 **Buku Bon** — catat utang pelanggan, reminder via WhatsApp
- 📊 **Laporan** — grafik tren omzet & profit (harian/mingguan/bulanan), produk terlaris
- ⚖️ **Repack Calculator** — hitung HPP saat repack barang curah jadi kemasan kecil
- 📂 **Import CSV** — bulk upload produk dari Excel/Google Sheets
- 👥 **Multi-Shift Kasir** — track performa per shift/karyawan
- 🖨️ **Bluetooth Thermal Printer** — cetak struk via printer ESC/POS 58mm/80mm
- 💾 **Backup & Restore** — export semua data ke JSON file

## 🛠️ Teknologi

- **Frontend**: Vanilla HTML + JavaScript (no framework)
- **Database**: IndexedDB (lokal di browser HP)
- **Charts**: Chart.js
- **CSV**: PapaParse
- **Barcode**: html5-qrcode
- **Printer**: Web Bluetooth API (ESC/POS)
- **Hosting**: Static (Vercel/Netlify/GitHub Pages — semua bisa)

## 🚀 Deploy

### Opsi 1: Vercel (Recommended)

1. Fork repository ini ke akun GitHub Opek
2. Buka [vercel.com](https://vercel.com) → Sign in with GitHub
3. **Add New Project** → pilih repository → **Deploy**
4. Selesai. URL `*.vercel.app` siap pakai

### Opsi 2: Netlify Drop

1. Download zip repository ini
2. Buka [app.netlify.com/drop](https://app.netlify.com/drop)
3. Drag-drop folder hasil extract
4. Selesai

### Opsi 3: GitHub Pages

1. Settings → Pages → Source: `main` branch → `/` (root) → Save
2. URL: `https://[username].github.io/[repo-name]`

## 📱 Install di HP

Setelah aplikasi live di URL HTTPS:

1. Buka URL di **Chrome Android**
2. Tap titik tiga (⋮) → **"Add to Home screen"** atau **"Install app"**
3. Icon WarungKu muncul di home screen
4. Tap → buka full screen seperti app native

## 💾 Backup Data

Data tersimpan di IndexedDB browser HP. **WAJIB backup rutin**:

- Buka aplikasi → tab **Laporan** → tap **💾 Backup**
- File `warungku-backup-[tanggal].json` tersimpan
- Simpan ke Google Drive / WhatsApp sendiri

Untuk restore: tap **📂 Restore** → upload file backup

## ⚙️ Persyaratan Browser

- **Chrome Android 90+** (recommended)
- HTTPS untuk fitur kamera barcode & Bluetooth printer
- Web Bluetooth API didukung Chrome, tidak didukung Firefox/Safari mobile

## 🔧 Customization

### Mengubah Nama Warung di Struk

Edit di `index.html`, cari:

```js
let warungMeta = { nama: 'Warung Sembako', alamat: '', telp: '' };
```

Ubah sesuai data warung sendiri.

### Mengubah Warna Brand

Edit di `index.html`, di dalam `<style>` paling atas, ubah CSS variables:

```css
--accent: #c4432b;        /* merah bata utama */
--accent-2: #d98824;      /* kuning kunyit */
--accent-3: #2d5f3f;      /* hijau daun */
```

## 📂 Struktur File

```
warungku/
├── index.html              # Aplikasi utama (HTML + CSS + JS dalam 1 file)
├── manifest.json           # PWA metadata
├── sw.js                   # Service worker (offline cache)
├── icon-192.png            # App icon kecil
├── icon-512.png            # App icon besar
├── icon-maskable-512.png   # Android adaptive icon
├── apple-touch-icon.png    # iOS icon
├── vercel.json             # Vercel config
└── README.md               # File ini
```

## 📝 Lisensi

Untuk penggunaan pribadi. Bebas dimodifikasi sesuai kebutuhan warung.

## 🙏 Built With

Dibangun untuk warung sembako Indonesia, dengan bahasa Indonesia sebagai bahasa utama. Mendukung pemilik warung kecil yang ingin go digital tanpa harus jago teknologi.
