part of 'login_bloc.dart';

@freezed
class LoginEvent with _$LoginEvent {
  const factory LoginEvent.started() = _Started;
  const factory LoginEvent.login({
    required String email,
    required String password,
  }) = _Login;

  // Tambahkan ini agar 'LoginEvent.verify2FA' dikenali
  const factory LoginEvent.verify2FA({
    required int userId,
    required String code,
    required String twoFactorToken,
  }) = _Verify2FA;
}
