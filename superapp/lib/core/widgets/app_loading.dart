import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:superapp/Themes/app_colors.dart';

class AppLoading extends StatelessWidget {
  final double? radius;
  final Color? color;

  const AppLoading({
    super.key,
    this.radius,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoActivityIndicator(
        radius: radius ?? 10,
        color: color ?? Colors.white,
      );
    }
    return CircularProgressIndicator(
      strokeWidth: 3,
      valueColor: AlwaysStoppedAnimation<Color>(
        color ?? AppColors.btnColor,
      ),
    );
  }
}
