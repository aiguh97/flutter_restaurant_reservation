import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restoguh/core/constants/colors.dart';
import 'package:restoguh/core/services/google_sign_in_service.dart';
import 'package:restoguh/presentation/2fa_challenge_page/pages/TwoFactorChallengepage.dart';
import 'package:restoguh/presentation/auth/bloc/google_auth/google_auth_bloc.dart';

import '../../../core/assets/assets.gen.dart';
import '../../../data/datasources/auth_local_datasource.dart';

class GoogleAuthButton extends StatelessWidget {
  final String label;

  const GoogleAuthButton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GoogleAuthBloc, GoogleAuthState>(
      listener: (context, state) async {
        state.maybeWhen(
          success: (data) async {
            // Jika ternyata response mengandung 2FA_REQUIRED
            if (data.message == '2FA_REQUIRED') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TwoFactorChallengePage(
                    userId: data.userId!,
                    twoFactorToken: data.twoFactorToken ?? '',
                  ),
                ),
              );
            } else {
              await AuthLocalDatasource().saveAuthData(data);
              if (!context.mounted) return;
              Navigator.pushReplacementNamed(context, '/home');
            }
          },
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message), backgroundColor: Colors.red),
            );
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        final isLoading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

        return SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: isLoading
                ? null
                : () async {
                    final idToken = await GoogleSignInService.getIdToken();

                    if (idToken == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Login Google dibatalkan'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                      return;
                    }

                    context.read<GoogleAuthBloc>().add(
                      GoogleAuthEvent.loginOrRegister(idToken: idToken),
                    );
                  },
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        Assets.images.google.path,
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        label,
                        style: const TextStyle(
                          // color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
