# TASBIH+

**TASBIH+** adalah aplikasi mobile yang menyediakan alat dzikir digital dan kumpulan doa harian dengan tampilan sederhana, nyaman, dan mudah digunakan. Aplikasi ini ditujukan untuk membantu pengguna berdzikir dan membaca doa secara terstruktur sekaligus menyimpan riwayat ibadah yang telah dilakukan. Aplikasi ini juga terintegrasi dengan Firebase Authentication dan Cloud Firestore sehingga mendukung login multiuser.


---

## 👤 Identitas
| Keterangan | Isi |
|-----------|-----|
| Nama      | Alya Maysa S |
| NIM       | 230605110007 |
| Kelas Praktikum    | Praktikum Pemrograman Mobile (E) |
| Kelas Teori | Pemrograman Mobile (B) |

---

## Tujuan Aplikasi
- Menyediakan tasbih digital sebagai pendamping dzikir kapan saja.
- Menyediakan daftar doa harian dengan UI sederhana dan ramah pengguna.
- Mendukung tampilan Light Mode dan Dark Mode.
- Menyediakan akses multiuser melalui fitur Login & Register.
- Menyimpan riwayat terakhir dzikir (Last Count) dan doa terakhir yang dibaca (Last Read).

---

## Fitur Utama

### **1. Login & Register**
- Menggunakan **Firebase Authentication**
- Menyimpan nama user ke **Firestore & SharedPreferences**

### **2. Home Page**
Menampilkan:
- Salam dan nama user
- Last Read Doa (judul & ID)
- Last Tasbih Count dalam bentuk circular progress
- Islamic Quotes dari API 
  `https://islamic-quotes-api.vercel.app/api/quotes`

### **3. Daftar Doa**
- Mengambil data doa dari API  
  `https://open-api.my.id/api/doa`
- Tersedia daftar lengkap judul doa

### **4. Halaman Detail Doa**
- Menampilkan Arab, Latin, dan arti
- Menyimpan:
  - `last_read_id`
  - `last_read_judul`
- Bisa disimpan ke *koleksi* (bookmark)

### **5. Tasbih Digital**
- Counter dengan efek circular glow
- Menggunakan SharedPreferences dan Firebase
- Menyimpan riwayat terakhir tasbih

### **6. Koleksi Doa (Bookmark)**
- CRUD lokal menggunakan SharedPreferences
- Menambah doa ke koleksi tertentu

### **7. Settings Page**
- Mengubah tema (light / dark mode)
- Ganti nama user
- Logout

### **8. Bottom Navigation**
Navigasi cepat ke:
- Home
- Daftar Doa
- Tasbih
- Favorite/Bookmark
- Settings

---

## Teknologi yang Digunakan

| Teknologi | Fungsi |
|----------|--------|
| **Flutter** | Frontend UI aplikasi |
| **Dart** | Bahasa pemrograman utama |
| **Firebase Auth** | Login & Register |
| **Cloud Firestore** | Menyimpan data user |
| **SharedPreferences** | Last Read, Last Tasbih, Username |
| **HTTP Package** | Mengambil data API |
| **Google Fonts** | Tampilan teks lebih estetik |
| **Theme Manager** | Light & Dark Mode |

---

## Cara Menjalankan Aplikasi

### 1. Clone repository

### 2. Install Dependencies
    flutter pub get

### 3. Tambahkan File Konfigurasi Firebase
    android/app/google-services.json

### 4. Jalankan Aplikasi
    flutter run

---

## Penyimpanan Data

### 1. Local Storage (Shared Preferences)
### 2. Cloud Storage (Firestore)



