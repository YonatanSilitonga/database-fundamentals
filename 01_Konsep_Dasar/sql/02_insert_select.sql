-- ============================================
-- 02: INSERT & SELECT — Nambah & Ambil Data
-- ============================================

-- INSERT: nambah data ke tabel users
INSERT INTO users (name, email) VALUES ('Yanto', 'yanto@email.com');
INSERT INTO users (name, email) VALUES ('YongMa', 'yongma@email.com');
INSERT INTO users (name, email) VALUES ('Budi', 'budi@email.com');

-- INSERT: nambah data ke tabel posts
INSERT INTO posts (title, content, user_id) VALUES ('Belajar SQL', 'Hari ini belajar SQL dasar.', 1);
INSERT INTO posts (title, content, user_id) VALUES ('Belajar Next.js', 'Framework React buat production.', 1);
INSERT INTO posts (title, content, user_id) VALUES ('Tips Go', 'Go itu bahasa backend yang keren.', 2);

-- SELECT: ambil semua data dari users
.print '=== Semua Users ===';
SELECT * FROM users;

-- SELECT: ambil data tertentu pake WHERE
.print '=== User dengan id = 1 ===';
SELECT * FROM users WHERE id = 1;

-- SELECT: ambil kolom tertentu
.print '=== Nama user aja ===';
SELECT name FROM users;

-- SELECT: urutin berdasarkan nama
.print '=== Users urut nama ===';
SELECT * FROM users ORDER BY name ASC;

-- SELECT: batasi jumlah data
.print '=== 2 users pertama ===';
SELECT * FROM users LIMIT 2;
