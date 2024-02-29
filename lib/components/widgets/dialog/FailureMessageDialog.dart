import 'package:expense_calc/components/constants/AppColors.dart';
import 'package:expense_calc/utils/AppExtensions.dart';
import 'package:flutter/material.dart';

import '../../constants/AppFonts.dart';
import '../../constants/AppIcons.dart';
import '../../constants/TextStyles.dart';
import '../../coreComponents/AppButton.dart';
import '../../coreComponents/ImageView.dart';
import '../../coreComponents/TextView.dart';

class FailureMessageDailog extends StatelessWidget {
  final Function()? onTap;
  final String message;
  final Function()? dismiss;
  const FailureMessageDailog({super.key, this.onTap, this.dismiss, required this.message});

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        context.isPortraitMode ? mainView() : Expanded(child: SingleChildScrollView(
          child: mainView(),
        ))
      ],
    );
  }

  Widget  mainView(){
    return  Column(
      children: [
       const  ImageView(url: AppIcons.exclamation,
          tintColor: AppColors.primaryColor,
          size: AppFonts.s40 * 2,),
        TextView(text: message, textStyle: TextStyles.regular16Black,
          textAlign: TextAlign.center,
          margin: const EdgeInsets.only(top: AppFonts.s10, bottom: AppFonts.s30),
        ),

        AppButton(
          padding: const EdgeInsets.symmetric(horizontal: AppFonts.s40,vertical: AppFonts.s16) ,
          onTap: onTap,
          label: 'OK',
          labelStyle: TextStyles.medium14White,
        )
      ],
    );

  }
}
