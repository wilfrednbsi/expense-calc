import 'package:expense_calc/components/constants/AppFonts.dart';
import 'package:expense_calc/components/constants/AppStrings.dart';
import 'package:expense_calc/components/coreComponents/AppButton.dart';
import 'package:expense_calc/components/coreComponents/EditText.dart';
import 'package:expense_calc/components/widgets/AppBar2.dart';
import 'package:expense_calc/components/widgets/dialog/FailureMessageDialog.dart';
import 'package:expense_calc/utils/AppExtensions.dart';
import 'package:expense_calc/viewController/profile/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/constants/TextStyles.dart';
import '../../components/constants/constants.dart';
import '../../components/widgets/EditProfileImage.dart';
import '../../model/ImageDataModel.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  ProfileBloc profileBloc(BuildContext context){
    return context.read<ProfileBloc>();
  }

  @override
  void initState() {
    super.initState();
      profileBloc(context).add(ProfileClearErrorEvent());
      final data = profileBloc(context).getProfileData;
      profileBloc(context).getEdImageData;
      nameCtrl.text = data.name ?? '';
      phoneCtrl.text = data.phone ?? '';
      emailCtrl.text = data.email ?? '';
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppBar2(
              title: AppStrings.editProfile,
              titleStyle: TextStyles.bold22Black,
              onLeadTap: context.pop,
            ),
            mainForm(context: context)
          ],
        ),
      ),
    );
  }


  Widget mainForm({required BuildContext context}) {
    return Expanded(child: SingleChildScrollView(
      padding: const EdgeInsets.all(AppFonts.s16),
      child: Column(
        children: [
          BlocConsumer<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is ProfileLoadingState) {
                context.load;
              } else if (state is ProfileFailureState) {
                context.stopLoader;
                context.openFailureDialog(state.message);
              } else if (state is ProfileSuccessState) {
                context.stopLoader;
                context.pop();
              } else if (state is ProfileFormValidationError) {
                context.stopLoader;
              }
            },
            builder: (context, state) {
              ImageDataModel imageData = profileBloc(context).editImageData;
              final formErrorState = state is ProfileFormValidationError ? state : null;
              return Column(
                children: [
                  BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                      return EditProfileImage(
                        size: 110,
                        imageData: imageData,
                        margin: const EdgeInsets.only(bottom: AppFonts.s30),
                        onChange: (data)=>profileBloc(context).add(ChangeProfileImageEvent(data: data)),
                        error: formErrorState?.image ?? '',
                      );
                    },
                  ),

                  EditText(
                      hint: AppStrings.fullName,
                      controller: nameCtrl,
                    error: formErrorState?.name,
                  ),

                  EditText(
                    hint: AppStrings.phoneNumber,
                    controller: phoneCtrl,
                    margin: const EdgeInsets.symmetric(vertical: AppFonts.s20),
                    error: formErrorState?.phone,
                  ),

                  EditText(
                    hint: AppStrings.emailAddress,
                    controller: emailCtrl,
                    readOnly: true,
                  ),
                ],
              );
            },
          ),
          AppButton(
            onTap: ()=> profileBloc(context).add(UpdateProfileEvent(name: nameCtrl.text, phoneNo: phoneCtrl.text)),
            label: AppStrings.update,
            margin: const EdgeInsets.only(top: AppFonts.s40),
          )
        ],
      ),
    ));
  }
}
