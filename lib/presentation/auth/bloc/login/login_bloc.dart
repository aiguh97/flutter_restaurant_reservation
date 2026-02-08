import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:restoguh/data/datasources/auth_remote_datasource.dart';

import '../../../../data/models/response/auth_response_model.dart';

part 'login_bloc.freezed.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRemoteDatasource authRemoteDatasource;

  LoginBloc(this.authRemoteDatasource) : super(const _Initial()) {
    on<_Login>((event, emit) async {
      emit(const _Loading());
      final response = await authRemoteDatasource.login(
        event.email,
        event.password,
      );

      response.fold((l) => emit(_Error(l)), (r) {
        // Periksa field message dari AuthResponseModel
        if (r.message == '2FA_REQUIRED') {
          emit(LoginState.twoFactorRequired(r.userId ?? 0));
        } else {
          emit(_Success(r));
        }
      });
    });

    on<_Verify2FA>((event, emit) async {
      emit(const _Loading());
      final response = await authRemoteDatasource.verify2FA(
        event.userId,
        event.code,
      );
      response.fold((l) => emit(_Error(l)), (r) => emit(_Success(r)));
    });
  }
}
