import 'package:flutter/material.dart';
import '../../global/extensions.dart';

class BaseTextField extends StatelessWidget {
  final Widget prefixIcon;
  final String labelText;
  final String hintText;
  final String errorText;
  final bool autofocus;
  final bool obscureText;
  final TextInputType keyboardType;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final Function onSubmitted;
  final Function onChanged;
  const BaseTextField({
    Key key,
    this.prefixIcon,
    @required this.labelText,
    this.hintText,
    this.errorText,
    this.autofocus = false,
    this.obscureText = false,
    this.keyboardType,
    this.focusNode,
    this.textInputAction,
    this.controller,
    this.onSubmitted,
    this.onChanged,
  })  : assert(labelText != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        labelText: labelText,
        hintText: hintText,
        errorText: errorText,
        labelStyle: TextStyle(
          color: context.accentColor,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: context.accentColor, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: context.accentColor, width: 1.0),
        ),
        errorStyle: TextStyle(
          color: context.accentColor,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: context.accentColor, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: context.accentColor, width: 1.0),
        ),
      ),
      autofocus: autofocus,
      obscureText: obscureText,
      cursorColor: context.accentColor,
      keyboardType: keyboardType,
      focusNode: focusNode,
      textInputAction: textInputAction,
      controller: controller,
      onSubmitted: onSubmitted,
      onChanged: onChanged,
    );
  }
}
