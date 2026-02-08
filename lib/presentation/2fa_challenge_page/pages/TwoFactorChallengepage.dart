import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos_2/core/components/spaces.dart';
import 'package:flutter_pos_2/data/datasources/auth_local_datasource.dart';
import 'package:flutter_pos_2/presentation/auth/bloc/login/login_bloc.dart';

class TwoFactorChallengePage extends StatefulWidget {
  final int userId;
  const TwoFactorChallengePage({super.key, required this.userId});

  @override
  State<TwoFactorChallengePage> createState() => _TwoFactorChallengePageState();
}

class _TwoFactorChallengePageState extends State<TwoFactorChallengePage> {
  final codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('2FA Verification')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Masukkan 6 digit kode verifikasi Anda",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SpaceHeight(20),
            TextField(
              controller: codeController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 6,
              style: const TextStyle(fontSize: 24, letterSpacing: 10),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                counterText: "",
              ),
            ),
            const SpaceHeight(30),
            BlocConsumer<LoginBloc, LoginState>(
              listener: (context, state) {
                state.maybeWhen(
                  success: (authData) async {
                    // ✅ PERBAIKAN: WAJIB Simpan data ke local storage sebelum pindah halaman
                    await AuthLocalDatasource().saveAuthData(authData);
                    // Simpan data dan ke dashboard
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home',
                        (route) => false,
                      );
                    }
                  },
                  error: (message) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  },
                  orElse: () {},
                );
              },
              builder: (context, state) {
                return state.maybeWhen(
                  loading: () => const CircularProgressIndicator(),
                  orElse: () => ElevatedButton(
                    onPressed: () {
                      context.read<LoginBloc>().add(
                        LoginEvent.verify2FA(
                          userId: widget.userId,
                          code: codeController.text,
                        ),
                      );
                    },
                    child: const Text("Verifikasi"),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
