import 'package:expense_calc/components/constants/AppFonts.dart';
import 'package:expense_calc/components/coreComponents/TextView.dart';
import 'package:flutter/material.dart';

import '../../components/constants/AppStrings.dart';
import '../../components/constants/TextStyles.dart';
import '../../components/coreComponents/AppButton.dart';
import '../../components/coreComponents/EditText.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: AppFonts.s20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextView(text: AppStrings.log_in_toYourAccount, textStyle: TextStyles.semiBold16Black,),
            EditText(
              margin: const EdgeInsets.symmetric(vertical: AppFonts.s20),
              hint: AppStrings.enterYourEmailAddress,
                controller: TextEditingController()),
            EditText(
                hint: AppStrings.enterYourPassword,
                controller: TextEditingController()),
            const AppButton(
              margin: EdgeInsets.symmetric(vertical: AppFonts.s40),
              label: AppStrings.login,
              labelStyle: TextStyles.medium14White,
            ),

            const Row(
              children: [
                TextView(text: AppStrings.ddntHaveAccount, textStyle: TextStyles.medium14Black,),
                TextView(text: AppStrings.createNew, textStyle: TextStyles.semiBold14Primary,)
              ],
            ),

            const TextView(text: AppStrings.forgotPassword,
            textStyle: TextStyles.semiBold14Primary,
            margin: EdgeInsets.only(top: AppFonts.s10),
            )
          ],
        ),
      ),
    );
  }
}
