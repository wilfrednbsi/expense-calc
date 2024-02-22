part of 'sign_up_bloc.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();
}

class SignUpInitial extends SignUpState {
  @override
  List<Object> get props => [];
}

class SignUpLoading extends SignUpState {
  @override
  List<Object> get props => [];
}

class SignUpFormValidationError extends SignUpState {
  final String email;
  final String password;
  final String confirmPassword;

  const SignUpFormValidationError({required this.email, required this.password, required this.confirmPassword});
  @override
  List<Object> get props => [email,password,confirmPassword];
}

class SignUpSuccess extends SignUpState {
  const SignUpSuccess();
  @override
  List<Object> get props => [];
}

class SignUpFailure extends SignUpState {
  final String error;

  const SignUpFailure({required this.error});
  @override
  List<Object> get props => [error];
}
