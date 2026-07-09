// ============================================
// 01: Konsep Dasar — JavaScript Version
// ============================================
// Jalanin: node javascript/index.js
// (Harus install better-sqlite3 dulu: npm install better-sqlite3)

const Database = require('better-sqlite3');

// Konek ke database (atau bikin baru kalo gak ada)
const db = new Database('learn.db');

// Matiin foreign key dulu
db.pragma('foreign_keys = OFF');

// --- CREATE TABLE ---
db.exec(`
    CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE
    )
`);

db.exec(`
    CREATE TABLE IF NOT EXISTS posts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT,
        user_id INTEGER NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users(id)
    )
`);

db.pragma('foreign_keys = ON');
console.log('✅ Tabel users dan posts berhasil dibuat!');

// --- INSERT ---
const insertUser = db.prepare('INSERT INTO users (name, email) VALUES (?, ?)');
insertUser.run('Yanto', 'yanto@email.com');
insertUser.run('YongMa', 'yongma@email.com');
insertUser.run('Budi', 'budi@email.com');
console.log('✅ Data users berhasil dimasukkan!');

const insertPost = db.prepare('INSERT INTO posts (title, content, user_id) VALUES (?, ?, ?)');
insertPost.run('Belajar SQL', 'Hari ini belajar SQL dasar.', 1);
insertPost.run('Belajar Next.js', 'Framework React buat production.', 1);
insertPost.run('Tips Go', 'Go itu bahasa backend yang keren.', 2);
console.log('✅ Data posts berhasil dimasukkan!');

// --- SELECT ---
console.log('\n=== Semua Users ===');
const users = db.prepare('SELECT * FROM users').all();
console.table(users);

console.log('\n=== User dengan id = 1 ===');
const user = db.prepare('SELECT * FROM users WHERE id = ?').get(1);
console.log(user);

// --- JOIN ---
console.log('\n=== Posts + Users (INNER JOIN) ===');
const posts = db.prepare(`
    SELECT posts.id, posts.title, users.name AS author
    FROM posts
    INNER JOIN users ON posts.user_id = users.id
`).all();
console.table(posts);

// --- GROUP BY ---
console.log('\n=== Jumlah Artikel per User ===');
const stats = db.prepare(`
    SELECT users.name, COUNT(posts.id) AS total_artikel
    FROM users
    LEFT JOIN posts ON users.id = posts.user_id
    GROUP BY users.id
`).all();
console.table(stats);

db.close();
console.log('\n✅ Selesai! Database ditutup.');
