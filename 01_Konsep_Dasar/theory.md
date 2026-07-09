# 01 — Konsep Dasar Database

---

## Apa Itu Database?

Database = tempat nyimpen data secara terstruktur.

**Kenapa gak pake file JSON/CSV aja?**
- JSON/CSV: lo baca seluruh file, cari manual, tulis ulang. Ribet dan lambat.
- Database: lo tinggal bilang `SELECT * FROM users WHERE id = 5`. Cepet, aman, gak perlu load semua data.

**Database Management System (DBMS)** = software yang ngatur database. Contoh:
- **SQLite** — kecil, file-based, cocok belajar & lokal
- **PostgreSQL** — canggih, production, open source
- **MySQL** — populer, banyak dipake web hosting

---

## Relational Database

Data disimpan dalam **tabel** — mirip Excel.

| Tabel Users | | |
|---|---|---|
| id (PK) | name | email |
| 1 | Yanto | yanto@email.com |
| 2 | YongMa | yongma@email.com |

**Istilah Penting:**
- **Tabel** = kumpulan data sejenis (contoh: Users, Posts)
- **Baris (Row/Record)** = satu entitas data (contoh: data user Yanto)
- **Kolom (Column/Field)** = satu atribut (contoh: name, email)
- **Primary Key (PK)** = kolom yang unik buat tiap baris (gak boleh sama)
- **Foreign Key (FK)** = kolom yang nyambung ke primary key tabel lain

---

## SQL Dasar

SQL = Structured Query Language. Bahasa yang dipake buat ngomong sama database.

4 operasi utama: **CRUD**
- **C**reate → `INSERT`
- **R**ead → `SELECT`
- **U**pdate → `UPDATE`
- **D**elete → `DELETE`

---

## Cara Belajar di Folder Ini

1. Buka folder `sql/` — jalanin file `.sql` pake SQLite di terminal
2. Baca kode di folder `javascript/`, `go/`, `java/`, `c/` — liat beda sintaks tapi konsep sama
3. Bandingin: SQL cuma 3 baris, sedangkan C bisa 80 baris buat hal yang sama
