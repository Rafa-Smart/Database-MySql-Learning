


https://dev.mysql.com/doc/refman/8.4/en/fulltext-query-expansion.html


-- jadi ketika dicari suatu data, nah berdasarka pencarian data pertama itu
-- akan dicari data yg sering muncul pada pencarian dat pertama
-- dan yg dicariya tu otomatis oleh si innodbnya

SELECT * FROM artikel
WHERE MATCH(judul, isi)
AGAINST('programming' WITH QUERY EXPANSION);

SELECT * FROM artikel
WHERE match(judul, isi)
against('programming' IN NATURAL LANGUAGE mode);


select * FROM artikel
WHERE match(judul, isi)
against('+programming' IN boolean mode); 


SELECT * FROM artikel
WHERE judul LIKE '%programming%' OR isi LIKE '%programming%'; 



*
 * 🔍 APA ITU FULL-TEXT SEARCH DENGAN QUERY EXPANSION MODE?
 * ----------------------------------------------------------------------------
 * Mode pencarian full-text di MySQL yang mencoba memberikan hasil **lebih relevan**
 * dengan cara menambahkan **kata-kata yang sering muncul dalam hasil awal** ke dalam
 * query pencarian kamu.
 *
 * Ini seperti pencarian **"lebih pintar"** karena tidak hanya mencari kata yang kamu
 * input, tetapi juga **memperluas** pencarian berdasarkan konteks dari data.
 *
 * ✅ Cocok untuk: Pencarian artikel, blog, katalog, knowledge base, dll.
 *
 *
 * 🧠 BAGAIMANA CARA KERJANYA?
 * ----------------------------------------------------------------------------
 * Query Expansion dilakukan dalam 2 tahap:
 *
 * 1. **Tahap Pertama**: MySQL mencari data berdasarkan query asli kamu,
 *    lalu mengambil 20 hasil teratas (default).
 *
 * 2. **Tahap Kedua**: MySQL **menelusuri kata-kata paling sering muncul**
 *    dari hasil tahap pertama tadi.
 *
 * 3. **Final Result**: MySQL melakukan pencarian ulang (refined search)
 *    dengan query awal kamu + kata-kata tambahan dari hasil awal.
 *
 * ➕ Hasil akhir bisa berbeda dari query awal karena ada **ekspansi makna**.
 *
 *
 * 🔧 SINTAKS DASAR:
 * ----------------------------------------------------------------------------
 * MATCH(kolom1, kolom2, ...)
 * AGAINST('kata_kunci' WITH QUERY EXPANSION)
 *
 * ⚠️ Wajib pakai FULLTEXT INDEX.
 *
 *
 * ✅ CONTOH PRAKTIS
 * ----------------------------------------------------------------------------
 *
 * // Buat index
 * ALTER TABLE artikel ADD FULLTEXT(judul, isi);use toko_online;

 * // Query dengan query expansion
 * SELECT * FROM artikel
 * WHERE MATCH(judul, isi)
 * AGAINST('programming' WITH QUERY EXPANSION);
 *
 * ➕ Jika kata "programming" awalnya cocok ke 20 hasil pertama,
 *    dan dalam hasil itu kata "python" dan "javascript" sering muncul,
 *    maka pencarian akan diperluas ke "programming", "python", "javascript".
 *
 *
 * 🎯 APA TUJUANNYA?
 * ----------------------------------------------------------------------------
 * - Membantu menemukan hasil relevan meskipun user tidak menulis kata kunci lengkap.
 * - Memberikan hasil lebih **kontekstual dan lebih luas** dari pencarian biasa.
 *
 *
 * ⚙️ PERILAKU TEKNIS:
 * ----------------------------------------------------------------------------
 * - Mode ini masih termasuk dalam **NATURAL LANGUAGE MODE**, tapi ditambahkan proses ekspansi.
 * - Menggunakan **TF-IDF** dan statistik frekuensi kata dari hasil tahap awal.
 * - Kata-kata baru ditambahkan **otomatis** ke dalam query.
 * - Tidak ada kontrol manual (tidak seperti BOOLEAN MODE).
 *
 *
 * ✅ PERBEDAAN MODE FULLTEXT SEARCH DI MYSQL
 * ----------------------------------------------------------------------------
 *
 * | Mode                   | Kontrol  | Relevansi | Ekspansi Kata | Dukungan Wildcard |
 * |------------------------|----------|-----------|----------------|--------------------|
 * | NATURAL LANGUAGE       | ❌ Rendah | ✅ Ya     | ❌ Tidak       | ❌ Tidak           |
 * | BOOLEAN MODE           | ✅ Tinggi | ❌ Tidak  | ❌ Tidak       | ✅ Ya (*)          |
 * | QUERY EXPANSION MODE   | ❌ Otomatis | ✅ Ya   | ✅ Ya         | ❌ Tidak           |
 *
 *
 * 🟢 KELEBIHAN QUERY EXPANSION MODE
 * ----------------------------------------------------------------------------
 * ✅ Hasil lebih luas dan kontekstual
 * ✅ Bisa "menebak" maksud user yang mengetik sedikit
 * ✅ Tidak perlu menulis banyak kata
 * ✅ Cocok untuk sistem pencarian artikel, dokumen
 *
 *
 * 🔴 KEKURANGAN
 * ----------------------------------------------------------------------------
 * ❌ Tidak ada kontrol manual atas kata ekspansi
 * ❌ Kadang hasil terlalu melebar (kurang spesifik)
 * ❌ Lebih lambat karena 2x proses pencarian
 *
 *
 * ✅ LATIHAN QUERY LANJUTAN
 * ----------------------------------------------------------------------------
 *
 * // Tanpa query expansion
 * SELECT * FROM artikel
 * WHERE MATCH(judul, isi)
 * AGAINST('database' IN NATURAL LANGUAGE MODE);
 *
 * // Dengan query expansion
 * SELECT * FROM artikel
 * WHERE MATCH(judul, isi)
 * AGAINST('database' WITH QUERY EXPANSION);
 *
 * // Coba juga kata kunci umum seperti "programming"
 * SELECT * FROM artikel
 * WHERE MATCH(judul, isi)
 * AGAINST('programming' WITH QUERY EXPANSION);
 *
 *
 * 📦 CONTOH KASUS PENGGUNAAN NYATA
 * ----------------------------------------------------------------------------
 * ✅ Cocok digunakan untuk:
 *    - Sistem pencarian artikel
 *    - Knowledge base (dokumentasi teknis)
 *    - Produk dengan deskripsi panjang
 *    - Sistem rekomendasi mirip pencarian
 *
 *
 * 🧠 TIPS PENGGUNAAN
 * ----------------------------------------------------------------------------
 * - Gunakan saat user tidak tahu persis apa yang ingin mereka cari.
 * - Uji coba query berbeda untuk melihat ekspansi mana yang muncul.
 * - Pastikan data cukup besar agar proses ekspansi masuk akal.
 *
 *
 * ✨ PENUTUP
 * ----------------------------------------------------------------------------
 * QUERY EXPANSION MODE adalah fitur powerful dari MySQL Full-Text Search.
 * Ia bekerja dengan memperluas pencarian berdasarkan hasil awal yang ditemukan,
 * lalu mencarikan hasil relevan yang lebih luas.
 *
 * Fitur ini cocok untuk sistem pencarian berbasis teks di mana pengguna
 * sering mengetik kata kunci yang tidak lengkap atau tidak spesifik.
 *
 * ⚠️ Harus digunakan dengan bijak karena bisa menghasilkan noise jika
 * datanya kecil atau tidak konsisten.
 *
 */






