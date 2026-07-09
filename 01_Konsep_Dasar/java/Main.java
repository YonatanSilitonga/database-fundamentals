// ============================================
// 01: Konsep Dasar — Java Version
// ============================================
// Jalanin:
//   javac Main.java
//   java -cp ".;sqlite-jdbc-3.45.0.0.jar" Main
// (Download dulu sqlite-jdbc dari https://github.com/xerial/sqlite-jdbc/releases)

import java.sql.*;

public class Main {
    public static void main(String[] args) {
        Connection conn = null;
        Statement stmt = null;

        try {
            // Konek ke database
            Class.forName("org.sqlite.JDBC");
            conn = DriverManager.getConnection("jdbc:sqlite:../learn.db");
            stmt = conn.createStatement();

            // Matiin foreign key
            stmt.execute("PRAGMA foreign_keys = OFF");

            // --- CREATE TABLE ---
            stmt.executeUpdate(
                "CREATE TABLE IF NOT EXISTS users (" +
                "id INTEGER PRIMARY KEY AUTOINCREMENT," +
                "name TEXT NOT NULL," +
                "email TEXT NOT NULL UNIQUE)"
            );

            stmt.executeUpdate(
                "CREATE TABLE IF NOT EXISTS posts (" +
                "id INTEGER PRIMARY KEY AUTOINCREMENT," +
                "title TEXT NOT NULL," +
                "content TEXT," +
                "user_id INTEGER NOT NULL," +
                "created_at TEXT DEFAULT CURRENT_TIMESTAMP," +
                "FOREIGN KEY (user_id) REFERENCES users(id))"
            );
            stmt.execute("PRAGMA foreign_keys = ON");
            System.out.println("✅ Tabel users dan posts berhasil dibuat!");

            // --- INSERT ---
            PreparedStatement pstmt = conn.prepareStatement(
                "INSERT INTO users (name, email) VALUES (?, ?)"
            );
            pstmt.setString(1, "Yanto");
            pstmt.setString(2, "yanto@email.com");
            pstmt.executeUpdate();

            pstmt.setString(1, "YongMa");
            pstmt.setString(2, "yongma@email.com");
            pstmt.executeUpdate();

            pstmt.setString(1, "Budi");
            pstmt.setString(2, "budi@email.com");
            pstmt.executeUpdate();
            System.out.println("✅ Data users berhasil dimasukkan!");

            // --- SELECT ---
            System.out.println("\n=== Semua Users ===");
            ResultSet rs = stmt.executeQuery("SELECT id, name, email FROM users");
            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                String email = rs.getString("email");
                System.out.printf("  %d | %s | %s%n", id, name, email);
            }

            // --- JOIN ---
            System.out.println("\n=== Posts + Users (INNER JOIN) ===");
            rs = stmt.executeQuery(
                "SELECT posts.id, posts.title, users.name " +
                "FROM posts INNER JOIN users ON posts.user_id = users.id"
            );
            while (rs.next()) {
                int id = rs.getInt("id");
                String title = rs.getString("title");
                String name = rs.getString("name");
                System.out.printf("  %d | %s | by %s%n", id, title, name);
            }

            // Cleanup
            rs.close();
            pstmt.close();
            stmt.close();
            conn.close();

            System.out.println("\n✅ Selesai!");

        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
