import 'package:restoguh/data/models/response/auth_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDatasource {
  Future<void> saveAuthData(AuthResponseModel authResponseModel) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_data', authResponseModel.toJson());
  }

  Future<void> removeAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_data');
  }

  Future<void> update2FAStatus(bool isEnabled) async {
    final authData = await getAuthData();
    if (authData != null && authData.user != null) {
      // Sekarang copyWith sudah tersedia
      final updatedUser = authData.user!.copyWith(twoFactorEnabled: isEnabled);
      final updatedAuthData = authData.copyWith(user: updatedUser);

      // Simpan JSON baru ke SharedPreferences
      await saveAuthData(updatedAuthData);
    }
  }

  Future<AuthResponseModel?> getAuthData() async {
    final pref = await SharedPreferences.getInstance();
    final authData = pref.getString('auth_data');
    if (authData != null && authData.isNotEmpty) {
      return AuthResponseModel.fromJson(authData);
    }
    return null;
  }

  Future<bool> isAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final authData = prefs.getString('auth_data');
    print('DEBUG AUTH DATA: $authData'); // Tambahkan ini sebentar saja

    if (authData == null || authData.isEmpty) return false;

    try {
      final model = AuthResponseModel.fromJson(authData);
      print('DEBUG TOKEN: ${model.token}'); // Pastikan token muncul di sini
      return model.token != null && model.token!.isNotEmpty;
    } catch (e) {
      print('DEBUG ERROR: $e');
      return false;
    }
  }

  Future<void> saveMidtransServerKey(String serverKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('server_key', serverKey);
  }

  //get midtrans server key
  Future<String> getMitransServerKey() async {
    final prefs = await SharedPreferences.getInstance();
    final serverKey = prefs.getString('server_key');
    return serverKey ?? '';
  }

  Future<void> savePrinter(String printer) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('printer', printer);
  }

  Future<String> getPrinter() async {
    final prefs = await SharedPreferences.getInstance();
    final printer = prefs.getString('printer');
    return printer ?? '';
  }
}
