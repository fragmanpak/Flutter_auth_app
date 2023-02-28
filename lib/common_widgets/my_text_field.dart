import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String? text;
  final Icon? icon;
  final Icon? eyeIcon;
  final bool? isReadOnly;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final Function? onSubmit;
  final TextInputType? keyBoardType;
  final Color? color;
  final TextEditingController controller;
  final VoidCallback? onSuffixTap;
  final ValueChanged<String>? onChanging;
  final TextStyle? hintStyle;
  final bool? isObscure;

  const MyTextField(
      {Key? key,
      this.hintStyle,
      this.text,
      this.color,
      this.eyeIcon,
      this.icon,
      this.keyBoardType,
      this.isObscure,
      this.isReadOnly,
      this.focusNode,
      this.nextFocus,
      this.onSubmit,
      required this.controller,
      this.onSuffixTap,
      this.onChanging})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanging,
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyBoardType,
      obscureText: isObscure != null ? isObscure! : false,
      readOnly: isReadOnly != null ? isReadOnly! : false,
      onSubmitted: (text) => nextFocus != null
          ? FocusScope.of(context).requestFocus(nextFocus)
          : onSubmit!(text),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
        filled: color == null ? false : true,
        fillColor: Theme.of(context).backgroundColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: color != null
              ? BorderRadius.circular(0)
              : BorderRadius.circular(2),
          borderSide: BorderSide(
            color: color != null ? color! : Theme.of(context).disabledColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: color != null
              ? BorderRadius.circular(0)
              : BorderRadius.circular(2),
        ),
        prefixIcon: icon,
        suffixIcon: eyeIcon != null
            ? IconButton(onPressed: onSuffixTap, icon: eyeIcon!)
            : null,
        hintStyle: hintStyle ?? TextStyle(color: Colors.grey[800]),
        hintText: text,
      ),
    );
  }
}
