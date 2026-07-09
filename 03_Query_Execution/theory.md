# 03 — Query Execution

---

## Sequential Scan

Database baca **semua baris** dari awal sampai akhir.

```
for each row in table:
    if row matches WHERE condition:
        return row
```

**Kapan dipake:**
- Gak ada index yang cocok
- Tabel kecil (< 1000 baris) — biasanya sequential scan lebih cepet dari index scan
- Harus baca banyak baris (> 30% dari total) — kadang lebih efisien daripada pake index

---

## Index Scan

Database pake **index** buat lompat langsung ke baris yang dicari.

```
1. Cari nilai di B-Tree (O(log n))
2. Dapet pointer ke baris asli
3. Ambil data dari baris asli
```

**Kapan dipake:**
- Ada index yang cocok dengan WHERE
- Data yang dicari sedikit (selektif)

---

## Query Planner

Database **otomatis milih** cara terbaik buat ngejalanin query lo. Dia mikir:

1. Index apa yang tersedia?
2. Berapa perkiraan jumlah baris yang bakal ke-filter?
3. Mana yang lebih murah: sequential scan atau index scan?

Keputusan ini dibuat oleh **Query Optimizer**. Kadang dia salah milih — itu yang disebut **slow query**.

---

## EXPLAIN

Perintah buat liat **gimana database ngejalanin query lo**.

```sql
EXPLAIN QUERY PLAN SELECT * FROM users WHERE name = 'Yanto';
```

Hasilnya bakal nunjukin:
- `SCAN` — sequential scan (tanpa index)
- `SEARCH` — index scan (pake index)
- `USING INDEX` — index yang dipake

Ini tools nomor 1 buat debug query lambat!

---

## Apa yang Akan Lo Praktekkan:

1. Jalanin `EXPLAIN` sebelum dan sesudah bikin index — liat bedanya
2. Jalanin `EXPLAIN` buat JOIN — liat algoritma yang dipake
3. Jalanin simulasi query planner di JS — paham gimana database milih jalan
