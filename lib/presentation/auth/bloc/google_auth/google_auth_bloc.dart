import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/datasources/auth_remote_datasource.dart';
import '../../../../data/models/response/auth_response_model.dart';

part 'google_auth_bloc.freezed.dart';
part 'google_auth_event.dart';
part 'google_auth_state.dart';

class GoogleAuthBloc extends Bloc<GoogleAuthEvent, GoogleAuthState> {
  final AuthRemoteDatasource authRemoteDatasource;

  GoogleAuthBloc(this.authRemoteDatasource)
    : super(const GoogleAuthState.initial()) {
    on<_LoginOrRegister>(_loginOrRegister);
  }

  Future<void> _loginOrRegister(
    _LoginOrRegister event,
    Emitter<GoogleAuthState> emit,
  ) async {
    emit(const GoogleAuthState.loading());

    final result = await authRemoteDatasource.loginWithGoogle(event.idToken);

    result.fold(
      (l) => emit(GoogleAuthState.error(l)),
      (r) => emit(GoogleAuthState.success(r)),
    );
  }
}
