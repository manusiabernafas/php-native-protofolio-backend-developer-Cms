SET NAMES utf8mb4;
SET time_zone = '+07:00';
DROP DATABASE IF EXISTS `porto_blueprint`;
CREATE DATABASE `porto_blueprint` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `porto_blueprint`;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nama VARCHAR(100) NOT NULL,
  username VARCHAR(50) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE login_gagal (
  id INT AUTO_INCREMENT PRIMARY KEY,
  ip VARCHAR(45) NOT NULL,
  waktu DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX (ip, waktu)
) ENGINE=InnoDB;

CREATE TABLE pengaturan (
  kunci VARCHAR(50) PRIMARY KEY,
  nilai TEXT NOT NULL
) ENGINE=InnoDB;

CREATE TABLE teknologi (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nama VARCHAR(60) NOT NULL,
  logo VARCHAR(40) NOT NULL DEFAULT '',
  kategori VARCHAR(40) NOT NULL DEFAULT 'Tools',
  level TINYINT UNSIGNED NOT NULL DEFAULT 70,
  unggulan TINYINT(1) NOT NULL DEFAULT 0,
  urutan INT NOT NULL DEFAULT 0
) ENGINE=InnoDB;

CREATE TABLE proyek (
  id INT AUTO_INCREMENT PRIMARY KEY,
  judul VARCHAR(150) NOT NULL,
  slug VARCHAR(90) NOT NULL UNIQUE,
  kategori VARCHAR(50) NOT NULL,
  ringkasan VARCHAR(255) NOT NULL DEFAULT '',
  isi TEXT NOT NULL,
  cover VARCHAR(255) NOT NULL DEFAULT '',
  klien VARCHAR(100) NOT NULL DEFAULT '',
  peran VARCHAR(100) NOT NULL DEFAULT '',
  tahun SMALLINT UNSIGNED NOT NULL,
  durasi VARCHAR(40) NOT NULL DEFAULT '',
  link_demo VARCHAR(255) NOT NULL DEFAULT '',
  link_repo VARCHAR(255) NOT NULL DEFAULT '',
  unggulan TINYINT(1) NOT NULL DEFAULT 0,
  tampil TINYINT(1) NOT NULL DEFAULT 1,
  urutan INT NOT NULL DEFAULT 0,
  dilihat INT UNSIGNED NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX (tampil, urutan)
) ENGINE=InnoDB;

CREATE TABLE proyek_gambar (
  id INT AUTO_INCREMENT PRIMARY KEY,
  proyek_id INT NOT NULL,
  file VARCHAR(255) NOT NULL,
  keterangan VARCHAR(150) NOT NULL DEFAULT '',
  urutan INT NOT NULL DEFAULT 0,
  FOREIGN KEY (proyek_id) REFERENCES proyek(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE proyek_teknologi (
  proyek_id INT NOT NULL,
  teknologi_id INT NOT NULL,
  PRIMARY KEY (proyek_id, teknologi_id),
  FOREIGN KEY (proyek_id) REFERENCES proyek(id) ON DELETE CASCADE,
  FOREIGN KEY (teknologi_id) REFERENCES teknologi(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE pengalaman (
  id INT AUTO_INCREMENT PRIMARY KEY,
  jenis ENUM('kerja','pendidikan') NOT NULL DEFAULT 'kerja',
  posisi VARCHAR(100) NOT NULL,
  instansi VARCHAR(120) NOT NULL,
  kota VARCHAR(60) NOT NULL DEFAULT '',
  mulai DATE NOT NULL,
  selesai DATE NULL,
  deskripsi TEXT NOT NULL
) ENGINE=InnoDB;

CREATE TABLE layanan (
  id INT AUTO_INCREMENT PRIMARY KEY,
  judul VARCHAR(100) NOT NULL,
  deskripsi VARCHAR(255) NOT NULL,
  ikon VARCHAR(40) NOT NULL DEFAULT 'sparkles',
  harga_mulai INT UNSIGNED NULL,
  urutan INT NOT NULL DEFAULT 0
) ENGINE=InnoDB;

CREATE TABLE testimoni (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nama VARCHAR(100) NOT NULL,
  jabatan VARCHAR(120) NOT NULL DEFAULT '',
  isi TEXT NOT NULL,
  foto VARCHAR(255) NOT NULL DEFAULT '',
  rating TINYINT UNSIGNED NOT NULL DEFAULT 5,
  tampil TINYINT(1) NOT NULL DEFAULT 1,
  urutan INT NOT NULL DEFAULT 0
) ENGINE=InnoDB;

CREATE TABLE pesan (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nama VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL,
  subjek VARCHAR(150) NOT NULL DEFAULT '',
  isi TEXT NOT NULL,
  anggaran VARCHAR(40) NOT NULL DEFAULT '',
  ip VARCHAR(45) NOT NULL DEFAULT '',
  dibaca TINYINT(1) NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX (ip, created_at)
) ENGINE=InnoDB;

CREATE TABLE kunjungan (
  tanggal DATE PRIMARY KEY,
  jumlah INT UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB;

-- ===== Data contoh =====
INSERT INTO users (nama, username, password) VALUES
('Rizky Firmansyah', 'admin', '$2y$10$hfPGjluwfNku5NZEkVGdjuwvX1Vc1qLQ4EygXt7IcuAsA1lMvQQ4y');

INSERT INTO pengaturan (kunci, nilai) VALUES
('nama', 'Rizky Firmansyah'),
('peran', 'Backend & DevOps Engineer'),
('judul_hero', 'Merancang sistem yang tetap tenang saat trafik sedang ribut.'),
('tagline', 'Backend & DevOps engineer dari Surabaya. Membangun API, antrean, dan infrastruktur yang sanggup melayani jutaan request per hari tanpa begadang tiap ada promo.'),
('bio', 'Aku **Rizky**, engineer yang lebih suka menggambar diagram dulu sebelum menulis baris kode pertama.

Selama 8 tahun aku merancang backend untuk marketplace, logistik, fintech, dan rumah sakit: dari memecah monolit yang sudah menua, menyiapkan antrean pesan yang tahan lonjakan, sampai menyusun pemantauan agar masalah ketahuan sebelum pelanggan mengeluh.

Prinsipku: sistem yang baik itu membosankan. Deploy jalan tiap hari tanpa drama, alarm hanya berbunyi kalau memang penting, dan dokumentasinya cukup jelas untuk dibaca engineer baru di minggu pertamanya.'),
('kota', 'Surabaya, Jawa Timur'),
('email', 'rizky@firmansyah.dev'),
('whatsapp', '081331234567'),
('status_teks', 'Menerima proyek konsultasi arsitektur'),
('tersedia', '1'),
('tahun_mulai', '2017'),
('aksen', 'kuning'),
('foto', ''),
('cv', ''),
('meta_deskripsi', 'Portofolio Rizky Firmansyah, backend & DevOps engineer Surabaya: Go, PHP, PostgreSQL, Kafka, Kubernetes, observability.'),
('sosial_github', 'https://github.com/rizkyfirmansyah'),
('sosial_linkedin', 'https://www.linkedin.com/in/rizkyfirmansyah'),
('sosial_instagram', ''),
('sosial_dribbble', ''),
('sosial_behance', ''),
('sosial_youtube', 'https://www.youtube.com/@rizkyngobrolinfra');

INSERT INTO teknologi (nama, logo, kategori, level, unggulan, urutan) VALUES
('Go', 'go', 'Bahasa', 95, 1, 1),
('PHP', 'php', 'Bahasa', 90, 0, 2),
('Python', 'python', 'Bahasa', 80, 0, 3),
('Laravel', 'laravel', 'Framework', 90, 1, 4),
('FastAPI', 'fastapi', 'Framework', 75, 0, 5),
('GraphQL', 'graphql', 'Framework', 70, 0, 6),
('PostgreSQL', 'postgresql', 'Data', 95, 1, 7),
('MySQL', 'mysql', 'Data', 90, 0, 8),
('Redis', 'redis', 'Data', 90, 1, 9),
('Elasticsearch', 'elasticsearch', 'Data', 75, 0, 10),
('Apache Kafka', 'apachekafka', 'Antrean', 85, 1, 11),
('RabbitMQ', 'rabbitmq', 'Antrean', 85, 0, 12),
('Docker', 'docker', 'Infrastruktur', 95, 1, 13),
('Kubernetes', 'kubernetes', 'Infrastruktur', 85, 1, 14),
('Nginx', 'nginx', 'Infrastruktur', 90, 0, 15),
('Google Cloud', 'googlecloud', 'Infrastruktur', 80, 0, 16),
('Cloudflare', 'cloudflare', 'Infrastruktur', 75, 0, 17),
('Linux', 'linux', 'Infrastruktur', 90, 0, 18),
('Prometheus', 'prometheus', 'Observability', 85, 1, 19),
('Grafana', 'grafana', 'Observability', 85, 1, 20),
('GitHub Actions', 'githubactions', 'Observability', 80, 0, 21);

INSERT INTO proyek (judul, slug, kategori, ringkasan, isi, cover, klien, peran, tahun, durasi, link_demo, link_repo, unggulan, urutan, dilihat, created_at) VALUES
('Gerbang Bayar Terpadu', 'gerbang-bayar', 'Backend', 'Satu API untuk QRIS, virtual account, dan e-wallet. 1,8 juta transaksi per bulan tanpa selisih.', '## Masalah
Koperasi memakai 4 penyedia pembayaran berbeda. Setiap bulan tim keuangan menghabiskan 3 hari untuk mencocokkan mutasi secara manual.

## Arsitektur
- Satu API internal yang menyamarkan perbedaan tiap penyedia
- Setiap request wajib membawa **idempotency key** agar pembayaran tidak pernah tercatat dua kali
- Callback dari penyedia masuk ke Kafka, diproses berurutan per transaksi
- Rekonsiliasi otomatis tiap jam 02.00 dengan laporan selisih

## Hasil
Selisih transaksi turun ke nol dalam 4 bulan berturut-turut. Waktu rekonsiliasi dari 3 hari menjadi 6 menit.

Endpoint utama menjawab dalam `p95 42 ms` di jam sibuk.', 'assets/img/contoh/gerbang-bayar.svg', 'Koperasi Digital Nusantara', 'Lead backend engineer', 2026, '5 bulan', '', '', 1, 1, 512, NOW() - INTERVAL 184 DAY),
('Memecah Monolit Grosir Sumber Makmur', 'pecah-monolit', 'Arsitektur', 'Memindahkan aplikasi PHP berusia 9 tahun ke layanan terpisah tanpa satu hari pun berhenti jualan.', '## Kondisi awal
Satu aplikasi PHP menangani kasir, gudang, dan laporan. Setiap deploy butuh jendela tengah malam, dan satu bug di laporan bisa mematikan kasir.

## Pendekatan
- Memetakan domain bisnis bersama tim gudang dan kasir
- Pola **strangler**: fitur dipindah satu per satu di belakang reverse proxy
- Komunikasi antar layanan lewat RabbitMQ, bukan panggilan langsung
- Database dipisah bertahap dengan sinkronisasi dua arah sementara

## Hasil
Deploy dari sebulan sekali menjadi beberapa kali sehari. Gangguan laporan tidak lagi memengaruhi kasir di 14 cabang.', 'assets/img/contoh/pecah-monolit.svg', 'Grosir Sumber Makmur', 'Konsultan arsitektur', 2025, '8 bulan', '', '', 0, 2, 431, NOW() - INTERVAL 161 DAY),
('Pengirim Notifikasi 1 Juta per Hari', 'notifikasi-sejuta', 'Backend', 'Antrean WhatsApp, SMS, dan email dengan prioritas, retry, dan batas kirim per penyedia.', '## Kebutuhan
Notifikasi status paket harus sampai cepat, tetapi tiap penyedia punya batas kirim yang berbeda.

## Desain
- Tiga antrean prioritas: OTP, status paket, promosi
- Rate limiter **token bucket** di Redis per penyedia
- Retry dengan jeda bertingkat dan antrean pesan gagal untuk diperiksa manual

Sistem mengirim rata-rata 1,1 juta pesan per hari dengan keterlambatan OTP di bawah 3 detik.', 'assets/img/contoh/notifikasi-sejuta.svg', 'Lintas Ekspedisi', 'Backend engineer', 2025, '3 bulan', '', '', 0, 3, 366, NOW() - INTERVAL 138 DAY),
('Observability Gudang Pintar', 'observability-gudang', 'DevOps', 'Metrik, log, dan alarm yang memberi tahu masalah sebelum pelanggan menelepon.', '## Sebelumnya
Tim baru tahu ada gangguan setelah pelanggan mengeluh di media sosial.

## Yang dipasang
- Metrik golden signals untuk 22 layanan
- Alarm berbasis **SLO**, bukan sekadar CPU tinggi
- Runbook singkat yang ditautkan langsung dari setiap alarm

Waktu rata-rata mendeteksi gangguan turun dari 47 menit menjadi 4 menit, dan alarm palsu berkurang 70%.', 'assets/img/contoh/observability-gudang.svg', 'Gudang Pintar Indonesia', 'SRE', 2024, '2 bulan', '', '', 0, 4, 288, NOW() - INTERVAL 115 DAY),
('Pencarian Produk Kilat', 'pencarian-kilat', 'Backend', 'Pencarian 240 ribu produk yang paham salah ketik dan nama lokal sayuran.', '## Tantangan
Pembeli mengetik "lombok ijo", "cabe hijau", atau "cabai hijau" untuk barang yang sama.

## Solusi
- Indeks Elasticsearch dengan kamus sinonim 1.800 nama lokal
- Toleransi salah ketik dan pengurutan berdasarkan stok terdekat
- Sinkron dari PostgreSQL lewat change data capture

Pencarian tanpa hasil turun dari 18% menjadi 3%.', 'assets/img/contoh/pencarian-kilat.svg', 'Pasar Tani Online', 'Backend engineer', 2024, '6 minggu', '', '', 0, 5, 254, NOW() - INTERVAL 92 DAY),
('Deploy Otomatis RS Harapan Sehat', 'deploy-rs', 'DevOps', 'Pipeline CI/CD dan klaster Kubernetes on-premise untuk sistem informasi rumah sakit.', '## Situasi
Pembaruan sistem rumah sakit dilakukan dengan menyalin file ke server lewat FTP, kadang di tengah jam pelayanan.

## Perubahan
- Klaster Kubernetes 3 node di server rumah sakit sendiri
- Pipeline tes, build image, dan deploy bertahap
- Rollback satu klik bila ada masalah

Deploy kini dilakukan siang hari tanpa mengganggu pendaftaran pasien.', 'assets/img/contoh/deploy-rs.svg', 'RS Harapan Sehat', 'DevOps engineer', 2023, '4 bulan', '', '', 0, 6, 199, NOW() - INTERVAL 69 DAY),
('API Wilayah Indonesia', 'api-wilayah', 'Open Source', 'API provinsi sampai desa, lengkap dengan kode pos. Dipakai ratusan aplikasi.', '## Latar
Hampir setiap aplikasi butuh dropdown wilayah, tetapi datanya tersebar dan sering tidak diperbarui.

## Fitur
- Endpoint provinsi, kabupaten/kota, kecamatan, desa, dan kode pos
- Pencarian nama wilayah dengan toleransi ejaan
- Bisa di-host sendiri dengan satu perintah `docker compose up`

Melayani rata-rata 2,3 juta request per bulan dari cache tepi Cloudflare.', 'assets/img/contoh/api-wilayah.svg', '', 'Pembuat & pengelola', 2022, 'Berjalan', '', 'https://github.com/', 0, 7, 342, NOW() - INTERVAL 46 DAY),
('kuota: Rate Limiter untuk Go', 'kuota-rate-limiter', 'Open Source', 'Library rate limiter token bucket dan sliding window dengan backend Redis.', '## Kenapa
Aku butuh rate limiter yang akurat di banyak server sekaligus, dan ingin memahami algoritmanya dengan benar.

## Isi library
- Token bucket dan sliding window log
- Operasi atomik dengan skrip Lua di Redis
- Middleware siap pakai untuk net/http

Sanggup memeriksa 85 ribu request per detik pada satu instance Redis.', 'assets/img/contoh/kuota-rate-limiter.svg', '', 'Pembuat', 2021, 'Berjalan', '', 'https://github.com/', 0, 8, 176, NOW() - INTERVAL 23 DAY);

INSERT INTO proyek_gambar (proyek_id, file, keterangan, urutan) VALUES
(1, 'assets/img/contoh/gerbang-bayar-1.svg', 'Alur rekonsiliasi harian', 1),
(1, 'assets/img/contoh/gerbang-bayar-2.svg', 'Diagram idempotency key', 2),
(2, 'assets/img/contoh/pecah-monolit-1.svg', 'Peta domain sebelum & sesudah', 1),
(2, 'assets/img/contoh/pecah-monolit-2.svg', 'Strategi strangler bertahap', 2),
(3, 'assets/img/contoh/notifikasi-sejuta-1.svg', 'Antrean prioritas & retry', 1),
(3, 'assets/img/contoh/notifikasi-sejuta-2.svg', 'Dasbor laju kirim', 2),
(4, 'assets/img/contoh/observability-gudang-1.svg', 'Dasbor golden signals', 1),
(4, 'assets/img/contoh/observability-gudang-2.svg', 'Aturan alarm berbasis SLO', 2),
(5, 'assets/img/contoh/pencarian-kilat-1.svg', 'Kamus sinonim nama lokal', 1),
(5, 'assets/img/contoh/pencarian-kilat-2.svg', 'Hasil uji relevansi', 2),
(6, 'assets/img/contoh/deploy-rs-1.svg', 'Topologi klaster on-premise', 1),
(6, 'assets/img/contoh/deploy-rs-2.svg', 'Alur pipeline dari commit ke produksi', 2),
(7, 'assets/img/contoh/api-wilayah-1.svg', 'Struktur data wilayah', 1),
(7, 'assets/img/contoh/api-wilayah-2.svg', 'Statistik pemakaian bulanan', 2),
(8, 'assets/img/contoh/kuota-rate-limiter-1.svg', 'Perbandingan algoritma', 1),
(8, 'assets/img/contoh/kuota-rate-limiter-2.svg', 'Hasil benchmark', 2);

INSERT INTO proyek_teknologi (proyek_id, teknologi_id) VALUES
(1, 1),
(1, 7),
(1, 9),
(1, 11),
(1, 14),
(2, 2),
(2, 4),
(2, 1),
(2, 12),
(2, 13),
(3, 1),
(3, 9),
(3, 12),
(3, 19),
(4, 19),
(4, 20),
(4, 14),
(4, 1),
(5, 10),
(5, 3),
(5, 5),
(5, 7),
(6, 14),
(6, 13),
(6, 21),
(6, 15),
(6, 18),
(7, 1),
(7, 7),
(7, 17),
(7, 13),
(8, 1),
(8, 9),
(8, 21);

INSERT INTO pengalaman (jenis, posisi, instansi, kota, mulai, selesai, deskripsi) VALUES
('kerja', 'Principal Backend Engineer', 'Arsitek Data Nusantara', 'Surabaya (hybrid)', '2023-01-01', NULL, 'Memimpin desain sistem pembayaran dan antrean untuk klien fintech dan logistik. Mentor untuk 6 engineer.'),
('kerja', 'Site Reliability Engineer', 'Gudang Pintar Indonesia', 'Jakarta (remote)', '2020-08-01', '2022-12-01', 'Membangun observability, otomasi deploy, dan budaya postmortem tanpa saling menyalahkan.'),
('kerja', 'Backend Developer', 'Pasar Tani Online', 'Surabaya', '2018-03-01', '2020-07-01', 'Mengembangkan API pemesanan, pencarian produk, dan integrasi kurir.'),
('kerja', 'Junior Web Developer', 'CV Teknologi Mandiri', 'Sidoarjo', '2017-02-01', '2018-02-01', 'Membuat aplikasi internal untuk pabrik dan distributor.'),
('pendidikan', 'S1 Teknik Informatika', 'Institut Teknologi Surabaya Raya', 'Surabaya', '2012-08-01', '2016-10-01', 'Tugas akhir: penjadwalan pekerjaan terdistribusi dengan antrean prioritas.'),
('pendidikan', 'Sertifikasi Kubernetes Administrator', 'Program Sertifikasi Cloud Native', 'Daring', '2022-04-01', '2022-06-01', 'Lulus ujian praktik administrasi klaster.');

INSERT INTO layanan (judul, deskripsi, ikon, harga_mulai, urutan) VALUES
('Desain Arsitektur', 'Diagram, keputusan teknologi, dan rencana migrasi yang realistis untuk tim kamu.', 'compass', 7500000, 1),
('Bangun API & Backend', 'API cepat dan terdokumentasi, lengkap dengan tes dan antrean.', 'server', 12000000, 2),
('DevOps & CI/CD', 'Container, Kubernetes, pipeline otomatis, dan rollback aman.', 'git-branch', 9000000, 3),
('Audit Performa & Keamanan', 'Cari query lambat, titik rawan, dan rencana perbaikan berprioritas.', 'shield-check', 5000000, 4);

INSERT INTO testimoni (nama, jabatan, isi, foto, rating, urutan) VALUES
('Hendro Wibowo', 'CTO Koperasi Digital Nusantara', 'Rizky mengubah urusan rekonsiliasi yang dulu bikin pusing jadi otomatis. Desainnya rapi dan dokumentasinya bisa dibaca tim keuangan juga.', 'assets/img/contoh/av-1.svg', 5, 1),
('Lina Marlina', 'Pemilik Grosir Sumber Makmur', 'Kami pindah sistem tanpa satu hari pun toko tutup. Setiap minggu ada laporan perkembangan yang jelas, bukan istilah teknis membingungkan.', 'assets/img/contoh/av-2.svg', 5, 2),
('Bayu Prasetyo', 'Engineering Manager, Gudang Pintar', 'Sejak alarm berbasis SLO dipasang, tim on-call akhirnya bisa tidur nyenyak. Rizky juga mengajari kami cara menulis postmortem yang baik.', 'assets/img/contoh/av-3.svg', 5, 3),
('dr. Ratna Dewi', 'Direktur RS Harapan Sehat', 'Pembaruan sistem sekarang tidak pernah mengganggu pelayanan pasien. Tim IT kami jauh lebih percaya diri.', 'assets/img/contoh/av-4.svg', 5, 4),
('Fajar Sidik', 'Backend Engineer, Arsitek Data Nusantara', 'Mentor yang sabar. Review kodenya tajam tapi selalu menjelaskan alasannya, bukan sekadar menyuruh ganti.', 'assets/img/contoh/av-5.svg', 4, 5);

INSERT INTO pesan (nama, email, subjek, isi, anggaran, ip, dibaca, created_at) VALUES
('Yusuf Hakim', 'yusuf@tokoemasmulia.co.id', 'Konsultasi migrasi server', 'Pak Rizky, aplikasi toko kami masih di satu VPS dan sering lambat saat promo. Bisa bantu rencana migrasi ke cloud?', 'Rp15 - 50 juta', '10.0.0.13', 0, NOW() - INTERVAL 1260 MINUTE),
('Melati Kusuma', 'melati.k@sekolahkoding.id', 'Narasumber webinar', 'Kami ingin mengundang Mas Rizky menjadi narasumber webinar tentang observability untuk mahasiswa.', 'Belum tahu', '10.0.0.22', 0, NOW() - INTERVAL 5040 MINUTE),
('Agus Salim', 'agus.salim@logistikjaya.com', 'Audit performa API', 'API pelacakan kami p95-nya 2 detik. Butuh audit dan rekomendasi perbaikan dalam 2 minggu.', 'Rp5 - 15 juta', '10.0.0.60', 1, NOW() - INTERVAL 21000 MINUTE);

INSERT INTO kunjungan (tanggal, jumlah) VALUES
(CURDATE() - INTERVAL 1 DAY, 70),
(CURDATE() - INTERVAL 2 DAY, 98),
(CURDATE() - INTERVAL 3 DAY, 89),
(CURDATE() - INTERVAL 4 DAY, 96),
(CURDATE() - INTERVAL 5 DAY, 112),
(CURDATE() - INTERVAL 6 DAY, 116),
(CURDATE() - INTERVAL 7 DAY, 80),
(CURDATE() - INTERVAL 8 DAY, 73),
(CURDATE() - INTERVAL 9 DAY, 73),
(CURDATE() - INTERVAL 10 DAY, 126),
(CURDATE() - INTERVAL 11 DAY, 51),
(CURDATE() - INTERVAL 12 DAY, 79),
(CURDATE() - INTERVAL 13 DAY, 75),
(CURDATE() - INTERVAL 14 DAY, 47),
(CURDATE() - INTERVAL 15 DAY, 51),
(CURDATE() - INTERVAL 16 DAY, 81),
(CURDATE() - INTERVAL 17 DAY, 41),
(CURDATE() - INTERVAL 18 DAY, 42),
(CURDATE() - INTERVAL 19 DAY, 51),
(CURDATE() - INTERVAL 20 DAY, 54),
(CURDATE() - INTERVAL 21 DAY, 58),
(CURDATE() - INTERVAL 22 DAY, 44),
(CURDATE() - INTERVAL 23 DAY, 94),
(CURDATE() - INTERVAL 24 DAY, 95),
(CURDATE() - INTERVAL 25 DAY, 78),
(CURDATE() - INTERVAL 26 DAY, 81),
(CURDATE() - INTERVAL 27 DAY, 59),
(CURDATE() - INTERVAL 28 DAY, 107),
(CURDATE() - INTERVAL 29 DAY, 57),
(CURDATE() - INTERVAL 30 DAY, 47);

