<p align="center">
  <img src="screenshoots/logo.png" width="180"/>
</p>

<h1 align="center">RestoGuh Mobile App</h1>

<p align="center">
  Aplikasi Mobile POS & Restaurant Management System berbasis Flutter.
</p>

---

## 🚀 Overview

**RestoGuh Mobile** adalah aplikasi client yang terintegrasi dengan backend Laravel 11.  
Aplikasi ini digunakan untuk kebutuhan kasir (POS), monitoring pesanan, dan manajemen transaksi secara real-time.

Backend API:  
🔗 http://202.10.34.144/api

---

## ✨ Fitur Utama

### 🔐 Authentication
- Login menggunakan API
- Support JWT / Sanctum Token
- Secure Logout
- 2FA Verification Support

---

### 🛒 POS (Point of Sales)
- Tambah produk ke keranjang
- Hitung total otomatis
- Input nominal bayar
- Generate order ke backend
- Status transaksi: Pending / Done

---

### 📦 Order Management
- Lihat daftar pesanan
- Filter berdasarkan status
- Update status order
- Sinkronisasi data dengan server

---

### 🔄 Offline Support (Local Storage)
- Simpan transaksi ke SQLite
- Sync otomatis saat online
- Status `isSync` untuk tracking

---

### 👤 User Info
- Tampilkan nama kasir
- ID kasir tersimpan
- Session management

---

## 🧱 Tech Stack

- Flutter 3.x
- Dart
- HTTP 
- SQLite (sqflite)
- Provider / State Management
- REST API Integration
- JSON Serialization

---

## 📸 Screenshots Interface



<h3>🏠 Home</h3>
<p align="center">
  <img src="screenshoots/home.jpeg" width="700"/>
</p>

<h3>🗂 Orders</h3>
<p align="center">
  <img src="screenshoots/orders.png" width="700"/>
</p>

<h3>🛒 Product Management</h3>
<p align="center">
  <img src="screenshoots/product.png" width="700"/>
</p>

<h3>Pilih Meja</h3>
<p align="center">
  <img src="screenshoots/pilih_meja.png" width="700"/>
</p>

<h3>Setup Auth</h3>
<p align="center">
  <img src="screenshoots/setup_auth.png" width="700"/>
</p>

<h3>2 FA Login</h3>
<p align="center">
  <img src="screenshoots/2fa_login.png" width="700"/>
</p>

<h3>Verifikasi 2 FA Via Email</h3>
<p align="center">
  <img src="screenshoots/verifikasi_2fa_via_email.png" width="700"/>
</p>


