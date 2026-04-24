import 'package:flutter/material.dart';
import 'package:superapp/Themes/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;
  final String? suffixText;
  final IconData? suffixIcon;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.obscureText = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.validator,
    this.suffixText,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.40)),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontFamily: 'SF Pro',
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: 'SF Pro',
          ),
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: Colors.white, size: 20)
              : null,
          suffixText: suffixText,
          suffixStyle: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: 'SF Pro',
          ),
          suffixIcon: suffixIcon != null
              ? Icon(suffixIcon, color: Colors.white, size: 20)
              : null,
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
