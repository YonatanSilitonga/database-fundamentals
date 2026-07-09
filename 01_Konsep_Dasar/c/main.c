// ============================================
// 01: Konsep Dasar — C Version
// ============================================
// Jalanin (pake GCC):
//   gcc main.c -lsqlite3 -o main
//   ./main
//
// Notes: Butuh libsqlite3-dev
//   Linux: sudo apt install libsqlite3-dev
//   Mac:   brew install sqlite3
//   Windows: download sqlite3.dll dari https://sqlite.org/download.html

#include <stdio.h>
#include <sqlite3.h>

void check_error(int rc, sqlite3 *db) {
    if (rc != SQLITE_OK) {
        fprintf(stderr, "SQL error: %s\n", sqlite3_errmsg(db));
    }
}

int main() {
    sqlite3 *db;
    char *err_msg = 0;
    int rc;

    // Konek ke database
    rc = sqlite3_open("../learn.db", &db);
    check_error(rc, db);
    printf("✅ Konek ke database berhasil!\n");

    // Matiin foreign key
    sqlite3_exec(db, "PRAGMA foreign_keys = OFF", 0, 0, &err_msg);

    // --- CREATE TABLE ---
    const char *sql_create_users = 
        "CREATE TABLE IF NOT EXISTS users ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "name TEXT NOT NULL,"
        "email TEXT NOT NULL UNIQUE"
        ");";

    rc = sqlite3_exec(db, sql_create_users, 0, 0, &err_msg);
    check_error(rc, db);

    const char *sql_create_posts = 
        "CREATE TABLE IF NOT EXISTS posts ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "title TEXT NOT NULL,"
        "content TEXT,"
        "user_id INTEGER NOT NULL,"
        "created_at TEXT DEFAULT CURRENT_TIMESTAMP,"
        "FOREIGN KEY (user_id) REFERENCES users(id)"
        ");";

    rc = sqlite3_exec(db, sql_create_posts, 0, 0, &err_msg);
    check_error(rc, db);

    sqlite3_exec(db, "PRAGMA foreign_keys = ON", 0, 0, &err_msg);
    printf("✅ Tabel users dan posts berhasil dibuat!\n");

    // --- INSERT ---
    sqlite3_exec(db, "INSERT INTO users (name, email) VALUES ('Yanto', 'yanto@email.com')", 0, 0, &err_msg);
    sqlite3_exec(db, "INSERT INTO users (name, email) VALUES ('YongMa', 'yongma@email.com')", 0, 0, &err_msg);
    sqlite3_exec(db, "INSERT INTO users (name, email) VALUES ('Budi', 'budi@email.com')", 0, 0, &err_msg);
    printf("✅ Data users berhasil dimasukkan!\n");

    sqlite3_exec(db, "INSERT INTO posts (title, content, user_id) VALUES ('Belajar SQL', 'Hari ini belajar SQL dasar.', 1)", 0, 0, &err_msg);
    sqlite3_exec(db, "INSERT INTO posts (title, content, user_id) VALUES ('Belajar Next.js', 'Framework React buat production.', 1)", 0, 0, &err_msg);
    sqlite3_exec(db, "INSERT INTO posts (title, content, user_id) VALUES ('Tips Go', 'Go itu bahasa backend yang keren.', 2)", 0, 0, &err_msg);
    printf("✅ Data posts berhasil dimasukkan!\n");

    // --- SELECT dengan callback ---
    printf("\n=== Semua Users ===\n");

    // Callback buat nampilin hasil SELECT
    sqlite3_exec(db, 
        "SELECT id, name, email FROM users",
        [](void *data, int argc, char **argv, char **col_name) -> int {
            for (int i = 0; i < argc; i++) {
                printf("  %s = %s", col_name[i], argv[i] ? argv[i] : "NULL");
                if (i < argc - 1) printf(" | ");
            }
            printf("\n");
            return 0;
        }, 
        nullptr, &err_msg
    );

    // --- JOIN ---
    printf("\n=== Posts + Users ===\n");

    sqlite3_exec(db,
        "SELECT posts.id, posts.title, users.name "
        "FROM posts INNER JOIN users ON posts.user_id = users.id",
        [](void *data, int argc, char **argv, char **col_name) -> int {
            printf("  %s | %s | by %s\n", argv[0], argv[1], argv[2]);
            return 0;
        },
        nullptr, &err_msg
    );

    printf("\n✅ Selesai!\n");

    sqlite3_close(db);
    return 0;
}
