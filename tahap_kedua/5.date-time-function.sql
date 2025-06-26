https://chatgpt.com/c/685d4a30-4324-8009-91d5-59907ec1a133
https://dev.mysql.com/doc/refman/8.4/en/date-and-time-functions.html




USE toko_online;

DESCRIBE products;

SHOW CREATE TABLE products;

SELECT * from products;


-- disin kita mencoba untuk engekstrak tahun dan bulan pad akolom created_at

SELECT id, extract(YEAR FROM created_at) AS `tahun`, extract(month FROM created_at) AS `bulan` 
FROM products;


-- atau bisa juga seperti ini
-- tapi wajib tipe data temporal: DATE, TIME, DATETIME, TIMESTAMP, YEAR.

SELECT id, created_at, year(created_at) AS tahun, month(created_at) AS bulan, now() AS sekarang FROM products;


disini coba lagi kita buat colom baru di SELECT jadi yg created_at kita akan baut dia emnjadi pake format yg lebih bagus

USE toko_online;
SELECT id, nama, created_at, date_format(created_at, '%W %d %M %Y') AS format_bagus FROM products;





 * 📚 Berdasarkan MySQL 8.4 Reference:
 * https://dev.mysql.com/doc/refman/8.4/en/date-and-time-functions.html
 * 
 * Fungsi ini digunakan untuk manipulasi tanggal, waktu,
 * konversi format, perhitungan interval, serta pemrosesan logis
 * terhadap tipe data temporal: DATE, TIME, DATETIME, TIMESTAMP, YEAR.
 *
 * Tipe Format Utama:
 * - DATE        → 'YYYY-MM-DD'
 * - DATETIME    → 'YYYY-MM-DD HH:MM:SS[.fraction]'
 * - TIMESTAMP   → Seperti DATETIME (auto-ZONE UTC)
 * - TIME        → 'HH:MM:SS'
 * - YEAR        → 'YYYY'
 */

// ─────────────────────────────────────────────────────
// 💡 Bagian A: Fungsi Tanggal & Waktu Saat Ini
// ─────────────────────────────────────────────────────

-- SELECT NOW();                 // Tanggal dan waktu saat ini
-- SELECT SYSDATE();             // Sama, tapi evaluasi real-time
-- SELECT CURRENT_DATE();        // Tanggal hari ini
-- SELECT CURRENT_TIME();        // Waktu sekarang
-- SELECT UTC_DATE();            // UTC sekarang
-- SELECT UTC_TIME();
-- SELECT UTC_TIMESTAMP();

// ─────────────────────────────────────────────────────
// 💡 Bagian B: Ekstrak Bagian dari Tanggal/Waktu
// ─────────────────────────────────────────────────────

-- SELECT YEAR(NOW());           // 2025
-- SELECT MONTH(NOW());          // 6
-- SELECT DAY(NOW());            // 26
-- SELECT HOUR(NOW());           // 14
-- SELECT MINUTE(NOW());
-- SELECT SECOND(NOW());
-- SELECT MICROSECOND(NOW());
-- SELECT QUARTER(NOW());        // 2

-- SELECT DAYNAME('2025-06-26');       // Thursday
-- SELECT MONTHNAME('2025-06-26');     // June
-- SELECT WEEKDAY('2025-06-26');       // 3 (Senin=0)
-- SELECT DAYOFWEEK('2025-06-26');     // 5 (Minggu=1)
-- SELECT DAYOFYEAR('2025-06-26');     // 177
-- SELECT WEEK('2025-06-26');          // 26
-- SELECT WEEKOFYEAR('2025-06-26');    // 26

// ─────────────────────────────────────────────────────
// 💡 Bagian C: Format & Parsing Tanggal
// ─────────────────────────────────────────────────────

-- SELECT DATE_FORMAT(NOW(), '%W %d %M %Y'); 
// → Kamis 26 Juni 2025

-- SELECT STR_TO_DATE('26-06-2025', '%d-%m-%Y');
// → Konversi string menjadi tanggal

-- SELECT FROM_UNIXTIME(1719400000); 
// → Konversi UNIX timestamp ke datetime

-- SELECT UNIX_TIMESTAMP('2025-06-26 00:00:00');
// → Konversi ke UNIX (dalam detik)

// ─────────────────────────────────────────────────────
// 💡 Bagian D: Penjumlahan & Pengurangan Waktu
// ─────────────────────────────────────────────────────

-- SELECT DATE_ADD('2025-06-26', INTERVAL 5 DAY); 
-- SELECT DATE_SUB('2025-06-26', INTERVAL 1 MONTH); 
-- SELECT ADDTIME('10:00:00', '02:00:00');
-- SELECT SUBTIME('12:30:00', '01:15:00');

// TIMESTAMPADD(unit, value, datetime)
-- SELECT TIMESTAMPADD(MINUTE, 120, '2025-06-26 10:00:00');

// TIMESTAMPDIFF(unit, dt1, dt2)
-- SELECT TIMESTAMPDIFF(YEAR, '2000-01-01', '2025-06-26'); // 25

// ─────────────────────────────────────────────────────
// 💡 Bagian E: Konversi & Manipulasi Lainnya
// ─────────────────────────────────────────────────────

-- SELECT DATE('2025-06-26 12:00:00');  // hanya tanggal
-- SELECT TIME('2025-06-26 12:00:00');  // hanya waktu

-- SELECT MAKEDATE(2025, 200); // 2025-07-18
-- SELECT MAKETIME(14, 30, 0); // 14:30:00

-- SELECT LAST_DAY('2025-02-11'); // 2025-02-28

-- SELECT TO_DAYS('2025-06-26');      // Jumlah hari sejak 0000-01-01
-- SELECT FROM_DAYS(738826);          // 2025-06-26

-- SELECT TIME_TO_SEC('01:02:03');    // 3723
-- SELECT SEC_TO_TIME(3723);          // '01:02:03'

-- SELECT TIMEDIFF('12:30:00','10:15:00'); // '02:15:00'

-- SELECT CONVERT_TZ('2025-06-26 10:00:00', '+00:00', '+07:00');
// → '2025-06-26 17:00:00'

// ─────────────────────────────────────────────────────
// Fungsi Khusus Periode dan Interval
// ─────────────────────────────────────────────────────

-- SELECT PERIOD_ADD(202406, 3);    // → 202409
-- SELECT PERIOD_DIFF(202501, 202312); // → 1

-- Gunakan format periode: YYYYMM


// 1. Hitung umur user:
-- SELECT name, TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) AS age FROM users;

// 2. Ambil log dalam 7 hari terakhir:
-- SELECT * FROM logs WHERE log_date >= DATE_SUB(NOW(), INTERVAL 7 DAY);

// 3. Format tanggal lokal ke format friendly:
-- SELECT DATE_FORMAT(invoice_date, '%d-%m-%Y') AS formatted_date FROM invoices;

// 4. Cek durasi sesi user (dalam menit):
-- SELECT user_id, TIMESTAMPDIFF(MINUTE, login_time, logout_time) AS duration_min FROM sessions;

// 5. Konversi UTC ke waktu lokal (Asia/Jakarta):
-- SELECT CONVERT_TZ(timestamp, '+00:00', '+07:00') FROM activity;

// 6. Validasi tanggal string:
-- SELECT STR_TO_DATE(user_input, '%d/%m/%Y');

// ─────────────────────────────────────────────────────
// 📌 Tips Tambahan:
// - Format string pakai %d %m %Y %H:%i:%s
// - Hati-hati zona waktu & perbedaan SYSDATE() vs NOW()
// - Untuk performance, hindari fungsi pada kolom saat WHERE
//   contoh: WHERE DATE(created_at) = '2025-06-26' ❌ (gunakan BETWEEN ✅)
// - Gunakan index pada kolom datetime jika filter besar



