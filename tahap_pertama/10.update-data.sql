-- untuk mengupdate atau mnegubah data pada tabel kita bisa menggunakan update,
-- dan bedanya dengn alter itu, kalo alter itu ngubah struktur pada tabel
-- kalo update itu mnegubah data pada tabel

-- saat menggunakan sql update kita harus memberi tahu data mana yg akan di update dengan
-- where clause
-- dan hati hati ketika update data di tabel, karena jika sampai where clause nya salah
-- maka bisa bisa kita malah mengupdate seluruh data yg ada di tabel

-- dan untuk update kita harus beritahu kolom mana yg mau ktia update
-- https://chatgpt.com/c/685abd10-9258-8009-8f41-add017e35394


-- disini coba kita akn menambahkan kolom baru di tabel products yaitu kategori

USE toko_online;
ALTER TABLE products 
    ADD COLUMN category enum("kuah", "goreng", "lain lain")
    AFTER nama;


-- SQL Error [1265] [01000]: Data truncated for column 'category' at row 1
-- artinya: nilai yang kamu masukkan ke kolom category tidak cocok dengan daftar nilai yang diizinkan oleh ENUM.
-- 
-- kenapa ga bisa karena kutip itu sangat berperan ya
-- -- kalo misalakn di enumnya '', maka kita juga di kode berikutnyakalo mau pilih enum
-- harus '', jangan "",
-- dan begitu pula untuk yg lainnya jadi harus di sepakati duu mau pake apa '', atau ""

-- disini kita hapus dulu si categorynya

ALTER TABLE products
    DROP COLUMN category;
-- baru buat lagi

-- 1. disini kita akan update 1 kolom

UPDATE products
SET category = "kuah"
WHERE id = 'p0001';


DESCRIBE products;
SELECT * FROM  products;


-- nah disini kita akan update data catgorynya

-- kalo kolom nama yg awalnya m, maka categorynya jadinya goreng
-- kalo kolom nama yg awalnya b, maka categorynya jadinya kuah
-- kalo kolom nama yg awalnya selain dari b dan m, maka categorynya jadinya lain lain

-- jadi fungis % ini maksudnya adalah terserah
-- misal b%, berati setelah b ini terserah apasaja isinya

-- disini kita pake fungis lower

-- 1.
UPDATE products
SET category = "kuah"
WHERE LOWER(nama) like "b%";

SELECT * FROM products;

-- 2.
UPDATE products
SET category = "goreng"
WHERE LOWER(nama) LIKE "m%";

-- 3.
UPDATE products
SET category = "lain lain"
WHERE LOWER(nama) NOT LIKE "m%" AND LOWER(nama) NOT LIKE "b%";


--4. melakukan UPDATE, tapi tidak mereplace

UPDATE products
SET price = price + 5000
WHERE id = "p0005";
-- maka jadinya harga di id p0005, yg asalnya 18000 menjadi 23000
-- dan bisa apapun disitu brekreasi saja
USE toko_online;

/*

 1. PENGERTIAN:
-------------------------------------------
UPDATE adalah perintah SQL yang digunakan untuk 
mengubah/menyesuaikan data dalam satu atau beberapa 
kolom pada baris tertentu dalam sebuah tabel.

Sintaks dasar:
----------------------------------------------------
UPDATE nama_tabel
SET nama_kolom1 = nilai_baru1, nama_kolom2 = nilai_baru2, ...
WHERE kondisi;

 PERHATIAN:
- Tanpa klausa WHERE, semua baris akan diperbarui!
- Selalu pakai WHERE jika hanya ingin update data tertentu.

 2. CONTOH DATA SEBELUMNYA (tabel: pelanggan)
----------------------------------------------------
+----+-------------+------------+-------------+
| id | nama        | email      | kota        |
+----+-------------+------------+-------------+
| 1  | Andi        | a@gmail.com| Jakarta     |
| 2  | Budi        | b@gmail.com| Bandung     |
| 3  | Citra       | c@gmail.com| Surabaya    |
+----+-------------+------------+-------------+

📌 CONTOH 1: Mengubah satu kolom
----------------------------------------------------
UPDATE pelanggan
SET kota = 'Yogyakarta'
WHERE id = 2;

✔️ Artinya: Baris dengan `id = 2` akan diubah kolom `kota`-nya 
dari 'Bandung' menjadi 'Yogyakarta'.

📌 CONTOH 2: Mengubah beberapa kolom sekaligus
----------------------------------------------------
UPDATE pelanggan
SET nama = 'Dewi', kota = 'Medan'
WHERE id = 3;

✔️ Artinya: Baris ke-3 akan diubah nama menjadi 'Dewi', dan kota menjadi 'Medan'.

📌 CONTOH 3: Update berdasarkan kondisi kolom lain
----------------------------------------------------
UPDATE pelanggan
SET kota = 'Bogor'
WHERE kota = 'Jakarta';

✔️ Artinya: Semua baris yang kotanya Jakarta akan diubah menjadi Bogor.

🔐 3. PENTINGNYA WHERE:
----------------------------------------------------
Tanpa WHERE, maka semua baris akan terkena update:

UPDATE pelanggan SET kota = 'Bali';

⚠️ Semua baris akan memiliki kota 'Bali', dan ini biasanya 
kesalahan fatal dalam sistem produksi.

--------------------------------------------
| IMPLEMENTASI UPDATE MENGGUNAKAN NODE.JS |
--------------------------------------------
Untuk menjalankan query UPDATE dari JavaScript (Node.js),
kita bisa pakai package `mysql2`.

1️⃣ Install dulu:
$ npm install mysql2

2️⃣ Contoh kode lengkap:
*/

import mysql from 'mysql2';

// Membuat koneksi ke database
const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',        // ganti sesuai konfigurasi kamu
  password: '',        // ganti sesuai konfigurasi kamu
  database: 'toko'     // pastikan database sudah ada
});

// Query UPDATE dengan parameter aman (prepared statement)
const sql = `UPDATE pelanggan SET kota = ? WHERE id = ?`;
const data = ['Semarang', 1];

connection.execute(sql, data, (err, results) => {
  if (err) {
    console.error("Gagal melakukan update:", err);
    return;
  }

  console.log("Jumlah baris yang diubah:", results.affectedRows);
});

/*
🧰 Keterangan:
- Tanda tanya (?) adalah placeholder untuk nilai yang akan diganti.
- `data` akan menggantikan `?` secara berurutan (Semarang => kota, 1 => id).
- Ini mencegah SQL Injection, karena input akan di-*escape* dengan aman.

✅ 4. CEK HASILNYA:
Setelah menjalankan query, kita bisa cek dengan:

SELECT * FROM pelanggan WHERE id = 1;

Akan terlihat bahwa `kota` pada pelanggan dengan `id = 1` telah berubah.

----------------------------------------
|  📌 RINGKASAN BEST PRACTICE UPDATE   |
----------------------------------------

✅ Gunakan WHERE untuk menghindari kesalahan massal
✅ Gunakan prepared statement untuk keamanan
✅ Periksa hasil melalui `affectedRows`
✅ Selalu backup sebelum update data sensitif

*/

