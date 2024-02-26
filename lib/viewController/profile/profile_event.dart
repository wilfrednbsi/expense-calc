part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class ProfileClearErrorEvent extends ProfileEvent{
  @override
  List<Object?> get props => [];
}

class FetchProfileEvent extends ProfileEvent{
  @override
  List<Object?> get props => [];
}


class UpdateProfileEvent extends ProfileEvent{
  final String name;
  final String phoneNo;

  const UpdateProfileEvent({required this.name, required this.phoneNo});
  @override
  List<Object?> get props => [name,phoneNo];
}


class ChangeProfileImageEvent extends ProfileEvent{
  final ImageDataModel data;

  const ChangeProfileImageEvent({required this.data});
  @override
  List<Object?> get props => [data];
}


class LogoutClickEvent extends ProfileEvent{
  @override
  List<Object?> get props => [];
}
