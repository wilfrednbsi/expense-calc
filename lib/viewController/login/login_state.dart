part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}
class LoginLoading extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginIsAuthenticated extends LoginState {
  final bool state;

  const LoginIsAuthenticated({required this.state});
  @override
  List<Object> get props => [state];
}

class LoginSuccess extends LoginState {
  const LoginSuccess();
  @override
  List<Object> get props => [];
}

class LoginFormValidationError extends LoginState {
  final String email ;
  final String password ;

  const LoginFormValidationError({required this.email,required this.password});
  @override
  List<Object> get props => [email,password];
}

class LoginError extends LoginState {
  final String error ;

  const LoginError({required this.error});
  @override
  List<Object> get props => [error];
}





// abstract class LoginState extends Equatable {
//   const LoginState();
//
//   @override
//   List<Object> get props => [];
// }
//
// class LoginInitial extends LoginState {}
//
// class LoginLoading extends LoginState {}
//
// class LoginFailure extends LoginState {
//   final String error;
//
//   const LoginFailure({@required this.error});
//
//   @override
//   List<Object> get props => [error];
//
//   @override
//   String toString() => 'LoginFailure { error: $error }';
// }
