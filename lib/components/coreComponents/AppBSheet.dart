 import 'package:flutter/material.dart';

import '../constants/AppColors.dart';
import '../constants/AppFonts.dart';

appBSheet(BuildContext context, Widget child,{Color? barrierColor}){
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,

        barrierColor: barrierColor,
        backgroundColor: AppColors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(AppFonts.s30),
              topLeft: Radius.circular(AppFonts.s30)
          ),
        ),
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
                top: AppFonts.s20,
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: child,
          );});
 }
