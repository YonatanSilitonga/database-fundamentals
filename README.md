# Database Fundamentals — Code Learning 


Repo ini buat belajar database dari fundamental sampai bisa paham cara kerja di dalamnya.

## 5 Topik Utama

| # | Topik | Isi |
|---|---|---|
| **01** | Konsep Dasar Database | SQL, Relational DB, PK, FK, JOIN |
| **02** | Storage & Indexing | Sequential vs Index, B-Tree, Clustered vs Non-Clustered |
| **03** | Query Execution | Sequential Scan, Index Scan, Query Planner, EXPLAIN |
| **04** | Transactions & ACID | Atomicity, Consistency, Isolation, Durability, Locking |
| **05** | Normalization | 1NF, 2NF, 3NF, Relationships |

## Bahasa yang Dipake

- **SQL** — fondasi utama
- **JavaScript** — prototype cepet
- **Go** — backend production
- **Java** — enterprise
- **C** — low level, koneksi langsung

## Cara Pake

Jalanin file `.sql`:
```bash
sqlite3 learn.db < 01_Konsep_Dasar/sql/01_create_table.sql
```

Jalanin file `.js`:
```bash
node 01_Konsep_Dasar/javascript/index.js
```
