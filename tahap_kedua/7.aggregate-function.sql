

https://dev.mysql.com/doc/refman/8.4/en/aggregate-functions.html


--  PENTINGG
-- adi agregate ini maksudnya adlah menghitung atau menggabungkan seluruh data dan engabaikan nilai null
-- dan bisa melkukan perhitungan terhadap data kumpulan tersebut
--
-- *  Aggregate functions digunakan untuk menghitung nilai dari
-- * sekumpulan baris (data set) — seperti jumlah, rata-rata, dll.
-- * Biasanya digunakan bersama GROUP BY atau langsung dalam SELECT.


-- disini kita ambil contoh untuk mengambil data paling mahal dari sebuh data yg telah di agregate / atau digabungkan
USE toko_online;
SELECT * FROM products;

-- nah ini gabisa karena kamu menggabungkan data agregate dengna data yg bukan agregate, kaena
-- data agregate ini datanya adalah data tunggal, jadi ga bisa di gabung dnegna yg lain
-- SELECT id, nama, price, max(price) AS `paling mahal` FROM products;

SELECT max(price) AS termahal FROM products; -- 25.000 -- satu data saja

-- atau kamu juga bisa pake ini sebenarnya

SELECT * FROM products
ORDER BY price DESC LIMIT 0,1; -- nah ini akna menampilkan data terbesarnya secara keseluruhan kolom


-- oke disini kita akn cari rata rata dari penggabungan seleuruh data yg ada di price
-- jadi cara kerjanya itu dimbil dulu seluruh datanya atau digabungkan, lalu di logickan
-- akanya datanya biasanya hanya satu


SELECT avg(price) AS rata_rata FROM products; -- 17692.3077

SELECT round(avg(price), 2) AS rata_rata FROM products; 17692.31


-- mengambil data count / seluruh data yg ada, jadi ada berapa data yg ada di tabel

SELECT count(id) AS data_total FROM products; -- 20, jdi ada 20 row atau baris di tabel kita



 * 📚 Aggregate functions digunakan untuk menghitung nilai dari
 * sekumpulan baris (data set) — seperti jumlah, rata-rata, dll.
 * Biasanya digunakan bersama GROUP BY atau langsung dalam SELECT.
 * 
 * Daftar Fungsi yang akan dibahas:
 * 1. COUNT()
 * 2. SUM()
 * 3. AVG()
 * 4. MIN()
 * 5. MAX()
 * 6. GROUP_CONCAT()
 * 7. STD(), STDDEV_POP(), STDDEV_SAMP()
 * 8. VARIANCE(), VAR_POP(), VAR_SAMP()
 * 9. BIT_AND(), BIT_OR(), BIT_XOR()
 * 10. JSON_ARRAYAGG(), JSON_OBJECTAGG()
 */

// ──────────────────────────────────────────────────────────────
// 1 COUNT([DISTINCT] expr) & COUNT(*)
// ➤ Menghitung jumlah baris
// ➤ COUNT(*) menghitung semua, COUNT(col) abaikan NULL
// ──────────────────────────────────────────────────────────────

-- SELECT COUNT(*) FROM users; // jumlah total baris
-- SELECT COUNT(email) FROM users; // hanya baris dengan email TIDAK NULL
-- SELECT COUNT(DISTINCT department_id) FROM employees; // jumlah departemen unik

// ──────────────────────────────────────────────────────────────
// 2 SUM(expr)
// ➤ Menjumlahkan semua nilai numerik (abaikan NULL)
// ──────────────────────────────────────────────────────────────

-- SELECT SUM(salary) AS total_gaji FROM employees;

// Misal tabel:
-- | name  | salary  |
// | Alice | 1000    |
// | Bob   | 1500    |
// | Null  | NULL    |
// TOTAL = 2500 (NULL tidak dihitung)

// ──────────────────────────────────────────────────────────────
// 3 AVG(expr)
// ➤ Menghitung rata-rata nilai numerik (abaikan NULL)
// ──────────────────────────────────────────────────────────────

-- SELECT AVG(salary) AS rata_gaji FROM employees;

// Sama seperti SUM / COUNT, tetapi otomatis dibagi jumlah data non-NULL

// ──────────────────────────────────────────────────────────────
// 4 MIN(expr) & MAX(expr)
// ➤ Mengambil nilai terkecil dan terbesar dari kolom
// ──────────────────────────────────────────────────────────────

-- SELECT MIN(score) AS skor_terendah, MAX(score) AS skor_tertinggi FROM tests;

// Cocok untuk laporan: skor tertinggi/terendah, harga paling mahal, dll

// ──────────────────────────────────────────────────────────────
// 5 GROUP_CONCAT(expr)
// ➤ Menggabungkan nilai dari grup menjadi string, bisa diurut & pisah
// ──────────────────────────────────────────────────────────────

-- SELECT department_id, GROUP_CONCAT(name SEPARATOR ', ') AS semua_nama
-- FROM employees
-- GROUP BY department_id;

// Misal:
-- dept A: "Alice, Bob, Charlie"

// ──────────────────────────────────────────────────────────────
// 6 STD(), STDDEV_POP(), STDDEV_SAMP()
// ➤ Deviasi standar → seberapa menyebar data dari rata-rata
// ──────────────────────────────────────────────────────────────

-- SELECT STD(score) FROM tests; // deviasi standar populasi
-- SELECT STDDEV_SAMP(score) FROM tests; // deviasi sampel

// STD = √((Σ(x - rata)²) / N)
// STD_SAMP = √((Σ(x - rata)²) / (N-1))

// ──────────────────────────────────────────────────────────────
// 7 VARIANCE(), VAR_POP(), VAR_SAMP()
// ➤ Mengukur keragaman nilai
// ──────────────────────────────────────────────────────────────

-- SELECT VARIANCE(score), VAR_SAMP(score) FROM tests;

// Variansi = kuadrat dari deviasi standar

// ──────────────────────────────────────────────────────────────
// 8 BIT_AND(), BIT_OR(), BIT_XOR()
// ➤ Operasi BIT untuk semua nilai (biner)
// ──────────────────────────────────────────────────────────────

-- SELECT BIT_AND(flag), BIT_OR(flag), BIT_XOR(flag) FROM logs;

// Misal: untuk flag boolean (0/1), status ON/OFF, hasil sensor, dll

// ──────────────────────────────────────────────────────────────
// 9 JSON_ARRAYAGG() dan JSON_OBJECTAGG()
// ➤ Membuat hasil dalam bentuk JSON
// ──────────────────────────────────────────────────────────────

-- SELECT JSON_ARRAYAGG(name) FROM users;
// hasil: ["Alice","Bob","Charlie"]

-- SELECT JSON_OBJECTAGG(id, name) FROM users;
// hasil: {"1":"Alice", "2":"Bob"}

// Cocok untuk frontend, API, atau kebutuhan format data terstruktur

// ──────────────────────────────────────────────────────────────
// 🎯 CONTOH KASUS PRAKTIS:
// ──────────────────────────────────────────────────────────────

// 1. Total gaji tiap departemen:
-- SELECT department_id, SUM(salary) AS total_gaji
-- FROM employees
-- GROUP BY department_id;

// 2. Rata-rata nilai per mata pelajaran:
-- SELECT subject, AVG(score) AS rata_nilai
-- FROM scores
-- GROUP BY subject;

// 3. Daftar semua murid per kelas:
-- SELECT class, GROUP_CONCAT(name ORDER BY name) AS daftar_murid
-- FROM students
-- GROUP BY class;

// 4. Ranking produk dengan harga maksimal:
-- SELECT category, MAX(price) AS harga_termahal
-- FROM products
-- GROUP BY category
-- ORDER BY harga_termahal DESC;

// ──────────────────────────────────────────────────────────────
// 🧠 CATATAN PENTING:
// - Semua fungsi mengabaikan NULL kecuali COUNT(*)
// - Jika ingin nilai default untuk NULL, gunakan IFNULL() / COALESCE()
// - Gunakan GROUP BY untuk mengelompokkan data per kategori
// - Bisa digabungkan dengan CASE, HAVING, JOIN, dsb



 * Mengabaikan nilai NULL kecuali COUNT(*) menghitung seluruh baris.
 *
 * Simpan file ini sebagai mysql_aggregate_functions.js
 */

// ────────────────────────────────────────────────────────────────
// 🎯 Fungsi Utama & Deskripsi
// ────────────────────────────────────────────────────────────────
// AVG(expr)            ➤ rata-rata nilai (NULL jika kosong)
// COUNT(expr or *)     ➤ jumlah baris (COUNT(*) hitung semua, COUNT(expr) abaikan NULL)
// COUNT(DISTINCT expr) ➤ jumlah nilai unik non-NULL
// SUM(expr)            ➤ jumlah total
// MIN(expr)            ➤ nilai minimum
// MAX(expr)            ➤ nilai maksimum
// STD(), STDDEV_POP(), STDDEV_SAMP() ➤ deviasi standar populasi/sampel
// VARIANCE(), VAR_POP(), VAR_SAMP()   ➤ variansi populasi/sampel
// BIT_AND(expr), BIT_OR(expr), BIT_XOR(expr) ➤ operasi bitwise per group
// GROUP_CONCAT(expr [ORDER BY ...] [SEPARATOR str]) ➤ gabungan string
// JSON_ARRAYAGG(expr) ➤ array JSON dari kolom
// JSON_OBJECTAGG(key_expr, val_expr) ➤ objek JSON dari dua kolom

// ────────────────────────────────────────────────────────────────
// ① AVG(), SUM(), MIN(), MAX()
// ────────────────────────────────────────────────────────────────

Contoh tabel: sales
+--------+--------+
| month  | amount |
+--------+--------+
| Jan    | 100    |
| Feb    | 150    |
| Mar    | NULL   |
| Apr    | 200    |
+--------+--------+

-- SELECT
--   AVG(amount) AS avg_amt,
--   SUM(amount) AS total_amt,
--   MIN(amount) AS min_amt,
--   MAX(amount) AS max_amt
-- FROM sales;
/*
Hasil: AVG=150, SUM=450, MIN=100, MAX=200
(catatan: baris NULL diabaikan) :contentReference[oaicite:2]{index=2}
*/


Tabel: employees
+------+---------+--------+
| dept | name    | salary |
+------+---------+--------+
| IT   | Alice   | 60000  |
| IT   | Bob     | NULL   |
| HR   | Carol   | 50000  |
| HR   | Dave    | 50000  |
+------+---------+--------+
*/
-- SELECT
--   dept,
--   COUNT(*) AS total_rows,
--   COUNT(name) AS cnt_name,
--   COUNT(DISTINCT salary) AS unique_salaries
-- FROM employees
-- GROUP BY dept;

IT: total_rows=2, cnt_name=2, unique_salaries=1
HR: total_rows=2, cnt_name=2, unique_salaries=1 :contentReference[oaicite:3]{index=3}
*/

// ────────────────────────────────────────────────────────────────
// ③ STDDEV, VARIANCE
// ────────────────────────────────────────────────────────────────

Contoh: scores (nilai murid)
+---------+
| score   |
+---------+
| 80      |
| 90      |
| 100     |
| 70      |
+---------+

-- SELECT
--   STD(score)      AS stddev_pop,
--   STDDEV_SAMP(score) AS stddev_samp,
--   VAR_POP(score)    AS var_pop,
--   VAR_SAMP(score)   AS var_samp
-- FROM scores;

STDDEV_POP = sqrt(((sum(x^2)/N)-avg^2)),
STDDEV_SAMP = √(Σ(x-avg)^2/(N-1)) :contentReference[oaicite:4]{index=4}
*/

// ────────────────────────────────────────────────────────────────
// ④ BIT_AND, BIT_OR, BIT_XOR
// ────────────────────────────────────────────────────────────────

Tabel: flags
+------+-------+
| grp  | flag  |
+------+-------+
| A    | 1     |
| A    | 3     |
| B    | 1     |
| B    | 0     |
+------+-------+

-- SELECT
--   grp,
--   BIT_AND(flag) AS all_and,
--   BIT_OR(flag)    AS any_or,
--   BIT_XOR(flag)   AS xor_all
-- FROM flags
-- GROUP BY grp;

A: 1&3=1, 1|3=3, 1⊕3=2
B: 1&0=0, 1|0=1, 1⊕0=1 :contentReference[oaicite:5]{index=5}
*/

// ────────────────────────────────────────────────────────────────
// ⑤ GROUP_CONCAT()
-- SW\concat string dari group

Tabel: tags
+------+-------+
| item | tag   |
+------+-------+
| 1    | a     |
| 1    | b     |
| 2    | x     |
| 2    | y     |
+------+-------+

-- SELECT
--   item,
--   GROUP_CONCAT(tag ORDER BY tag SEPARATOR ',') AS all_tags
-- FROM tags
-- GROUP BY item;
/*
1 → 'a,b'; 2 → 'x,y' :contentReference[oaicite:6]{index=6}


// ────────────────────────────────────────────────────────────────
// ⑥ JSON_ARRAYAGG(), JSON_OBJECTAGG()
// ────────────────────────────────────────────────────────────────

Tabel: users
+------+----------+-------+
| id   | name     | score |
+------+----------+-------+
| 1    | Alice    | 90    |
| 2    | Bob      | 85    |
+------+----------+-------+

-- SELECT
--   JSON_ARRAYAGG(name) AS names,
--   JSON_OBJECTAGG(id, score) AS scores_by_id
-- FROM users;
/*
→ ["Alice","Bob"], {"1":90,"2":85} :contentReference[oaicite:7]{index=7}
*/

// ────────────────────────────────────────────────────────────────
// 📚 Catatan & Tips
// ────────────────────────────────────────────────────────────────

- NULL diabaikan oleh semua kecuali COUNT(*)
- Untuk agregasi waktu, gunakan SEC_TO_TIME(SUM(TIME_TO_SEC(...)))
- Untuk GROUP BY non-deterministik, gunakan ANY_VALUE() :contentReference[oaicite:8]{index=8}
- Bandingkan populasi vs sampel: STD/SAMP



Tabel: orders (order_date, amount, region)
1) Total & rata-rata penjualan per bulan:

-- SELECT
--   DATE_FORMAT(order_date,'%Y-%m') AS month,
--   COUNT(*) AS total_orders,
--   SUM(amount) AS total_revenue,
--   AVG(amount) AS avg_order
-- FROM orders
-- GROUP BY month
-- ORDER BY month;

2) Daerah dengan penjualan tertinggi & tagarnya:
SELECT
  region,
  SUM(amount) AS revenue,
  MAX(amount) AS highest_order,
  GROUP_CONCAT(DISTINCT customer_id) AS customers
FROM orders
GROUP BY region
HAVING revenue > 100000
ORDER BY revenue DESC;













