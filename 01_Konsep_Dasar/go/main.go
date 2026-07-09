// ============================================
// 01: Konsep Dasar — Go Version
// ============================================
// Jalanin: go run main.go
// (Harus install dulu: go mod init database-learn && go get github.com/mattn/go-sqlite3)

package main

import (
	"database/sql"
	"fmt"
	"log"

	_ "github.com/mattn/go-sqlite3"
)

func main() {
	// Konek ke database
	db, err := sql.Open("sqlite3", "../learn.db")
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	// Matiin foreign key
	db.Exec("PRAGMA foreign_keys = OFF")

	// --- CREATE TABLE ---
	createUsers := `
	CREATE TABLE IF NOT EXISTS users (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		name TEXT NOT NULL,
		email TEXT NOT NULL UNIQUE
	);`
	_, err = db.Exec(createUsers)
	if err != nil {
		log.Fatal(err)
	}

	createPosts := `
	CREATE TABLE IF NOT EXISTS posts (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		title TEXT NOT NULL,
		content TEXT,
		user_id INTEGER NOT NULL,
		created_at TEXT DEFAULT CURRENT_TIMESTAMP,
		FOREIGN KEY (user_id) REFERENCES users(id)
	);`
	_, err = db.Exec(createPosts)
	if err != nil {
		log.Fatal(err)
	}
	db.Exec("PRAGMA foreign_keys = ON")
	fmt.Println("✅ Tabel users dan posts berhasil dibuat!")

	// --- INSERT ---
	db.Exec("INSERT INTO users (name, email) VALUES (?, ?)", "Yanto", "yanto@email.com")
	db.Exec("INSERT INTO users (name, email) VALUES (?, ?)", "YongMa", "yongma@email.com")
	db.Exec("INSERT INTO users (name, email) VALUES (?, ?)", "Budi", "budi@email.com")
	fmt.Println("✅ Data users berhasil dimasukkan!")

	db.Exec("INSERT INTO posts (title, content, user_id) VALUES (?, ?, ?)", "Belajar SQL", "Hari ini belajar SQL dasar.", 1)
	db.Exec("INSERT INTO posts (title, content, user_id) VALUES (?, ?, ?)", "Belajar Next.js", "Framework React buat production.", 1)
	db.Exec("INSERT INTO posts (title, content, user_id) VALUES (?, ?, ?)", "Tips Go", "Go itu bahasa backend yang keren.", 2)
	fmt.Println("✅ Data posts berhasil dimasukkan!")

	// --- SELECT ---
	fmt.Println("\n=== Semua Users ===")
	rows, _ := db.Query("SELECT id, name, email FROM users")
	for rows.Next() {
		var id int
		var name, email string
		rows.Scan(&id, &name, &email)
		fmt.Printf("  %d | %s | %s\n", id, name, email)
	}

	// --- JOIN ---
	fmt.Println("\n=== Posts + Users (INNER JOIN) ===")
	rows, _ = db.Query(`
		SELECT posts.id, posts.title, users.name 
		FROM posts 
		INNER JOIN users ON posts.user_id = users.id
	`)
	for rows.Next() {
		var id int
		var title, name string
		rows.Scan(&id, &title, &name)
		fmt.Printf("  %d | %s | by %s\n", id, title, name)
	}

	fmt.Println("\n✅ Selesai!")
}
