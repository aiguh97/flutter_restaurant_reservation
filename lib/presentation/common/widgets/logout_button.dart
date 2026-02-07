import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos_2/data/datasources/auth_local_datasource.dart';
import 'package:flutter_pos_2/presentation/auth/pages/login_page.dart';
import 'package:flutter_pos_2/presentation/home/bloc/logout/logout_bloc.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogoutBloc, LogoutState>(
      listener: (context, state) async {
        state.maybeMap(
          success: (_) async {
            await AuthLocalDatasource().removeAuthData();

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (_) => false,
            );
          },
          error: (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.message), backgroundColor: Colors.red),
            );
          },
          orElse: () {},
        );
      },
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
          onPressed: () {
            context.read<LogoutBloc>().add(const LogoutEvent.logout());
          },
          child: const Text(
            'Logout',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
