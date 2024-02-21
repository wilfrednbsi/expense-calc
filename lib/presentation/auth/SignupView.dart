import 'package:expense_calc/utils/AppExtensions.dart';
import 'package:flutter/material.dart';

import '../../components/constants/AppFonts.dart';
import '../../components/constants/AppStrings.dart';
import '../../components/constants/TextStyles.dart';
import '../../components/coreComponents/AppButton.dart';
import '../../components/coreComponents/EditText.dart';
import '../../components/coreComponents/TextView.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: AppFonts.s20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextView(text: AppStrings.createAccount, textStyle: TextStyles.semiBold16Black,),
            EditText(
                margin: const EdgeInsets.symmetric(vertical: AppFonts.s20),
                hint: AppStrings.enterYourEmailAddress,
                controller: TextEditingController()
            ),
            EditText(
                hint: AppStrings.password,
                controller: TextEditingController(),
              isPassword: true,
            ),
            EditText(
                hint: AppStrings.confirmPassword,
                controller: TextEditingController(),
              isPassword: true,
              margin: const EdgeInsets.only(top: AppFonts.s20),
            ),
            const AppButton(
              margin: EdgeInsets.symmetric(vertical: AppFonts.s40),
              label: AppStrings.continuee,
              labelStyle: TextStyles.medium14White,
            ),
             Row(
              children: [
                const TextView(text: AppStrings.haveAnAccount, textStyle: TextStyles.medium14Black,),
                TextView(
                  onTap: context.pop,
                  text: AppStrings.login, textStyle: TextStyles.semiBold14Primary,)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
