# 🌤️ Responsi Pemrograman Mobile - Aplikasi Prakiraan Cuaca Flutter (Open-Meteo)

Nama  : Talitha Maharani Nashier
NIM  : H1D024098
Shift Awal  : H
Shift Akhir  : D

Proyek ini dibangun untuk memenuhi tugas **Responsi Praktikum Pemrograman Mobile**. Aplikasi prakiraan cuaca ini dikembangkan menggunakan framework **Flutter** dan bahasa pemrograman **Dart** dengan menerapkan pola arsitektur **Model-View-ViewModel (MVVM)**, integrasi **REST API Open-Meteo**, penyimpanan lokal (**SharedPreferences**), serta desain antarmuka berbasis **Material Design 3**.

---

## 📋 Daftar Isi
1. [Fitur Aplikasi](#-fitur-aplikasi)
2. [Tampilan Antarmuka (Screenshots)](#-tampilan-antarmuka-screenshots)
3. [Arsitektur Aplikasi (MVVM)](#-arsitektur-aplikasi-mvvm)
4. [Struktur Direktori Proyek](#-struktur-direktori-proyek)
5. [Implementasi REST API Open-Meteo](#-implementasi-rest-api-open-meteo)
6. [Penyimpanan Lokal (Local Storage)](#-penyimpanan-lokal-local-storage)
7. [Panduan Menjalankan Aplikasi](#-panduan-menjalankan-aplikasi)
8. [Panduan Perekaman Video Penjelasan Kode](#-panduan-perekaman-video-penjelasan-kode)
9. [Informasi Pengumpulan](#-informasi-pengumpulan)

---

## ✨ Fitur Aplikasi

### 1. Layar Utama (Home / Weather Screen)
- **Nama Kota Terpilih**: Menampilkan nama kota, provinsi/administrasi, dan negara secara dinamis.
- **Kondisi Cuaca Terkini**: Menampilkan status cuaca berbahasa Indonesia (misal: *Cerah*, *Berawan Sebagian*, *Gerimis Ringan*, *Hujan Lebat*, dsb.) lengkap dengan ikon representatif dan latar belakang gradasi dinamis.
- **Suhu Saat Ini**: Menampilkan suhu aktual dalam satuan derajat Celsius (°C) (`current.temperature_2m`).
- **Informasi Cuaca Tambahan**:
  - 💧 **Kelembapan Relatif**: `current.relative_humidity_2m` (%)
  - 💨 **Kecepatan Angin**: `current.wind_speed_10m` (km/h)
  - ☂️ **Peluang Hujan Maksimum**: `daily.precipitation_probability_max` (%)
  - 🌡️ **Suhu yang Dirasakan (Apparent Temp)**: `current.apparent_temperature` (°C)
  - 🌧️ **Curah Hujan**: `current.precipitation` (mm)
  - ☀️ **Kode Kondisi Cuaca**: `current.weather_code` (WMO Standard)
- **Perkiraan Cuaca Harian**:
  - Prakiraan cuaca hingga 7 hari ke depan.
  - Menampilkan suhu maksimum (`daily.temperature_2m_max`), suhu minimum (`daily.temperature_2m_min`), kemungkinan hujan, dan ikon cuaca untuk setiap hari.
- **Pull-to-Refresh**: Pengguna dapat menarik layar ke bawah untuk memperbarui data cuaca langsung dari API.

### 2. Layar Pencarian & Lokasi (Search / Location Screen)
- **Pencarian Kota Real-Time**: Input pencarian terhubung langsung ke **Open-Meteo Geocoding API** dengan mekanisme *debounce* (500ms) agar efisien dalam melakukan request jaringan.
- **Daftar Hasil Pencarian**: Menampilkan nama kota, wilayah/provinsi, negara, dan koordinat lintang-bujur (*latitude & longitude*).
- **Pemilihan Lokasi**: Memilih salah satu kota pada daftar akan langsung memperbarui data cuaca pada layar utama dan menyimpannya sebagai lokasi terakhir.
- **Simpan Lokasi Favorit**: Pengguna dapat menandai kota sebagai favorit dengan menekan ikon bintang (★).
- **Riwayat Pencarian**: Menampilkan daftar kota yang pernah dicari dengan opsi hapus riwayat.

### 3. Layar Favorit (Favorites Screen)
- Menampilkan daftar semua kota favorit yang tersimpan di penyimpanan lokal.
- Mendukung fitur *Swipe-to-Dismiss* untuk menghapus kota dari daftar favorit.
- Klik pada salah satu kota favorit untuk langsung beralih melihat kondisi cuacanya di layar utama.

---

## 📱 Tampilan Antarmuka (Screenshots)

| 1. Home Screen (Cuaca Terkini) | 2. Home Screen (Informasi Tambahan) | 3. Home Screen (Prakiraan Cuaca 7 Hari Kedepan) |
|:---:|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/d23c8f83-bed0-41f9-a7fe-d21ca6b8fe43" width="250" alt="Home Screen Cuaca Terkini" /> | <img src="https://github.com/user-attachments/assets/5c41f576-fc98-45f5-9876-8690a56a4bde" width="250" alt="Home Screen Informasi Tambahan" /> | <img src="https://github.com/user-attachments/assets/22ca6172-fe1f-4055-8372-76b4ee2568dd" width="250" alt="Home Screen Prakiraan Harian" /> |

| 4. Search Screen (Pencarian API) | 5. Favorites Screen (Kota Favorit) | 6. Search Screen (Riwayat Pencarian) |
|:---:|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/21f812a8-57bb-4259-bb56-ef864cafcd73" width="250" alt="Search Screen" /> | <img src="https://github.com/user-attachments/assets/ed5027ee-6347-42bb-aef1-b64103fe4931" width="250" alt="Favorites Screen" /> | <img src="https://github.com/user-attachments/assets/b98bef38-7a81-4bfb-b510-47e5fa6cc9eb" width="250" alt="Riwayat Pencarian" /> |
---

## 🏛️ Arsitektur Aplikasi (MVVM)

Aplikasi ini menggunakan pola arsitektur **Model-View-ViewModel (MVVM)** dengan pemisahan tanggung jawab yang jelas:

```
┌─────────────────────────────────────────────────────────────┐
│                           VIEW                              │
│   (HomeScreen, SearchScreen, FavoritesScreen, Widgets)      │
│   - Bertanggung jawab murni pada tampilan antarmuka (UI).    │
│   - Mendengarkan perubahan data melalui Consumer / watch.   │
└──────────────────────────────▲──────────────────────────────┘
                               │ Membaca State & Memicu Event
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                        VIEWMODEL                            │
│           (WeatherViewModel, LocationViewModel)             │
│   - Menangani logika bisnis dan manajemen state aplikasi.   │
│   - Memperbarui state dan memanggil notifyListeners().     │
└──────────────────────────────▲──────────────────────────────┘
                               │ Memanggil Service
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                    SERVICE & REPOSITORY                     │
│      (WeatherApiService, LocalStorageService)               │
│   - Mengelola komunikasi HTTP REST API & SharedPreferences. │
└──────────────────────────────▲──────────────────────────────┘
                               │ Serialisasi & Deserialisasi
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                           MODEL                             │
│   (WeatherData, CurrentWeather, DailyForecast, LocationModel)│
│   - Representasi struktur data Dart dengan fromJson / toJson │
└─────────────────────────────────────────────────────────────┘
```

1. **Model**:
   - `LocationModel`: Menyimpan data identitas lokasi (id, nama kota, latitude, longitude, provinsi, negara, status favorit).
   - `WeatherData`, `CurrentWeather`, `DailyForecast`: Menampung data respons JSON cuaca dari Open-Meteo API.
   - `WeatherCodeHelper`: Memetakan kode cuaca standar WMO (0-99) ke bahasa Indonesia, ikon Material, dan gradasi warna.
2. **ViewModel**:
   - `WeatherViewModel`: Mewarisi `ChangeNotifier` untuk mengelola state cuaca (status loading, error handling, refresh data, pemilihan kota aktif, toggle favorit).
   - `LocationViewModel`: Mengelola pencarian kota dengan debounce, sinkronisasi favorit, dan riwayat pencarian.
3. **View**:
   - Terdiri dari widget `StatelessWidget` dan `StatefulWidget` yang bersih tanpa logika pemanggilan HTTP langsung di dalam UI. UI bereaksi secara otomatis ketika ViewModel memanggil `notifyListeners()`.

---

## 📁 Struktur Direktori Proyek

```
responsipemmob/
├── android/                        # Konfigurasi platform Android
├── ios/                            # Konfigurasi platform iOS
├── web/                            # Konfigurasi platform Web
├── screenshots/                    # Screenshot setiap layar aplikasi
│   ├── 1_home_screen.png           # Tampilan cuaca terkini & info tambahan
│   ├── 2_forecast_scroll.png       # Tampilan scroll prakiraan 7 hari
│   ├── 3_search_screen.png         # Tampilan pencarian kota & hasil API
│   └── 4_favorites_screen.png      # Tampilan daftar lokasi favorit
├── lib/
│   ├── main.dart                   # Titik masuk aplikasi & konfigurasi MultiProvider
│   ├── theme/
│   │   └── app_theme.dart          # Tema Material Design 3 (Light & Dark)
│   ├── models/
│   │   ├── location_model.dart     # Model data lokasi kota
│   │   ├── weather_model.dart      # Model data cuaca terkini & harian
│   │   └── weather_code_helper.dart# Helper pemetaan kode cuaca WMO
│   ├── services/
│   │   ├── weather_api_service.dart# Layanan HTTP REST API Open-Meteo
│   │   └── local_storage_service.dart # Layanan SharedPreferences lokal
│   ├── viewmodels/
│   │   ├── weather_viewmodel.dart  # ViewModel untuk state cuaca
│   │   └── location_viewmodel.dart # ViewModel untuk pencarian & favorit
│   ├── views/
│   │   ├── home_screen.dart        # Screen utama cuaca
│   │   ├── search_screen.dart      # Screen pencarian & tab riwayat
│   │   └── favorites_screen.dart   # Screen daftar favorit
│   └── widgets/
│       ├── weather_header_card.dart# Kartu banner utama cuaca
│       ├── weather_detail_grid.dart# Grid 6 metrik cuaca tambahan
│       ├── daily_forecast_list.dart# Daftar prakiraan cuaca 7 hari
│       ├── empty_error_view.dart   # Widget penanganan error & data kosong
│       └── search_result_tile.dart # Komponen item kota hasil pencarian
├── test/
│   └── widget_test.dart            # Unit test untuk Model dan Helper
├── pubspec.yaml                    # Konfigurasi dependensi Flutter
└── README.md                       # Dokumentasi resmi proyek responsi
```

---

## 🌐 Implementasi REST API Open-Meteo

API yang digunakan adalah Open-Meteo (tanpa API Key yang rumit, bebas diakses):

### 1. Geocoding API (Pencarian Lokasi)
- **URL Endpoint**: `https://geocoding-api.open-meteo.com/v1/search`
- **Metode**: `GET`
- **Parameter**:
  - `name`: Nama kota yang dicari (URL encoded)
  - `count`: `10` (jumlah maksimal hasil)
  - `language`: `id` (Bahasa Indonesia)
  - `format`: `json`
- **Contoh Request**:
  ```http
  GET https://geocoding-api.open-meteo.com/v1/search?name=Bandung&count=10&language=id&format=json
  ```

### 2. Weather Forecast API (Prakiraan Cuaca)
- **URL Endpoint**: `https://api.open-meteo.com/v1/forecast`
- **Metode**: `GET`
- **Parameter yang Dikirim**:
  - `latitude`: Koordinat lintang kota
  - `longitude`: Koordinat bujur kota
  - `current`: `temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m`
  - `daily`: `temperature_2m_max,temperature_2m_min,precipitation_probability_max,weather_code`
  - `timezone`: `auto`
- **Contoh Request**:
  ```http
  GET https://api.open-meteo.com/v1/forecast?latitude=-6.92&longitude=107.61&current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m&daily=temperature_2m_max,temperature_2m_min,precipitation_probability_max,weather_code&timezone=auto
  ```

### 3. Penanganan Kondisi Jaringan
- **Loading State**: Menampilkan indikator loading animasi saat data sedang diambil.
- **Empty State**: Menampilkan pesan interaktif jika pencarian tidak menemukan kota.
- **Error State**: Menampilkan pesan kesalahan (misal: koneksi terputus atau timeout) disertai tombol **Coba Lagi (Retry)**.

---

## 💾 Penyimpanan Lokal (Local Storage)

Menggunakan package `shared_preferences` untuk persistensi data secara lokal pada perangkat:
1. **Lokasi Terakhir (`last_location`)**: Menyimpan kota terakhir yang sedang dilihat sehingga ketika aplikasi ditutup dan dibuka kembali, cuaca kota tersebut langsung dimuat secara otomatis.
2. **Lokasi Favorit (`favorite_locations`)**: Menyimpan daftar kota favorit yang ditandai oleh pengguna dalam format serialisasi JSON.
3. **Riwayat Pencarian (`search_history`)**: Menyimpan 10 kota terakhir yang pernah dipilih pengguna untuk kemudahan akses cepat.

---

## 🚀 Panduan Menjalankan Aplikasi

Pastikan Flutter SDK sudah terpasang di komputer Anda (Flutter 3.x dan Dart 3.x).

1. **Clone repository ini**:
   ```bash
   git clone https://github.com/talithanashier/H1D024098-ResponsiPrakPemmob-ShiftD-AplikasiPerkiraanCuaca.git
   cd responsipemmob
   ```

2. **Pasang dependensi**:
   ```bash
   flutter pub get
   ```

3. **Jalankan pengujian unit (Unit Test)**:
   ```bash
   flutter test
   ```

4. **Jalankan aplikasi**:
   - Di perangkat Android (Emulator atau HP fisik):
     ```bash
     flutter run
     ```
   - Di Web Browser (Chrome):
     ```bash
     flutter run -d chrome
     ```
   - Di Windows Desktop:
     ```bash
     flutter run -d windows
     ```
