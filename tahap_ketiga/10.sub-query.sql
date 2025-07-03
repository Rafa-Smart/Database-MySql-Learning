



1. subquery di WHERE

-- jadi kita bisa melakukan where setelah melakukan select
-- jdai misal ada data price, nah kita ingin lihat apa saja yang datanya
-- leih dari rata rata
-- maka yang perlu kita lakuka adalah kita query menggunakan agregate function dulu untuk avg
-- lalu kita cari price > dari avg tersebut
-- dan ingat kalo pake di where, maka hasil querynya harus tunggal, agar bisa dibandingkan
-- atu bisa juga tidak tunggal jika inign mengacari not in atau in
-- lihat saja di contoh sampai paling bawah


use toko_online;

SELECT * FROM products
WHERE price > (SELECT avg(price) FROM products);


2. subquery di from

-- jadi di from ini hasil querry nya harus banyak
-- disini kita akn mengambil data harga termahal dari products
-- pada selruh data di tabel products yang punya kaitan dengna category
-- atauyang punya category
-- jdai meskpun ada dat adi products yang harganya sangat mahal
-- tapi karena dia tidak berkaitan atau tidak punya category
-- maka tidka akna terselect

-- dan disini uga wajib mneggunkan alias

SHOW TABLEs;
DESC category;
SELECT * FROM products;
SELECT * FROM category;

UPDATE products
SET price = 10000000
WHERE id = 'xxx1';

-- sudah kita set agar ada price yg sangat mahal tapi tidka berelasi
-- jadi dia tidak akna terambil

SELECT max(hasil_query_1.price) FROM (
    SELECT p.price FROM products AS p
    INNER JOIN category AS c ON (c.id = p.id_category)
) AS hasil_query_1; -- hasil 25000


SELECT max(price) FROM products; -- 10000000






 * ➤ Clause `HAVING` digunakan setelah `GROUP BY` untuk memfilter
 *    hasil agregasi (seperti COUNT, SUM, AVG, dll).
 *
 * ➤ Subquery dalam `HAVING` digunakan untuk membandingkan hasil
 *    agregasi terhadap hasil dari query lain.
 *
 * 📌 CONTOH PRAKTIS: SUBQUERY DALAM HAVING
 *
 * Misal: Tampilkan produk yang terjual lebih dari rata-rata semua pembelian.
 */

const subqueryInHaving = `
SELECT product_id, SUM(quantity) AS total_sold
FROM orders
GROUP BY product_id
HAVING SUM(quantity) > (
  SELECT AVG(quantity) FROM orders
);
`;


 * 🔍 PENJELASAN:
 * - `GROUP BY` mengelompokkan berdasarkan `product_id`
 * - `SUM(quantity)` dihitung per produk
 * - `HAVING` membandingkan hasil agregasi itu terhadap **AVG dari seluruh pembelian** (dari subquery)
 *
 * ✅ Cocok saat kamu ingin filter berdasarkan agregat yang bergantung pada data lain.
 */


 * ================================================
 * SUBQUERY DALAM INSERT
 * ================================================
 *
 * 📌 INSERT INTO ... SELECT ...
 * ➤ Digunakan untuk **memasukkan data dari hasil query lain** ke dalam tabel baru.
 * ➤ Subquery digunakan di bagian `SELECT`
 *
 * 📌 CONTOH PRAKTIS:
 * Salin produk yang belum pernah dibeli ke tabel `archived_products`
 */

const subqueryInInsert = `
INSERT INTO archived_products (id, name, price)
SELECT id, name, price
FROM products
WHERE id NOT IN (
  SELECT product_id FROM orders
);
`;


 * 🔍 PENJELASAN:
 * - Subquery di `WHERE` menyaring produk yang tidak ada di tabel orders
 * - Hasil `SELECT` dimasukkan ke `archived_products`
 * - Berguna untuk backup data, cloning, archive, dll
 */


 * ================================================
 * SUBQUERY DALAM UPDATE
 * ================================================
 *
 * 📌 Gunakan subquery dalam `SET` atau `WHERE` clause
 * ➤ Tujuan: Mengubah data berdasarkan hasil query lain
 *
 * 📌 CONTOH PRAKTIS:
 * Update harga produk menjadi 0 jika tidak pernah dibeli
 */

const subqueryInUpdate = `
UPDATE products
SET price = 0
WHERE id NOT IN (
  SELECT product_id FROM orders
);
`;

 * 🔍 PENJELASAN:
 * - Subquery mencari produk yang tidak pernah dipesan
 * - Produk tersebut di-set harganya menjadi 0
 *
 * 📌 CONTOH LANJUT:
 * Naikkan harga produk yang jumlah pembeliannya di atas rata-rata
 */

const conditionalUpdate = `
UPDATE products
SET price = price + 50
WHERE id IN (
  SELECT product_id
  FROM (
    SELECT product_id
    FROM orders
    GROUP BY product_id
    HAVING SUM(quantity) > (
      SELECT AVG(quantity) FROM orders
    )
  ) AS temp
);
`;

/**
 * 🔍 PERHATIAN:
 * - Karena MySQL tidak mengizinkan update pada tabel yang sedang di-SELECT (alias "can't update same table you select from"),
 *   maka perlu disimpan subquery-nya dulu dalam alias (misal: `AS temp`)
 */


 * ================================================
 * SUBQUERY DALAM DELETE
 * ================================================
 *
 * 📌 Subquery di `WHERE` untuk menghapus data berdasarkan hasil query lain
 *
 * 📌 CONTOH PRAKTIS:
 * Hapus produk yang sudah dibeli (mungkin karena obsolete)
 */

const subqueryInDelete = `
DELETE FROM products
WHERE id IN (
  SELECT product_id FROM orders
);
`;


 * 🔍 PENJELASAN:
 * - Subquery ambil `product_id` dari tabel orders
 * - Semua produk dengan ID itu akan dihapus dari tabel products
 *
 * ⚠️ PERINGATAN:
 * - Gunakan dengan hati-hati! Selalu uji dulu subquery-nya sebelum DELETE.
 *
 * ✅ Tips: Jalankan subquery-nya sendiri dulu → lalu wrap dengan DELETE jika hasilnya sudah sesuai.
 */

/**
 * ================================================
 * KESIMPULAN UMUM UNTUK SEMUA CLAUSE
 * ================================================
 * 🔹 `HAVING`  → untuk filter agregasi berdasarkan hasil query lain
 * 🔹 `INSERT`  → untuk menyalin data dari hasil SELECT/subquery
 * 🔹 `UPDATE`  → untuk mengubah data berdasarkan syarat dari subquery
 * 🔹 `DELETE`  → untuk menghapus data berdasarkan hasil subquery
 *
 * 💡 Subquery membuat query lebih fleksibel dan powerful.
 * Namun tetap perlu hati-hati soal performa dan validasi hasil.
 *
 * 📌 Best Practices:
 * - Gunakan alias jika subquery kompleks
 * - Gunakan parenthesis (kurung) untuk isolasi subquery
 * - Pastikan subquery menghasilkan hasil yang logis untuk operator yang digunakan
 * - Uji subquery secara terpisah sebelum dipakai dalam operasi data penting
 */





 * Subquery (atau "nested query") adalah **query di dalam query lain**.
 * Biasanya digunakan untuk mengambil hasil perantara, yang kemudian dipakai
 * oleh query utama (outer query).
 *
 * Dalam MySQL, subquery bisa digunakan di banyak bagian SQL:
 * - `SELECT`  (untuk kolom virtual)
 * - `WHERE`   ✅ (paling umum)
 * - `FROM`    ✅ (alias sebagai virtual table atau derived table)
 * - `HAVING`
 * - `INSERT`, `UPDATE`, `DELETE`, dll.
 *
 * ================================================
 * 🔍 SUBQUERY DALAM CLAUSE `WHERE`
 * ================================================
 *
 * ➤ Digunakan untuk menyaring data **berdasarkan hasil dari query lain**.
 * ➤ Hasil dari subquery digunakan sebagai syarat untuk baris yang akan diambil.
 * ➤ Biasanya menghasilkan satu nilai (scalar) atau satu kolom.
 *
 * 📌 STRUKTUR DASAR:
 * ----------------------------------------
 * SELECT kolom
 * FROM tabel
 * WHERE kolom OPERATOR (
 *   SELECT kolom FROM tabel_lain WHERE ...
 * );
 *
 * OPERATOR bisa berupa: =, <, >, IN, NOT IN, EXISTS, dll.
 *
 * 📌 CONTOH PRAKTIS:
 * Misal ada 2 tabel:
 *
 * Tabel: products
 * +----+---------+--------+
 * | id | name    | price  |
 * +----+---------+--------+
 * | 1  | Laptop  | 1000   |
 * | 2  | Mouse   | 25     |
 * | 3  | Monitor | 150    |
 * | 4  | Tablet  | 300    |
 * +----+---------+--------+
 *
 * Tabel: orders
 * +----+------------+------------+
 * | id | product_id | quantity   |
 * +----+------------+------------+
 * | 1  | 2          | 3          |
 * | 2  | 3          | 1          |
 * +----+------------+------------+
 *
 * Kita ingin menampilkan produk yang **belum pernah dibeli**.
 */

// SQL-nya:
const subqueryInWhere = `
SELECT name
FROM products
WHERE id NOT IN (
  SELECT product_id FROM orders
);
`;


 * 🔍 PENJELASAN:
 * Subquery: SELECT product_id FROM orders → menghasilkan daftar produk yang dibeli.
 * WHERE id NOT IN (...) → mengambil produk yang ID-nya **tidak ada** di daftar tersebut.
 *
 * Hasilnya:
 * Produk Laptop dan Tablet (karena tidak ada di tabel orders).
 */


 * ================================================
 * 🔍 SUBQUERY DALAM CLAUSE `FROM`
 * ================================================
 *
 * ➤ Subquery di FROM digunakan untuk membuat **tabel virtual sementara**
 *    yang bisa langsung di-`JOIN`, di-`GROUP BY`, atau diolah kembali.
 *
 * ➤ Cocok untuk kasus kompleks, misalnya: agregasi, filter lanjutan,
 *    perhitungan sementara, dsb.
 *
 * 📌 STRUKTUR DASAR:
 * ----------------------------------------
 * SELECT ...
 * FROM (
 *   SELECT ... FROM tabel WHERE ...
 * ) AS alias
 *
 * ❗ Penting: HARUS diberi alias.
 *
 * 📌 CONTOH PRAKTIS:
 * Kita ingin menghitung **total pembelian per produk**, lalu
 * menampilkan produk yang terjual lebih dari 1.
 */

// Subquery di FROM:
const subqueryInFrom = `
SELECT p.name, o.total_qty
FROM (
  SELECT product_id, SUM(quantity) AS total_qty
  FROM orders
  GROUP BY product_id
) AS o
JOIN products AS p ON p.id = o.product_id
WHERE o.total_qty > 1;
`;


 * 🔍 PENJELASAN:
 * Subquery (alias `o`) menghitung jumlah pembelian per produk.
 * Kemudian di-`JOIN` dengan tabel products berdasarkan `product_id`.
 * Filter akhir dilakukan dengan `WHERE o.total_qty > 1`.
 *
 * Hasil:
 * Menampilkan produk yang dibeli lebih dari sekali.
 */


 * ================================================
 * ✅ KEUNTUNGAN MENGGUNAKAN SUBQUERY
 * ================================================
 * 1. Lebih modular & terstruktur (terutama subquery di FROM)
 * 2. Dapat menggantikan JOIN dalam beberapa kasus
 * 3. Menghindari query yang terlalu panjang dengan banyak JOIN
 * 4. Bisa digunakan untuk menyaring berdasarkan hasil dinamis
 * 5. Efektif untuk nilai tunggal (misal max, min, avg dari query lain)
 *
 * Contoh:
 */
const hargaTermahal = `
SELECT name, price
FROM products
WHERE price = (
  SELECT MAX(price) FROM products
);
`;


 * Menampilkan produk dengan harga tertinggi.
 * Subquery menghasilkan satu nilai: MAX(price).
 */


 * ================================================
 * ⚠️ PERHATIAN DAN BEST PRACTICES
 * ================================================
 * - Hindari subquery bersarang terlalu dalam, bisa membingungkan & lambat
 * - Untuk query kompleks, pertimbangkan untuk memakai `WITH` (CTE / Common Table Expression)
 * - Gunakan alias yang jelas pada subquery di FROM
 * - Pada kondisi banyak data, JOIN + GROUP BY bisa lebih optimal dibanding subquery
 *
 * ❗ Hindari menggunakan `NOT IN (SELECT ...)` jika kolom tersebut bisa berisi NULL.
 *    Gunakan `LEFT JOIN ... IS NULL` atau `NOT EXISTS` sebagai alternatif yang lebih aman.
 */


 * ================================================
 * KESIMPULAN
 * ================================================
 * 🔹 Subquery adalah teknik powerful dalam SQL
 * 🔹 Subquery di WHERE: cocok untuk menyaring berdasarkan hasil query lain
 * 🔹 Subquery di FROM: cocok untuk menciptakan tabel virtual sebagai dasar olah data lanjutan
 * 🔹 Digunakan dengan hati-hati untuk performa dan kejelasan kode
 */


 
 
 





