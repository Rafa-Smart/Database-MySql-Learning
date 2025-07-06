





-- jadi many TO many ini adlah relasi
-- yang dimana ada 2 tabel dan tabel pertma bisa puna banyak relasi ke tabel kedua dan sebaliknya
-- contoh relasi many to many
-- relasi antara produk dan penjualan, dimaa setiap produk bisa dijual berklai kali, da setiap penjualan 
-- bisa dijual untuk lebih dari 1 produk


-- maka kita perlu 1 tabel tambahan ditengah tengahnya yang memiliki foreign key ke tabel 1 dan tabel 2
-- jadi disini kita akan buat tabel penjualan yng menghubungkan tabel products dengan tabel customer

use toko_online;

DESCRIBE customer;
DESCRIBE products;
SELECT * FROM customer;
SELECT * FROM products;


CREATE TABLE penjualan (
    id int PRIMARY KEY AUTO_INCREMENT,
    id_customer int,
    id_products varchar(10),
    jumlah int NOT NULL DEFAULT 0,
    harga int NOT NULL DEFAULT 0,
    CONSTRAINT fk_id_customer_penjualan FOREIGN KEY (id_customer) REFERENCES customer (id),
    CONSTRAINT fk_id_products_penjualan FOREIGN KEY (id_products) REFERENCES products (id)
) ENGINE = innodb;

DESCRIBE penjualan;
SELECT * FROM penjualan;

ALTER TABLE penjualan
ADD COLUMN created_at timestamp DEFAULT current_timestamp;
truncate TABLE penjualan;
INSERT INTO penjualan (id_customer, id_products, jumlah, harga)
VALUES (1,'p0002',4,15000), 
       (3,'p0012',2,16000), 
       (2,'p0002',4,15000),
       (6,'p0012',2,16000), 
       (3,'p0016',3,18000); 
-- lihat di bagian p0002 dan id_customer 3
-- jadi saling bisa banyak relasi
1   p0002
3   p0012
2   p0002
6   p0012
3   p0016


-- sekarang kita tinggal ambil saja datanya

SELECT c.first_name AS `nama`,
       p.id AS `id produk`,
       c.id AS `id customer`, 
       pjln.jumlah `jumlah beli`, 
       pjln.harga `harga produk`, 
       (pjln.harga * pjln.jumlah) AS `total beli`
       FROM penjualan AS pjln
       JOIN products AS p ON (p.id = pjln.id_products)
       JOIN customer AS c ON (c.id = pjln.id_customer);
--        HAVING `total beli` > 32000;


-- gini juga bisa, jadi kita select berdsarkan tabel products
SELECT * FROM products AS p
JOIN penjualan AS pjln ON (pjln.id_products = p.id)
JOIN customer AS c ON (c.id = p.id_category);





Many-to-Many (M:N) relationship adalah hubungan antar dua entitas (tabel) 
di mana satu data di tabel A bisa berelasi ke banyak data di tabel B,
dan sebaliknya, satu data di tabel B juga bisa berelasi ke banyak data di tabel A.

📌 Contoh Nyata:
- Seorang siswa bisa mengambil banyak mata kuliah.
- Satu mata kuliah bisa diikuti oleh banyak siswa.

Maka kita tidak bisa menyimpan relasi ini hanya di satu tabel.
Solusinya adalah menggunakan **TABEL RELASI (junction table / pivot table)** di tengah.

----------------------------------------

🔧 2. BAGAIMANA CARA KERJANYA?
----------------------------------------
Untuk membuat relasi Many-to-Many, kita membutuhkan 3 tabel:
1. TABEL A → menyimpan data utama (contoh: students)
2. TABEL B → menyimpan data lain (contoh: courses)
3. TABEL RELASI → tabel perantara (contoh: enrollments)

Tabel relasi ini berisi dua FOREIGN KEY:
- FOREIGN KEY ke TABEL A
- FOREIGN KEY ke TABEL B

Tabel ini akan menyimpan semua kombinasi relasi antara A dan B.

----------------------------------------

🎯 3. KENAPA HARUS PAKAI MANY-TO-MANY?
----------------------------------------
Karena:
- MySQL **tidak bisa menyimpan banyak nilai dalam satu kolom** (tidak normal).
- Relasi kompleks (seperti siswa mengambil banyak mata kuliah) **tidak bisa ditangani** oleh one-to-many atau one-to-one.
- Membuat skema database **lebih rapi, fleksibel, dan scalable**.

----------------------------------------

📦 4. CONTOH IMPLEMENTASI LENGKAP
----------------------------------------
📁 Studi Kasus:
- Satu pelanggan bisa memesan banyak produk
- Satu produk bisa dipesan oleh banyak pelanggan
- Kita buat tabel `customers`, `products`, dan `order_items` sebagai tabel relasi.

*/

// Membuat tabel pelanggan
CREATE TABLE customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nama VARCHAR(100) NOT NULL
);

// Membuat tabel produk
CREATE TABLE products (
    id VARCHAR(10) PRIMARY KEY,
    nama VARCHAR(100) NOT NULL
);


🧩 TABEL RELASI: order_items
-----------------------------
- Digunakan untuk menyimpan relasi pesanan antar customer dan product
- Satu baris = satu produk yang dibeli oleh satu pelanggan
- Tambahkan FOREIGN KEY ke kedua tabel utama
*/

CREATE TABLE order_items (
    id INT PRIMARY KEY AUTO_INCREMENT,

    id_customer INT NOT NULL,
    id_product VARCHAR(10) NOT NULL,
    jumlah INT NOT NULL,

    -- FOREIGN KEY ke tabel customer
    CONSTRAINT fk_order_customer FOREIGN KEY (id_customer)
        REFERENCES customers(id)
        ON DELETE CASCADE ON UPDATE CASCADE,

    -- FOREIGN KEY ke tabel products
    CONSTRAINT fk_order_product FOREIGN KEY (id_product)
        REFERENCES products(id)
        ON DELETE CASCADE ON UPDATE CASCADE
);


----------------------------------------
📋 5. CONTOH PENGISIAN DATA
----------------------------------------
*/

// Tambah data customer
INSERT INTO customers (nama) VALUES 
('Andi'), ('Budi');

// Tambah data produk
INSERT INTO products (id, nama) VALUES 
('p001', 'Mie Ayam'), 
('p002', 'Bakso'), 
('p003', 'Nasi Goreng');

// Tambah relasi pembelian (customer beli produk apa)
INSERT INTO order_items (id_customer, id_product, jumlah) VALUES 
(1, 'p001', 2), -- Andi beli 2 Mie Ayam
(1, 'p003', 1), -- Andi beli 1 Nasi Goreng
(2, 'p002', 3), -- Budi beli 3 Bakso
(2, 'p001', 1); -- Budi beli 1 Mie Ayam


----------------------------------------
📌 6. CARA MENGAMBIL DATA (JOIN)
----------------------------------------
Tampilkan semua pesanan lengkap dengan nama customer dan nama produk
*/

SELECT 
    c.nama AS nama_customer,
    p.nama AS nama_produk,
    oi.jumlah
FROM order_items oi
JOIN customers c ON c.id = oi.id_customer
JOIN products p ON p.id = oi.id_product;


===========================================
✅ RINGKASAN INTI:
- Many-to-Many adalah hubungan di mana dua tabel saling terhubung lebih dari satu kali.
- Solusi: buat TABEL RELASI sebagai penghubung yang punya dua FOREIGN KEY.
- Sangat berguna dalam kasus pembelian, pendidikan, pemesanan, dan banyak sistem lain.
- Tabel relasi juga bisa ditambahkan kolom ekstra (seperti jumlah, tanggal, dsb).
- Ini adalah teknik dasar dalam desain database profesional.
===========================================
*/






