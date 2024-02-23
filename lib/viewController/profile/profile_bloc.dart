import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_calc/components/constants/constants.dart';
import 'package:expense_calc/model/ImageDataModel.dart';
import 'package:expense_calc/model/ProfileModel.dart';
import 'package:expense_calc/services/respository/authRepo/authRepo.dart';
import 'package:expense_calc/utils/AppExtensions.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final repo = AuthRepoImplementation();
  var profileData = ProfileModel();
  var imageData = ImageDataModel();
  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileClearErrorEvent>((event, emit) {
      emit(const ProfileFormValidationError(image: '', name: '', phone: ''));
    });
    on<FetchProfileEvent>(_fetchProfile);
    on<UpdateProfileEvent>(_updateProfile);
    on<ChangeProfileImageEvent>(_changeProfileImage);
  }

  FutureOr<void> _fetchProfile(FetchProfileEvent event, Emitter<ProfileState> emit) async{
    try {
      emit(const ProfileLoadingState());
     await repo.getProfile().then((value) {
        emit(GetProfileState(data: value));
      });
    } catch (e) {
      emit(ProfileFailureState(message: e.toString()));
    }
  }

  ProfileModel  get getProfileData {
    if(state is GetProfileState){
      final profileState = state as GetProfileState;
      profileData = profileState.data;
    }
    return profileData;
  }

  ImageDataModel  get getImageData {
    if(state is GetProfileState){
      final profileState = state as GetProfileState;
      final image = profileState.data.image;
      imageData.network = image;
      if(image != null && image.isNotEmpty){
        imageData.type = ImageType.network;
      }
    }
    return imageData;
  }

  FutureOr<void> _updateProfile(UpdateProfileEvent event, Emitter<ProfileState> emit) async{
    try{
      emit(const ProfileLoadingState());
      final name = event.name.trim();
      final phone = event.phoneNo.trim();
      if(imageData.type != ImageType.asset && name.isNotEmpty && phone.isPhone){
        await repo.updateProfile().then((value) {
          emit(const ProfileSuccessState());
          emit(GetProfileState(data: value));
        });
      }else{
        emit(ProfileFormValidationError(
            image: imageData.type == ImageType.asset ? 'Please select your profile picture' : '',
            name: name.isNotEmpty ? '': 'Please enter your name',
            phone: phone.isPhone ? '':'Please enter valid mobile number'
        ));
      }
    }catch(e){
      emit(ProfileFailureState(message: e.toString()));
    }
  }

  FutureOr<void> _changeProfileImage(ChangeProfileImageEvent event, Emitter<ProfileState> emit) async{
    imageData = event.data;
    emit(ProfileInitial());
  }
}
