

-- jadi kita bisa pake fungisnya di where atau di select


-- jadi ini untuk memanipulasi angka
USE toko_online;
DESCRIBE products;
SHOW CREATE TABLE products;

SELECT * FROM products;


-- misal nih kita ingin menghtung operasi matematika
-- ini misalnya adalah pangkat / pow

-- jadi select itu untuk menampilkan
SELECT pow(5,2); -- hasilnya adalah 25


-- disini coba kita membuat kolom baru yg memperlihatkan price tapi dalam k atau ribu

SELECT id, price, price DIV 1000 AS "price dlm k"
FROM products ORDER BY price desc;


-- kalo ini ga bisa karena kita mneggunakan "", nah itu tu ga bisa di gunakan dalam alias

SELECT id, price, price DIV 1000 AS "price dlm k"
FROM products ORDER BY "price dlm k" desc;


-- jadi alias itu kalo lebih dari 1 kata, maka menggunakan backtik
SELECT id, price, price DIV 1000 AS `price dlm k`
FROM products ORDER BY `price dlm k` DESC;



-- coba tes lagi

SELECT sin(30);
SELECT sqrt(13); -- 3.605551275463989
SELECT round(sqrt(13),2); -- 3.61




 * ---------------------------------------------------------------
 * Numeric Function (fungsi numerik) di MySQL adalah fungsi bawaan
 * yang digunakan untuk melakukan operasi perhitungan atau manipulasi angka.
 * 
 * ➤ Fungsi numerik digunakan dalam SELECT, WHERE, ORDER BY, dan lainnya.
 * 
 * Tipe data numerik bisa berupa: INT, DECIMAL, FLOAT, DOUBLE, dsb.
 *
 * ================================================================
 *              1. DAFTAR FUNGSI NUMERIK UTAMA
 * ================================================================
 *  ✅ ABS(x)       → Nilai mutlak (positif)
 *  ✅ CEIL(x)      → Pembulatan ke atas
 *  ✅ FLOOR(x)     → Pembulatan ke bawah
 *  ✅ ROUND(x, d)  → Pembulatan ke d desimal
 *  ✅ TRUNCATE(x,d)→ Pangkas ke d desimal (tanpa pembulatan)
 *  ✅ MOD(x, y)    → Sisa bagi (modulo)
 *  ✅ POW(x,y)     → Pangkat (x^y)
 *  ✅ SQRT(x)      → Akar kuadrat
 *  ✅ SIGN(x)      → Tanda nilai (-1, 0, 1)
 *  ✅ RAND()       → Angka acak (0 sampai <1)
 *  ✅ LEAST(a, b)  → Nilai terkecil
 *  ✅ GREATEST(a,b)→ Nilai terbesar
 *
 * ================================================================
 *                 2. PENJELASAN & CONTOH
 * ================================================================
 * ➤ ABS(x)
 *   SELECT ABS(-10); → 10
 *
 * ➤ CEIL(x)
 *   SELECT CEIL(5.3); → 6
 *
 * ➤ FLOOR(x)
 *   SELECT FLOOR(5.9); → 5
 *
 * ➤ ROUND(x, d)
 *   SELECT ROUND(5.6789, 2); → 5.68
 *
 * ➤ TRUNCATE(x, d)
 *   SELECT TRUNCATE(5.6789, 2); → 5.67
 *
 * ➤ MOD(x, y)
 *   SELECT MOD(10, 3); → 1
 *
 * ➤ POW(x, y)
 *   SELECT POW(2, 3); → 8
 *
 * ➤ SQRT(x)
 *   SELECT SQRT(25); → 5
 *
 * ➤ SIGN(x)
 *   SELECT SIGN(-99); → -1
 *   SELECT SIGN(0);   →  0
 *   SELECT SIGN(20);  →  1
 *
 * ➤ RAND()
 *   SELECT RAND(); → Hasil: 0.726489123 (acak)
 *
 * ➤ LEAST(a, b, c)
 *   SELECT LEAST(5, 10, 3); → 3
 *
 * ➤ GREATEST(a, b, c)
 *   SELECT GREATEST(5, 10, 3); → 10
 *
 * ================================================================
 *               3. LATIHAN DATA: TABEL produk
 * ================================================================
 * CREATE TABLE produk (
 *   id INT PRIMARY KEY AUTO_INCREMENT,
 *   nama VARCHAR(100),
 *   harga DECIMAL(10,2),
 *   diskon_persen INT
 * );
 *
 * INSERT INTO produk (nama, harga, diskon_persen) VALUES
 * ('Laptop', 12000000, 10),
 * ('HP', 4500000, 5),
 * ('Mouse', 80000, 0),
 * ('Monitor', 1500000, 20);
 *
 * ================================================================
 *        4. CONTOH PENGGUNAAN NUMERIC FUNCTION DI SELECT
 * ================================================================
 * ➤ Hitung total setelah diskon:
 *
 * SELECT 
 *   nama,
 *   harga,
 *   diskon_persen,
 *   ROUND(harga - (harga * diskon_persen / 100), 2) AS harga_setelah_diskon
 * FROM produk;
 *
 * ➤ Gunakan FLOOR & CEIL:
 * SELECT 
 *   nama,
 *   harga,
 *   FLOOR(harga / 1000000) AS harga_juta_floor,
 *   CEIL(harga / 1000000)  AS harga_juta_ceil
 * FROM produk;
 *
 * ================================================================
 *           5. NUMERIC FUNCTION DI WHERE CLAUSE
 * ================================================================
 * ➤ Cari produk dengan harga bulat jutaan:
 *
 * SELECT * FROM produk
 * WHERE MOD(harga, 1000000) = 0;
 *
 * ➤ Cari produk yang harga set. diskonnya > 1 juta:
 * SELECT * FROM produk
 * WHERE (harga - (harga * diskon_persen / 100)) > 1000000;
 *
 * ================================================================
 *           6. NUMERIC FUNCTION DI ORDER BY / LIMIT
 * ================================================================
 * ➤ Urutkan berdasarkan hasil pangkat harga:
 * SELECT *, POW(harga, 0.5) AS akar FROM produk
 * ORDER BY akar DESC;
 *
 * ➤ Ambil 1 produk termurah setelah diskon:
 * SELECT *, (harga - (harga * diskon_persen / 100)) AS akhir
 * FROM produk
 * ORDER BY akhir ASC
 * LIMIT 1;
 *
 * ================================================================
 *               7. IMPLEMENTASI DI NODE.JS
 * ================================================================
 */

import mysql from "mysql2/promise";

(async () => {
  const conn = await mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "",
    database: "toko"
  });

  // Ambil produk dan hitung harga diskon menggunakan ROUND()
  const [rows] = await conn.execute(`
    SELECT 
      nama,
      harga,
      diskon_persen,
      ROUND(harga - (harga * diskon_persen / 100), 2) AS harga_diskon
    FROM produk
    ORDER BY harga_diskon ASC
  `);

  console.log("Daftar produk dengan harga setelah diskon:");
  console.table(rows);

  await conn.end();
})();


 * ================================================================
 *                         8. RANGKUMAN
 * ================================================================
 * ✅ Fungsi numerik di MySQL sangat berguna untuk:
 *    - Perhitungan matematika
 *    - Diskon harga
 *    - Rounding dan formatting angka
 *    - Saring data numerik (WHERE)
 *    - Buat ranking dan batasan (ORDER BY + LIMIT)
 *
 * ✅ Fungsi penting yang wajib dikuasai:
 *    ABS, CEIL, FLOOR, ROUND, TRUNCATE, MOD,
 *    POW, SQRT, SIGN, RAND, LEAST, GREATEST
 *
 * ✅ Kombinasikan dengan SELECT, WHERE, ORDER BY, LIMIT
 *
 * 📌 Hindari over-use tanpa alasan logis, karena fungsi matematis
 *     bisa memperlambat performa jika tabel sangat besar.
 *
 * ================================================================
 *            SELESAI — SEMOGA SANGAT JELAS & LENGKAP!
 * ================================================================
 */



















