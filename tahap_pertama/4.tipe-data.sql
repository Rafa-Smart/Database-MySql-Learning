-- tipe data yg ada di mysql
-- jadi kita bisa menentukan tipe data apa saja yag inign kitamasukan disetiap kolomnya
-- pda sebuah tabel
-- nah tapi dengan catatan, misal di satu kolom itu tipe datanya adalah int, maka seluruh nya dari atas sampai
-- bawah itu harus int, gableh tiba tiba ada yg string atau yg lain

-- jaid kamu harus menentukan tipe data di setiap kolom, misal kolom id tipedatanya apa, dll

-- misal

-- id (number) | nama (text) | harga (number)
-- 1				apel			5000
-- 2				jeruk			7000
-- 3				semangka		8000

-- https://chatgpt.com/c/685a578f-24dc-8009-b827-be75ef0c185e#2
-- jdai tidak bisa tiba tiba di kolom id, ada yg tipedatanya adlah string




-- 1. tipe data number 

ada 2 tipe data number di mysql yaitu integer(bulat) dan float(pecahan)

tipe data integer

-- jadi yg asalnya signed(bisa negeatif), menjadi unsigned(non negatis caranya adlaah

jdi minimum unsigned(non negatif) itu pasti 0
dan untuk yg maxsimumnya itu dari signed min ditambah dnegna signed max 
contoh tinyint berapa max unsignednya ?
min signed + max signed
berati -128 -> 128 + 127 -> 255

jadi begitu setrusnya


Tipe			Ukuran			Nilai									Keterangan
TINYINT			1 byte			-128 s/d 127 / 0 s/d 255 (UNSIGNED)		Bilangan sangat kecil
SMALLINT		2 byte			-32.768 s/d 32.767						Umumnya untuk status ID
MEDIUMINT		3 byte			-8 juta s/d 8 juta						Jarang dipakai
INT / INTEGER	4 byte			±2,1 milyar								Paling umum
BIGINT			8 byte			±9 triliun								Untuk data besar seperti uang


jadi memori penympanannya adalah ini :
1 byte itu adalah 4 bit
dan 1 bit itu adlaah angka 0 atau 1
tinyint berati itu bitnya ada 4 



2. flaoting point (pecahan)

Tipe Data		Ukuran			Rentang Nilai (perkiraan)				Presisi	Keterangan / Kegunaan
FLOAT(M,D)		4 byte			~ ±3.402823466E+38	±7 					digit signifikan	Untuk angka desimal presisi menengah
DOUBLE(M,D)		8 byte			~ ±1.7976931348623157E+308	±15-16 		digit	Untuk angka desimal presisi tinggi
DECIMAL(M,D)	Bervariasi		Berdasarkan M dan D (misal: DECIMAL(5,2) = 999.99)	Presisi tetap	Untuk keuangan (tanpa error pembulatan)


Keterangan Kolom:
M = Jumlah digit maksimal (total digit)
D = Jumlah digit di belakang koma
FLOAT dan DOUBLE memakai presisi floating-point (berisiko error pembulatan kecil)
DECIMAL menyimpan sebagai string → akurat, cocok untuk transaksi keuangan


jadi misal decimal(7,3);
berati akan disiapkan tempat 7 angka, dengan 3 angka dibelakang koma


-- jadi kesimpulannya kalo mau presisi, gunakan saja decimal, meskipun sama sama bis pake presisi (m,d)

-- misal decimal(5,0) => -88888(min), 88888(max)
-- misal decimal(5,4) => -8.8888(min), 8.8888(max)
-- misal decimal(5) => -88888(min), 88888(max)


-- 3 atribut tambahan pada number

--TYPE(N)-- :
maksudnya adlah type disini adalah yg sudah kita jelaskan sebelumnya misal float, int, tinyint, dllalter 
dan n ini maksudnya adlaah panjang angkanya

misal int(3) artiny adalah tipe data ini maksimum panjangnya adalah 3, bisa 999,799,896,212, dllalter 

--zerofill :
jadi maksudnya adalah gini misal
int(5) zerofill artinya adalah jika ada user yg inputannya hanya 3 angka maka sisanya akan diisi oleh 0

jadi int(5) zerofill dan diisi oleh user hanya 56 maka -> 00056
jika user isi 9 maka 00009, dan seterusnya




-- 4. tipe data string:

ada 2 yaitu char dan varchar (Fixed & Variable Length)
-- jadi kita bisa mengatur jumlah panjang maksimal karakter yg bisa ditampung oleh si char dan varchar ini
-- dengan menggunakan (panjang-kisaran); 
-- misal char(10) dan varchar(10) maka tipedatanya stirng dan maksimal karakternya adalah 10 karakter
-- dan ukuran maksimum karakter char dan varchar adalah 65535


nah lalu apa bedanya char dna varchar ini ?

bedanya adlah :

value   |    char(4)  |  storage   | varchar  |   storage    |
''			'    '		  4bytes		'' 			1byte
'ab'		'ab  '		  4bytes		'ab' 		3byte
'abc'		'abc '		  4bytes		'abc' 		5byte
'abcd'		'abcd'		  4bytes		'abcd' 		5byte

-- jadi var char itu akan menyesuaikan dengan inputan aslinya, jika kita sudah menentukan varchar(4);
-- tapi ternyata datanya hanya 3 karakter, maka storagenya juga menyesuaikan
-- tapi dia juga membutuhkan 1 bytes informasi lihat ditabel meski hanya 4 karakter, tapi dia mmebutuhkan 5bytes
-- 1 bytesnya itu untuk informasi


-- tapi kalo char itu dia tidak peduli apakah inputannya sama seperti yg sudah ditentukan atau tidak
-- yg penting jika char(4), maka akn dipukul rata, seluruh data yg masuk itu stroragenya 4 bytes



-- nah berbeda dnegan dengna yg sebelumnya kalo ini sudah memiliki panjang maksimumnya

(Teks Panjang)
Tipe			Panjang Maksimal	Cocok Untuk
TINYTEXT		255 byte			Catatan pendek
TEXT			64 KB				Deskripsi panjang
MEDIUMTEXT		16 MB				Artikel
LONGTEXT		4 GB				Dokumen besar




5.enum adalah  tipe data yg sudah ditentukan pilihan pilihannya
misal enum('pria','wanita')
maka kita hanya boleh memilih diantara 2 data itu saja, kalo engga nanti bakal di tolak

dan selain itu ada juga set
dn kalo set itu jug bisa tapi lebih banyak pilihannya
set('membaca', 'menulis', 'berenang', 'memasak')






6. tipe data tanggal



| Tipe       | Format                  | Keterangan                              |
|------------|-------------------------|------------------------------------------|
| DATE       | 'YYYY-MM-DD'            | Menyimpan tanggal saja (tanpa waktu)     |
| DATETIME   | 'YYYY-MM-DD HH:MM:SS'   | Menyimpan tanggal + waktu                |
| TIMESTAMP  | UNIX Timestamp (UTC)    | Cocok untuk pencatatan waktu otomatis    | --> sama kayak datetime, dan ada informasi tertentu
| TIME       | 'HH:MM:SS'              | Menyimpan waktu (tanpa tanggal)          |
| YEAR       | 'YYYY'                  | Menyimpan tahun (antara 1901 - 2155)     |



CREATE TABLE log_aktivitas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  waktu_login TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  waktu_logout DATETIME,
  durasi TIME,
  tahun_bergabung YEAR
);

==============================
 CATATAN PENTING
==============================
- TIMESTAMP otomatis di-set ke UTC dan bisa auto-update.
- DATETIME cocok untuk menyimpan zona waktu lokal (manual).
- YEAR hanya untuk tahun, sangat efisien dalam penyimpanan.
- TIME cocok untuk durasi atau jam tertentu (tanpa tanggal).

*/

7. tibe data boolean yaitu true dan false incasesesitive


==============================
 TIPE DATA LAINNYA DI MYSQL
==============================

========
 BLOB (Binary Large Object)
========
Digunakan untuk menyimpan data **biner besar**, seperti:
- Gambar
- PDF
- File audio/video

| Tipe        | Ukuran Maksimal   | Keterangan                   |
|-------------|-------------------|------------------------------|
| TINYBLOB    | 255 byte          | Ukuran sangat kecil          |
| BLOB        | 64 KB             | Default blob                 |
| MEDIUMBLOB  | 16 MB             | Cukup besar untuk video kecil|
| LONGBLOB    | 4 GB              | Untuk file besar (arsip, dll)|

 Contoh:
CREATE TABLE dokumen (
  id INT,
  nama_file VARCHAR(255),
  file_data LONGBLOB
);

========
 SPATIAL DATA TYPES (GEOMETRIK)
========
Digunakan untuk menyimpan data spasial/GIS (geografi):
- Titik lokasi
- Garis jalan
- Area wilayah

| Tipe             | Deskripsi                              |
|------------------|----------------------------------------|
| GEOMETRY         | Tipe dasar spasial                     |
| POINT            | Titik tunggal (x, y)                   |
| LINESTRING       | Garis yang terdiri dari banyak titik   |
| POLYGON          | Area tertutup (misal: batas wilayah)   |
| MULTIPOINT       | Beberapa titik                         |
| MULTILINESTRING  | Beberapa garis                         |
| MULTIPOLYGON     | Beberapa area                          |
| GEOMETRYCOLLECTION | Kumpulan berbagai geometri           |

 Contoh:
CREATE TABLE lokasi (
  id INT,
  nama VARCHAR(100),
  koordinat POINT
);

 Notes:
- SPATIAL INDEX hanya didukung di `InnoDB` (MySQL 5.7+)
- Cocok untuk aplikasi peta, logistik, pengiriman

========
 JSON
========
Tipe data untuk menyimpan objek JSON secara native:
- Bisa menyimpan struktur array, objek, dll.
- Validasi otomatis (harus JSON valid)

 Contoh:
CREATE TABLE user_setting (
  id INT,
  preferensi JSON
);

🧪 Query JSON:
SELECT preferensi->'$.tema' FROM user_setting;

 Fungsi JSON di MySQL:
- `JSON_EXTRACT()`
- `JSON_SET()`
- `JSON_ARRAY()`
- `JSON_OBJECT()`

 Gunakan JSON saat data tidak kaku/berstruktur fleksibel, tapi hindari untuk data relasional utama.

========
 ENUM dan SET
========

1. ENUM = Pilihan tunggal dari beberapa nilai
   Cocok untuk status, jenis kelamin, dll.

 Contoh:
CREATE TABLE karyawan (
  nama VARCHAR(100),
  gender ENUM('pria', 'wanita')
);

2. SET = Bisa memilih **lebih dari satu** nilai sekaligus
   Cocok untuk hobi, skill, preferensi ganda

 Contoh:
CREATE TABLE user_hobi (
  nama VARCHAR(100),
  hobi SET('menulis', 'membaca', 'berenang', 'main game')
);

 Kelebihan:
- Validasi otomatis oleh MySQL
- Hemat penyimpanan

==================================================
 Gunakan tipe-tipe ini jika:
==================================================
- Perlu simpan file/gambar → Gunakan BLOB
- Perlu simpan lokasi → Gunakan POINT, SPATIAL
- Data fleksibel & berubah-ubah → Gunakan JSON
- Nilai pilihan terbatas → ENUM / SET




==========================
TABEL KONVERSI DATA DIGITAL
==========================

Konversi Umum:
---------------------------------------------------------
| Dari ↓ / Ke → | Bit       | Byte     | KB        | MB        | GB        | TB        |
|---------------|-----------|----------|-----------|-----------|-----------|-----------|
| 1 Byte        | 8 b       | 1 B      | 0.00098   | ~0.000001 | ~0.000000001 | ~0.000000000001 |
| 1 KB          | 8,192 b   | 1,024 B  | 1 KB      | ~0.00098  | ~0.00000098  | ~0.00000000098  |
| 1 MB          | 8,388,608 b | 1,048,576 B | 1,024 KB | 1 MB      | ~0.00098     | ~0.00000098     |
| 1 GB          | 8,589,934,592 b | 1,073,741,824 B | 1,048,576 KB | 1,024 MB | 1 GB      | ~0.00098     |
| 1 TB          | 8,796,093,022,208 b | 1,099,511,627,776 B | 1,073,741,824 KB | 1,048,576 MB | 1,024 GB | 1 TB |

Catatan:
- 1 Byte = 8 Bit
- 1 KB = 1024 Bytes
- 1 MB = 1024 KB
- 1 GB = 1024 MB
- 1 TB = 1024 GB

==========================
 RUMUS KONVERSI UMUM
==========================

Bit → Byte:
    byte = bit / 8

Byte → KB:
    KB = byte / 1024

Byte → MB:
    MB = byte / (1024 * 1024)

MB → Byte:
    byte = MB * 1024 * 1024

GB → MB:
    MB = GB * 1024

TB → GB:
    GB = TB * 1024

==========================
 Tips:
==========================
- Bit = digunakan untuk satuan kecepatan jaringan (misalnya 100 Mbps)
- Byte = digunakan untuk ukuran file (misalnya 20 MB file video)
- MBps = MegaByte per second (lebih cepat dari Mbps)





