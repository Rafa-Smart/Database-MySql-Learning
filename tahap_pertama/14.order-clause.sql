
-- jadi order by ini akakn mengurutkan data berdasarkan kolom mana yg diurutkan menggunakan metode asc adau desc



-- Maksudnya:
-- 1. MySQL akan mengurutkan semua baris berdasarkan kolom `nama` secara ASC (dari A ke Z).
-- 2. Jika ada baris yang memiliki nilai `nama` yang sama, maka baris-baris tersebut akan
--    diurutkan lagi berdasarkan kolom `harga` secara DESC (dari besar ke kecil).

-- Jadi:
-- - Kolom pertama (`nama ASC`) menjadi prioritas utama urutan.
-- - Kolom kedua (`harga DESC`) digunakan hanya jika nilai kolom pertama sama.
-- - Jika nilai pada kolom pertama berbeda, maka kolom kedua tidak digunakan.

-- jadi ginii
--  Salah jika berpikir bahwa "semua data akan diurutkan berdasarkan kolom pertama dulu lalu diurutkan ulang semuanya berdasarkan kolom kedua".
--  Yang benar: Kolom kedua hanya berperan untuk menyelesaikan konflik pada kolom pertama (saat nilainya sama).

USE toko_online;

SELECT * FROM products;

SELECT * FROM products
-- disini bisa juga pakein where -- sebelum order
ORDER BY category asc, id desc;

-- jadi kolom kedua ini hanya untuk tambalan saja

-- dn defaultnya itu ketik kita hanya menyebutkna kolom nya saja, ch = nama
-- maka itu artinya adlaah nama asc









--https://chatgpt.com/c/685b94dd-fa34-8009-92d5-cecd5feefbdc


 *
 * Pengertian:
 * -----------
 * ORDER BY adalah klausa di MySQL yang digunakan untuk mengurutkan hasil query
 * berdasarkan satu atau lebih kolom, baik secara ASCENDING (naik) maupun DESCENDING (turun).
 *
 * Klausa ini digunakan setelah SELECT ... FROM ... [WHERE ...] dan sebelum LIMIT.
 *
 * ======================================================
 *                1. STRUKTUR DASAR
 * ======================================================
 * Sintaks dasar:
 *   SELECT kolom1, kolom2
 *   FROM nama_tabel
 *   ORDER BY kolom [ASC|DESC];
 *
 * - ASC (default): urutan naik (dari kecil ke besar, dari A ke Z)
 * - DESC        : urutan turun (dari besar ke kecil, dari Z ke A)
 *
 * Contoh:
 *   SELECT * FROM pelanggan
 *   ORDER BY nama ASC;
 *
 * ======================================================
 *          2. MENGURUTKAN LEBIH DARI 1 KOLOM
 * ======================================================
 * Sintaks:
 *   ORDER BY kolom1 [ASC|DESC], kolom2 [ASC|DESC];
 *
 * Artinya:
 * - Urutkan dulu berdasarkan kolom1
 * - Jika kolom1 sama nilainya, baru diurutkan berdasarkan kolom2
 *
 * Contoh:
 *   SELECT * FROM pelanggan
 *   ORDER BY kota ASC, nama DESC;
 *
 * Penjelasan:
 * - Urutkan berdasarkan kota (A-Z)
 * - Di dalam kota yang sama, nama diurutkan dari Z ke A
 *
 * ======================================================
 *         3. MENGURUTKAN BERDASARKAN NOMOR KOLOM
 * ======================================================
 * Sintaks:
 *   ORDER BY 2 ASC;
 *
 * Penjelasan:
 * - Angka mewakili posisi kolom pada SELECT.
 *   Misal: SELECT id, nama, kota
 *          Maka ORDER BY 2 berarti urutkan berdasarkan `nama`
 *
 * Tidak disarankan untuk pemakaian jangka panjang karena tidak eksplisit.
 *
 * ======================================================
 *        4. MENGURUTKAN DENGAN EKSPRESI ATAU FUNGSI
 * ======================================================
 * ORDER BY bisa digunakan untuk mengurutkan hasil dari perhitungan.
 *
 * Contoh:
 *   SELECT nama, poin * 2 AS poin_ganda
 *   FROM pelanggan
 *   ORDER BY poin * 2 DESC;
 *
 * Bisa juga dengan fungsi:
 *   SELECT nama, LENGTH(nama) AS panjang_nama
 *   FROM pelanggan
 *   ORDER BY LENGTH(nama) DESC;
 *
 * ======================================================
 *              5. ORDER BY DAN NULL
 * ======================================================
 * - Di MySQL, NULL akan dianggap "paling rendah" di ASC dan "paling tinggi" di DESC.
 * - Tapi bisa dikendalikan secara eksplisit dengan:
 * 
 * ASCENDING:
 *   ORDER BY kolom IS NULL ASC, kolom ASC;
 *
 * DESCENDING:
 *   ORDER BY kolom IS NULL DESC, kolom DESC;
 *
 * ======================================================
 *            6. ORDER BY DENGAN LIMIT
 * ======================================================
 * Digunakan untuk mengambil hasil yang sudah diurutkan sebagian saja.
 *
 * Contoh:
 *   SELECT * FROM pelanggan
 *   ORDER BY poin DESC
 *   LIMIT 3;
 *
 * Penjelasan:
 * - Ambil 3 pelanggan dengan poin tertinggi
 *
 * ======================================================
 *               7. LATIHAN DATA
 * ======================================================
 * CREATE TABLE pelanggan (
 *   id INT PRIMARY KEY AUTO_INCREMENT,
 *   nama VARCHAR(100),
 *   kota VARCHAR(100),
 *   poin INT
 * );
 *
 * INSERT INTO pelanggan (nama, kota, poin) VALUES
 * ('Rafa', 'Bandung', 100),
 * ('Dina', 'Jakarta', 200),
 * ('Sari', 'Bandung', 150),
 * ('Budi', 'Surabaya', 200),
 * ('Tono', NULL, 50);
 *
 * ======================================================
 *      8. PRAKTIK ORDER BY MENGGUNAKAN NODE.JS
 * ======================================================
 */

import mysql from "mysql2/promise";

(async () => {
  const conn = await mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "",
    database: "toko"
  });

  // Contoh: Ambil semua pelanggan, urutkan berdasarkan poin tertinggi
  const [rows] = await conn.execute(`
    SELECT id, nama, kota, poin
    FROM pelanggan
    ORDER BY poin DESC, nama ASC
  `);

  console.log("Hasil query dengan ORDER BY poin DESC, nama ASC:");
  console.table(rows);

  await conn.end();
})();

 * ======================================================
 *                 9. RINGKASAN ORDER BY
 * ======================================================
 * ✅ ORDER BY digunakan untuk mengurutkan hasil SELECT
 * ✅ ASC (default) = urutan naik, DESC = urutan turun
 * ✅ Bisa berdasarkan:
 *    - Kolom tunggal
 *    - Beberapa kolom
 *    - Posisi kolom (1, 2, dst)
 *    - Ekspresi atau hasil fungsi
 * ✅ Bisa digabungkan dengan:
 *    - LIMIT (ambil data teratas/bawah)
 *    - NULL handling (mengontrol posisi NULL)
 * ✅ Gunakan ORDER BY untuk ranking, sorting, leaderboard, laporan, dsb.

 
 
 
 
 
 
 
 
 