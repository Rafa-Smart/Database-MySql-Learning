

https://dev.mysql.com/doc/refman/8.4/en/group-by-modifiers.html

-- nanti belajar lagi tentan agregate ini mengenai ocntoh contohnya...

/*
HAVING: filter setelah agregasi.
WHERE: filter sebelum agregasi.
*/

-- jadi ketika kita ingin menampilkan data yg sudah di agregate, jadi akan menhasilkan 1 data saja
-- oleh kaena itu kita ga bisa kombinasikan data agregate dengan data lain
-- karena data lainnya itu banyak, sedangkan data agregatenya itu sedikit

-- maka disinilah kita membutuhkan group by

-- jadi group by ini akan mengelompokan data yg di agregate
-- misal kita punya data category yg hanya ada 3 yaitu kuah, goreng, dan lain lain,
-- nah ita ingin menghitung kita punya berpa data kuah, goreng, dan lain lain si dalam tbel products

--maka kita bisa pake GROUP BY

SELECT category, count(category) AS banyak_data FROM products GROUP BY category ;

-- PENTING,
-- jadi gini analogi sederhananya
-- kita akn mengagregate data yg agregatenya itu neggunakan fungis count yg fungi count ini adlah menghitung baris data
-- nah jadi kita akan menghitung baris data berdasarkan categorynya

-- jadi kalo misalkan cateogorinya itu ada 3 uniq data, maka kita akn mengagregate data itu pre yg uniqnya
-- jadi misal ada goreng, kuah, lain lain, jadi akan dihitung satu satu
-- greng berapa baris, kuah berapa baris, dan lain lain berapa baris

-- nah dapetlah data goreng = 9, kuah = 3, lain lain= 14

use toko_online;


-- 2. coba lagi, jadi ita akn mneghitung total penghasilan dari price * jumlah (anggap aja quantity itu jumlah pembelian)
-- jadi kita akn hitung agregate menggunakan sum, jadi mengihtung total pembelian BERDASARKAN kolom category
-- nah jadi kita punya data 3 data uniq nih, maka nanti agreagatenya akan di hiitung sebanyak 3 kali

-- contoh dah

-- PENTING
-- jadi ketika ada 3 kelompk, maka akn diagregate per kelompomnya

SELECT category, sum(price * quantity) AS total_pembelian
FROM products
GROUP BY category;
-- berhasil
goreng  13010000
kuah    4735000
lain lain   16965000


 * GROUP BY digunakan untuk mengelompokkan baris berdasarkan satu atau
 * lebih kolom, lalu menerapkan agregasi (COUNT, SUM, AVG, dll).
 * Referensi: MySQL 8.4 docs :contentReference[oaicite:1]{index=1}
 */

// ────────────────────────────────────────────────────────────────
// 1️⃣ Dasar Syntax GROUP BY
// ────────────────────────────────────────────────────────────────

-- SELECT kolom, agregasi(...)
-- FROM tabel
-- [WHERE kondisi]
-- GROUP BY kolom1[, kolom2, ...]
-- [HAVING kondisi_agregat]
-- [ORDER BY kolom/alias]
-- [LIMIT ...]


- Tanpa GROUP BY, seluruh set dianggap satu grup.
- Semua kolom di SELECT harus:
  • bagian agregasi (SUM, COUNT,...), atau
  • disebut dalam GROUP BY,
  kecuali jika kolom secara fungsional bergantung (mode sql ONLY_FULL_GROUP_BY) :contentReference[oaicite:2]{index=2}
*/

// ────────────────────────────────────────────────────────────────
// 2️⃣ Contoh Dasar
// ────────────────────────────────────────────────────────────────

-- SELECT department_id, COUNT(*) AS jumlah_pegawai
-- FROM employees
-- GROUP BY department_id;


Membentuk baris output:
+---------------+------------------+
| department_id | jumlah_pegawai   |
+---------------+------------------+
| 1             | 10               |
| 2             | 5                |
...
+---------------+------------------+
*/

// ────────────────────────────────────────────────────────────────
// 3️⃣ HAVING vs WHERE
// ────────────────────────────────────────────────────────────────

-- SELECT department_id, COUNT(*) AS cnt
-- FROM employees
-- GROUP BY department_id
-- HAVING cnt > 5
-- WHERE tidak dapat digunakan pada agregat ini

HAVING: filter setelah agregasi.
WHERE: filter sebelum agregasi.
*/

// ────────────────────────────────────────────────────────────────
// 4️⃣ ORDER BY & LIMIT
// ────────────────────────────────────────────────────────────────

-- SELECT department_id, SUM(salary) AS total_gaji
-- FROM employees
-- GROUP BY department_id
-- ORDER BY total_gaji DESC
-- LIMIT 3


Mengambil 3 departemen dengan pengeluaran gaji tertinggi.
*/

// ────────────────────────────────────────────────────────────────
// 5️⃣ Grouping untuk banyak kolom
// ────────────────────────────────────────────────────────────────

-- SELECT department_id, job_title, COUNT(*) AS cnt
-- FROM employees
-- GROUP BY department_id, job_title


Kelompokkan data kombinasi departemen & jabatan.
*/

// ────────────────────────────────────────────────────────────────
// 6️⃣ WITH ROLLUP (subtotal & grand total)
// ────────────────────────────────────────────────────────────────

-- SELECT year, country, SUM(profit) AS total_profit
-- FROM sales
-- GROUP BY year, country WITH ROLLUP


Hasil tambahan:
- Setelah tiap negara: subtotal per tahun
- Sebelum baris pertama tiap tahun: subtotal keseluruhan tahun
- Baris terakhir: grand total (NULL pada semua kolom)
:contentReference[oaicite:3]{index=3}
*/

// 6a. Mendeteksi level dengan GROUPING()
-- SELECT year, country, 
--        SUM(profit) AS profit,
--        GROUPING(year) AS g_year,
--        GROUPING(country) AS g_country
-- FROM sales
-- GROUP BY year, country WITH ROLLUP


g_year=1 atau g_country=1 artinya itu baris subtotal/grandtotal.
*/

// ────────────────────────────────────────────────────────────────
// 7️⃣ NONSTANDARD: kolom tidak di-GROUP BY
// ────────────────────────────────────────────────────────────────

-- SELECT department_id, ANY_VALUE(location), COUNT(*) AS cnt
-- FROM employees
-- GROUP BY department_id

MySQL mengizinkan kolom non-agregat jika menggunakan ANY_VALUE()
atau jika kolom tersebut fungsional tergantung :contentReference[oaicite:4]{index=4}
*/

// ────────────────────────────────────────────────────────────────
// 8️⃣ OPTIMASI dan INDEX
// ────────────────────────────────────────────────────────────────


MySQL dapat menggunakan
- Tight Index Scan (index mencakup semua kolom GROUP BY),
- Loose Index Scan (scan per grup) :contentReference[oaicite:5]{index=5}.
Pastikan kolom GROUP BY diindeks untuk performa optimal.
*/

// ────────────────────────────────────────────────────────────────
// 9️⃣ Stud i Kasus Lengkap
// ────────────────────────────────────────────────────────────────


Tabel: orders(order_date, region, product, amount)
*/

-- // A) Total penjualan per bulan:
-- SELECT DATE_FORMAT(order_date,'%Y-%m') AS bulan,
--        SUM(amount) AS total_penjualan
-- FROM orders
-- GROUP BY bulan
-- ORDER BY bulan;


Output: per bulan, total penjualan.
*/

-- // B) Penjualan per region + produk, plus subtotal & grand total:
-- SELECT region, product, SUM(amount) AS total
-- FROM orders
-- GROUP BY region, product WITH ROLLUP
-- HAVING NOT (region IS NULL AND product IS NOT NULL)
-- ORDER BY region, product;

\
HAVING menghilangkan baris subtotal per produk tanpa region.
*/

// ────────────────────────────────────────────────────────────────
// 📌 Ringkasan & Tips Penting
// ────────────────────────────────────────────────────────────────
\
- GROUP BY membagi baris jadi subset, lalu agregasi dipakai per subset.
- Gunakan HAVING utk filter hasil agregasi.
- ROLLUP memberikan tingkat agregasi tambahan: subtotal & grandtotal.
- GROUPING() mengidentifikasi level subtotal/grandtotal.
- BoSQL mode ONLY_FULL_GROUP_BY wajib untuk akurasi.
- Pastikan index untuk kolom GROUP BY utk efisiensi.
- Hindari kolom non-agregat tanpa ANY_VALUE() di select/GROUP BY.
*/













