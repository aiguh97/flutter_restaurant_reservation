import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos_2/core/components/spaces.dart';
import 'package:flutter_pos_2/data/datasources/auth_local_datasource.dart';
import 'package:flutter_pos_2/presentation/auth/pages/login_page.dart';
import 'package:flutter_pos_2/presentation/common/widgets/logout_button.dart';
import 'package:flutter_pos_2/presentation/home/bloc/logout/logout_bloc.dart';

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
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final authData = snapshot.data!;
            final user = authData.user;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SpaceHeight(30),

                  /// ===== USER INFO =====
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
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SpaceHeight(6),

                  Text(
                    user.email ?? '-',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),

                  const SpaceHeight(8),

                  Text(
                    "Role : ${user.roles}",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),

                  const SpaceHeight(30),
                  const Divider(),
                  const SpaceHeight(20),

                  /// ===== LOGOUT BUTTON =====
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
}
