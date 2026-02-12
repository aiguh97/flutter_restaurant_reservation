import 'package:flutter/material.dart';
import 'package:restoguh/core/components/spaces.dart';
import 'package:restoguh/core/constants/colors.dart';
import 'package:restoguh/data/datasources/auth_local_datasource.dart';
import 'package:restoguh/data/datasources/auth_remote_datasource.dart';
import 'package:restoguh/data/models/response/auth_response_model.dart';
import 'package:restoguh/presentation/2fa_challenge_page/pages/TwoFactorSetupPage.dart';
import 'package:restoguh/presentation/common/widgets/logout_button.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({super.key});

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  AuthResponseModel? _authData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final data = await AuthLocalDatasource().getAuthData();
    if (mounted) {
      setState(() {
        _authData = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final user = _authData?.user;
    if (user == null) {
      return const Scaffold(body: Center(child: Text("Data tidak ditemukan")));
    }

    bool is2faEnabled = user.twoFactorEnabled ?? false;

    return Scaffold(
      backgroundColor: const Color(
        0xFFF8F9FD,
      ), // Latar belakang abu-abu sangat muda
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER BIRU MELENGKUNG (Sesuai Gambar)
            _buildHeader(user),

            // CONTENT LIST MENU
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.person_outline,
                    title: "Edit Profile",
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.lock_outline,
                    title: "Change Password",
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.language,
                    title: "Language",
                    subtitle: "English (US)",
                    onTap: () {},
                  ),
                  // MENU 2FA (Khusus Aplikasi Anda)
                  _build2FAMenu(is2faEnabled),

                  _buildMenuItem(
                    icon: Icons.help_outline,
                    title: "Help Center",
                    onTap: () {},
                  ),
                  // _buildMenuItem(
                  //   icon: Icons.privacy_tip_outline,
                  //   title: "Privacy Policy",
                  //   onTap: () {},
                  // ),
                  const SpaceHeight(10),
                  const LogoutButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET HEADER SESUAI DESAIN GAMBAR
  // WIDGET HEADER SESUAI DESAIN GAMBAR (DIPERBAIKI)
  Widget _buildHeader(dynamic user) {
    // Mengambil inisial nama (huruf pertama)
    String getInitial(String? name) {
      if (name == null || name.isEmpty) return "AD"; // Default Admin

      List<String> parts = name.trim().split(" ");
      if (parts.length > 1) {
        // Ambil huruf pertama kata pertama + huruf pertama kata kedua
        return (parts[0][0] + parts[1][0]).toUpperCase();
      } else {
        // Jika hanya 1 kata, ambil 2 huruf pertama (jika ada) atau 1 huruf saja
        return name.length >= 2
            ? name.substring(0, 2).toUpperCase()
            : name[0].toUpperCase();
      }
    }

    String initials = getInitial(user.name);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        top: 50,
        bottom: 20,
      ), // Padding disesuaikan
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white24,
                    width: 3,
                  ), // Border diperkecil
                ),
                child: CircleAvatar(
                  radius: 40, // Ukuran diperkecil dari 55 ke 40
                  backgroundColor: const Color.fromARGB(255, 31, 158, 6),
                  child: Text(
                    initials, // Menggunakan Inisial Nama
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const CircleAvatar(
                radius: 14, // Ukuran ikon kamera diperkecil
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.camera_alt,
                  size: 14,
                  color: Color.fromARGB(255, 15, 134, 41),
                ),
              ),
            ],
          ),
          const SpaceHeight(12),
          Text(
            user.name ?? "Admin Cashier",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20, // Font sedikit diperkecil agar proporsional
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            user.email ?? "admin@cafepos.com",
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET LIST ITEM SESUAI DESAIN GAMBAR
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFEEF0FF),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      ),
    );
  }

  // WIDGET KHUSUS UNTUK TOGGLE 2FA
  Widget _build2FAMenu(bool isEnabled) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFFFF4E5),
          child: Icon(Icons.security, color: Colors.orange),
        ),
        title: const Text(
          "Two-Factor Auth",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(isEnabled ? "Aktif" : "Non-Aktif"),
        trailing: Switch(
          activeColor: const Color(0xFF4C4DDC),
          value: isEnabled,
          onChanged: (value) {
            if (value) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TwoFactorSetupPage(),
                ),
              ).then((_) => _loadInitialData());
            } else {
              _showDisableConfirmation(context);
            }
          },
        ),
      ),
    );
  }

  void _showDisableConfirmation(BuildContext parentContext) {
    showDialog(
      context: parentContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Nonaktifkan 2FA?"),
        content: const Text("Keamanan akun Anda akan berkurang."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              showDialog(
                context: parentContext,
                barrierDismissible: false,
                builder: (_) =>
                    const Center(child: CircularProgressIndicator()),
              );

              final result = await AuthRemoteDatasource().disable2FA();
              if (!mounted) return;
              Navigator.pop(parentContext);

              result.fold((error) => _showSnackBar(parentContext, error), (
                message,
              ) async {
                await AuthLocalDatasource().update2FAStatus(false);
                setState(() {
                  _authData = _authData?.copyWith(
                    user: _authData?.user?.copyWith(twoFactorEnabled: false),
                  );
                });
                _showSnackBar(parentContext, message);
              });
            },
            child: const Text(
              "Ya, Nonaktifkan",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
