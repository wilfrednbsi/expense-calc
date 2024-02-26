part of 'change_password_bloc.dart';

abstract class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();
}

class OnChangeEvent extends ChangePasswordEvent {
  final String oldPassword;
  final String newPassword;
  final String confirmPassword;

  const OnChangeEvent({required this.oldPassword, required this.newPassword, required this.confirmPassword});
  @override
  // TODO: implement props
  List<Object?> get props => [oldPassword,newPassword,confirmPassword];
}

class ClearFormErrorEvent extends ChangePasswordEvent {
  const ClearFormErrorEvent();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
