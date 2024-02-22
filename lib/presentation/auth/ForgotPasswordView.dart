import 'package:expense_calc/components/widgets/AppBar2.dart';
import 'package:expense_calc/utils/AppExtensions.dart';
import 'package:flutter/material.dart';

import '../../components/constants/AppFonts.dart';
import '../../components/constants/AppStrings.dart';
import '../../components/constants/TextStyles.dart';
import '../../components/coreComponents/AppButton.dart';
import '../../components/coreComponents/EditText.dart';
import '../../components/coreComponents/TextView.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppBar2(
              isLeadVisible: true,
              onLeadTap: context.pop,
              title: AppStrings.forgotPassword,
              titleStyle: TextStyles.semiBold20Black,
            ),
           Expanded(
             child: Padding(
               padding: const EdgeInsets.symmetric(horizontal: AppFonts.s20),
               child: Column(
                 children: [
                   const Spacer(),
                   const TextView(text: AppStrings.forgotPasswordSubtitleDesc, textStyle: TextStyles.medium14Black,),
                    EditText(
                        margin: const EdgeInsets.symmetric(vertical: AppFonts.s20),
                        hint: AppStrings.enterYourEmailAddress,
                        controller: TextEditingController()),
                    const AppButton(
                      margin: EdgeInsets.symmetric(vertical: AppFonts.s40),
                      label: AppStrings.continuee,
                      labelStyle: TextStyles.medium14White,
                    ),
                    const Spacer(),
                 ],
               ),
             ),
           ),
          ],
        ),
      ),
    );
  }
}
