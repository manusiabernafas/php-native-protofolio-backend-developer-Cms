<?php
require ROOT . '/includes/data.php';
$p = data_proyek((string) ($_GET['slug'] ?? ''));
if (!$p) { http_response_code(404); require ROOT . '/pages/404.php'; exit; }
$s = setting();
$info = array_filter(['Klien' => $p['klien'] ?: 'Proyek pribadi', 'Peran' => $p['peran'], 'Tahun' => $p['tahun'], 'Durasi' => $p['durasi'], 'Dilihat' => number_format((int) $p['dilihat'], 0, ',', '.') . ' kali']);
$cover = gambar($p['cover']);
?>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <?= meta_head($p['judul'] . ' · ' . $s['nama'], $p['ringkasan'], $cover) ?>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?<?= FONT_SITE ?>&display=swap">
    <link rel="stylesheet" href="assets/css/site.css">
    <?= css_aksen() ?>
    <script>document.documentElement.classList.add('js')</script>
</head>
<body class="detail">
<div class="xhair" aria-hidden="true"><i class="xh"></i><i class="xv"></i><span class="xc mono">X 0000 · Y 0000</span></div>
<header class="tblock">
    <a href="index.php#lembar" class="tb-cell tb-brand"><span class="tb-mark"><?= icon('arrow-left', 20) ?></span><span><small class="mono">Kembali ke</small><b>Lembar proyek</b></span></a>
    <div class="tb-cell tb-grow mono"><small>Judul gambar</small><b><?= e($p['judul']) ?></b></div>
    <div class="tb-cell tb-sheet mono"><small>Kategori</small><b><?= e($p['kategori']) ?></b></div>
</header>
<main class="wrap frame">
    <section class="d-head">
        <p class="mono tag"><span class="tag-box"><?= e(strtoupper($p['kategori'])) ?></span> <?= $p['tahun'] ?></p>
        <h1><?= e($p['judul']) ?></h1>
        <p class="lead"><?= e($p['ringkasan']) ?></p>
    </section>
    <figure class="d-cover rv" id="loupeArea">
        <img src="<?= e($cover) ?>" alt="<?= e($p['judul']) ?>" id="loupeImg">
        <span class="loupe" id="loupe" style="background-image:url('<?= e($cover) ?>')"></span>
        <figcaption class="mono">Arahkan kursor ke gambar untuk memperbesar &middot; skala 2:1</figcaption>
    </figure>
    <section class="d-body">
        <table class="spec rv"><?php foreach ($info as $k => $v): ?><tr><th class="mono"><?= $k ?></th><td><?= e($v) ?></td></tr><?php endforeach; ?>
            <?php if ($p['tek']): ?><tr><th class="mono">Komponen</th><td><ul class="d-tek"><?php foreach ($p['tek'] as $t): ?><li><?= logo($t['logo'], 18, $t['nama']) ?> <?= e($t['nama']) ?></li><?php endforeach; ?></ul></td></tr><?php endif; ?>
        </table>
        <article class="prose rv"><?= markdown_mini($p['isi']) ?>
            <div class="d-links">
                <?php if ($u = link_aman($p['link_demo'])): ?><a class="btn btn-hi" href="<?= e($u) ?>" target="_blank" rel="noopener"><?= icon('external-link', 18) ?> Lihat sistem</a><?php endif; ?>
                <?php if ($u = link_aman($p['link_repo'])): ?><a class="btn btn-line" href="<?= e($u) ?>" target="_blank" rel="noopener"><?= icon('git-branch', 18) ?> Repositori</a><?php endif; ?>
            </div>
        </article>
    </section>
    <?php if ($p['galeri']): ?>
    <section class="d-gallery">
        <?php foreach ($p['galeri'] as $i => $g): ?>
            <figure class="rv"><a href="<?= e(gambar($g['file'])) ?>" data-lb><img src="<?= e(gambar($g['file'])) ?>" alt="<?= e($g['keterangan']) ?>" loading="lazy"></a><figcaption class="mono">DET. <?= chr(65 + $i) ?> &mdash; <?= e($g['keterangan'] ?: 'Detail') ?></figcaption></figure>
        <?php endforeach; ?>
    </section>
    <?php endif; ?>
    <?php if ($p['berikut']): ?>
    <nav class="d-next">
        <a href="<?= url('proyek', ['slug' => $p['sebelum']['slug']]) ?>"><small class="mono"><?= icon('arrow-left', 14) ?> Lembar sebelumnya</small><b><?= e($p['sebelum']['judul']) ?></b></a>
        <a href="<?= url('proyek', ['slug' => $p['berikut']['slug']]) ?>" class="nx"><small class="mono">Lembar berikutnya <?= icon('arrow-right', 14) ?></small><b><?= e($p['berikut']['judul']) ?></b></a>
    </nav>
    <?php endif; ?>
</main>
<div class="lightbox" id="lb" hidden><button class="btn btn-hi" aria-label="Tutup"><?= icon('x', 22) ?></button><img alt=""></div>
<footer class="foot"><div class="wrap foot-grid mono"><div class="cell"><small>Digambar oleh</small><b><?= e($s['nama']) ?></b></div><a class="cell" href="index.php#order"><small>Tertarik?</small><b>Ajukan work order</b></a></div></footer>
<script src="assets/js/site.js"></script>
</body>
</html>
