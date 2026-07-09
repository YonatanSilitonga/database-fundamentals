-- ============================================
-- 04: JOIN — Nyambungin Antar Tabel
-- ============================================

-- INNER JOIN: ambil posts + usernya (hanya yang punya user)
.print '=== INNER JOIN: posts + users ===';
SELECT 
    posts.id,
    posts.title,
    users.name AS author
FROM posts
INNER JOIN users ON posts.user_id = users.id;

-- LEFT JOIN: ambil semua posts, meskipun usernya udah dihapus
.print '=== LEFT JOIN: posts + users (termasuk yang user-nya ilang) ===';
SELECT 
    posts.id,
    posts.title,
    users.name AS author
FROM posts
LEFT JOIN users ON posts.user_id = users.id;

-- JOIN dengan kondisi WHERE
.print '=== Artikel punya Yanto ===';
SELECT 
    posts.title,
    posts.content
FROM posts
INNER JOIN users ON posts.user_id = users.id
WHERE users.name = 'Yanto';

-- Hitung jumlah artikel per user (GROUP BY + COUNT)
.print '=== Jumlah Artikel per User ===';
SELECT 
    users.name,
    COUNT(posts.id) AS total_artikel
FROM users
LEFT JOIN posts ON users.id = posts.user_id
GROUP BY users.id;
