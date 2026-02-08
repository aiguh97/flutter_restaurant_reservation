import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restoguh/core/components/spaces.dart';
import 'package:restoguh/data/datasources/auth_local_datasource.dart';
import 'package:restoguh/presentation/auth/bloc/login/login_bloc.dart';
import 'package:pinput/pinput.dart';

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
    final defaultPinTheme = PinTheme(
      width: 52,
      height: 60,
      textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: const Text('Verifikasi 2FA'), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔐 Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.security,
                    size: 40,
                    color: Colors.orange,
                  ),
                ),

                const SpaceHeight(20),

                const Text(
                  "Verifikasi Dua Langkah",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SpaceHeight(8),

                const Text(
                  "Masukkan 6 digit kode dari aplikasi Authenticator",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),

                const SpaceHeight(30),

                // 🔢 PIN INPUT
                Pinput(
                  controller: codeController,
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      border: Border.all(color: Colors.orange, width: 2),
                    ),
                  ),
                  submittedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      color: Colors.orange.withOpacity(0.1),
                    ),
                  ),
                  onCompleted: (pin) {
                    context.read<LoginBloc>().add(
                      LoginEvent.verify2FA(userId: widget.userId, code: pin),
                    );
                  },
                ),

                const SpaceHeight(30),

                BlocConsumer<LoginBloc, LoginState>(
                  listener: (context, state) {
                    state.maybeWhen(
                      success: (authData) async {
                        await AuthLocalDatasource().saveAuthData(authData);

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
                      orElse: () => SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            context.read<LoginBloc>().add(
                              LoginEvent.verify2FA(
                                userId: widget.userId,
                                code: codeController.text,
                              ),
                            );
                          },
                          child: const Text(
                            "Verifikasi",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
