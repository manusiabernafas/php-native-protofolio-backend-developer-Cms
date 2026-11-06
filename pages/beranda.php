<?php
require ROOT . '/includes/data.php';
$D = data_beranda();
$s = setting();
$kontak = $_SESSION['kontak'] ?? null;
unset($_SESSION['kontak']);
$foto = gambar($s['foto'] ?? '', 'assets/img/potret.svg');
$wa = nomor_wa($s['whatsapp'] ?? '');
$inisial = implode('', array_map(fn($w) => mb_substr($w, 0, 1), array_slice(explode(' ', $s['nama']), 0, 2)));

// Lapisan tumpukan isometrik = kategori teknologi (maks 6), logo diambil dari teknologi di kategori itu
$lapis = array_slice($D['tek_kategori'], 0, 6, true);

// Rentang tahun untuk diagram Gantt perjalanan karier
$semuaJejak = array_merge($D['kerja'], $D['pendidikan']);
$thAwal = $semuaJejak ? (int) min(array_map(fn($x) => substr($x['mulai'], 0, 4), $semuaJejak)) : (int) date('Y') - 5;
$thAkhir = (int) date('Y') + 1;
$posisi = function (?string $tgl) use ($thAwal, $thAkhir): float {
    $t = $tgl ? strtotime($tgl) : time();
    $x = ((int) date('Y', $t) - $thAwal + ((int) date('n', $t) - 1) / 12) / max(1, $thAkhir - $thAwal);
    return round(max(0, min(1, $x)) * 100, 2);
};
?>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <?= meta_head($s['nama'] . ' · ' . $s['peran']) ?>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?<?= FONT_SITE ?>&display=swap">
    <link rel="stylesheet" href="assets/css/site.css">
    <?= css_aksen() ?>
    <script>document.documentElement.classList.add('js')</script>
</head>
<body>
<div class="xhair" aria-hidden="true"><i class="xh"></i><i class="xv"></i><span class="xc mono">X 0000 · Y 0000</span></div>

<header class="tblock" id="tblock">
    <a href="#top" class="tb-cell tb-brand"><span class="tb-mark"><?= e(mb_strtoupper($inisial)) ?></span><span><small class="mono">Digambar oleh</small><b><?= e($s['nama']) ?></b></span></a>
    <nav class="tb-nav" id="tbnav">
        <a href="#spesifikasi" class="tb-cell"><small class="mono">A</small>Spesifikasi</a>
        <a href="#lembar" class="tb-cell"><small class="mono">B</small>Proyek</a>
        <a href="#komponen" class="tb-cell"><small class="mono">C</small>Komponen</a>
        <a href="#jejak" class="tb-cell"><small class="mono">D</small>Jejak</a>
        <a href="#order" class="tb-cell tb-hot"><small class="mono">E</small>Work order</a>
    </nav>
    <div class="tb-cell tb-sheet mono"><small>Lembar</small><b id="sheetNo">01</b>/07</div>
    <button class="tb-burger" aria-label="Menu" onclick="document.body.classList.toggle('menu-open')"><?= icon('menu', 24) ?></button>
</header>

<main id="top">
    <!-- HERO -->
    <section class="hero wrap" data-sheet="01">
        <div class="hero-text">
            <p class="mono tag"><span class="tag-box">DWG-01</span> Rancangan utama &middot; <?= e($s['kota']) ?></p>
            <h1><?= e($s['judul_hero']) ?></h1>
            <p class="lead"><?= e($s['tagline']) ?></p>
            <div class="cta">
                <a href="#lembar" class="btn btn-hi"><?= icon('ruler', 18) ?> Lihat lembar proyek</a>
                <?php if (!empty($s['cv'])): ?><a href="<?= e(gambar($s['cv'])) ?>" class="btn btn-line" download><?= icon('download', 18) ?> Unduh CV</a><?php endif; ?>
            </div>
            <?php if (($s['tersedia'] ?? '1') === '1'): ?><p class="status mono"><span class="led"></span><?= e($s['status_teks']) ?></p><?php endif; ?>
        </div>
        <div class="iso-stage" aria-hidden="true">
            <div class="iso" id="iso" style="--n:<?= count($lapis) ?>">
                <?php $i = 0; foreach ($lapis as $kat => $list): ?>
                    <div class="slab <?= $i === 0 ? 'hi' : '' ?>" style="--i:<?= $i ?>">
                        <span class="slab-label mono"><?= str_pad((string) ($i + 1), 2, '0', STR_PAD_LEFT) ?> <?= e(mb_strtoupper($kat)) ?></span>
                        <div class="slab-logos"><?php foreach (array_slice($list, 0, 4) as $t): ?><span><?= logo($t['logo'], 30, $t['nama']) ?></span><?php endforeach; ?></div>
                    </div>
                <?php $i++; endforeach; ?>
            </div>
            <div class="iso-legend mono">
                <?php $i = 0; foreach ($lapis as $kat => $list): ?><span><b><?= str_pad((string) ($i + 1), 2, '0', STR_PAD_LEFT) ?></b> <?= e($kat) ?> <em><?= count($list) ?></em></span><?php $i++; endforeach; ?>
                <span class="hint">scroll &darr; untuk mengurai</span>
            </div>
        </div>
    </section>

    <!-- SPESIFIKASI -->
    <section class="wrap sheet" id="spesifikasi" data-sheet="02">
        <div class="sheet-head rv"><span class="mono">A &mdash; 02</span><h2>Spesifikasi teknis</h2><i class="dim"></i></div>
        <div class="spec-grid">
            <div class="spec-photo rv">
                <img src="<?= e($foto) ?>" alt="<?= e($s['nama']) ?>">
                <span class="dimline v mono"><i></i><b>1 orang</b><i></i></span>
                <span class="dimline h mono"><i></i><b><?= $D['angka']['tahun'] ?> tahun</b><i></i></span>
            </div>
            <div class="bio rv"><?= markdown_mini($s['bio'] ?? '') ?></div>
            <table class="spec rv">
                <tr><th class="mono">Model</th><td><?= e($s['peran']) ?></td></tr>
                <tr><th class="mono">Basis</th><td><?= e($s['kota']) ?></td></tr>
                <tr><th class="mono">Beroperasi sejak</th><td><?= e($s['tahun_mulai']) ?></td></tr>
                <tr><th class="mono">Komponen utama</th><td><?= e(implode(', ', array_column(array_slice($D['unggulan_tek'], 0, 4), 'nama'))) ?></td></tr>
                <?php if (!empty($s['email'])): ?><tr><th class="mono">Antarmuka</th><td><a href="mailto:<?= e($s['email']) ?>"><?= e($s['email']) ?></a></td></tr><?php endif; ?>
            </table>
        </div>
        <div class="readouts">
            <?php foreach ([['tahun', 'tahun beroperasi'], ['proyek', 'sistem dirilis'], ['klien', 'klien'], ['tek', 'komponen dikuasai']] as [$k, $l]): ?>
                <div class="readout rv"><b class="mono" data-count="<?= $D['angka'][$k] ?>">00</b><span class="mono"><?= $l ?></span></div>
            <?php endforeach; ?>
        </div>
    </section>

    <!-- LEMBAR PROYEK -->
    <section class="wrap sheet" id="lembar" data-sheet="03">
        <div class="sheet-head rv"><span class="mono">B &mdash; 03</span><h2>Lembar proyek</h2><i class="dim"></i></div>
        <div class="filters mono" role="tablist">
            <button class="on" data-f="*">Semua</button>
            <?php foreach ($D['kategori'] as $k): ?><button data-f="<?= e($k) ?>"><?= e($k) ?></button><?php endforeach; ?>
        </div>
        <div class="sheets">
            <?php foreach ($D['proyek'] as $i => $p): ?>
                <article class="flip rv" data-k="<?= e($p['kategori']) ?>" tabindex="0">
                    <div class="flip-in">
                        <div class="face front">
                            <img src="<?= e(gambar($p['cover'])) ?>" alt="<?= e($p['judul']) ?>" loading="lazy">
                            <div class="tb-mini mono"><span>DWG-<?= str_pad((string) ($i + 1), 2, '0', STR_PAD_LEFT) ?></span><b><?= e($p['judul']) ?></b><span><?= e($p['kategori']) ?> &middot; <?= $p['tahun'] ?></span></div>
                        </div>
                        <div class="face back">
                            <p class="mono">DWG-<?= str_pad((string) ($i + 1), 2, '0', STR_PAD_LEFT) ?> &middot; detail</p>
                            <h3><?= e($p['judul']) ?></h3>
                            <p><?= e($p['ringkasan']) ?></p>
                            <dl class="mono"><dt>Klien</dt><dd><?= e($p['klien'] ?: 'Pribadi') ?></dd><dt>Peran</dt><dd><?= e($p['peran']) ?></dd></dl>
                            <div class="b-logos"><?php foreach ($p['tek'] as $t): ?><span title="<?= e($t['nama']) ?>"><?= logo($t['logo'], 22, $t['nama']) ?></span><?php endforeach; ?></div>
                            <a class="btn btn-hi" href="<?= url('proyek', ['slug' => $p['slug']]) ?>"><?= icon('arrow-up-right', 18) ?> Buka lembar</a>
                        </div>
                    </div>
                </article>
            <?php endforeach; ?>
        </div>
    </section>

    <!-- KOMPONEN (BOM) -->
    <section class="wrap sheet" id="komponen" data-sheet="04">
        <div class="sheet-head rv"><span class="mono">C &mdash; 04</span><h2>Daftar komponen</h2><i class="dim"></i></div>
        <div class="bom-wrap rv">
            <table class="bom">
                <thead class="mono"><tr><th>No.</th><th>Komponen</th><th class="hide-sm">Kelompok</th><th>Penguasaan</th></tr></thead>
                <tbody>
                    <?php foreach ($D['teknologi'] as $i => $t): ?>
                        <tr><td class="mono"><?= str_pad((string) ($i + 1), 3, '0', STR_PAD_LEFT) ?></td><td><span class="bom-name"><?= logo($t['logo'], 24, $t['nama']) ?> <?= e($t['nama']) ?></span></td><td class="mono hide-sm"><?= e($t['kategori']) ?></td>
                            <td><div class="lv"><span class="segs" style="--lv:<?= (int) round($t['level'] / 10) ?>" aria-label="<?= (int) $t['level'] ?>%"><?php for ($k = 1; $k <= 10; $k++): ?><i class="<?= $k <= round($t['level'] / 10) ? 'on' : '' ?>"></i><?php endfor; ?></span><b class="mono"><?= (int) $t['level'] ?>%</b></div></td></tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        </div>
    </section>

    <!-- LAYANAN: diagram alir -->
    <?php if ($D['layanan']): ?>
    <section class="wrap sheet" id="layanan" data-sheet="05">
        <div class="sheet-head rv"><span class="mono">C &mdash; 05</span><h2>Modul layanan</h2><i class="dim"></i></div>
        <div class="flow">
            <?php foreach ($D['layanan'] as $i => $l): ?>
                <article class="module rv" style="--d:<?= $i * 120 ?>ms">
                    <span class="mod-no mono">M<?= $i + 1 ?></span>
                    <span class="mod-ic"><?= icon($l['ikon'], 30) ?></span>
                    <h3><?= e($l['judul']) ?></h3>
                    <p><?= e($l['deskripsi']) ?></p>
                    <p class="mono price"><?= $l['harga_mulai'] ? 'mulai ' . rupiah((int) $l['harga_mulai']) : 'harga sesuai lingkup' ?></p>
                </article>
            <?php endforeach; ?>
        </div>
    </section>
    <?php endif; ?>

    <!-- JEJAK: gantt -->
    <section class="wrap sheet" id="jejak" data-sheet="06">
        <div class="sheet-head rv"><span class="mono">D &mdash; 06</span><h2>Jadwal perjalanan</h2><i class="dim"></i></div>
        <div class="gantt rv">
            <div class="g-scale mono"><?php for ($y = $thAwal; $y <= $thAkhir; $y++): ?><span style="left:<?= round(($y - $thAwal) / max(1, $thAkhir - $thAwal) * 100, 2) ?>%"><?= $y ?></span><?php endfor; ?></div>
            <?php foreach (['Kerja' => $D['kerja'], 'Pendidikan' => $D['pendidikan']] as $grup => $list): if (!$list) continue; ?>
                <p class="g-group mono"><?= $grup ?></p>
                <?php foreach ($list as $x): $a = $posisi($x['mulai']); $b = $posisi($x['selesai']); ?>
                    <div class="g-row">
                        <div class="g-label"><b><?= e($x['posisi']) ?></b><small><?= e($x['instansi']) ?> &middot; <span class="mono"><?= bulan_tahun($x['mulai']) ?> &ndash; <?= bulan_tahun($x['selesai']) ?></span></small></div>
                        <div class="g-track"><i class="g-bar <?= $x['selesai'] ? '' : 'now' ?> <?= $grup === 'Pendidikan' ? 'edu' : '' ?>" style="left:<?= $a ?>%;width:<?= max(1.5, $b - $a) ?>%" title="<?= e($x['deskripsi']) ?>"></i></div>
                    </div>
                <?php endforeach; ?>
            <?php endforeach; ?>
        </div>
        <ul class="g-notes">
            <?php foreach ($D['kerja'] as $x): ?><li class="rv"><span class="mono"><?= bulan_tahun($x['mulai']) ?></span><b><?= e($x['instansi']) ?></b><p><?= e($x['deskripsi']) ?></p></li><?php endforeach; ?>
        </ul>
    </section>

    <!-- TESTIMONI: tabel revisi -->
    <?php if ($D['testimoni']): ?>
    <section class="wrap sheet" id="revisi" data-sheet="06">
        <div class="sheet-head rv"><span class="mono">D &mdash; 06b</span><h2>Catatan revisi dari klien</h2><i class="dim"></i></div>
        <div class="revs">
            <?php foreach ($D['testimoni'] as $i => $t): ?>
                <figure class="rev rv">
                    <span class="rev-no mono">REV.<?= chr(65 + $i) ?></span>
                    <blockquote><?= e($t['isi']) ?></blockquote>
                    <figcaption><img src="<?= e(gambar($t['foto'], 'assets/img/avatar.svg')) ?>" alt="" loading="lazy"><span><b><?= e($t['nama']) ?></b><small><?= e($t['jabatan']) ?></small></span><span class="rev-ok mono"><?= icon('check', 14) ?> <?= (int) $t['rating'] ?>/5</span></figcaption>
                </figure>
            <?php endforeach; ?>
        </div>
    </section>
    <?php endif; ?>

    <!-- WORK ORDER -->
    <section class="wrap sheet" id="order" data-sheet="07">
        <div class="sheet-head rv"><span class="mono">E &mdash; 07</span><h2>Formulir work order</h2><i class="dim"></i></div>
        <form class="wo rv" method="post" action="<?= url('kirim') ?>" id="cform" novalidate>
            <?= csrf_field() ?>
            <div class="hp" aria-hidden="true"><label>Website<input name="website" tabindex="-1" autocomplete="off"></label></div>
            <div class="wo-grid">
                <label class="cell"><span class="mono">01 Pemohon</span><input name="nama" required maxlength="100" autocomplete="name" placeholder="Nama lengkap"></label>
                <label class="cell"><span class="mono">02 Email balasan</span><input type="email" name="email" required maxlength="150" autocomplete="email" placeholder="nama@perusahaan.id"></label>
                <label class="cell"><span class="mono">03 Judul pekerjaan</span><input name="subjek" maxlength="150" placeholder="Migrasi server, audit API, ..."></label>
                <label class="cell"><span class="mono">04 Anggaran</span><select name="anggaran"><option value="">Pilih rentang</option><?php foreach (ANGGARAN as $a): ?><option><?= e($a) ?></option><?php endforeach; ?></select></label>
                <label class="cell wide"><span class="mono">05 Uraian masalah</span><textarea name="isi" rows="6" required minlength="10" maxlength="3000" placeholder="Kondisi saat ini, target, dan tenggat waktu."></textarea></label>
            </div>
            <div class="wo-foot">
                <button class="btn btn-hi" type="submit"><?= icon('send', 18) ?> Ajukan work order</button>
                <p class="form-msg mono <?= $kontak ? ($kontak[0] ? 'ok' : 'err') : '' ?>" id="formMsg" role="status"><?= $kontak ? e($kontak[1]) : '' ?></p>
                <ul class="wo-contact mono">
                    <?php if ($wa): ?><li><a href="https://wa.me/<?= e($wa) ?>" target="_blank" rel="noopener"><?= icon('message-circle', 16) ?> <?= e($s['whatsapp']) ?></a></li><?php endif; ?>
                    <?php foreach (sosial() as $so): ?><li><a href="<?= e($so['url']) ?>" target="_blank" rel="noopener"><?= $so['svg'] ?> <?= e($so['label']) ?></a></li><?php endforeach; ?>
                </ul>
            </div>
        </form>
    </section>
</main>

<footer class="foot">
    <div class="wrap foot-grid mono">
        <div class="cell"><small>Proyek</small><b>Portofolio <?= e($s['nama']) ?></b></div>
        <div class="cell"><small>Skala</small><b>1 : 1</b></div>
        <div class="cell"><small>Revisi</small><b><?= date('d.m.Y') ?></b></div>
        <div class="cell"><small>Sistem</small><b>PHP &amp; MySQL</b></div>
        <a class="cell" href="<?= url('login') ?>" rel="nofollow"><small>Akses</small><b><?= icon('lock', 14) ?> CMS</b></a>
    </div>
</footer>
<script src="assets/js/site.js"></script>
</body>
</html>
