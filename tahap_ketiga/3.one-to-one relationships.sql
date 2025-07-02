



-- jadi maksudnya adlah tiap baris pada sebuah tabel utama hanya bleh unya relasi 1 baris daja juga
-- di tabel anaknya (yg mereferences)

-- misal membuat toko online yg terdapat fitur e wallet, jadi 1 customer
-- hanya bisa punya relasi (punya) e wallet 1 di tabel wallet

-- jadi caranya itu foreign key yg ada di tabel yg ereferences / anak
-- harus kita setting menjadi unique
-- atau cara kedua, kita setting kedua id yg ada di tabel yaitu wallet dan customer mnejadi primary key yg sama
-- persis

-- jadi cuma ada 1 customer saja di tabel wallet
USE toko_online;
CREATE TABLE wallet (
    id int NOT NULL auto_increment,
    id_customer int NOT NULL,
    uang_saku int NOT NULL DEFAULT 0,
    CONSTRAINT primary_key PRIMARY KEY (id),
    CONSTRAINT unique_id UNIQUE (id_customer), -- agar bisa one to one relationship
    CONSTRAINT fk_id_wallet_customer FOREIGN KEY (id_customer) REFERENCES customer (id)
    ON DELETE CASCADE ON UPDATE CASCADE
) engine = innodb;

DESCRIBE wallet;

SHOW DATABASES;
DROP TABLE wallet;

SELECT * FROM customer;
SELECT * FROM wallet;
-- jadi jika ada satu saja id yg kita tambahkan ke wallet 

INSERT INTO wallet (id_customer, uang_saku)
VALUES (1,90000),(2,70000),(6,60000),(5,90000);

-- dan ketika kita masukan data yg duplikat

INSERT INTO wallet (id_customer, uang_saku)
VALUES (1,40000);
-- SQL Error [1062] [23000]: Duplicate entry '1' for key 'wallet.unique_id'

-- ga bisa, berati benar, satu customer hanya bisa memiliki 1 wallet saja
-- dan otomatis juga satu wallet hanya bisa 1 customer saja

SELECT c.id, c.email, w.uang_saku FROM wallet AS w
JOIN customer AS c ON (c.id = w.id_customer);
-- hasil
id   email     uang_saku
1   rafaEmail   90000
2   jamalEmail  70000
6   johnEmail   60000
5   udinEmail   90000


 * -----------------------------------
 * One-to-One (1:1) adalah jenis relasi dalam database di mana:
 * 
 * 🔹 Satu baris di TABEL A hanya boleh memiliki satu baris yang terkait di TABEL B
 * 🔹 Dan sebaliknya, satu baris di TABEL B hanya boleh memiliki satu baris yang terkait di TABEL A
 * 
 * Artinya: hubungan "1 berbanding 1".
 * 
 * Contoh dalam dunia nyata:
 * - Setiap **pengguna** memiliki tepat satu **profil pribadi**
 * - Setiap **paspor** hanya dimiliki oleh satu **orang**
 * - Setiap **mobil** hanya punya satu **STNK**
 * 
 * 
 * 📌 MENGAPA MENGGUNAKAN ONE-TO-ONE?
 * ----------------------------------
 * - Untuk **memisahkan data** yang hanya digunakan dalam kondisi tertentu
 * - Untuk **keamanan**: misalnya memisahkan data sensitif (e.g. NIK, alamat) dari tabel utama
 * - Untuk **mengurangi kompleksitas** tabel utama agar lebih modular
 * 
 * 
 * 📌 CARA KERJA DI MYSQL
 * ----------------------
 * Umumnya digunakan dengan dua tabel:
 * - TABEL A: tabel utama (e.g. `users`)
 * - TABEL B: tabel pendukung (e.g. `user_profiles`)
 * 
 * Ada 2 cara implementasi relasi 1:1:
 * 
 * ✅ Cara 1: FOREIGN KEY di tabel B yang merujuk ke PRIMARY KEY di tabel A (paling umum)
 * ✅ Cara 2: Kedua tabel memiliki PRIMARY KEY yang sama (lebih ketat & pasti 1:1)
 * 
 * 
 * =============================
 * ✅ CONTOH KASUS:
 * =============================
 * Kita ingin menyimpan data pengguna dan data profil pengguna secara terpisah:
 * 
 * - Tabel `users` → menyimpan data login
 * - Tabel `user_profiles` → menyimpan informasi pribadi
 * 
 * 💡 Setiap user hanya boleh punya satu profil, dan satu profil hanya untuk satu user.
 */

// 1. Buat tabel utama: users
CREATE TABLE users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(50) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE
);

// 2. Buat tabel user_profiles yang punya FOREIGN KEY ke users.id
CREATE TABLE user_profiles (
  user_id INT PRIMARY KEY, -- ini juga berfungsi sebagai FOREIGN KEY
  full_name VARCHAR(100),
  address TEXT,
  phone VARCHAR(20),
  -- definisikan foreign key
  CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
);


 * 🔍 Penjelasan:
 * - user_profiles.user_id adalah PRIMARY KEY → memastikan hanya 1 profil per user
 * - FOREIGN KEY memastikan bahwa hanya user yang valid yang bisa punya profil
 * - ON DELETE CASCADE → jika user dihapus, profilnya juga ikut terhapus
 * 
 * ✅ Ini adalah bentuk *paling ketat dan ideal* untuk memastikan hubungan One-to-One
 * 
 * =====================================
 * ✅ INSERT DATA CONTOH:
 * =====================================
 */

-- Insert user
INSERT INTO users (username, email)
VALUES ('rafakhadafi', 'rafa@example.com');

-- Insert profil user (dengan user_id sama persis dengan id di tabel users)
INSERT INTO user_profiles (user_id, full_name, address, phone)
VALUES (1, 'Rafa Khadafi', 'Jl. Merdeka No.10', '08123456789');


 * ❗ Jika kamu coba insert dua kali dengan user_id yang sama, akan error!
 * 
 * INSERT INTO user_profiles (user_id, ...) VALUES (1, ...); ❌
 * 
 * Karena PRIMARY KEY (user_id) harus unik → jadi tidak bisa punya 2 profil untuk 1 user.
 */


 * =====================================
 * ✅ AMBIL DATA DARI KEDUA TABEL (JOIN)
 * =====================================
 */

SELECT 
  users.id,
  users.username,
  user_profiles.full_name,
  user_profiles.phone
FROM users
JOIN user_profiles ON users.id = user_profiles.user_id;


 * 📌 Penjelasan:
 * - Kita JOIN berdasarkan id dari users dan user_id dari user_profiles
 * - Karena 1:1, maka hasilnya 1 baris untuk setiap user
 */


 * =========================================
 * 📌 KESIMPULAN PENTING: ONE-TO-ONE RELATION
 * =========================================
 * 
 * 🔹 Gunakan relasi ini jika:
 *    - Setiap baris di tabel A hanya punya 1 baris di tabel B
 *    - Dan sebaliknya
 * 
 * 🔹 Manfaat:
 *    - Struktur database lebih rapi dan modular
 *    - Data bisa dipisah sesuai sensitivitas atau kebutuhan
 * 
 * 🔹 Implementasi terbaik:
 *    - FOREIGN KEY + PRIMARY KEY di kolom yang sama (user_id)
 *    - ON DELETE CASCADE jika ingin data ikut terhapus
 * 
 * 🔹 Performa:
 *    - JOIN sangat cepat karena relasi hanya 1 banding 1
 * 
 * 🔹 Validasi:
 *    - MySQL menjamin tidak akan ada lebih dari satu profil untuk satu user
 */

// Selesai ✔








