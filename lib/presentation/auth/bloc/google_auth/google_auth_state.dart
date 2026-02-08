part of 'google_auth_bloc.dart';

@freezed
class GoogleAuthState with _$GoogleAuthState {
  const factory GoogleAuthState.initial() = _Initial;
  const factory GoogleAuthState.loading() = _Loading;
  const factory GoogleAuthState.success(AuthResponseModel authResponseModel) =
      _Success;
  const factory GoogleAuthState.error(String message) = _Error;
}
