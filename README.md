# Blueprint — Template Portofolio Engineer + CMS (PHP Native + MySQL)

Template portofolio bergaya gambar teknik cetak biru untuk backend engineer, DevOps, system architect, atau insinyur. Kepala halaman berupa blok judul gambar kerja, kursor berubah menjadi crosshair lengkap dengan koordinat, tumpukan arsitektur isometrik 3D yang terurai saat di-scroll, kartu proyek yang berbalik 3D, daftar komponen (BOM), diagram alir layanan, diagram Gantt perjalanan karier, catatan revisi dari klien, dan formulir work order.

## Isi folder

| Path | Fungsi |
|---|---|
| `index.php` | Router: halaman publik (`beranda`, `proyek`, `kirim`) + halaman CMS |
| `config/database.php` | Koneksi MySQL |
| `includes/bootstrap.php` | PDO, CSRF, login & sesi, upload gambar → WebP, ikon & logo |
| `includes/data.php` | Pengambil data halaman publik |
| `includes/tema.php` | Pilihan warna kertas biru & sorot, font tema Blueprint |
| `includes/logos.php`, `includes/icons.php` | 70+ logo teknologi satu warna & ikon garis |
| `pages/beranda.php`, `pages/proyek.php` | Halaman depan & lembar detail proyek (dengan kaca pembesar) |
| `pages/kirim.php` | Penerima formulir work order |
| `pages/admin/*` | Halaman CMS |
| `assets/css`, `assets/js` | Tampilan & efek (tanpa framework) |
| `assets/img` | Tile grid, potret & avatar ilustrasi, diagram proyek contoh |
| `assets/uploads` | File yang diunggah dari CMS |
| `database/porto_blueprint.sql` | Skema + data contoh |

## Instalasi singkat

1. Salin folder `porto-blueprint` ke `htdocs` (XAMPP) atau `www` (Laragon).
2. Jalankan Apache & MySQL, impor `database/porto_blueprint.sql` lewat phpMyAdmin.
3. Sesuaikan `config/database.php` bila perlu.
4. Situs: `http://localhost/porto-blueprint/` — CMS: `http://localhost/porto-blueprint/index.php?page=login`
   Login awal **admin / admin123**, segera ganti di menu **Akun**.

## Yang bisa diatur dari CMS

- **Profil & Situs**: nama, peran, kalimat hero, tagline, bio, kota, tahun mulai, status, foto, CV PDF, kontak, media sosial, SEO, 4 kombinasi warna (kobalt-kuning, kobalt-oranye, navy-sian, teal-kuning).
- **Proyek**: semua detail + cover, galeri, teknologi, unggulan, sembunyikan, urutan.
- **Teknologi**: logo, kategori, tingkat penguasaan. **Setiap kategori otomatis menjadi satu lapisan** di tumpukan isometrik hero, dan semuanya tampil di tabel daftar komponen.
- **Pengalaman & pendidikan**: otomatis digambar sebagai diagram Gantt berdasarkan bulan mulai & selesai.
- **Layanan** (modul diagram alir), **Testimoni** (catatan revisi), **Pesan masuk** + CSV, **Dashboard**.

## Catatan keamanan

- PDO prepared statement, escape output, CSRF di semua form.
- Password hash, login dikunci 15 menit setelah 5 kali gagal, sesi lain otomatis keluar saat password diganti.
- Gambar dicek MIME aslinya lalu digambar ulang menjadi WebP; CV hanya PDF; folder upload diberi `.htaccess` anti-eksekusi.
- Hanya link `http(s)://` yang diterima.
- Work order: honeypot, maksimal 3 pesan per 10 menit per IP, tolak pesan dobel.
- CSV aman dari formula injection.

## Catatan tampilan

- Crosshair dan kaca pembesar hanya aktif di perangkat dengan mouse. Di HP, kartu proyek dibalik dengan sekali ketuk.
- Semua animasi mati otomatis bila pengunjung mengaktifkan "kurangi gerakan".
