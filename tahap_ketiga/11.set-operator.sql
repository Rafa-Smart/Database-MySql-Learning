


-- disini ktia buat dulu table questbook
USE toko_online;
CREATE TABLE guestbook (
    id int NOT NULL auto_increment,
    email varchar(100) NOT NULL,
    title varchar(100),
    content text,
    CONSTRAINT fk_primary_key PRIMARY KEY (id)
) engine=innodb;

SELECT * FROM customer;

INSERT INTO guestbook (email, title, content)
VALUES ('guest1@gmail.com', 'hello', 'hello'),
       ('guest1@gmai2.com', 'hello', 'hello'),
       ('guest1@gmai3.com', 'hello', 'hello'),
       ('guest1@gmai4.com', 'hello', 'hello'),
       ('rafaEmail', 'hello', 'hello'),
       ('rafaEmail', 'hello', 'hello'),
       ('rafaEmail', 'hello', 'hello'),
       ('jamalEmail', 'hello', 'hello');

SELECT * FROM guestbook;


1. UNION
-- jadi fungisnya daalah untuk menggabungkan dua buah select, dimana jika terdapat data yang
-- data yang sama, maka data duplikatnya akan dihapus dari haisl query kedauanya

-- jadi kita akn lihat data email yang pernah daftar di customer dan juga di guestbook
-- jadi misal di di gueestbook dan di customre ada rafaEmail
-- maka haisl querynya rafaEmail ini hanya satu
-- tapi kalo union all, maka si rafaEmail ini tetap ada secara duplikat

-- jadi ktia ingin meliht seluruh data email yang dia ada di custmomer atau ada di guestbook

SELECT DISTINCT email FROM customer
UNION
SELECT DISTINCT email FROM guestbook;

-- smaa aja

SELECT email FROM customer
UNION
SELECT email FROM guestbook;


2. UNION ALL
-- Mirip UNION, tapi **TIDAK menghapus duplikat**
-- Lebih cepat dari UNION biasa karena tidak perlu cek duplikat

-- jadi jika ada data yang sama diantara dua tabel
-- maka data tersebut tidak akan di distinct


SELECT email FROM customer
UNION all
SELECT email FROM guestbook;




3.INTERSECT
-- Menghasilkan baris yang **muncul di kedua query**
-- Digunakan untuk mencari *nilai irisan*

-- jadi ktia gapunya di mysql
-- tapi kita bisa menggunkan inner join
-- karena ingin melihat data yang hanya ada pada kedua tabel


-- berati data email yang pernah jadi customer dan jadi guestbook adalah
-- rafaEmail dan jamalEmail
SELECT * FROM customer AS c
INNER JOIN guestbook AS g ON (g.email = c.email);

-- atua kalo mau distinct
SELECT DISTINCT hasil_query.email 
from (SELECT c.email FROM customer AS c
INNER JOIN guestbook AS g ON (g.email = c.email)) AS hasil_query;

-- jadi di query innernya itu kalo kita mau select
-- maka kita harus spesifik selectnya, jadi gabisa *


-- atau bisa juga seperti ini
SELECT email FROM customer
WHERE email IN (SELECT email FROM guestbook);
-- jamalEmail
-- rafaEmail



4.minus
Menghasilkan baris dari query pertama yang **tidak ada di query kedua**
Juga dikenal sebagai "MINUS"

-- jadi minus ini hanya akan mengambil data email yang hanya ada
-- ditabel pertama tapi tidak ada di tabel kedua
-- ini ga ada di mysql
-- tapi kita bsia gunakan left join

-- disni kita akan abil data email yang hanya pernah menjadi customer
-- tapi tidak pernah menjadi questbook 


-- ini gagal
SELECT hasil_query.email FROM 
(SELECT c.email FROM customer AS c
LEFT JOIN guestbook AS g ON (c.email = g.email)) AS hasil_query
WHERE g.email IS NULL;

SELECT c.email FROM customer AS c
LEFT JOIN guestbook AS g ON (c.email = g.email)
WHERE g.email IS NULL;

-- berati email email ini
-- hanya ada di customer saja tpi tidka pernah ada di questbook


johnEmail
johnEmail2
sitiEmail
udinEmail

-- dan disini kita ingin melihat data email yang hanya ada pada guestbook saja 
-- tapi tidak pernah ada di customer

SELECT g.email FROM guestbook AS g
left JOIN customer AS c ON (g.email = c.email)
WHERE c.email IS NULL;

-- data data email yang hanya ada di guestbook
-- tapi tidak pernah ada di customer
guest1@gmail.com
guest1@gmai2.com
guest1@gmai3.com
guest1@gmai4.com



 * ➤ Set Operator dalam SQL adalah **operator khusus** yang digunakan
 *    untuk menggabungkan hasil dari dua atau lebih query SELECT.
 * ➤ Disebut "SET" karena terinspirasi dari konsep **himpunan (set)** dalam matematika.
 * ➤ Berfungsi untuk melakukan operasi seperti union (gabungan), 
 *    intersection (irisan), dan difference (selisih) antar hasil query.
 *
 * ===============================================================
 * 📦 JENIS-JENIS SET OPERATOR DI MySQL
 * ===============================================================
 *
 * ✅ 1. UNION
 * ✅ 2. UNION ALL
 * ⛔ 3. INTERSECT   → ❗ tidak didukung langsung di MySQL (bisa pakai cara alternatif)
 * ⛔ 4. EXCEPT      → ❗ juga tidak didukung langsung, tapi bisa disimulasikan
 *
 * ===============================================================
 * 📌 1. UNION
 * ---------------------------------------------------------------
 * ➤ Menggabungkan hasil dari dua query SELECT
 * ➤ Otomatis **menghapus duplikat** (DISTINCT)
 *
 * 📌 SINTAKS:
 * SELECT kolom FROM tabel1
 * UNION
 * SELECT kolom FROM tabel2;
 *
 * 📌 ATURAN PENTING:
 * - Jumlah kolom di kedua query HARUS SAMA
 * - Tipe data kolom harus kompatibel (misal: int dengan int, varchar dengan varchar)
 *
 * 📌 CONTOH:
 */
const unionQuery = `
SELECT name FROM customers
UNION
SELECT name FROM suppliers;
`;


 * 🔍 HASIL:
 * - Menggabungkan semua nama dari customers dan suppliers
 * - Jika ada nama yang sama, hanya tampil 1 kali (tanpa duplikat)
 *
 * ===============================================================
 * 📌 2. UNION ALL
 * ---------------------------------------------------------------
 * ➤ Mirip UNION, tapi **TIDAK menghapus duplikat**
 * ➤ Lebih cepat dari UNION biasa karena tidak perlu cek duplikat
 *
 * 📌 CONTOH:
 */
const unionAllQuery = `
SELECT name FROM customers
UNION ALL
SELECT name FROM suppliers;
`;


 * 🔍 HASIL:
 * - Menggabungkan semua nama, termasuk yang duplikat
 *
 * 📌 KAPAN GUNAKAN UNION ALL?
 * - Jika kamu tahu tidak ada duplikat, atau
 * - Memang ingin menghitung jumlah total termasuk pengulangan
 *
 * ===============================================================
 * 📌 3. INTERSECT (❗TIDAK DIDUKUNG LANGSUNG DI MYSQL)
 * ---------------------------------------------------------------
 * ➤ Menghasilkan baris yang **muncul di kedua query**
 * ➤ Digunakan untuk mencari *nilai irisan*
 *
 * 📌 MySQL tidak punya INTERSECT secara langsung,
 *    tapi bisa disimulasikan dengan INNER JOIN atau EXISTS.
 *
 * 📌 SIMULASI INTERSECT:
 */
const intersectSimulation = `
SELECT name FROM customers
WHERE name IN (
  SELECT name FROM suppliers
);
`;


 * 🔍 HASIL:
 * - Menampilkan nama yang ada di customers **dan** suppliers
 * - Mirip seperti INTERSECT
 *
 * ===============================================================
 * 📌 4. EXCEPT (❗JUGA TIDAK DIDUKUNG LANGSUNG)
 * ---------------------------------------------------------------
 * ➤ Menghasilkan baris dari query pertama yang **tidak ada di query kedua**
 * ➤ Juga dikenal sebagai "MINUS"
 *
 * 📌 SIMULASI DI MYSQL:
 */
const exceptSimulation = `
SELECT name FROM customers
WHERE name NOT IN (
  SELECT name FROM suppliers
);
`;


 * 🔍 HASIL:
 * - Menampilkan nama yang hanya ada di customers, bukan di suppliers
 *
 * ===============================================================
 * 🧠 KAPAN DAN KENAPA GUNAKAN SET OPERATOR?
 * ---------------------------------------------------------------
 * ✅ Saat kamu ingin menggabungkan hasil dari dua sumber data yang serupa
 * ✅ Saat kamu ingin mencari perbedaan atau kesamaan antara dua SELECT
 * ✅ Saat kamu tidak ingin repot menulis JOIN jika hanya butuh nilai final
 * ✅ Saat kamu perlu menyiapkan laporan gabungan dari 2 tabel berbeda
 *
 * ===============================================================
 * ⚠️ PERHATIAN PENTING
 * ---------------------------------------------------------------
 * 1. Kolom SELECT harus **jumlah dan urutannya sama**
 * 2. Gunakan alias atau CAST jika perlu samakan tipe data
 * 3. UNION lebih lambat dari UNION ALL karena hapus duplikat
 * 4. Gunakan LIMIT di luar jika ingin batasi hasil gabungan
 *
 * ===============================================================
 * 🔁 CONTOH KOMPLEKS: UNION + FILTER
 */
const unionWithFilter = `
(
  SELECT name, 'customer' AS type FROM customers
  WHERE active = 1
)
UNION ALL
(
  SELECT name, 'supplier' AS type FROM suppliers
  WHERE status = 'verified'
);
`;


 * 🔍 HASIL:
 * - Menggabungkan dua tabel
 * - Menambah kolom "type" untuk tahu sumber data (customer atau supplier)
 *
 * ===============================================================
 * ✅ BEST PRACTICES
 * ---------------------------------------------------------------
 * 🔹 Gunakan UNION ALL jika performa penting dan duplikat tidak masalah
 * 🔹 Gunakan CAST jika tipe data tidak cocok
 * 🔹 Simpan query UNION kompleks dalam VIEW atau CTE (jika tersedia)
 * 🔹 Jangan lupa beri alias kolom jika perlu dibaca dari luar
 */


 * ===============================================================
 * KESIMPULAN
 * ===============================================================
 * ➤ SET OPERATOR memungkinkan penggabungan hasil query
 * ➤ MySQL hanya mendukung UNION dan UNION ALL secara native
 * ➤ INTERSECT dan EXCEPT bisa disimulasikan dengan subquery atau EXISTS
 * ➤ Sangat bermanfaat untuk analisis data multi-sumber, perbandingan, dan pencarian irisan/perbedaan
 */







