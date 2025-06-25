-- database adalah tempat kita untuk menyimpan table di mysql
-- jika dimisalkan table adalah file, maka databse adalah foldernya
-- yg bsia menyimpan banyak table dalam satu databse

-- dan biasanya dalam satu jenis aplikasi itu hanya terdapat satu database
-- misl aplikasi toko online, mka ada satu databsee namaya tokoOnline
-- dan di database tokoOnline ini mempunyai tabel barang, pelanggan, penjualan, dll
-- jadi sebelum kita membuat sebuah table, ita perlu membuat databasenya terlebih dahulu

-- server mysql -> 1 conection --> database xxx dan ada database yyy

-- databse xxx -> tabel a, tabel b, tabel c
-- databse yyy -> tabel a, tabel b, tabel c


-- cara melihat database apa saja yg ada di server mysqlnya
-- kita bis amneggunakan perintah 
-- SHOW DATABASES

-- dan biasanya penulisan syntax itu besar semua, kecuali yg kita buat (nama databse, tabel, dll)
-- dan setiap akhir penulisan dari statement atau perintah harus diakhiri dengna ;


-- dan untuk runningnya tinggal blok (jika multi baris), atau taurh cursor di baris yg inign dieksekusi(jika sebaris)
-- lalu klik ctrl enter

SHOW DATABASES;

-- ini adalah data data dari databse bawaan atau default nya dari mysql

-- mysql --> dari mysql
-- performance_schema --> dari mysql
-- sakila --> dari dbevier
-- sys --> dari mysql
-- world --> dari dbevier

-- dan cara eksekusi progamnya ini unik, jadi ga dari atas kebawah, dan dari dari kiri kekanan (kalo engga di klik excute sql script)
-- (untuk mengeksekusi satu file)

-- tpai kita juga bisa mengekseusi bagian bagian tertentu saja dnegan cara yg ctrl enter


-- misalkan kamu sudah pernah menjalankan 1 file yg ada perintah untuk create database, nah kalo kamu jalankan lagi 1 file itu
-- langusng, maka akn error, karena databse pernah dibuat, makanya kita bisa hanya mengeksekusi perintah tertentu sja
-- jadi ga semua langsung











