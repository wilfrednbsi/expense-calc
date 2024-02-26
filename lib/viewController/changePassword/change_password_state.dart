part of 'change_password_bloc.dart';

abstract class ChangePasswordState extends Equatable {
  const ChangePasswordState();
}

class ChangePasswordInitial extends ChangePasswordState {
  @override
  List<Object> get props => [];
}

class ChangePasswordLoadingState extends ChangePasswordState {
  @override
  List<Object> get props => [];
}

class ChangePasswordSuccessState extends ChangePasswordState {
  @override
  List<Object> get props => [];
}


class ChangePasswordFormValidationErrorState extends ChangePasswordState {
  final String oldPassword;
  final String newPassword;
  final String confirmPassword;

  const ChangePasswordFormValidationErrorState({required this.oldPassword, required this.newPassword, required this.confirmPassword});

  @override
  List<Object> get props => [oldPassword, newPassword, confirmPassword];
}

class ChangePasswordFailureState extends ChangePasswordState {
  final String message;

  const ChangePasswordFailureState({required this.message});
  @override
  List<Object> get props => [message];
}
