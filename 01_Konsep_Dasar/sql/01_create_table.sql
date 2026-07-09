-- ============================================
-- 01: CREATE TABLE — Bikin Tabel
-- ============================================
-- Jalanin: sqlite3 learn.db < 01_create_table.sql

-- Matiin dulu foreign key biar gak error pas bikin tabel
PRAGMA foreign_keys = OFF;

-- Bikin tabel users
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE
);

-- Bikin tabel posts (nyambung ke users via user_id)
CREATE TABLE IF NOT EXISTS posts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    content TEXT,
    user_id INTEGER NOT NULL,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Hidupin lagi foreign key
PRAGMA foreign_keys = ON;

.print '✅ Tabel users dan posts berhasil dibuat!';
