part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  @override
  List<Object> get props => [];
}

class GetProfileState extends ProfileState {
  final ProfileModel data;

  const GetProfileState({required this.data});
  @override
  List<Object> get props => [data];
}


class ProfileFailureState extends ProfileState {
  final String message;

  const ProfileFailureState({required this.message});
  @override
  List<Object> get props => [message];
}

class ProfileFormValidationError extends ProfileState {
  final String image;
  final String name;
  final String phone;

  const ProfileFormValidationError({required this.image, required this.name, required this.phone});

  @override
  List<Object> get props => [image,name,phone];
}

class ProfileSuccessState extends ProfileState {
  const ProfileSuccessState();
  @override
  List<Object> get props => [];
}


class ProfileLoadingState extends ProfileState {
  const ProfileLoadingState();
  @override
  List<Object> get props => [];
}


class ProfileLogoutState extends ProfileState {
  const ProfileLogoutState();
  @override
  List<Object> get props => [];
}
