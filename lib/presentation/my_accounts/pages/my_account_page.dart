import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos_2/core/components/spaces.dart';
import 'package:flutter_pos_2/data/datasources/auth_local_datasource.dart';
import 'package:flutter_pos_2/presentation/common/widgets/logout_button.dart';

class MyAccountPage extends StatelessWidget {
  const MyAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Account'), centerTitle: true),
      body: SafeArea(
        child: FutureBuilder(
          future: AuthLocalDatasource().getAuthData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return const Center(child: CircularProgressIndicator());

            final authData = snapshot.data!;
            final user = authData.user!;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                // Gunakan ListView agar bisa discroll
                children: [
                  const SpaceHeight(30),
                  _buildProfileHeader(user),
                  const SpaceHeight(30),
                  const Divider(),

                  /// ===== MENU SETTINGS =====
                  // ListTile(
                  //   leading: const Icon(Icons.email_outlined),
                  //   title: const Text("Edit Email"),
                  //   subtitle: Text(user.email),
                  //   trailing: const Icon(Icons.edit, size: 20),
                  //   onTap: () {
                  //     // Navigasi ke halaman Edit Email
                  //   },
                  // ),
                  ListTile(
                    leading: const Icon(Icons.security),
                    title: const Text("Two-Factor Authentication"),
                    subtitle: const Text("Amankan akun dengan kode OTP"),
                    trailing: Switch(
                      value:
                          true, // Idealnya ambil dari status user.two_factor_enabled
                      onChanged: (value) {
                        // Logika untuk navigasi ke setup 2FA atau disable 2FA
                      },
                    ),
                  ),

                  const SpaceHeight(40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: LogoutButton(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileHeader(dynamic user) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          child: Text(
            user.name.substring(0, 1).toUpperCase(),
            style: const TextStyle(fontSize: 28),
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
