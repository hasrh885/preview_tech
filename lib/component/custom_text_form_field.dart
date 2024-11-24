import 'package:denomination/resources/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final TextStyle? hintStyle;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final TextAlign? textAlign;
  final bool? showCursor;
  final bool? readOnly;
  final GestureTapCallback? onTap;
  final ValueChanged<String>? onChanged;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool? obscureText;
  final BorderRadius? borderRadius;
  final BorderSide? borderSide;
  final String? labelText;
  final double? height;
  final double? width;
  final bool? required;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final EdgeInsetsGeometry? contentPadding;
  final FocusNode? focusNode;
  final Widget? suffix;
  final int? maxLines;

  const CustomTextFormField({
    Key? key,
    this.hintText,
    this.hintStyle,
    required this.controller,
    this.validator,
    this.textAlign = TextAlign.left,
    this.showCursor = true,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureText = false,
    this.borderRadius,
    this.borderSide,
    this.labelText,
    this.height,
    this.width,
    this.required = false,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.onChanged,
    this.inputFormatters,
    this.contentPadding,
    this.focusNode,
    this.suffix,
    this.maxLines = 1
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText ?? false,
      textAlign: textAlign!,
      focusNode: focusNode,
      cursorColor: lightBlue,
      showCursor: showCursor ?? true,
      readOnly: readOnly ?? false,
      keyboardType: keyboardType ?? TextInputType.text,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      onChanged: onChanged,
      maxLines: maxLines,
      style: TextStyle(
          color: white,
          fontSize: 18
      ),
      decoration: InputDecoration(
        isDense: true,
        fillColor: fillColor,
        filled: true,
        labelText: labelText ?? '',
        hintText: hintText ?? '',
        hintStyle: hintStyle ?? TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderSide: borderSide ?? BorderSide(color: Colors.grey),
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: borderSide ?? BorderSide(color: Colors.grey),
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: borderSide ?? BorderSide(color: Colors.blue),
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        suffix: suffix,
        contentPadding: contentPadding ?? EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      ),
      onTap: onTap,
    );
  }
}
