import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/AppColors.dart';
import '../constants/AppFonts.dart';
import '../constants/TextStyles.dart';

class EditText extends StatefulWidget {
  final TextEditingController controller;
  final bool? readOnly;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? radius;
  final Color? borderColor;
  final Color? filledColor;
  final bool isFilled;
  final bool isPassword;
  final String? hint;
  final String? error;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final Function(String)? onChange;
  final Function()? onTap;
  final List<TextInputFormatter>? format;
  final TextInputType? inputType;
  const EditText({super.key, required this.controller, this.readOnly, this.padding, this.margin, this.radius, this.borderColor, this.filledColor, this.isFilled = true, this.hint, this.hintStyle, this.textStyle, this.error,  this.isPassword = false, this.onChange, this.format, this.inputType, this.onTap});

  @override
  State<EditText> createState() => _EditTextState();
}

class _EditTextState extends State<EditText> {

  @override
  Widget build(BuildContext context) {
    final borderStyle = _borderStyle(borderColor: widget.borderColor,radius: widget.radius);
    return Padding(
      padding: widget.margin ?? EdgeInsets.zero,
      child: TextField(
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onTap: widget.onTap,
        style: widget.textStyle ?? TextStyles.regular14Black,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: widget.hintStyle ?? TextStyles.regularTextHint,
          filled: widget.isFilled,
          fillColor: widget.filledColor ?? AppColors.transparent,
          // enabledBorder: borderStyle,
          // border: borderStyle,
          // focusedBorder: borderStyle,
            errorText: widget.error != null && widget.error!.trim().isEmpty
                ? null
                : widget.error
        ),
        inputFormatters: widget.format,
        keyboardType: widget.inputType,
        obscureText: widget.isPassword,
        readOnly: widget.readOnly ?? false,
        controller: widget.controller,
        onChanged: widget.onChange,
      ),
    );
  }
}

InputBorder _borderStyle({double? radius, Color? borderColor}){
  return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius??AppFonts.s10),
      borderSide: BorderSide(color:borderColor?? AppColors.primaryGreen, width: 2));
}
