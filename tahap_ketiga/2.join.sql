
-- n



-- jadi join ini adaah fitur untuk menggabungkan fitur select ke beberapa tbale sekaligus
-- namun biasanya untuk mneggunkan join ini kita perlu menentukan kolom mana yg merupakan referensi ke tabel lain
-- jdai join ini cocok sekali dengan constraint foreign key
-- tappi sebenarnya bebas tidak hanya bisa menggunkaan foregin key saja
-- jadi kalo ada kolom yg sama dia antara 2 tabel atau lebih maka kita bisa gunakan ini
-- untuk join

-- dan jika kita kebanyakan join maka akn lambat querynya dan ideanya join itu hanya 5 tabel saja tidak lebih  

SELECT * FROM customer;
DESCRIBE customer;
-- melakukan join

USE toko_online;

-- disini kita akn melakukan join antara tabel wishlist dengan tabel products
-- jadi kita akn lihat querry dari kedua tabel ini
-- misal di tabel wishlist kita menambhakan data id products, nah kita ga tau id products ini
-- nama, harga, quantity, dll nya apa
-- makanya kita melakukan querry gabungan dengan join ini
SELECT * FROM wishlist;
SELECT * FROM products;

SELECT * FROM wishlist
JOIN products ON (wishlist.id_products = products.id); -- ini adalah data yg sama di kedua tabel
-- jadi tidak harus foreign key

-- atau bisa juga kita tentukan kolom yg diselect

SELECT wishlist.id_products, products.id, products.nama, products.price FROM wishlist
JOIN products ON (wishlist.id_products = products.id);

SELECT * FROM wishlist
JOIN products ON (wishlist.id_products = products.id)
WHERE products.price > 15000
ORDER BY price desc;


-- atau bisa juga menggunakan alias
SELECT w.id_products AS idWishlist, 
       p.id AS idProducts, 
       p.nama AS nama, 
       w.description AS deskripsi,
       p.price AS harga
       FROM wishlist AS w 
JOIN products AS p ON (w.id_products = p.id);

-- jadi where disini, kita akn mengambil data price yg lebi dari 15000
-- ketika selesai di join
-- jadi data setelah di joinnya itu atau data yg berelasi itu yg pricenya lebih dari 15000
-- hanya 2

-- dan secara DEFAULT kita itu menggunkaan INNER JOIN, yaitu
-- hasih join yg berelasi
-- jadi hanya menampilkan data yg berelasi saja

SELECT * FROM customer;
DESCRIBE customer;

-- sekarnang kita akan gabungkan atau relasikan 3 tabel customer, products, wishlist
-- jadi kita tambahkan relasi customer ke tabel wishlist
ALTER TABLE wishlist
DROP id_customer;
DESCRIBE wishlist;
ALTER TABLE wishlist
ADD COLUMN id_customer int;

ALTER TABLE wishlist
add CONSTRAINT fk_id_customer FOREIGN KEY (id_customer) REFERENCES customer(id);

SELECT * FROM wishlist;
-- yg pertama itu ita insertkna, karena belum ada data sama sekali
-- tapi untuk menambhakan foreignkey yg kedua ini kia hanya perlu update kolom foreignkey yg bru saja
-- karena data sebelumnya sudah ada
UPDATE wishlist AS w
SET w.id_customer = 1
WHERE w.id = 5;

UPDATE wishlist AS w
SET w.id_customer = 2
WHERE w.id = 6;

UPDATE wishlist AS w
SET w.id_customer = 3
WHERE w.id = 8;

-- sekarang kita akn join

SELECT w.id_products, w.id_customer, w.id,
       p.nama,
       p.price AS harga,
       c.email AS email_pembeli,
       c.uang AS uang_pembeli
       FROM wishlist AS w
JOIN products AS p ON (p.id = w.id_products)
JOIN customer AS c ON (c.id = w.id_customer);





 * JOIN adalah sebuah operasi dalam SQL yang digunakan untuk menggabungkan baris-baris dari dua atau lebih tabel
 * berdasarkan relasi tertentu antar kolomnya (biasanya menggunakan PRIMARY KEY dan FOREIGN KEY).
 * 
 * JOIN digunakan ketika kita ingin mengambil data dari banyak tabel dalam satu hasil query.
 * 
 * MENGAPA HARUS MENGGUNAKAN JOIN?
 * -------------------------------
 * Karena dalam database relasional, kita sering menyimpan data yang saling berhubungan dalam tabel yang berbeda 
 * (untuk menjaga normalisasi, efisiensi, dan fleksibilitas).
 * JOIN memungkinkan kita menggabungkan data tersebut tanpa merusak struktur relasional.
 * 
 * CONTOH:
 * Tabel `customers` menyimpan data pelanggan.
 * Tabel `orders` menyimpan pesanan yang dibuat oleh pelanggan.
 * Untuk melihat siapa saja yang memesan dan apa yang mereka pesan, kita butuh JOIN antar kedua tabel ini.
 * 
 * CARA KERJA JOIN:
 * ----------------
 * JOIN mencocokkan baris-baris antar tabel berdasarkan kondisi tertentu (biasanya kesamaan antar kolom),
 * dan mengembalikan baris yang cocok (atau tidak cocok tergantung jenis JOIN-nya).
 * 
 * ===========================================
 * JENIS-JENIS JOIN DI MYSQL DAN PENJELASANNYA
 * ===========================================
 *
 * 1. INNER JOIN
 * -------------
 * Mengembalikan baris yang memiliki kecocokan di kedua tabel.
 * 
 * CONTOH:
 */

-- TABEL
-- customers(id, name)
-- orders(id, customer_id, product)

SELECT 
  customers.id,
  customers.name,
  orders.product
FROM customers
INNER JOIN orders ON customers.id = orders.customer_id;


 * Penjelasan:
 * - Hanya akan menampilkan pelanggan yang memiliki pesanan (match di kedua tabel).
 */


 * 2. LEFT JOIN (LEFT OUTER JOIN)
 * ------------------------------
 * Mengembalikan semua data dari tabel kiri dan data yang cocok dari tabel kanan.
 * Jika tidak ada kecocokan, maka kolom dari tabel kanan diisi NULL.
 */

SELECT 
  customers.id,
  customers.name,
  orders.product
FROM customers
LEFT JOIN orders ON customers.id = orders.customer_id;


 * Penjelasan:
 * - Menampilkan SEMUA pelanggan, meskipun mereka tidak punya pesanan.
 * - Jika tidak ada pesanan, `orders.product` akan bernilai NULL.
 */


 * 3. RIGHT JOIN (RIGHT OUTER JOIN)
 * --------------------------------
 * Kebalikan dari LEFT JOIN: mengambil semua dari tabel kanan dan cocok dari tabel kiri.
 */

SELECT 
  customers.name,
  orders.product
FROM customers
RIGHT JOIN orders ON customers.id = orders.customer_id;


 * Penjelasan:
 * - Menampilkan SEMUA pesanan, termasuk yang tidak memiliki pelanggan (jika datanya rusak).
 */


 * 4. FULL OUTER JOIN (tidak didukung langsung oleh MySQL)
 * --------------------------------------------------------
 * Menggabungkan LEFT JOIN dan RIGHT JOIN: semua data dari kedua tabel.
 * Bisa disimulasikan dengan UNION:
 */

SELECT 
  customers.name,
  orders.product
FROM customers
LEFT JOIN orders ON customers.id = orders.customer_id

UNION

SELECT 
  customers.name,
  orders.product
FROM customers
RIGHT JOIN orders ON customers.id = orders.customer_id;


 * Penjelasan:
 * - Menampilkan semua baris dari kedua tabel, cocok maupun tidak cocok.
 */


 * 5. CROSS JOIN
 * -------------
 * Menghasilkan semua kombinasi antara baris dari dua tabel (perkalian Cartesian).
 * Digunakan jika kita ingin menggabungkan semua baris dengan semua baris.
 */

SELECT 
  customers.name,
  products.name AS product
FROM customers
CROSS JOIN products;


 * Penjelasan:
 * - Jika ada 5 pelanggan dan 3 produk, akan menghasilkan 5 x 3 = 15 baris.
 * - Gunakan hati-hati karena bisa menghasilkan data sangat besar!
 */


 * 6. SELF JOIN
 * ------------
 * JOIN antar baris dalam satu tabel itu sendiri. Biasanya digunakan untuk data hierarkis.
 */

-- Misalnya tabel `employees`:
-- id | name   | manager_id

SELECT 
  a.name AS employee,
  b.name AS manager
FROM employees a
LEFT JOIN employees b ON a.manager_id = b.id;


 * Penjelasan:
 * - Kita JOIN tabel employees dengan dirinya sendiri untuk mengetahui siapa manajer dari tiap karyawan.
 */


 * CATATAN PENTING:
 * ----------------
 * - JOIN yang efisien sangat penting untuk performa.
 * - Gunakan INDEX pada kolom yang digunakan dalam kondisi ON untuk mempercepat pencocokan.
 * - Selalu tahu relasi antar tabel sebelum membuat JOIN.
 * 
 * ========================
 * KESIMPULAN RINGKAS:
 * ========================
 * | JOIN Type     | Hasil                                                                 |
 * |---------------|-----------------------------------------------------------------------|
 * | INNER JOIN    | Hanya baris yang cocok dari kedua tabel                              |
 * | LEFT JOIN     | Semua dari kiri + cocok dari kanan (NULL jika tidak cocok)          |
 * | RIGHT JOIN    | Semua dari kanan + cocok dari kiri (NULL jika tidak cocok)          |
 * | FULL OUTER    | Semua dari kiri dan kanan, cocok maupun tidak (UNION dari LEFT+RIGHT)|
 * | CROSS JOIN    | Semua kombinasi dari kedua tabel                                     |
 * | SELF JOIN     | JOIN tabel dengan dirinya sendiri                                    |
 * 
 * 
 * ====================================
 * STUDI KASUS: JOIN DENGAN TABEL RIIL
 * ====================================
 * -- Tabel produk
 * CREATE TABLE products (
 *   id VARCHAR(10) PRIMARY KEY,
 *   name VARCHAR(50),
 *   price INT
 * );
 * 
 * -- Tabel wishlist
 * CREATE TABLE wishlist (
 *   id INT AUTO_INCREMENT PRIMARY KEY,
 *   id_products VARCHAR(10),
 *   FOREIGN KEY (id_products) REFERENCES products(id)
 * );
 * 
 * -- Ambil daftar wishlist beserta nama produk dan harganya:
 */

SELECT 
  wishlist.id,
  products.name,
  products.price
FROM wishlist
JOIN products ON wishlist.id_products = products.id;


 * Penjelasan:
 * - Kita JOIN wishlist (yang menyimpan id produk) dengan products (yang menyimpan detail produk).
 * - Hasilnya adalah daftar wishlist yang lengkap dengan nama dan harga produk.
 */








