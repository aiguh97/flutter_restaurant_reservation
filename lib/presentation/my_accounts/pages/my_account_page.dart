import 'package:flutter/material.dart';
import 'package:flutter_pos_2/core/components/spaces.dart';
import 'package:flutter_pos_2/core/constants/colors.dart';
import 'package:flutter_pos_2/data/datasources/auth_local_datasource.dart';
import 'package:flutter_pos_2/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_pos_2/data/models/response/auth_response_model.dart';
import 'package:flutter_pos_2/presentation/2fa_challenge_page/pages/TwoFactorSetupPage.dart';
import 'package:flutter_pos_2/presentation/common/widgets/logout_button.dart';

// Import halaman setup 2FA (buat jika belum ada)
// import 'package:flutter_pos_2/presentation/auth/pages/two_factor_setup_page.dart';
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
      appBar: AppBar(title: const Text('My Account'), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              const SpaceHeight(30),
              _buildProfileHeader(user),
              const SpaceHeight(30),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.security, color: Colors.orange),
                title: Text("Two-Factor Authentication"),
                subtitle: Text(is2faEnabled ? "Aktif" : "Non-Aktif"),
                trailing: Switch(
                  activeColor: Colors.orange,
                  value: is2faEnabled,
                  onChanged: (value) {
                    if (value) {
                      if (!is2faEnabled) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TwoFactorSetupPage(),
                          ),
                        ).then((_) => _loadInitialData());
                      }
                    } else {
                      _showDisableConfirmation(context);
                    }
                  },
                ),
              ),
              const SpaceHeight(40),
              const LogoutButton(),
            ],
          ),
        ),
      ),
    );
  }

  void _showDisableConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Nonaktifkan 2FA?"),
        content: const Text("Keamanan akun Anda akan berkurang."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) =>
                    const Center(child: CircularProgressIndicator()),
              );

              final result = await AuthRemoteDatasource().disable2FA();

              if (mounted) Navigator.pop(context); // Tutup loading

              result.fold((error) => _showSnackBar(context, error), (
                message,
              ) async {
                await AuthLocalDatasource().update2FAStatus(false);

                if (mounted) {
                  setState(() {
                    _authData = _authData?.copyWith(
                      user: _authData?.user?.copyWith(twoFactorEnabled: false),
                    );
                  });
                  _showSnackBar(context, message);
                }
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

  // METHOD YANG TADI HILANG
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildProfileHeader(dynamic user) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.orange.withOpacity(0.2),
          child: Text(
            user.name[0].toUpperCase(),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        const SpaceHeight(16),
        Text(
          user.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          "Role : ${user.roles}",
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
