

-- * CROSS JOIN adalah salah satu jenis JOIN dalam SQL
-- * yang menghasilkan **produk Cartesian** dari dua tabel,
-- * yaitu setiap baris dari tabel pertama akan dipasangkan
-- * dengan semua baris dari tabel kedua.
-- *
-- * Contoh:
-- * Tabel A punya 3 baris, Tabel B punya 2 baris,
-- * maka hasil CROSS JOIN = 3 x 2 = 6 baris.




-- disini coba kita membaut table perkalian menggunkaan cross join
-- buat dulu tabelnya

USE toko_online;
CREATE TABLE number(
    id int PRIMARY key
) engine=innodb;


INSERT INTO number(id)
VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10);

SELECT * FROM number;

SELECT number2.id, number1.id, (number2.id * number1.id) AS hasil FROM number AS number1
CROSS JOIN number AS number2
ORDER BY number1.id asc, number2.id asc;




 * CROSS JOIN adalah salah satu jenis JOIN dalam SQL
 * yang menghasilkan **produk Cartesian** dari dua tabel,
 * yaitu setiap baris dari tabel pertama akan dipasangkan
 * dengan semua baris dari tabel kedua.
 *
 * Contoh:
 * Tabel A punya 3 baris, Tabel B punya 2 baris,
 * maka hasil CROSS JOIN = 3 x 2 = 6 baris.
 *
 * 📌 STRUKTUR DASAR CROSS JOIN:
 * ----------------------------------------
 * SELECT * FROM tabel1
 * CROSS JOIN tabel2;
 *
 * Atau juga bisa menggunakan:
 * SELECT * FROM tabel1, tabel2;
 *
 * Keduanya menghasilkan hasil yang sama (produk Cartesian).
 *
 * 📌 CARA KERJA:
 * ----------------------------------------
 * MySQL akan memasangkan SETIAP baris dari tabel pertama
 * dengan SELURUH baris dari tabel kedua satu per satu.
 *
 * Jadi jika:

 
 * - Tabel A berisi baris a1, a2
 * - Tabel B berisi baris b1, b2, b3
 * Maka hasilnya:
 *   - a1 b1
 *   - a1 b2
 *   - a1 b3
 *   - a2 b1
 *   - a2 b2
 *   - a2 b3
 *
 * 📌 KAPAN DAN KENAPA MENGGUNAKAN CROSS JOIN?
 * ----------------------------------------
 * ➤ Digunakan ketika kita ingin menggabungkan SEMUA kombinasi
 *    dari dua dataset tanpa filter/kondisi.
 *
 * ➤ Umumnya digunakan untuk:
 *    1. Kombinasi semua kemungkinan (misal kombinasi warna dan ukuran produk)
 *    2. Pembuatan data dummy/testing
 *    3. Simulasi matriks atau eksperimen matematis
 *    4. Analisis kombinasi antar entitas (misal siswa dan mata pelajaran)
 *
 * 📌 CATATAN PENTING:
 * ----------------------------------------
 * Karena hasilnya bisa sangat besar (n x m baris),
 * HINDARI penggunaan pada tabel besar tanpa kebutuhan jelas!
 *
 * 📌 CONTOH PRAKTIS:
 * ----------------------------------------
 */

// Misalkan kita punya 2 tabel berikut:

 * Tabel: colors
 * +----+--------+
 * | id | color  |
 * +----+--------+
 * | 1  | Red    |
 * | 2  | Blue   |
 * +----+--------+
 *
 * Tabel: sizes
 * +----+--------+
 * | id | size   |
 * +----+--------+
 * | 1  | Small  |
 * | 2  | Medium |
 * | 3  | Large  |
 * +----+--------+
 *
 * Kita ingin membuat kombinasi semua warna dan ukuran.
 */

// SQL CROSS JOIN:
const query = `
SELECT colors.color, sizes.size
FROM colors
CROSS JOIN sizes;
`;


 * 🔍 HASILNYA:
 * +--------+--------+
 * | color  | size   |
 * +--------+--------+
 * | Red    | Small  |
 * | Red    | Medium |
 * | Red    | Large  |
 * | Blue   | Small  |
 * | Blue   | Medium |
 * | Blue   | Large  |
 * +--------+--------+
 *
 * Setiap warna dikombinasikan dengan semua ukuran — total 2 x 3 = 6 baris.
 */


 * 📌 PERBANDINGAN DENGAN JOIN LAIN:
 * ----------------------------------------
 * - INNER JOIN  ➜ hanya mencocokkan baris yang memiliki relasi
 * - LEFT JOIN   ➜ ambil semua dari kiri + pasangan kanan (jika ada)
 * - RIGHT JOIN  ➜ ambil semua dari kanan + pasangan kiri (jika ada)
 * - CROSS JOIN  ➜ ambil semua kombinasi (n * m baris)
 */


 * 📌 CONTOH LAIN: KOMBINASI HARI & JAM
 */

// Tabel: days
// +-----+
// | day |
// +-----+
// | Mon |
// | Tue |
// +-----+

// Tabel: hours
// +------+
// | hour |
// +------+
// | 09   |
// | 10   |
// | 11   |
// +------+

// Query:
const scheduleQuery = `
SELECT days.day, hours.hour
FROM days
CROSS JOIN hours;
`;


 * 🔍 Output:
 * +-----+------+
 * | day | hour |
 * +-----+------+
 * | Mon | 09   |
 * | Mon | 10   |
 * | Mon | 11   |
 * | Tue | 09   |
 * | Tue | 10   |
 * | Tue | 11   |
 * +-----+------+
 *
 * Ini bisa digunakan untuk membuat slot jadwal harian otomatis.
 */

 * ================================================
 * TIPS & BEST PRACTICES PENGGUNAAN CROSS JOIN
 * ================================================
 * 1. ✅ Gunakan hanya jika BENAR-BENAR perlu kombinasi penuh.
 * 2. ❌ Jangan digunakan pada tabel besar tanpa filter, bisa memperlambat sistem.
 * 3. ✅ Bisa digabung dengan WHERE untuk filter hasil kombinasi.
 *    Contoh:
 *    SELECT ... FROM tabel1 CROSS JOIN tabel2
 *    WHERE some_condition;
 * 4. ✅ Cocok untuk membuat semua kemungkinan dari beberapa entitas.
 */


 * ================================================
 * PENUTUP
 * ================================================
 * CROSS JOIN sangat berguna dalam situasi tertentu
 * yang membutuhkan semua kombinasi data antara dua tabel.
 * Namun harus digunakan secara bijak karena dapat menghasilkan
 * jumlah baris yang sangat besar jika tabel-tabelnya besar.
 */




















