part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();
}

 class SignupRegisterEvent extends SignUpEvent {
  final String email;
  final String password;
  final String confirmPassword;

  const SignupRegisterEvent({required this.email, required this.password, required this.confirmPassword});

  @override
  List<Object?> get props => [email,password,confirmPassword];
}
