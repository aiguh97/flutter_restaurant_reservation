import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter_pos_2/core/components/spaces.dart';
import 'package:flutter_pos_2/data/datasources/auth_remote_datasource.dart'; // Pastikan ada fungsi setup2FA & enable2FA

class TwoFactorSetupPage extends StatefulWidget {
  const TwoFactorSetupPage({super.key});

  @override
  State<TwoFactorSetupPage> createState() => _TwoFactorSetupPageState();
}

class _TwoFactorSetupPageState extends State<TwoFactorSetupPage> {
  bool _isLoading = true;
  String? _qrCodeBase64;
  String? _secretKey;
  final _pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSetupData();
  }

  // Fungsi mengambil data QR dari API /2fa/setup
  Future<void> _loadSetupData() async {
    // Idealnya gunakan Bloc, ini contoh langsung via Datasource untuk kecepatan
    final response = await AuthRemoteDatasource().setup2FA();
    response.fold(
      (error) {
        debugPrint("Error 2FA Setup: $error"); // Cek ini di console!
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                error,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      (data) {
        setState(() {
          // data['qr_code'] biasanya: data:image/png;base64,iVBORw0K...
          _qrCodeBase64 = data['qr_code'].split(',').last;
          _secretKey = data['secret'];
          _isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 45,
      height: 55,
      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Setup 2FA")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text(
                    "Scan QR Code",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SpaceHeight(8),
                  const Text(
                    "Buka aplikasi Authenticator (Google/Microsoft) dan scan kode di bawah ini",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SpaceHeight(30),

                  // Tampilan QR Code
                  if (_qrCodeBase64 != null)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.memory(
                        base64Decode(_qrCodeBase64!),
                        width: 200,
                        height: 200,
                      ),
                    ),

                  const SpaceHeight(20),
                  Text(
                    "Secret Key: $_secretKey",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),

                  const SpaceHeight(40),
                  const Text(
                    "Masukkan 6-digit kode dari aplikasi untuk konfirmasi:",
                  ),
                  const SpaceHeight(16),

                  Pinput(
                    length: 6,
                    controller: _pinController,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        border: Border.all(color: Colors.orange),
                      ),
                    ),
                  ),

                  const SpaceHeight(40),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => _verifyAndEnable(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Aktifkan Sekarang",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _verifyAndEnable() async {
    if (_pinController.text.length < 6) return;

    final response = await AuthRemoteDatasource().enable2FA(
      _pinController.text,
    );
    response.fold(
      (error) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error))),
      (message) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("2FA Berhasil diaktifkan!")),
        );
        Navigator.pop(context); // Kembali ke MyAccountPage
      },
    );
  }
}
