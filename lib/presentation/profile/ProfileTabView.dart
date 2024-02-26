import 'package:expense_calc/components/constants/constants.dart';
import 'package:expense_calc/components/widgets/AppBar2.dart';
import 'package:expense_calc/components/widgets/EditProfileImage.dart';
import 'package:expense_calc/model/ImageDataModel.dart';
import 'package:expense_calc/presentation/auth/LoginView.dart';
import 'package:expense_calc/presentation/profile/ChangePassword.dart';
import 'package:expense_calc/presentation/profile/EditProfile.dart';
import 'package:expense_calc/utils/AppExtensions.dart';
import 'package:expense_calc/viewController/profile/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/constants/AppColors.dart';
import '../../components/constants/AppFonts.dart';
import '../../components/constants/AppStrings.dart';
import '../../components/constants/TextStyles.dart';
import '../../components/coreComponents/TextView.dart';

class ProfileTabView extends StatefulWidget {
  const ProfileTabView({super.key});

  @override
  State<ProfileTabView> createState() => _ProfileTabViewState();
}

class _ProfileTabViewState extends State<ProfileTabView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar2(
          title: AppStrings.profile,
          titleStyle: TextStyles.bold22Black,
          isLeadVisible: false,
          tail: TextView(
            onTap: () => context.pushNavigator(const EditProfile()),
            text: AppStrings.settings,
            textStyle: TextStyles.semiBold14Primary,
          ),
        ),
        mainForm(context: context)
      ],
    );
  }

  Widget mainForm({required BuildContext context}) {
    return Expanded(
        child: SingleChildScrollView(
      padding: const EdgeInsets.all(AppFonts.s16),
      child: Column(
        children: [
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              final bloc = context.read<ProfileBloc>();
              final data = bloc.getProfileData;
              return Column(
                children: [
                  EditProfileImage(
                    size: 110,
                    imageData: bloc.getImageData,
                    isEditable: false,
                    margin: const EdgeInsets.only(bottom: AppFonts.s30),
                  ),
                  _EntityTile(
                    title: AppStrings.fullName,
                    value: data.name ?? '',
                  ),
                  _EntityTile(
                    title: AppStrings.emailAddress,
                    value: data.email ?? '',
                  ),
                  _EntityTile(
                    title: AppStrings.phoneNumber,
                    value: data.phone ?? '',
                  ),
                ],
              );
            },
          ),
          TextView(
            onTap: () => context.pushNavigator(const ChangePassword()),
            text: AppStrings.changePassword,
            textStyle: TextStyles.semiBold14Primary,
            margin: const EdgeInsets.only(top: AppFonts.s30),
          ),
          TextView(
            onTap: () => context.pushAndClearNavigator(const LoginView()),
            text: AppStrings.logout,
            textStyle: TextStyles.semiBold14Primary,
            margin: const EdgeInsets.only(top: AppFonts.s10),
          )
        ],
      ),
    ));
  }
}

class _EntityTile extends StatelessWidget {
  final String title;
  final String value;

  const _EntityTile({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.symmetric(vertical: AppFonts.s10),
      padding: const EdgeInsets.symmetric(
          horizontal: AppFonts.s10, vertical: AppFonts.s14),
      decoration: BoxDecoration(
          color: AppColors.grey40.withOpacity(0.2),
          borderRadius: BorderRadius.circular(AppFonts.s10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextView(
            text: title,
            textStyle: TextStyles.regular10TextGrey,
          ),
          TextView(
            text: value,
            textStyle: TextStyles.regular14Black,
            margin: const EdgeInsets.only(top: AppFonts.s7),
          )
        ],
      ),
    );
  }
}
