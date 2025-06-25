-- data biasanya disimpan dalam bentuk tabel di mysql
-- dan tiap tabel biasanya mentimpan satu jenis data, misalnya ketika kita membuat aplikasi toko online
-- kia akn membuat tabel barang, tabel pelanggan, tabel penjual, dan lain lain
-- dan sebeum kita memasukan data ke tabel kita wajibterlebih dahulu membuat tabelnya

-- dan tiap tiap tabel yg kita buat wajib ditentukan tipe datany asetiap kolmnya
-- dan kita juga ketika saudah terlanjur membuat tabel, dan kita ingin mnehapus, menyisipkan, dan menambhakan kolom itu bisa



-- didalam mysql terdapat berbagai cara unutk melakukan pengolahan data, hal ini disebut dnegan storage engines
-- dan yg popular itu adalah innodb (default)

-- dan untuk meliha ada apa saja storage engines yg ada di mysql, ita bisa mengunakan perintah
show ENGINES; 
-- jalankan saja


-- adi kalo misalakan kamu bikin tabel lalu lupa untuk menyertakan eginesnya apa, maka defaultnya itu adalah innodb




-- melihat isi dari table
-- caranya adalah use dulu databsenya lalu baru show

show databases;
use toko_online;
show tables; -- masih kosong




-- 2. cara membuat tabel
-- jadi nama headernya diikuti dnegn tipe datanya
create table barang (
	kode int,
	nama varchar(100),
	harga int,
	jumlah int
) engine = innodb;

show tables; -- keluar abel barang

-- nah kalo mau lihat detailnya itu kita bisa pake
describe barang;
-- atau 
desc barang;

-- atau kalo mau lihat struktur tabel / pembuatannya pake 
show create table barang;
 

-- 3. cara mengubah table
-- menggunakan alter 

-- contoh

-- alter table barang
-- 	add column nama_column text ,
-- 	drop column nama,
-- 	rename column nama to nama_baru,
-- 	modify nama varchar(100) after jumlah,
-- 	modify nama varchar(100) first;


show tables;
-- 1. 
alter table barang 
	add column deskripsi text; 
-- jadi maksudnya adlaah menambah column deskripsi dipaling akhir
-- 2.
alter table barang 
	add column salah int;
-- 3
alter table barang 
	drop column salah;
-- kalo drop column ga perlu kita kasih tau tipedataya, nanti gagal


-- 4
alter table barang 
	modify column deskripsi text after nama;
-- jadi kita memodifikasi column deskripsi (tipedata), kita tampatkan setelah column nama


-- 5
alter table barang
	rename column deskripsi to descripsi;

-- 6
alter table barang
	rename column descripsi to deskripsi;

-- 7 memodifikasi tipe data
alter table barang
	modify nama varchar(200);

-- | --
describe barang;



-- contoh lainnya



-- 1. Membuat tabel dasar untuk latihan
DROP TABLE IF EXISTS siswa;
CREATE TABLE siswa (
  id INT,
  nama VARCHAR(100),
  email VARCHAR(100)
);

-- ===========================================
-- 2. ADD – Menambahkan kolom
-- ===========================================
ALTER TABLE siswa ADD umur INT;  -- Menambahkan kolom umur

-- ===========================================
-- 3. DROP – Menghapus kolom
-- ===========================================
ALTER TABLE siswa DROP COLUMN umur;  -- Menghapus kolom umur

-- ===========================================
-- 4. MODIFY – Mengubah tipe data kolom
-- ===========================================
ALTER TABLE siswa MODIFY nama VARCHAR(200);  -- Mengubah panjang kolom nama

-- ===========================================
-- 5. CHANGE – Ganti nama dan tipe kolom
-- ===========================================
ALTER TABLE siswa CHANGE nama nama_lengkap VARCHAR(200);  -- Ubah nama kolom dan panjangnya

-- ===========================================
-- 6. RENAME TO – Ganti nama tabel
-- ===========================================
ALTER TABLE siswa RENAME TO murid;  -- Ganti nama tabel dari siswa ke murid

-- Kembalikan nama tabel agar contoh selanjutnya tetap jalan
ALTER TABLE murid RENAME TO siswa;

-- ===========================================
-- 7. RENAME COLUMN – Ganti nama kolom (MySQL 8+)
-- ===========================================
ALTER TABLE siswa RENAME COLUMN nama_lengkap TO nama;  -- Kembalikan nama kolom

-- ===========================================
-- 8. ADD CONSTRAINT – Tambah foreign key atau unique
-- (Harus punya tabel referensi)
DROP TABLE IF EXISTS kelas;
CREATE TABLE kelas (
  id INT PRIMARY KEY,
  nama_kelas VARCHAR(50)
);

ALTER TABLE siswa ADD COLUMN id_kelas INT;  -- Tambah kolom relasi
ALTER TABLE siswa ADD CONSTRAINT fk_kelas FOREIGN KEY (id_kelas) REFERENCES kelas(id);

-- ===========================================
-- 9. DROP CONSTRAINT – Hapus constraint (MySQL 8+)
-- (Hanya bisa jika constraint foreign key dinamai)
ALTER TABLE siswa DROP FOREIGN KEY fk_kelas;

-- ===========================================
-- 10. ADD INDEX / DROP INDEX
-- ===========================================
ALTER TABLE siswa ADD INDEX idx_nama(nama);  -- Tambah index ke kolom nama
ALTER TABLE siswa DROP INDEX idx_nama;       -- Hapus index

-- ===========================================
-- 11. ADD UNIQUE – Kolom harus unik
-- ===========================================
ALTER TABLE siswa ADD UNIQUE (email);

-- ===========================================
-- 12. ADD PRIMARY KEY – Tambah primary key
-- ===========================================
ALTER TABLE siswa DROP PRIMARY KEY;  -- Pastikan tidak ada PK sebelumnya
ALTER TABLE siswa ADD PRIMARY KEY (id);  -- Jadikan kolom id sebagai primary key

-- ===========================================
-- 13. AUTO_INCREMENT – Tambah auto increment
-- ===========================================
ALTER TABLE siswa MODIFY id INT AUTO_INCREMENT;

-- ===========================================
-- 14. SET DEFAULT – Set nilai default (MySQL 8+)
-- ===========================================
ALTER TABLE siswa ALTER nama SET DEFAULT 'Anonim';

-- ===========================================
-- 15. DROP DEFAULT – Hapus default value
-- ===========================================
ALTER TABLE siswa ALTER nama DROP DEFAULT;

-- ===========================================
-- 16. ENGINE – Ubah storage engine tabel
-- ===========================================
ALTER TABLE siswa ENGINE = InnoDB;

-- ===========================================
-- 17. CHARACTER SET / COLLATE – Ubah charset
-- ===========================================
ALTER TABLE siswa CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- ===========================================
-- 18. FIRST / AFTER – Atur posisi kolom
-- ===========================================
ALTER TABLE siswa ADD alamat VARCHAR(100) AFTER nama;

-- ===========================================
-- 19. DISABLE KEYS / ENABLE KEYS – (MyISAM only)
-- Untuk bulk insert (tidak berlaku untuk InnoDB)
-- ALTER TABLE siswa DISABLE KEYS;
-- ALTER TABLE siswa ENABLE KEYS;

-- ===========================================
-- 20. ALGORITHM – Tentukan algoritma pengubahan
-- ===========================================
ALTER TABLE siswa ALGORITHM = INPLACE, ADD jenis_kelamin VARCHAR(10);

-- ===========================================
-- 21. LOCK – Atur level penguncian saat ALTER
-- ===========================================
ALTER TABLE siswa LOCK = NONE;



