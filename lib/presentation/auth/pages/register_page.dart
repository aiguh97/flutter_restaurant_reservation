import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restoguh/presentation/auth/widgets/google_auth_button.dart';

import '../../../core/assets/assets.gen.dart';
import '../../../core/components/buttons.dart';
import '../../../core/components/custom_text_field.dart';
import '../../../core/components/spaces.dart';
import '../bloc/register/register_bloc.dart';
import '../../auth/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        // Menambahkan Key membantu Flutter mengelola state widget dalam list
        key: const Key('register_listview'),
        padding: const EdgeInsets.all(16),
        children: [
          const SpaceHeight(60),
          Center(
            child: Image.asset(
              Assets.images.logo.path,
              width: 100,
              height: 100,
            ),
          ),
          const SpaceHeight(8),
          CustomTextField(controller: nameController, label: 'Name'),
          const SpaceHeight(12),
          CustomTextField(controller: emailController, label: 'Email'),
          const SpaceHeight(12),
          CustomTextField(
            controller: passwordController,
            label: 'Password',
            obscureText: true,
          ),
          const SpaceHeight(12),
          CustomTextField(
            controller: confirmPasswordController,
            label: 'Confirm Password',
            obscureText: true,
          ),
          const SpaceHeight(24),
          BlocConsumer<RegisterBloc, RegisterState>(
            listener: (context, state) {
              state.whenOrNull(
                success: (_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Register berhasil, silakan login'),
                      backgroundColor: Colors.green,
                    ),
                  );

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!context.mounted) return;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                    );
                  });
                },
                error: (message) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
              );
            },

            builder: (context, state) {
              return state.maybeWhen(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
                orElse: () => Button.filled(
                  label: 'Register',
                  onPressed: () {
                    // Validasi sederhana sebelum kirim ke Bloc
                    if (passwordController.text !=
                        confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Konfirmasi password tidak cocok'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                      return;
                    }

                    context.read<RegisterBloc>().add(
                      RegisterEvent.register(
                        name: nameController.text,
                        email: emailController.text,
                        password: passwordController.text,
                        passwordConfirmation: confirmPasswordController.text,
                      ),
                    );
                  },
                ),
              );
            },
          ),
          const SpaceHeight(16),
          GoogleAuthButton(label: 'Regisster with Google'),

          const SpaceHeight(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Sudah punya akun? "),
              InkWell(
                // Menggunakan InkWell untuk feedback sentuhan yang lebih baik
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                },
                child: const Text(
                  "Login",
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
