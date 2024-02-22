import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_calc/services/respository/authRepo/authRepo.dart';
import 'package:expense_calc/utils/AppExtensions.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final repo = AuthRepoImplementation();
  LoginBloc() : super(LoginInitial()) {
    on<DoLoginEvent>(_doLoginApi);
  }

  FutureOr<void> _doLoginApi(DoLoginEvent event, Emitter<LoginState> emit) async{
    try {
      emit(LoginLoading());
      if(event.email.trim().isEmail && event.password.trim().isPassword){
        await repo.authenticate(email: event.email, password: event.password).then((value) {
          emit(const LoginSuccess());
        });
      }else{
        emit(LoginFormValidationError(
            email: !event.email.trim().isEmail ? 'Please enter valid email address' : '',
            password: !event.password.trim().isPassword ? 'Please enter valid password' : ''
        ));
      }
    } catch (e) {
      emit(LoginError(error: e.toString()));}
  }
}
