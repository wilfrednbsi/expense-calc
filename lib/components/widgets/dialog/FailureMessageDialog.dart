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
        Align(
          alignment: Alignment.centerRight,
          child: ImageView(
            onTap: dismiss,
            url:
            // AppIcons.cancelCross,
            AppIcons.remove,
            size: AppFonts.s20,
          ),
        ),

        context.isPortraitMode ? mainView() : Expanded(child: SingleChildScrollView(
          child: mainView(),
        ))
      ],
    );
  }

  Widget  mainView(){
    return  Column(
      children: [
        ImageView(url:
        AppIcons.remove,
        // AppIcons.help,
          size: AppFonts.s40 * 2,),
        // TextView(text: AppStrings.upgradeRequired, textStyle: TextStyles.semiBold20Black,
        //   margin: EdgeInsets.only(top: AppFonts.s16),
        // ),
        TextView(text: message, textStyle: TextStyles.regular16Black,
          textAlign: TextAlign.center,
          margin: EdgeInsets.only(top: AppFonts.s10, bottom: AppFonts.s30),
        ),

        AppButton(
          padding: EdgeInsets.symmetric(horizontal: 40,vertical: 5) ,
          onTap: onTap,
          label: 'OK',
          labelStyle: TextStyles.medium14White,
        )
        // TextBtn(
        //   padding: EdgeInsets.symmetric(horizontal: 40,vertical: 5) ,
        //     onTap: onTap,
        //     label: AppStrings.ok, textStyle: TextStyles.regular17White),
      ],
    );

  }
}
