import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_calc/services/respository/authRepo/authRepo.dart';
import 'package:expense_calc/utils/AppExtensions.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final repo = AuthRepoImplementation();
  SignUpBloc() : super(SignUpInitial()) {
    on<SignUpEvent>((event, emit) {
    });
    on<SignupRegisterEvent>(_registerAction);
  }

  FutureOr<void> _registerAction(SignupRegisterEvent event, Emitter<SignUpState> emit) async{
    try {
      emit(SignUpLoading());
      final email = event.email.trim();
      final password = event.password.trim();
      final confirmPassword = event.confirmPassword.trim();
      if(email.isEmail && password.isPassword && confirmPassword.isEquals(password)){
        await repo.register(email: email, password: password).then((value){
          emit(const SignUpSuccess());
        });
      }else{
        emit(SignUpFormValidationError(
            email: email.isEmail ? '' : 'Please enter valid email address',
            password: password.isPassword ? '' : 'Please enter valid password',
            confirmPassword: confirmPassword.isEquals(password) ? '' :'Password not matched'
        ));
      }
    } catch (e) {
      emit(SignUpFailure(error: e.toString()));
    }
  }
}
