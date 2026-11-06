// Efek halaman Blueprint: crosshair, tumpukan isometrik terurai, nomor lembar, reveal, kartu balik, kaca pembesar
(() => {
    const reduce = matchMedia('(prefers-reduced-motion: reduce)').matches;
    const fine = matchMedia('(hover: hover) and (pointer: fine)').matches;
    const $ = (s, el = document) => el.querySelector(s);
    const $$ = (s, el = document) => [...el.querySelectorAll(s)];

    // Crosshair + koordinat kursor (hanya mouse)
    const xh = $('.xhair');
    if (xh && fine && !reduce) {
        document.body.classList.add('xh-on');
        const h = $('.xh', xh), v = $('.xv', xh), c = $('.xc', xh);
        addEventListener('pointermove', e => {
            document.body.classList.add('xh-moved');
            h.style.transform = `translateY(${e.clientY}px)`;
            v.style.transform = `translateX(${e.clientX}px)`;
            c.style.transform = `translate(${e.clientX + 12}px, ${e.clientY + 12}px)`;
            c.textContent = `X ${String(Math.round(e.pageX)).padStart(4, '0')} · Y ${String(Math.round(e.pageY)).padStart(4, '0')}`;
        });
        document.documentElement.addEventListener('pointerleave', () => document.body.classList.remove('xh-moved'));
    }

    // Tumpukan isometrik: jarak antar lapis melebar mengikuti scroll (exploded view)
    const iso = $('#iso');
    const sheetNo = $('#sheetNo');
    const sheets = $$('[data-sheet]');
    let ticking = false;
    const onScroll = () => {
        if (iso && !reduce) {
            const small = innerWidth < 640;
            const p = Math.min(1, scrollY / (innerHeight * 0.8));
            iso.style.setProperty('--gap', ((small ? 26 : 34) + p * (small ? 36 : 62)).toFixed(1) + 'px');
        }
        if (sheetNo) {
            let cur = sheets[0]?.dataset.sheet;
            for (const s of sheets) if (s.getBoundingClientRect().top < innerHeight * 0.4) cur = s.dataset.sheet;
            if (cur) sheetNo.textContent = cur;
        }
        ticking = false;
    };
    addEventListener('scroll', () => { if (!ticking) { ticking = true; requestAnimationFrame(onScroll); } }, { passive: true });
    onScroll();

    // Reveal & angka penunjuk
    const count = el => {
        const n = +el.dataset.count, pad = v => String(v).padStart(2, '0');
        if (reduce) { el.textContent = pad(n); return; }
        const t0 = performance.now();
        const step = t => { const p = Math.min(1, (t - t0) / 1200); el.textContent = pad(Math.round(n * p)); if (p < 1) requestAnimationFrame(step); };
        requestAnimationFrame(step);
    };
    const io = new IntersectionObserver(es => es.forEach(en => {
        if (!en.isIntersecting) return;
        en.target.classList.add('in');
        $$('[data-count]', en.target).forEach(count);
        io.unobserve(en.target);
    }), { threshold: 0.15 });
    $$('.rv').forEach(el => io.observe(el));

    // Filter lembar proyek
    $$('.filters button').forEach(b => b.addEventListener('click', () => {
        $$('.filters button').forEach(x => x.classList.toggle('on', x === b));
        $$('.flip').forEach(c => c.classList.toggle('hide', b.dataset.f !== '*' && c.dataset.k !== b.dataset.f));
    }));

    // Kartu balik: di layar sentuh, ketukan pertama membalik kartu
    if (!fine) $$('.flip').forEach(f => f.addEventListener('click', e => {
        if (!f.classList.contains('open')) { e.preventDefault(); $$('.flip.open').forEach(o => o.classList.remove('open')); f.classList.add('open'); }
    }));

    // Kaca pembesar di cover detail proyek
    const area = $('#loupeArea'), lens = $('#loupe'), img = $('#loupeImg');
    if (area && lens && fine) {
        const zoom = 2;
        area.addEventListener('pointerenter', () => area.classList.add('on'));
        area.addEventListener('pointerleave', () => area.classList.remove('on'));
        area.addEventListener('pointermove', e => {
            const r = img.getBoundingClientRect();
            const x = e.clientX - r.left, y = e.clientY - r.top;
            lens.style.left = x + 'px'; lens.style.top = y + 'px';
            lens.style.backgroundSize = `${r.width * zoom}px ${r.height * zoom}px`;
            lens.style.backgroundPosition = `${-(x * zoom - 110)}px ${-(y * zoom - 110)}px`;
        });
    }

    // Work order lewat fetch (tanpa JS tetap terkirim lewat POST biasa)
    const form = $('#cform'), msg = $('#formMsg');
    if (form) form.addEventListener('submit', async e => {
        e.preventDefault();
        if (!form.reportValidity()) return;
        const btn = $('button[type=submit]', form);
        btn.disabled = true; msg.className = 'form-msg mono'; msg.textContent = 'Mengirim work order...';
        try {
            const r = await fetch(form.action, { method: 'POST', body: new FormData(form), headers: { 'X-Requested-With': 'fetch' } });
            const j = await r.json();
            msg.className = 'form-msg mono ' + (j.ok ? 'ok' : 'err'); msg.textContent = j.msg;
            if (j.ok) form.reset();
        } catch { msg.className = 'form-msg mono err'; msg.textContent = 'Koneksi terputus. Coba kirim ulang.'; }
        btn.disabled = false;
    });

    // Lightbox
    const lb = $('#lb');
    if (lb) {
        $$('[data-lb]').forEach(a => a.addEventListener('click', e => { e.preventDefault(); $('img', lb).src = a.href; $('img', lb).alt = $('img', a).alt; lb.hidden = false; }));
        lb.addEventListener('click', () => { lb.hidden = true; });
        addEventListener('keydown', e => { if (e.key === 'Escape') lb.hidden = true; });
    }
    $$('#tbnav a').forEach(a => a.addEventListener('click', () => document.body.classList.remove('menu-open')));
})();
