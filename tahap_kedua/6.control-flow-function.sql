
https://dev.mysql.com/doc/refman/8.4/en/flow-control-functions.html


-- tapi ini tuh ga se rumit di bahasa pemrograman,
-- jadi simple simple sjaa

-- jadi kalo mau yg komplex if elsenya maka lebih baik kamu buat dulu control 
-- flownya di bahasa pemrogramannya, jadi nanti ketika sudah jadi querrynya, baru dikirim ke mysql


USE toko_online;

DESCRIBE products;

SHOW CREATE TABLE products;

SELECT * FROM products;


-- disini kita akan memberikan kolom baru tapi langusng pada selectnya
-- bisa juga permanent tapi pake update, tapi add dulu

ALTER TABLE products 
ADD COLUMN indikasi varchar(100) NOT null;

ALTER table products
DROP COLUMN indikasi;

yg ini ga bisa, karena WHEN price < 15000 → Tidak boleh seperti itu dalam bentuk simple CASE.
Penulisan indikasi = "murah" dalam THEN → Salah, cukup "murah" saja.
CASE price hanya cocok untuk CASE simple yang membandingkan satu nilai terhadap nilai tetap (bukan ekspresi logika).
✅ Solusi: Gunakan CASE WHEN (search CASE) bukan CASE value
-- UPDATE products
-- SET indikasi = CASE price
--     WHEN price < 15000 THEN indikasi = "murah"
--     WHEN price BETWEEN 15000 AND 20000 THEN indikasi = "sedang"
--     ELSE indikasi = "mahal"
-- END;

UPDATE products
SET indikasi = CASE -- jadi kalo disini kita pake price atau value, maka hanya bisa yg simple aja, jadi bukan expresi, tapi langusng nilai
    WHEN price < 15000 THEN "murah"
    WHEN price BETWEEN 15000 AND 20000 THEN "sedang"
    ELSE "mahal"
END;


-- 2. oke disini baru kita versi ;angsung selectnya aja

SELECT id, nama, price, CASE 
    WHEN price < 15000 THEN "murah"
    WHEN price BETWEEN 15000 AND 20000 THEN "sedang"
    else"mahal"
END AS `keterngan_harga` FROM products;

-- jadi klo case value, maka di whennya itu hanya satu data saja, jadi hanya mencocokan, jadi ga bisa pake ekpresi
-- jadi kalo mau pake ekpresi maka pake case saja, ga pake valuenya



-- oke sekaran kit apake if else

-- disini kita sudah punya kolom indikasi ya

-- UPDATE products
-- SET indikasi = if(price < 15000, `murah`, if(price BETWEEN 15000 AND 20000, `sedang`, `mahal`) ); -- inngt buat penutupnya ya
-- 

-- PENTINGGGGGG-----------------------------------------------
-- oke, jadi kao ditabel dan kolom, dan juga untuk alias di eduanya itu menggunakan ``, 
-- tpi kalo buat string, lebih Utama pake '', dan jangan lagi pake ""

UPDATE products
SET indikasi = if(price < 15000, 'murah', IF(price BETWEEN 15000 AND 20000, 'sedang', 'mahal'));


SELECT * FROM products;


-- atau bisa juga ketika SELECT

SELECT id, nama, price, 
    if(price < 15000, 'murah', IF(price BETWEEN 15000 AND 20000, 'sedang', 'mahal'))
    AS `indikasi` -- nah disini boleh kita pake `` unutk kolom,tabel, alias
    FROM products;








 * Fungsi pengendali alur ini sangat berguna untuk logika kondisional
 * dalam SELECT, INSERT, UPDATE, atau query analitik kompleks.
 *
 * Format:
 * - IF(expr, then, else)
 * - CASE [value] WHEN x THEN ... [ELSE ...] END
 * - IFNULL(expr1, expr2)
 * - NULLIF(expr1, expr2)
 * - COALESCE(expr1, expr2, ..., exprN)

// ────────────────────────────────────────────────────────────
// 1. IF(expr, true_value, false_value)
//    ➤ Mirip ternary operator di JS.
//    ➤ Kembalikan true_value jika expr ≠ 0 && ≠ NULL, else false_value.
// ────────────────────────────────────────────────────────────
-- SELECT IF(score >= 60, 'Lulus', 'Gagal') AS result
-- FROM students;

// ────────────────────────────────────────────────────────────
// 2. CASE value WHEN compare THEN result [WHEN ...] [ELSE ...] END
//    ➤ Cocokkan value dengan beberapa case.
// ────────────────────────────────────────────────────────────
-- SELECT name,
--   CASE grade
--     WHEN 'A' THEN 'Excellent'
--     WHEN 'B' THEN 'Good'
--     ELSE 'Needs Improvement'
--   END AS remark
-- FROM report_card;

// ────────────────────────────────────────────────────────────
// 3. CASE WHEN condition THEN result [...] [ELSE ...] END
//    ➤ Versi generik: gunakan kondisi boolean.
// ────────────────────────────────────────────────────────────
-- SELECT id, price,
--   CASE
--     WHEN price < 100 THEN 'Cheap'
--     WHEN price BETWEEN 100 AND 500 THEN 'Moderate'
--     ELSE 'Expensive'
--   END AS price_range
-- FROM products;

// ────────────────────────────────────────────────────────────
// 4. IFNULL(expr1, expr2)
//    ➤ Jika expr1 NULL → expr2; else expr1.
// ────────────────────────────────────────────────────────────
-- SELECT product,
--   IFNULL(discount_price, base_price) AS selling_price
-- FROM inventory; :contentReference[oaicite:2]{index=2}

// ────────────────────────────────────────────────────────────
// 5. NULLIF(expr1, expr2)
//    ➤ Jika expr1 = expr2 → NULL; else expr1.
// ────────────────────────────────────────────────────────────
-- SELECT NULLIF(bank_balance, 0) AS nonzero_balance
-- FROM accounts; :contentReference[oaicite:3]{index=3}

// ────────────────────────────────────────────────────────────
// 6. COALESCE(expr1, expr2, ..., exprN)
//    ➤ Mengembalikan nilai pertama non-NULL di daftar.
// ────────────────────────────────────────────────────────────
-- SELECT name, COALESCE(nickname, firstname, 'Guest') AS display_name
-- FROM users; :contentReference[oaicite:4]{index=4}

-- penjelsan yg lebih detail lagi



// ───────────────────────────────────────────────────────────────
// 1 IFNULL(expr1, expr2)
//    ➤ Mengembalikan expr2 jika expr1 bernilai NULL, jika tidak NULL maka kembalikan expr1.
//    ➤ Fungsi fallback untuk nilai NULL.
// ───────────────────────────────────────────────────────────────

Contoh Tabel: inventory
+----------+------------+-----------------+
| product  | base_price | discount_price  |
+----------+------------+-----------------+
| Laptop   | 10000000   | NULL            |
| Keyboard | 500000     | 450000          |
| Mouse    | 200000     | NULL            |
+----------+------------+-----------------+
*/

-- SELECT product,
--        IFNULL(discount_price, base_price) AS selling_price
-- FROM inventory;


Penjelasan:
- Jika discount_price tersedia (tidak NULL), maka gunakan discount_price.
- Jika NULL, maka fallback ke base_price.

Hasil:
+----------+----------------+
| product  | selling_price |
+----------+----------------+
| Laptop   | 10000000       |
| Keyboard | 450000         |
| Mouse    | 200000         |
+----------+----------------+
*/

// ───────────────────────────────────────────────────────────────
// NULLIF(expr1, expr2)
//    ➤ Jika expr1 = expr2 → NULL
//    ➤ Jika expr1 ≠ expr2 → expr1
//    ➤ Digunakan untuk menghindari error pembagian dengan nol (0).
// ───────────────────────────────────────────────────────────────

Contoh Tabel: accounts
+------------+--------------+
| account_id | bank_balance |
+------------+--------------+
| A001       | 1000000      |
| A002       | 0            |
| A003       | 500000       |
+------------+--------------+
*/

-- SELECT account_id,
--        NULLIF(bank_balance, 0) AS nonzero_balance
-- FROM accounts;

Penjelasan:
- Jika bank_balance = 0 → return NULL.
- Jika ≠ 0 → return nilai aslinya.
- Berguna agar pembagian seperti amount / NULLIF(total, 0) tidak error (division by zero).

Hasil:
+------------+------------------+
| account_id | nonzero_balance |
+------------+------------------+
| A001       | 1000000          |
| A002       | NULL             |
| A003       | 500000           |
+------------+------------------+
*/

// ───────────────────────────────────────────────────────────────
// COALESCE(expr1, expr2, ..., exprN)
//    ➤ Mengembalikan nilai pertama yang tidak NULL dari daftar.
//    ➤ Cocok untuk fallback bertingkat: nickname → firstname → default.
// ───────────────────────────────────────────────────────────────


Contoh Tabel: users
+------------+----------+-----------+----------+
| name       | nickname | firstname | lastname |
+------------+----------+-----------+----------+
| John Doe   | NULL     | John      | Doe      |
| Alice Lee  | Ally     | Alice     | Lee      |
| GuestUser  | NULL     | NULL      | NULL     |
+------------+----------+-----------+----------+
*/

-- SELECT name,
--        COALESCE(nickname, firstname, 'Guest') AS display_name
-- FROM users;


Penjelasan:
- Gunakan nickname jika ada.
- Jika NULL, fallback ke firstname.
- Jika semua NULL, tampilkan 'Guest'.

Hasil:
+------------+---------------+
| name       | display_name |
+------------+---------------+
| John Doe   | John          |
| Alice Lee  | Ally          |
| GuestUser  | Guest         |
+------------+---------------+
*/

// ───────────────────────────────────────────────────────────────
// 🔄 Ringkasan Perbedaan:
// ───────────────────────────────────────────────────────────────

| Fungsi     | Kegunaan                                                  |
|------------|-----------------------------------------------------------|
| IFNULL     | Fallback 1 tingkat (nilai default jika NULL)              |
| NULLIF     | Cek kesamaan → kembalikan NULL jika sama                  |
| COALESCE   | Fallback bertingkat → ambil nilai pertama yang valid      |
*/

// ───────────────────────────────────────────────────────────────
// 🎯 Studi Kasus Nyata Penggunaan:
// ───────────────────────────────────────────────────────────────

// 1. Cegah pembagian nol:
-- SELECT amount / NULLIF(total, 0) AS ratio FROM stats;

// 2. Hitung harga final produk dengan diskon (jika ada):
-- SELECT product, price * (1 - IFNULL(discount_pct, 0)/100) AS final_price FROM items;

// 3. Tampilkan nama tampilan dengan fallback:
-- SELECT COALESCE(nickname, CONCAT(firstname, ' ', lastname), 'User') AS display_label FROM users;

// 4. Tandai status:
-- SELECT IF(status = 'active', 'Aktif', 'Nonaktif') FROM users;

// ────────────── EOF: mysql_control_flow_ifnull_nullif_coalesce.js ──────────────




// | Fungsi     | Output                                              |
// |------------|-----------------------------------------------------|
// | IF         | Nilai alternatif berdasarkan kondisi TRUE/FALSE     |
// | CASE val   | Pencocokan nilai dengan hasil berbeda               |
// | CASE WHEN  | Evaluasi kondisi logis kompleks                    |
// | IFNULL     | Default jika NULL                                   |
// | NULLIF     | Ubah menjadi NULL jika sama                         |
// | COALESCE   | Ambil nilai pertama non-null                        |
// ────────────────────────────────────────────────────────────

// ────────────────────────────────────────────────────────────
// 🎯 Studi Kasus Nyata
// ────────────────────────────────────────────────────────────

// 1) Tandai pelanggan loyal:
// Jika total_transaksi > 100000 → 'Gold', >50000 → 'Silver', else 'Bronze'
-- SELECT customer_id, total_spent,
--   CASE
--     WHEN total_spent > 100000 THEN 'Gold'
--     WHEN total_spent > 50000 THEN 'Silver'
--     ELSE 'Bronze'
--   END AS tier
-- FROM customers;

// 2) Harga final gunakan IFNULL:
// Diskon boleh NULL → fallback pakai 0
-- SELECT item_id,
--   price * (1 - IFNULL(discount_pct, 0)/100) AS final_price
-- FROM sales_items;

// 3) Hindari pembagian nol dengan NULLIF:
// UPDATE accounts SET ratio = amount / NULLIF(total_count,0);

// 4) Sisipkan nilai tampilan gabungan dengan COALESCE:
// SELECT COALESCE(nickname, CONCAT(firstname,' ',lastname), 'User') AS label
-- FROM users;

// 5) Masa berlaku subscription dengan CASE:
-- SELECT user_id, status,
--   CASE status
--     WHEN 'active' THEN 'Active User'
--     WHEN 'expired' THEN 'Expired - Renew'
--     WHEN 'canceled' THEN 'Canceled'
--     ELSE 'Unknown'
--   END AS status_label
-- FROM subscriptions;

// 6) Indicator numeric jadi flag boolean:
-- SELECT IF(status = 'shipped', 1, 0) AS shipped_flag FROM orders;


// ────────────────────────────────────────────────────────────
// 💡 Tips & Catatan penting:
// - IFNULL lebih efisien daripada COALESCE dengan 2 argumen.
// - NULLIF sering dipakai untuk menangani division-by-zero.
// - CASE generik (WHEN…) lebih fleksibel daripada CASE value.
// - Output kolom CASE/IF punya tipe gabungan dari hasil. :contentReference[oaicite:5]{index=5}
// - Cocok digunakan dalam report, kolom kalkulasi, transformasi data.




