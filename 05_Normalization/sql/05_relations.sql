-- ============================================
-- 05-05: Relationships — One-to-One, One-to-Many, Many-to-Many
-- ============================================

-- ============================================
// ONE-TO-ONE (1:1)
// ============================================
-- 1 user punya 1 profil (dan 1 profil cuma buat 1 user)
.print '=== ONE-TO-ONE: Users ↔ Profiles ===';

CREATE TABLE IF NOT EXISTS users_11 (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS profiles (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL UNIQUE,  -- UNIQUE = 1 user cuma punya 1 profil
    bio TEXT,
    avatar_url TEXT,
    FOREIGN KEY (user_id) REFERENCES users_11(id)
);

INSERT INTO users_11 VALUES (1, 'Yanto');
INSERT INTO profiles VALUES (1, 1, 'Software engineer belajar', 'https://avatar.com/yanto');

SELECT u.name, p.bio FROM users_11 u
INNER JOIN profiles p ON u.id = p.user_id;

-- ============================================
// ONE-TO-MANY (1:N)
// ============================================
-- 1 user punya BANYAK posts
.print '\n=== ONE-TO-MANY: Users ↔ Posts ===';

CREATE TABLE IF NOT EXISTS users_1n (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS posts_1n (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,         -- NOT UNIQUE = banyak posts bisa punya user yang sama
    title TEXT NOT NULL,
    content TEXT,
    FOREIGN KEY (user_id) REFERENCES users_1n(id)
);

INSERT INTO users_1n VALUES (1, 'Yanto');
INSERT INTO posts_1n VALUES (1, 1, 'Post 1', 'Isi post pertama');
INSERT INTO posts_1n VALUES (2, 1, 'Post 2', 'Isi post kedua');

SELECT u.name, p.title FROM users_1n u
INNER JOIN posts_1n p ON u.id = p.user_id;

-- ============================================
// MANY-TO-MANY (N:M)
// ============================================
-- 1 post punya BANYAK tags, 1 tag dipake BANYAK posts
-- Butuh tabel PENGHUBUNG (junction table)
.print '\n=== MANY-TO-MANY: Posts ↔ Tags ===';

CREATE TABLE IF NOT EXISTS posts_nm (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS tags (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE
);

-- Junction table (tabel penghubung)
CREATE TABLE IF NOT EXISTS post_tags (
    post_id INTEGER NOT NULL,
    tag_id INTEGER NOT NULL,
    PRIMARY KEY (post_id, tag_id),
    FOREIGN KEY (post_id) REFERENCES posts_nm(id),
    FOREIGN KEY (tag_id) REFERENCES tags(id)
);

INSERT INTO posts_nm VALUES (1, 'Belajar SQL');
INSERT INTO posts_nm VALUES (2, 'Tips React');
INSERT INTO tags VALUES (1, 'database');
INSERT INTO tags VALUES (2, 'frontend');
INSERT INTO tags VALUES (3, 'tutorial');

-- Post 1 punya tag: database, tutorial
INSERT INTO post_tags VALUES (1, 1);
INSERT INTO post_tags VALUES (1, 3);

-- Post 2 punya tag: frontend, tutorial
INSERT INTO post_tags VALUES (2, 2);
INSERT INTO post_tags VALUES (2, 3);

-- Cari tags dari post 1
.print 'Tags dari "Belajar SQL":';
SELECT t.name FROM tags t
INNER JOIN post_tags pt ON t.id = pt.tag_id
WHERE pt.post_id = 1;

-- Cari posts dengan tag "tutorial"
.print '\nPost dengan tag "tutorial":';
SELECT p.title FROM posts_nm p
INNER JOIN post_tags pt ON p.id = pt.post_id
INNER JOIN tags t ON pt.tag_id = t.id
WHERE t.name = 'tutorial';

.print '\n✅ SEMUA RELATIONSHIP SELESAI!';
.print '1:1 — users ↔ profiles (UNIQUE FK)';
.print '1:N — users ↔ posts (FK biasa)';
.print 'N:M — posts ↔ tags (junction table)';
