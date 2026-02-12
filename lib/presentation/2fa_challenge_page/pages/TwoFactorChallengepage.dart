import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:restoguh/core/constants/colors.dart'; // Sesuaikan path AppColors Anda
import 'package:restoguh/core/components/spaces.dart';
import 'package:restoguh/data/datasources/auth_local_datasource.dart';
import 'package:restoguh/data/datasources/auth_remote_datasource.dart';
import 'package:restoguh/presentation/auth/bloc/login/login_bloc.dart';

class TwoFactorChallengePage extends StatefulWidget {
  final int userId;
  final String twoFactorToken;

  const TwoFactorChallengePage({
    super.key,
    required this.userId,
    required this.twoFactorToken,
  });

  @override
  State<TwoFactorChallengePage> createState() => _TwoFactorChallengePageState();
}

class _TwoFactorChallengePageState extends State<TwoFactorChallengePage> {
  final codeController = TextEditingController();
  int _cooldownSeconds = 0;
  bool _isSendingEmail = false;
  Timer? _timer;

  void _startCooldown(int seconds) {
    setState(() => _cooldownSeconds = seconds);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_cooldownSeconds == 0) {
        timer.cancel();
      } else {
        setState(() => _cooldownSeconds--);
      }
    });
  }

  Future<void> _handleSendEmail() async {
    setState(() => _isSendingEmail = true);
    final result = await AuthRemoteDatasource().sendEmailOTP(widget.userId);
    setState(() => _isSendingEmail = false);

    result.fold(
      (l) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l), backgroundColor: Colors.red)),
      (r) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(r), backgroundColor: Colors.green),
        );
        _startCooldown(30);
      },
    );
  }

  @override
  void dispose() {
    codeController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // PinTheme yang lebih modern & clean
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade300),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: Colors.white,
        border: Border.all(color: AppColors.primary, width: 2),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: SafeArea(
        child: Center(
          // Menempatkan konten di tengah layar
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon Security untuk kesan modern
                const Icon(
                  Icons.vpn_key_rounded,
                  size: 80,
                  color: AppColors.primary,
                ),
                const SpaceHeight(24),
                const Text(
                  "Verifikasi 2FA",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SpaceHeight(12),
                const Text(
                  "Masukkan 6 digit kode keamanan Anda",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SpaceHeight(32),

                // Pinput dengan spacing antar box yang rata
                Pinput(
                  controller: codeController,
                  length: 6,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  onCompleted: (pin) {
                    context.read<LoginBloc>().add(
                      LoginEvent.verify2FA(
                        userId: widget.userId,
                        code: pin,
                        twoFactorToken: widget.twoFactorToken,
                      ),
                    );
                  },
                ),

                const SpaceHeight(32),

                // Tombol Verifikasi Utama
                BlocConsumer<LoginBloc, LoginState>(
                  listener: (context, state) {
                    state.maybeWhen(
                      success: (authData) async {
                        await AuthLocalDatasource().saveAuthData(authData);
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/home',
                            (r) => false,
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
                      loading: () => const CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                      orElse: () => SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            if (codeController.text.length == 6) {
                              context.read<LoginBloc>().add(
                                LoginEvent.verify2FA(
                                  userId: widget.userId,
                                  code: codeController.text,
                                  twoFactorToken: widget.twoFactorToken,
                                ),
                              );
                            }
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

                const SpaceHeight(24),

                // Opsi Kirim Ulang Email
                _isSendingEmail
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      )
                    : TextButton(
                        onPressed: _cooldownSeconds > 0
                            ? null
                            : _handleSendEmail,
                        child: Text(
                          _cooldownSeconds > 0
                              ? "Kirim ulang tersedia dalam $_cooldownSeconds dtk"
                              : "Kirim kode via Email",
                          style: TextStyle(
                            color: _cooldownSeconds > 0
                                ? Colors.grey
                                : AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
