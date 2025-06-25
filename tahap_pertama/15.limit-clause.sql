


use toko_online;

DESCRIBE products;
SELECT * FROM products;


-- disini ktia akan menyelect data dari products, dan kita ambil yg pricenya lebih dari 15000 dan kita dari yg terbesar ke
-- yg trkecil, dan kita hanya menampilkan 5 data pertama
-- dan kalo kita ga pake order maka nanti data yg diambil itu akan random


SELECT * FROM products
WHERE price > 15000
ORDER BY price DESC
-- param pertama itu DATA offset
-- param kedua itu data yg diambil
LIMIT 0, 5; -- jdi nagambil 5 data pertama



-- atau bisa juga gini, jadi yg ini expisit ngasih tau limit dan offsetnya

SELECT * FROM products
WHERE price > 15000
ORDER BY price DESC
LIMIT 5 offset 5; -- jdi nagambil 5 data setelah 5 data sebelumnya - lompat 5 data


-- coba ga pake order
SELECT * FROM products
WHERE price > 15000
LIMIT 0,5;

-- maka akan random dikasihnya

-- kita buat page 
SELECT * FROM products WHERE price > 15000 ORDER BY price desc LIMIT 0,5; -- page pertama
SELECT * FROM products WHERE price > 15000 ORDER BY price desc LIMIT 5,5; -- page kedua
SELECT * FROM products WHERE price > 15000 ORDER BY price desc LIMIT 10,5; -- page ketiga
SELECT * FROM products WHERE price > 15000 ORDER BY price desc LIMIT 15,5; -- page keempat





 * LIMIT adalah klausa dalam MySQL yang digunakan untuk
 * membatasi jumlah baris (row) yang ditampilkan oleh perintah SELECT.
 *
 * Dengan kata lain, LIMIT mencegah hasil query menampilkan terlalu banyak data.
 * 
 * ➤ Format Umum:
 *     SELECT kolom FROM tabel
 *     LIMIT jumlah_baris;
 *
 * ➤ Contoh:
 *     SELECT * FROM pelanggan
 *     LIMIT 5;
 *
 * ✅ Artinya:
 *     Ambil hanya 5 baris pertama dari tabel pelanggan.
 *
 * ⚠️ Urutan baris akan acak jika tidak dikombinasikan dengan ORDER BY!
 *
 * ➤ Disarankan:
 *     Gunakan LIMIT selalu bersama ORDER BY.
 *
 * ==============================================================
 *           2. LIMIT DENGAN ORDER BY → (PAGING DASAR)
 * ==============================================================
 * Contoh:
 *   SELECT * FROM produk
 *   ORDER BY harga DESC
 *   LIMIT 3;
 *
 * ✅ Artinya:
 *     Ambil 3 produk dengan harga tertinggi.
 *
 * Kombinasi ini sangat berguna untuk ranking, leaderboard, laporan top-N, dsb.
 *
 * ==============================================================
 *         3. LIMIT DENGAN OFFSET (dua argumen)
 * ==============================================================
 * Format:
 *     LIMIT offset, jumlah_baris
 *
 * Atau:
 *     LIMIT jumlah_baris OFFSET offset
 *
 * ➤ Contoh 1:
 *     SELECT * FROM pelanggan LIMIT 3, 5;
 *     → Lewati 3 baris pertama, ambil 5 baris berikutnya
 *
 * ➤ Contoh 2 (sama hasil):
 *     SELECT * FROM pelanggan LIMIT 5 OFFSET 3;
 *
 * ✅ Berguna untuk fitur paginasi:
 *     Halaman 1: LIMIT 0, 10
 *     Halaman 2: LIMIT 10, 10
 *     Halaman 3: LIMIT 20, 10
 *
 * Rumus:
 *     OFFSET = (halaman - 1) * jumlah_per_halaman
 *
 * ==============================================================
 *                 4. LIMIT PADA SUBQUERY
 * ==============================================================
 * LIMIT juga bisa digunakan di dalam subquery untuk mengambil baris tertentu.
 *
 * Contoh:
 *     SELECT * FROM (
 *       SELECT * FROM produk ORDER BY harga DESC LIMIT 1
 *     ) AS produk_termahal;
 *
 * ==============================================================
 *              5. BEHAVIOR PENTING LIMIT
 * ==============================================================
 * - LIMIT bekerja SETELAH WHERE dan ORDER BY.
 * - Jika tidak ada ORDER BY, maka hasil bisa tidak berurutan.
 * - LIMIT sangat berguna untuk meringankan beban query besar.
 *
 * ==============================================================
 *        6. TABEL CONTOH UNTUK LATIHAN QUERY
 * ==============================================================
 * CREATE TABLE pelanggan (
 *   id INT PRIMARY KEY AUTO_INCREMENT,
 *   nama VARCHAR(100),
 *   kota VARCHAR(100),
 *   poin INT
 * );
 *
 * INSERT INTO pelanggan (nama, kota, poin) VALUES
 * ('Rafa', 'Bandung', 120),
 * ('Dina', 'Jakarta', 180),
 * ('Budi', 'Surabaya', 90),
 * ('Sari', 'Bandung', 200),
 * ('Tono', 'Medan', 150),
 * ('Ayu', 'Jakarta', 175);
 *
 * ==============================================================
 *        7. CONTOH HASIL QUERY DENGAN LIMIT + ORDER
 * ==============================================================
 * Query:
 *   SELECT nama, poin FROM pelanggan
 *   ORDER BY poin DESC
 *   LIMIT 3;
 *
 * Output:
 * +--------+-------+
 * | nama   | poin  |
 * +--------+-------+
 * | Sari   | 200   |
 * | Dina   | 180   |
 * | Ayu    | 175   |
 * +--------+-------+
 *
 * Penjelasan:
 * - Ambil 3 pelanggan dengan poin tertinggi.


import mysql from "mysql2/promise";

(async () => {
  const conn = await mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "",
    database: "toko"
  });

  const [rows] = await conn.execute(`
    SELECT nama, poin
    FROM pelanggan
    ORDER BY poin DESC
    LIMIT 3
  `);

  console.log("Top 3 pelanggan berdasarkan poin:");
  console.table(rows);

  await conn.end();
})();


 * ==============================================================
 *                      9. RANGKUMAN LIMIT
 * ==============================================================
 * ✅ LIMIT membatasi jumlah baris hasil SELECT
 * ✅ Format: LIMIT jumlah_baris
 * ✅ Format dengan OFFSET: LIMIT offset, jumlah_baris
 * ✅ Bisa digabung dengan ORDER BY untuk sorting + paging
 * ✅ Gunakan OFFSET untuk navigasi halaman (pagination)
 * ✅ LIMIT juga digunakan di subquery (misalnya top-1)
 * ✅ Pastikan selalu gunakan ORDER BY jika ingin hasil urutan yang konsisten
 *
 * Contoh skenario penggunaan LIMIT:
 * ---------------------------------
 * - Top 10 skor tertinggi
 * - Ambil 1 produk termurah
 * - Fitur "load more" di web
 * - Navigasi halaman 1, 2, 3...
 *






















