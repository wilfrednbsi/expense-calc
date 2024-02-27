import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_calc/services/respository/authRepo/authRepo.dart';
import 'package:expense_calc/utils/AppExtensions.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final repo = AuthRepoImplementation();
  ChangePasswordBloc() : super(ChangePasswordInitial()) {
    on<OnChangeEvent>(_onChange);
    on<ClearFormErrorEvent>(_clearFormError);
  }

  FutureOr<void> _clearFormError(ClearFormErrorEvent event, Emitter<ChangePasswordState> emit) {
    emit(ChangePasswordLoadingState());
    emit(const ChangePasswordFormValidationErrorState(oldPassword: '', newPassword: '', confirmPassword: ''));
  }

  FutureOr<void> _onChange(OnChangeEvent event, Emitter<ChangePasswordState> emit) async{
    try{
      emit(ChangePasswordLoadingState());
      final oldPassword = event.oldPassword.trim();
      final newPassword = event.newPassword.trim();
      final confirmPassword = event.confirmPassword.trim();
      if(oldPassword.isNotEmpty && newPassword.isPassword && !newPassword.isEquals(oldPassword) && confirmPassword.isEquals(newPassword)){
        await repo.changePassword(oldPassword: oldPassword, newPassword: newPassword).then((value){
          emit(ChangePasswordSuccessState());
        });
      }else{
        emit(ChangePasswordFormValidationErrorState(
            oldPassword: oldPassword.isEmpty ? 'Please enter your old password' : '',
            newPassword: newPassword.isPassword ? newPassword.isEquals(oldPassword) ? 'Password should not match with old password' : '': 'Please create valid password',
            confirmPassword: confirmPassword.isEquals(newPassword) ? '' : 'Password not matched'
        ));
      }
    }catch(e){
      emit(ChangePasswordFailureState(message: e.toString()));
    }
  }
}
