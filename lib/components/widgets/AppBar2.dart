import 'package:flutter/material.dart';

import '../constants/AppFonts.dart';
import '../constants/AppIcons.dart';
import '../coreComponents/ImageView.dart';
import '../coreComponents/TextView.dart';

class AppBar2 extends StatelessWidget {
  final EdgeInsets? padding;
  final String? leadIcon;
  final bool isLeadVisible;
  final double? leadIconSize;
  final Function()? onLeadTap;
  final Widget? tail;
  final String? title;
  final TextStyle? titleStyle;
  const AppBar2({super.key, this.padding, this.leadIcon, this.onLeadTap, this.leadIconSize, this.tail, this.isLeadVisible = true, this.title, this.titleStyle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.all(AppFonts.s16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Visibility(
            visible: isLeadVisible,
            child: ImageView(
              onTap: onLeadTap,
                url: leadIcon ?? AppIcons.backButton,
              size: leadIconSize ?? AppFonts.s20,
              margin:   const EdgeInsets.only(right: AppFonts.s10),
            ),
          ),
          Expanded(child: TextView(text: title ?? '', textStyle: titleStyle,)),
          SizedBox(child: tail)
        ],
      ),
    );
  }
}
