import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restoguh/data/datasources/auth_local_datasource.dart';
import 'package:restoguh/presentation/2fa_challenge_page/pages/TwoFactorChallengepage.dart';
import 'package:restoguh/presentation/auth/bloc/login/login_bloc.dart';
import 'package:restoguh/presentation/auth/pages/register_page.dart';
import 'package:restoguh/presentation/auth/widgets/google_auth_button.dart';

import '../../../core/assets/assets.gen.dart';
import '../../../core/components/buttons.dart';
import '../../../core/components/custom_text_field.dart';
import '../../../core/components/spaces.dart';
import '../../home/pages/dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SpaceHeight(60.0),
          Center(
            child: Image.asset(
              Assets.images.logo.path,
              width: 100,
              height: 100,
            ),
          ),
          const SpaceHeight(8.0),
          const Center(
            child: Text(
              'Login to your account',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          const SpaceHeight(40.0),

          CustomTextField(controller: usernameController, label: 'Email'),
          const SpaceHeight(12.0),
          CustomTextField(
            controller: passwordController,
            label: 'Password',
            obscureText: true,
          ),
          const SpaceHeight(24.0),

          BlocConsumer<LoginBloc, LoginState>(
            listener: (context, state) {
              state.maybeWhen(
                success: (data) async {
                  await AuthLocalDatasource().saveAuthData(data);

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!context.mounted) return;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const DashboardPage()),
                      (route) => false,
                    );
                  });
                },

                twoFactorRequired: (userId) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TwoFactorChallengePage(userId: userId),
                    ),
                  );
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
                loading: () => const Center(child: CircularProgressIndicator()),
                orElse: () => Button.filled(
                  label: 'Login',
                  onPressed: () {
                    context.read<LoginBloc>().add(
                      LoginEvent.login(
                        email: usernameController.text,
                        password: passwordController.text,
                      ),
                    );
                  },
                ),
              );
            },
          ),

          const SpaceHeight(16),
          GoogleAuthButton(label: 'Login with Google'),

          const SpaceHeight(16),
          // 👉 LINK KE REGISTER (Gunakan TextButton untuk navigasi yang lebih stabil)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Belum punya akun? "),
              TextButton(
                // Mengganti GestureDetector dengan TextButton
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterPage(),
                    ),
                  );
                },
                child: const Text(
                  "Register",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
