import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restoguh/core/constants/colors.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Tambahkan ini
import 'package:pinput/pinput.dart';
import 'package:restoguh/core/components/spaces.dart';
import 'package:restoguh/data/datasources/auth_remote_datasource.dart';
import 'package:restoguh/data/datasources/auth_local_datasource.dart'; // Import ini untuk update status

class TwoFactorSetupPage extends StatefulWidget {
  const TwoFactorSetupPage({super.key});

  @override
  State<TwoFactorSetupPage> createState() => _TwoFactorSetupPageState();
}

class _TwoFactorSetupPageState extends State<TwoFactorSetupPage> {
  bool _isLoading = true;
  String? _qrData; // Kita ganti nama jadi lebih umum
  String? _secretKey;
  final _pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSetupData();
  }

  Future<void> _loadSetupData() async {
    final response = await AuthRemoteDatasource().setup2FA();
    response.fold(
      (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error), backgroundColor: Colors.red),
          );
        }
      },
      (data) {
        print("ISI QR DATA: ${data['qr_code']}"); // Lihat di debug console!
        setState(() {
          _qrData = data['qr_code']; // Simpan data mentah
          _secretKey = data['secret'];
          _isLoading = false;
        });
      },
    );
  }

  // Fungsi helper untuk merender QR Code baik format SVG maupun Base64
  Widget _buildQrWidget(String data) {
    String cleanData = data.trim();

    // 🔥 FIX: hapus background putih SVG
    cleanData = cleanData.replaceAll(
      RegExp(r'<rect[^>]*fill="#fefefe"[^>]*/>'),
      '',
    );

    // Pastikan SVG valid
    if (cleanData.startsWith('<?xml')) {
      cleanData = cleanData.substring(cleanData.indexOf('<svg'));
    }

    return SvgPicture.string(
      cleanData,
      width: 200,
      height: 200,
      fit: BoxFit.contain,
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

                  if (_qrData != null)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white, // Penting agar QR mudah discan
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: _buildQrWidget(_qrData!),
                    ),

                  const SpaceHeight(20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Secret Key",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              SelectableText(
                                _secretKey ?? "-",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 20),
                          tooltip: "Copy",
                          onPressed: () {
                            if (_secretKey == null) return;

                            Clipboard.setData(ClipboardData(text: _secretKey!));

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.green,
                                content: Text(
                                  "Secret key berhasil disalin",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SpaceHeight(40),
                  const Text("Masukkan 6-digit kode konfirmasi:"),
                  const SpaceHeight(16),

                  Pinput(
                    length: 6,
                    controller: _pinController,
                    defaultPinTheme: defaultPinTheme,
                    onCompleted: (pin) => _verifyAndEnable(),
                  ),

                  const SpaceHeight(40),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _verifyAndEnable,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
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
      (error) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error, style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
        ),
      ),
      (message) async {
        // PENTING: Update status 2FA di database lokal agar Switch di MyAccount berubah
        await AuthLocalDatasource().update2FAStatus(true);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                "2FA Berhasil diaktifkan!",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
          Navigator.pop(context); // Kembali dan MyAccountPage akan reload
        }
      },
    );
  }
}
