
one TO one berati yg kiri itu adlaah tabel induk yg kanan tabel anak
one TO many berati yg kiri itu adlaah tabel induk yg kanan tabel anak

-- jadi kalo tabel category bisa punya banyak relasi (maksudnya itu misal)
-- 1 catergory(goreng), bisa punya relasu kebnayak products
-- jadi ada banyak products yg bsa memiliki category goreng

-- tapi 1 products hanya bisa memiliki 1 category (goreng) saja di tabel category
-- jadi 1 products ga bisa punya banyak category sekaligus


-- jadi sebenarnya itu, one-to-many relationship ini sama kayak
-- one-to-one relationship, tapi id atau foreign key yg ada di teabel yg referens
-- itu tidak disetting unique, jadi dari data induknya (id category) boleh bisa ada banyak di tabel anaknya
-- karena ga unik




-- membuat tabel category

use toko_online;
DROP TABLE category;
DESCRIBE products;

CREATE TABLE category (
    id int  NOT NULL PRIMARY KEY auto_increment,
    nama varchar(100) NOT NULL
) ENGINE = innodb;
/* 
        Disini kita tidak menambahkan foreign key karena tabel ini 
        berfungsi sebagai referensi. Nantinya, tabel lain seperti `products`
        akan menggunakan category.id sebagai foreign key.

        Contoh foreign key di tabel lain:
        CONSTRAINT fk_id_products_3 FOREIGN KEY (id_category) REFERENCES category(id)
*/

DESCRIBE category;
DESCRIBE products;
-- disini karena di tabel products kita sudah bunya column category
-- maka kita hapus dulu

ALTER TABLE products
DROP COLUMN category;

-- lalu kita tambah lagi 

ALTER TABLE products
ADD COLUMN id_category int; -- ga bisa pake not null, karena sudah ada data dibarisnya

ALTER TABLE products
MODIFY id_category int AFTER nama;

-- lalu kita tmbahkan foreign key ke table category

ALTER TABLE products
ADD CONSTRAINT fk_id_category FOREIGN KEY (id_category) REFERENCES category(id);



-- masukan data category ke table category

DESCRIBE category;
SELECT * FROM category;
INSERT INTO category (nama)
VALUES ('goreng'),('kuah'),('lain lain');




-- nah lalu kita upadate kolm id category yg ada di tabel products
SELECT * FROM products;

-- 🔸 Category 1: GORENG / MAKANAN BERAT
UPDATE products
SET id_category = 1
WHERE id IN (
  'p0007', 'p0008', 'p0009', 'p0011', 'p0012', 'p0014', 'p0015',
  'p0016', 'p0017', 'p0020', 'p0021', 'p0022', 'p0026', 'p0055'
);

-- 🔹 Category 2: KUAH
UPDATE products
SET id_category = 2
WHERE id IN (
  'p0002', 'p0003', 'p0004', 'p0005', 'p0006', 'p0013',
  'p0018', 'p0019', 'p0023', 'p0024'
);

-- 🟡 Category 3: LAIN-LAIN (camilan)
UPDATE products
SET id_category = 3
WHERE id IN (
  'p0010', 'p0025'
);

SELECT * FROM category;

-- setelah itu tinggal kita join kan saja

SELECT p.nama AS nama, p.id_category, c.nama AS category
FROM products AS p
JOIN category AS c ON (p.id_category = c.id);




 * One-to-Many (1:M) adalah jenis relasi antar tabel dalam database relasional
 * di mana satu baris di TABEL A bisa terhubung dengan BANYAK baris di TABEL B,
 * tapi satu baris di TABEL B hanya bisa terhubung ke SATU baris di TABEL A.
 * 
 * 🔁 Dalam bahasa sehari-hari:
 * - Satu pelanggan (customer) bisa memiliki banyak pesanan (orders)
 * - Satu guru bisa mengajar banyak siswa
 * - Satu kategori bisa digunakan oleh banyak produk
 * 
 * 
 * 📌 KENAPA HARUS MENGGUNAKAN ONE-TO-MANY?
 * ----------------------------------------
 * - Untuk menjaga **struktur database tetap normal dan efisien**
 * - Untuk **menghindari duplikasi data**
 * - Untuk menyimpan **relasi yang alami** dalam kehidupan nyata (misalnya satu orang banyak pesanan)
 * - Untuk **kemudahan query dan integritas data**
 * 
 * 
 * 📌 BAGAIMANA CARA KERJANYA DI MySQL?
 * -------------------------------------
 * ➤ TABEL INDUK (One) → memiliki PRIMARY KEY
 * ➤ TABEL ANAK (Many) → memiliki kolom FOREIGN KEY yang mengacu ke PRIMARY KEY tabel induk
 * ➤ MySQL menjamin hanya data yang valid (dari tabel induk) yang bisa dimasukkan ke tabel anak
 * 
 * 
 * ==========================
 * ✅ CONTOH KASUS PRAKTIS:
 * ==========================
 * Kita ingin membuat sistem toko online:
 * - Tabel `customer` → menyimpan data pelanggan
 * - Tabel `orders` → menyimpan data pesanan, dan SETIAP PESANAN harus punya ID CUSTOMER
 * 
 * Artinya:
 *   1 customer → bisa punya banyak orders
 *   1 order    → hanya milik 1 customer
 */

// ========================
// 1. Buat tabel customer
// ========================
CREATE TABLE customer (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL
);

// =====================
// 2. Buat tabel orders
// =====================
CREATE TABLE orders (
  id INT PRIMARY KEY AUTO_INCREMENT,
  id_customer INT NOT NULL, -- foreign key mengacu ke customer
  product_name VARCHAR(100),
  quantity INT,
  order_date DATE DEFAULT CURRENT_DATE,
  -- Definisikan relasi one-to-many
  CONSTRAINT fk_id_customer FOREIGN KEY (id_customer) REFERENCES customer(id)
  ON DELETE CASCADE ON UPDATE CASCADE
);


 * 🔍 Penjelasan:
 * - Setiap baris `orders` harus mencantumkan `id_customer` yang valid.
 * - Jika customer dihapus, maka semua pesanan terkait ikut terhapus (CASCADE).
 * - Relasi ini menjamin integritas antara customer dan orders.
 * 
 * ✅ Ini adalah implementasi standar relasi One-to-Many di MySQL
 */



 * ========================
 * ✅ MASUKKAN DATA CONTOH
 * ========================
 */
-- Tambahkan pelanggan
INSERT INTO customer (name) VALUES 
('Rafa Khadafi'),
('Dina Fatimah');

-- Tambahkan pesanan (orders) untuk masing-masing customer
INSERT INTO orders (id_customer, product_name, quantity) VALUES
(1, 'Keyboard Mechanical', 1),
(1, 'Mouse Wireless', 2),
(2, 'Monitor LED', 1),
(1, 'USB Hub', 3);

 * 🔍 Penjelasan:
 * - Customer id 1 (Rafa) memiliki 3 pesanan
 * - Customer id 2 (Dina) memiliki 1 pesanan
 * - Ini menunjukkan hubungan 1:M dengan sempurna
 */



 * =========================
 * ✅ JOIN UNTUK MELIHAT DATA
 * =========================
 */

SELECT 
  customer.name AS customer_name,
  orders.product_name,
  orders.quantity,
  orders.order_date
FROM customer
JOIN orders ON customer.id = orders.id_customer
ORDER BY customer.name;


 * 🔍 Hasil:
 * - Menampilkan semua pesanan beserta nama pelanggannya
 * - Karena One-to-Many, nama customer bisa muncul beberapa kali
 */



 * ==============================
 * 🧠 BEST PRACTICE DESAIN 1:M
 * ==============================
 * 
 * 🔹 Gunakan tipe data yang sama antara FOREIGN KEY dan PRIMARY KEY (INT vs INT, dsb)
 * 🔹 Selalu beri INDEX pada kolom FOREIGN KEY untuk mempercepat JOIN
 * 🔹 Gunakan ON DELETE CASCADE jika ingin data anak ikut terhapus
 * 🔹 Jangan pakai NULL untuk kolom foreign key jika datanya wajib terhubung
 */



 * ==============================
 * 📌 KESIMPULAN ONE-TO-MANY
 * ==============================
 * 
 * ✅ 1 baris di tabel A → bisa punya banyak relasi ke tabel B
 * ✅ 1 baris di tabel B → hanya milik 1 entitas di tabel A
 * ✅ Digunakan untuk semua relasi alami seperti: user-post, customer-order, kategori-produk
 * ✅ Implementasi: FOREIGN KEY di tabel anak → mengacu ke PRIMARY KEY tabel induk
 * ✅ JOIN hasilnya banyak baris untuk satu entitas induk
 */











