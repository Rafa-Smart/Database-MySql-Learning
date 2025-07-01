--



-- kita bisa melakukan relasi antar table
-- misla pada tabel penjualan, nah pasti didalam data penjualan ini terdapat data barangnya
-- artinya ketika kita membuat tabel penjualan maka itu akan berelasi dengn tabel barnag



-- dan juga ketika kita membuat tabel, biasanya kita kan emmbuat sebua kolom sebagai
--referensi ke tabel lainnua
-- misal saat kita mmebuat tabel penjualan didalam tabel penjualan kita akn menambahkan kolom id_products
-- sebagai referensi ke tabel produk, yg berisi PRIMARY KEY di tabel products

-- nah kolom referensi ini di mysql dinamakan foregein key
-- dan kita juga bisa menambahkan satu atau lebih foregein key dalam sebuah tabel

-- nah sekarang kita akn membuat tabel wishlist

USE toko_online;

SELECT * FROM wishlist;

DESCRIBE wishlist;
DROP TABLE wishlist;
CREATE TABLE wishlist (
    id int NOT NULL PRIMARY KEY auto_increment,
    id_products varchar(10) NOT NULL, -- tipe datanya harus sama
    -- dengna yg ditabel products (referencenya)
    description text,
    CONSTRAINT fk_wishlist_products FOREIGN KEY (id_products) REFERENCES products (id)
) engine = innodb;

SELECT * FROM products;
DESCRIBE products;


-- atau jika sudah dibuat
ALTER TABLE wishlist
DROP constraint fk_wishlist_products;

ALTER TABLE wishlist
DROP id_products;

-- disini kita buat dulu kolomnnya
ALTER TABLE wishlist
ADD COLUMN id_products varchar(10) NOT NULL;

ALTER TABLE wishlist
ADD CONSTRAINT fk_wishlist_products FOREIGN KEY (id_products) REFERENCES products (id);

DESCRIBE wishlist;

jadi ketika DATA id products yg ada di wishlist ketika di INSERT tidak sama dnegna id yg ada di TABLE
products maka akan ditolak

-- ini informasi ketika data induk dan data anak 

 * ✅ Tabel induk (parent table)
 * ----------------------------------------------------------------------------
 * - Nama tabel: `products`
 * - Alasannya: Karena kolom `id` dari `products` dijadikan referensi
 *   oleh tabel `wishlist`.
 * - Dengan kata lain, data di `products` harus sudah ada lebih dulu
 *   sebelum digunakan di tabel `wishlist`.
 */

 * ✅ Tabel anak (child table)
 * ----------------------------------------------------------------------------
 * - Nama tabel: `wishlist`
 * - Alasannya: Karena kolom `id_products` di `wishlist` mereferensikan
 *   kolom `id` dari tabel `products`.
 * - Ini berarti `wishlist` hanya boleh berisi ID produk yang sudah ada
 *   di tabel `products`.
 */


 * ✅ Kolom referensi (referenced column)
 * ----------------------------------------------------------------------------
 * - Letaknya di: Tabel induk (`products`)
 * - Nama kolom: `id`
 * - Fungsinya: Menjadi acuan validasi data untuk kolom foreign key di tabel anak.
 */


 * ✅ Kolom FOREIGN KEY berada di:
 * ----------------------------------------------------------------------------
 * - Letaknya di: Tabel anak (`wishlist`)
 * - Nama kolom: `id_products`
 * - Fungsinya: Menyimpan ID dari produk yang berasal dari tabel `products`.
 *   Hanya boleh berisi ID yang benar-benar ada di `products.id`.
 */


 * 🎯 Kesimpulan:
 * ----------------------------------------------------------------------------
 * - Tabel referensi = tabel induk (`products`)
 * - Kolom referensi = kolom yang jadi acuan (`products.id`)
 * - Foreign key = kolom yang berada di tabel anak (`wishlist.id_products`)
 *
 * 📌 Jadi: FOREIGN KEY berada di TABEL ANAK dan mengacu ke KOLOM REFERENSI di TABEL INDUK
 */


 DESCRIBE wishlist;
 SELECT * FROM wishlist;
 INSERT INTO wishlist (id_products, description)
 VALUES ('p0001', 'makanan kesukaan');
 -- bisa karena memang data id p0001 benar ada didalam
--  tabel products
 
 
 -- disini coba kita masukan data id yg tidak ada di tabel products
 INSERT INTO wishlist (id_products, description)
 VALUES ('salah', 'minuman kesukaan');
--  SQL Error [1452] [23000]: Cannot add or update a child row: a foreign key constraint fails (`toko_online`.`wishlist`, CONSTRAINT `fk_wishlist_products` FOREIGN KEY (`id_products`) REFERENCES `products` (`id`))
 
 
 
 
-- disini coa kita hapus data yg sudah ada di tabel relasi atau yg menerima reference (wishlist)-
-- jadi kalo di tabel reference ada data yg sudah ada di tabel wishlist
-- maka ketika dihapus,tidak akn bisa
 -- karena data itu terpakai di tabel wishlishnya
 
-- coba
 
DELETE FROM products
WHERE id = 'p0001';
-- SQL Error [1451] [23000]: Cannot delete or update a parent row: a foreign key constraint fails 
-- (`toko_online`.`wishlist`, CONSTRAINT `fk_wishlist_products` FOREIGN KEY (`id_products`) REFERENCES `products` (`id`))
-- jadi cara kerjanya itu akan dicek dulu data yg dihapus, apakah tabel yg referens ke tabel dan adta yg
-- ingin dihapus, (karena ada), maka aka ditlak 

-- begitupula jika meghapus, update, karea akan merusak referencenya

-- tapi kita bisa merubah behaviornya menggunakan ini

 -- oleh karena it kita bisa mengunakan configurasi ini
-- jadi kalo on delete (aksi) on update (aksi)
                                             
 * | Aksi          | Artinya                                                             |
 * |---------------|---------------------------------------------------------------------|
 * | CASCADE       | Data anak ikut terhapus atau di-update                             |
 * | SET NULL      | Data anak jadi NULL jika induk dihapus                              |
 * | NO ACTION     | Tolak jika masih ada relasi anak                                    |
 * | RESTRICT      | Seperti NO ACTION, tapi diperiksa lebih ketat (default)                      |
 * | SET DEFAULT   | Atur ke nilai default (jarang dipakai)    
 
 
 ALTER TABLE wishlist
 add CONSTRAINT fk_products_id
 FOREIGN KEY (id_products) REFERENCES products (id)
 ON DELETE CASCADE ON UPDATE CASCADE;
 
 SHOW CREATE TABLE wishlist;
 DESCRIBE wishlist;
SELECT * FROM wishlist;
 -- nah disini sudah kita setting bahwa etika di tabel referencenya diubah, maka dat ayg ada di 
 -- tabel yg referens ke tabel refeences akan ikut berubha juga

 -- disini coba kita masukan data id yg tidak ada di tabel products
 INSERT INTO products (id, name, category, price, quantity)
 VALUES ('pxxxx', 'minuman kesukaan');

 DELETE FROM products
WHERE id = 'p0001';
 

 *
 * 🔑 APA ITU FOREIGN KEY?
 * ----------------------------------------------------------------------------
 * FOREIGN KEY (atau kunci asing) adalah **hubungan antara dua tabel**
 * yang mengaitkan **kolom di satu tabel dengan kolom di tabel lain**.
 *
 * ➕ Tujuan utamanya adalah menjaga **integritas data relasional**,
 *     artinya:
 *     - Data yang ditautkan harus valid
 *     - Tidak bisa memasukkan data yang tidak berelasi
 *
 *
 * 🎯 MENGAPA HARUS MENGGUNAKAN FOREIGN KEY?
 * ----------------------------------------------------------------------------
 * ✅ Menjamin integritas data (tidak ada referensi ke ID yang tidak ada)
 * ✅ Menghindari duplikasi data
 * ✅ Otomatis menghapus / mengubah data terkait (ON DELETE / ON UPDATE)
 * ✅ Memodelkan hubungan antar tabel (1-to-1, 1-to-many)
 *
 *
 * 🔧 SINTAKS DASAR:
 * ----------------------------------------------------------------------------
 * CREATE TABLE child_table (
 *   id INT PRIMARY KEY,
 *   parent_id INT,
 *   FOREIGN KEY (parent_id) REFERENCES parent_table(id)
 * );
 *
 * // Atau saat ALTER TABLE:
 * ALTER TABLE child_table
 * ADD CONSTRAINT nama_kunci_asing
 * FOREIGN KEY (kolom_di_child)
 * REFERENCES parent_table(kolom_di_parent);
 *
 *
 * 🧠 CONTOH PRAKTIS 1 - Tabel User dan Orders
 * ----------------------------------------------------------------------------
 * Tabel users (tabel induk)
 * CREATE TABLE users (
 *   id INT PRIMARY KEY AUTO_INCREMENT,
 *   nama VARCHAR(100)
 * );
 *
 * Tabel orders (tabel anak)
 * CREATE TABLE orders (
 *   id INT PRIMARY KEY AUTO_INCREMENT,
 *   user_id INT,
 *   total DECIMAL(10,2),
 *   FOREIGN KEY (user_id) REFERENCES users(id)
 * );
 *
 * ➕ Maka setiap `orders.user_id` HARUS cocok dengan `users.id`.
 * ➖ Jika tidak cocok, akan error saat INSERT atau UPDATE.
 *
 *
 * ✅ ON DELETE dan ON UPDATE (opsional tapi penting)
 * ----------------------------------------------------------------------------
 * FOREIGN KEY mendukung **aksi otomatis saat data induk diubah**:
 *
 * | Aksi          | Artinya                                                             |
 * |---------------|---------------------------------------------------------------------|
 * | CASCADE       | Data anak ikut terhapus atau di-update                             |
 * | SET NULL      | Data anak jadi NULL jika induk dihapus                              |
 * | NO ACTION     | Tolak jika masih ada relasi anak                                    |
 * | RESTRICT      | Seperti NO ACTION, tapi diperiksa lebih ketat                       |
 * | SET DEFAULT   | Atur ke nilai default (jarang dipakai)                              |
 *
 * Contoh:
 * FOREIGN KEY (user_id) REFERENCES users(id)
 * ON DELETE CASCADE
 * ON UPDATE CASCADE;
 *
 *
 * 🧱 STRUKTUR HUBUNGAN YANG DIDUKUNG
 * ----------------------------------------------------------------------------
 * - One-to-One    → data di kedua tabel berpasangan satu-satu
 * - One-to-Many   → satu user punya banyak order
 * - Many-to-Many  → butuh tabel perantara (relasi)
 *
 *
 * ❗ SYARAT TEKNIS PENTING FOREIGN KEY
 * ----------------------------------------------------------------------------
 * 1. Kedua kolom harus punya tipe data yang **sama persis** (misal: INT dan INT).
 * 2. Kolom yang jadi referensi harus diindeks (biasanya PRIMARY KEY atau UNIQUE).
 * 3. Tabel harus pakai engine **InnoDB** (MyISAM tidak mendukung).
 * 4. Nama kolom FOREIGN KEY harus konsisten (tidak harus sama, tapi disarankan).
 *
 *
 * ❌ ERROR UMUM DAN PENYEBABNYA
 * ----------------------------------------------------------------------------
 * - Foreign key constraint fails → karena referensi tidak cocok.
 * - Unknown column in foreign key → karena typo nama kolom.
 * - Cannot add foreign key constraint → karena tipe data beda, atau engine salah.
 *
 * ✅ Solusi:
 * - Gunakan `SHOW ENGINE INNODB STATUS\G;` untuk debugging foreign key error.
 * - Pastikan semua kolom yang di-referensi adalah PRIMARY KEY atau UNIQUE.
 *
 *
 * 📌 TIPS BEST PRACTICE
 * ----------------------------------------------------------------------------
 * ✅ Gunakan nama constraint yang deskriptif, seperti:
 *    CONSTRAINT fk_orders_user_id FOREIGN KEY (user_id) REFERENCES users(id)
 *
 * ✅ Hindari NULL jika memungkinkan (gunakan ON DELETE CASCADE lebih aman)
 *
 * ✅ Gunakan `ON UPDATE CASCADE` jika ingin menjaga referensi saat ID diubah
 *
 *
 * ✅ CONTOH LATIHAN LENGKAP
 * ----------------------------------------------------------------------------
 *
 * // 1. Tabel categories
 * CREATE TABLE categories (
 *   id INT PRIMARY KEY AUTO_INCREMENT,
 *   nama_kategori VARCHAR(100) NOT NULL
 * );
 *
 * // 2. Tabel produk
 * CREATE TABLE produk (
 *   id INT PRIMARY KEY AUTO_INCREMENT,
 *   nama_produk VARCHAR(100) NOT NULL,
 *   kategori_id INT,
 *   FOREIGN KEY (kategori_id) REFERENCES categories(id)
 *   ON DELETE SET NULL
 *   ON UPDATE CASCADE
 * );
 *
 * // 3. Tambahkan data
 * INSERT INTO categories (nama_kategori) VALUES ('Elektronik'), ('Pakaian');
 * INSERT INTO produk (nama_produk, kategori_id) VALUES ('Laptop', 1), ('Kaos', 2);
 *
 *
 * ✨ PENUTUP
 * ----------------------------------------------------------------------------
 * FOREIGN KEY adalah fitur penting dalam sistem database relasional.
 * Ia menjaga integritas antar tabel, memastikan data tidak menjadi "yatim piatu".
 *
 * Gunakanlah FOREIGN KEY secara bijak terutama saat:
 *  - Menyusun relasi antar entitas (user → order, produk → kategori)
 *  - Ingin mengatur penghapusan otomatis atau pencegahan data rusak
 *
 * ⚠️ Walau powerful, FOREIGN KEY bisa memperlambat INSERT/DELETE massal,
 * jadi perhatikan skalabilitas aplikasi.
 *
 */





