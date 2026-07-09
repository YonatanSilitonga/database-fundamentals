# 02 — Storage & Indexing

---

## Sequential Storage (Heap)

Cara paling sederhana database nyimpen data: **ditulis berurutan** kayak buku tamu.

**Keuntungan:**
- Nulis cepet (tinggal append di akhir file)
- Cocok buat data yang jarang dicari (log, audit trail)

**Kerugian:**
- Nyari data lambat — harus scan dari baris pertama sampe ketemu (sequential scan)
- Makin banyak data, makin lambat (O(n))

**Analogi:**
Kayak lo nyari nomor telepon di buku tanpa indeks. Lo buka halaman 1, baca satu-satu sampe ketemu. Capek kan?

---

## Indexing

Index = struktur data terpisah yang **mempercepat pencarian**.

**Cara kerja:**
- Index nyimpen salinan kolom yang di-index + pointer ke baris asli
- Pake struktur data **B-Tree / B+Tree** biar pencarian cepet (O(log n))

**Keuntungan:**
- SELECT jadi jauh lebih cepet
- WHERE, JOIN, ORDER BY juga terbantu

**Kerugian:**
- Nulis (INSERT/UPDATE/DELETE) jadi lebih lambat — karena index juga harus diupdate
- Pake storage tambahan (biasanya 10-20% dari ukuran data)

**Kapan pake index:**
✅ Kolom yang sering dipake di WHERE
✅ Kolom yang dipake JOIN (Foreign Key)
✅ Kolom yang perlu unique / cepet dicari

❌ Kolom yang jarang dipake di query
❌ Tabel kecil ( < 1000 baris ) — sequential scan udah cukup cepet

---

## B-Tree / B+Tree

B-Tree = struktur data tree yang:
- Node punya banyak child (bukan Cuma 2 kayak binary tree)
- Seimbang (balanced) — depth-nya hampir sama buat semua leaf
- Pencarian O(log n) — 1 juta data cuma butuh ~3-4 level

**B+Tree** (yang paling sering dipake database):
- Semua data ada di leaf nodes (node paling bawah)
- Internal nodes cuma nyimpen key buat navigasi
- Leaf nodes saling nyambung — bikin range scan cepet

---

## Clustered vs Non-Clustered Index

**Clustered Index:**
- Data diurutin langsung berdasarkan index
- 1 tabel cuma bisa punya 1 clustered index (biasanya PRIMARY KEY)
- SQLite: clustered index otomatis di `INTEGER PRIMARY KEY`
- MySQL InnoDB: clustered index di PRIMARY KEY

**Non-Clustered Index:**
- Index pisah dari data asli
- Index nyimpen pointer ke data asli
- 1 tabel bisa punya banyak non-clustered index
- SELECT butuh 2 langkah: cari di index → ambil data

---

## Apa yang Akan Lo Praktekkan:

1. **Jalanin query tanpa index** — liat lambatnya sequential scan
2. **Buat index** — jalanin query yang sama, liat beda kecepatan
3. **Bandingin hasil** — pake `.timer ON` di SQLite
4. **Simulasi B-Tree pake JS** — biar paham struktur data di dalamnya
