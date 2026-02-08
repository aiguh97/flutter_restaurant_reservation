part of 'google_auth_bloc.dart';

@freezed
class GoogleAuthEvent with _$GoogleAuthEvent {
  const factory GoogleAuthEvent.loginOrRegister({required String idToken}) =
      _LoginOrRegister;
}
