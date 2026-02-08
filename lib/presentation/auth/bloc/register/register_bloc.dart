import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/datasources/auth_remote_datasource.dart';
import '../../../../data/models/response/auth_response_model.dart';

part 'register_bloc.freezed.dart';
part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRemoteDatasource authRemoteDatasource;

  RegisterBloc(this.authRemoteDatasource)
    : super(const RegisterState.initial()) {
    on<_Register>((event, emit) async {
      emit(const RegisterState.loading());

      final response = await authRemoteDatasource.register(
        name: event.name,
        email: event.email,
        password: event.password,
        passwordConfirmation: event.passwordConfirmation,
      );

      response.fold(
        (l) => emit(RegisterState.error(l)),
        (r) => emit(RegisterState.success(r)),
      );
    });
  }
}
