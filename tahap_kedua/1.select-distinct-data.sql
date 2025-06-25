-- --SELECT DISTINCT DATA = pilih data yang berbeda, jadi cari data yg ga duplikat



USE toko_online;
DESCRIBE products;

SELECT * FROM products;

SELECT DISTINCT category FROM products; -- hanya keluar 3

-- tapi coba lihat kalo kita mendistict data yg banyak dan ernyata dia sudah uniq
-- jadi disini coba kita sandingkan data catergory (yg pasti duplikat) 
-- dengan data id (sudah pasti berbeda / distinct)

SELECT DISTINCT id, category FROM products; -- maka data categorynya akan tetp saja duplikat
SELECT DISTINCT category, id FROM products; -- sama aja


-- jadi pastikan ketika kmu ingin mendapatkan data yg tidak duplikat
-- pastikan dulu bahwa data tersebut benar benar banyak duplikatnya




 * ==============================================================
 *             4. DISTINCT PADA MULTI KOLOM
 * ==============================================================
 * Contoh:
 *     SELECT DISTINCT kota, nama FROM pelanggan;
 *
 * ➤ Artinya:
 * - Hanya tampilkan baris dengan kombinasi kota-nama yang unik.
 * - Jika ada nama sama tapi kota beda, itu dianggap berbeda.
 
 -- itu karena ketika di cek untuk yg preama kali itu kolom pertama dulu yg dice, dan ketika di cek
 -- maka ditentukan bahwa kolom tersebut berbeda, tapi tidak sempat mengecek kolom yg kedua


 -- disini menghitung data yg uniq
 SELECT count(DISTINCT category) AS jumlah_category
 FROM products; -- hasilnya 3
 

 *
 * 🔍 PENGERTIAN:
 * --------------------------------------------------------------
 * `SELECT DISTINCT` digunakan untuk **menghilangkan data duplikat**
 * dalam hasil query SELECT.
 * 
 * Dengan DISTINCT, hanya data yang **unik/satu-satunya** yang akan ditampilkan.
 * 
 * Tanpa DISTINCT, SELECT akan menampilkan **semua baris** yang sesuai,
 * meskipun ada yang **berulang/duplikat**.
 *
 * ==============================================================
 *                1. SINTAKS DASAR
 * ==============================================================
 * 
 * ➤ Format Umum:
 *     SELECT DISTINCT kolom1, kolom2, ...
 *     FROM nama_tabel;
 *
 * ➤ Contoh:
 *     SELECT DISTINCT kota FROM pelanggan;
 *
 * ✅ Artinya:
 *     Tampilkan daftar kota yang berbeda/unik dari tabel pelanggan.
 *
 * ==============================================================
 *         2. BAGAIMANA DISTINCT BEKERJA?
 * ==============================================================
 * DISTINCT akan **menggabungkan semua kolom** yang ditulis setelah SELECT DISTINCT,
 * lalu mencari kombinasi data yang unik (tanpa duplikat).
 *
 * ➤ Contoh:
 *     SELECT DISTINCT kota, status FROM pelanggan;
 *
 * Maka yang dianggap duplikat adalah pasangan `(kota, status)` yang sama.
 *
 * ==============================================================
 *            3. PERBEDAAN SELECT BIASA VS DISTINCT
 * ==============================================================
 * Misal data:

 * +----+--------+----------+
 * | id | nama   | kota     |
 * +----+--------+----------+
 * | 1  | Rafa   | Bandung  |
 * | 2  | Dina   | Jakarta  |
 * | 3  | Sari   | Bandung  |
 * | 4  | Budi   | Jakarta  |
 * | 5  | Tono   | Bandung  |
 * +----+--------+----------+
 *
 * ➤ SELECT kota → akan menampilkan:
 * Bandung, Jakarta, Bandung, Jakarta, Bandung
 *
 * ➤ SELECT DISTINCT kota → akan menampilkan:
 * Bandung, Jakarta
 *
 * ==============================================================
 *             4. DISTINCT PADA MULTI KOLOM
 * ==============================================================
 * Contoh:
 *     SELECT DISTINCT kota, nama FROM pelanggan;
 *
 * ➤ Artinya:
 * - Hanya tampilkan baris dengan kombinasi kota-nama yang unik.
 * - Jika ada nama sama tapi kota beda, itu dianggap berbeda.
 *
 * ==============================================================
 *             5. DISTINCT DENGAN ORDER BY
 * ==============================================================
 * DISTINCT bisa dikombinasikan dengan ORDER BY untuk mengurutkan hasil unik.
 *
 * Contoh:
 *     SELECT DISTINCT kota FROM pelanggan
 *     ORDER BY kota ASC;
 *
 * ==============================================================
 *          6. DISTINCT DENGAN LIMIT
 * ==============================================================
 * Untuk membatasi hasil unik yang ditampilkan:
 *
 * Contoh:
 *     SELECT DISTINCT kota FROM pelanggan
 *     LIMIT 3;
 *
 * ✅ Ambil 3 kota unik pertama.
 *
 * ==============================================================
 *       7. COUNT(DISTINCT kolom) → MENGHITUNG YANG UNIK
 * ==============================================================
 * Contoh:
 *     SELECT COUNT(DISTINCT kota) AS jumlah_kota
 *     FROM pelanggan;
 *
 * ✅ Hitung jumlah kota yang berbeda (bukan jumlah total baris).
 *
 * ==============================================================
 *         8. DISTINCT TIDAK BERLAKU PADA ALIAS/FUNGSI
 * ==============================================================
 * Contoh salah:
 *     SELECT DISTINCT UPPER(nama) FROM pelanggan;
 * ✅ Benar: karena UPPER(nama) menghasilkan nilai langsung.
 *
 * Tapi:
 *     SELECT UPPER(DISTINCT nama) → ❌ SALAH (DISTINCT harus di awal)
 *
 * ==============================================================
 *                9. TABEL LATIHAN
 * ==============================================================
 * CREATE TABLE pelanggan (
 *   id INT PRIMARY KEY AUTO_INCREMENT,
 *   nama VARCHAR(100),
 *   kota VARCHAR(100),
 *   status ENUM('aktif', 'tidak aktif')
 * );
 *
 * INSERT INTO pelanggan (nama, kota, status) VALUES
 * ('Rafa', 'Bandung', 'aktif'),
 * ('Dina', 'Jakarta', 'aktif'),
 * ('Sari', 'Bandung', 'tidak aktif'),
 * ('Budi', 'Jakarta', 'aktif'),
 * ('Rafa', 'Bandung', 'aktif');
 *
 * ==============================================================
 *         10. HASIL SELECT DISTINCT kota, status
 * ==============================================================
 * +----------+---------------+
 * | kota     | status        |
 * +----------+---------------+
 * | Bandung  | aktif         |
 * | Jakarta  | aktif         |
 * | Bandung  | tidak aktif   |
 * +----------+---------------+
 *
 * ✅ Meskipun 'Bandung' muncul 3x, hanya kombinasi unik yang ditampilkan.
 *
 * ==============================================================
 *             11. PENGGUNAAN DI NODE.JS
 * ==============================================================
 */

import mysql from "mysql2/promise";

(async () => {
  const conn = await mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "",
    database: "toko"
  });

  // Ambil daftar kota yang unik/berbeda
  const [rows] = await conn.execute(`
    SELECT DISTINCT kota
    FROM pelanggan
    ORDER BY kota ASC
  `);

  console.log("Daftar kota unik:");
  console.table(rows);

  await conn.end();
})();


 * ==============================================================
 *                     12. KESIMPULAN
 * ==============================================================
 * ✅ SELECT DISTINCT digunakan untuk menghapus baris duplikat
 * ✅ Bekerja dengan 1 kolom atau lebih (kombinasi nilai)
 * ✅ Dapat digabungkan dengan ORDER BY, LIMIT, COUNT
 * ✅ Gunakan DISTINCT untuk:
 *    - Mencari nilai unik
 *    - Menampilkan hanya 1 kali setiap data
 *    - Membuat laporan ringkasan
 *
 * 🚫 Jangan gunakan DISTINCT sembarangan, karena:
 *    - Bisa memperlambat query besar (karena butuh proses grouping)
 *    - Mungkin tidak perlu jika data memang sudah unik (contoh PRIMARY KEY)
 *
 * Contoh aplikasi nyata:
 * ----------------------
 * - Tampilkan semua kota unik pelanggan
 * - Hitung jumlah status yang berbeda
 * - Ambil kombinasi unik kategori-produk
 *

























