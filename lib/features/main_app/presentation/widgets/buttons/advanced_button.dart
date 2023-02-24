import 'package:flutter/material.dart';
import 'package:lifestep/features/tools/config/main_colors.dart';
import 'package:lifestep/features/tools/config/styles.dart';

class MainAdvancedButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final Color? buttonColor;
  final Color? textColor;
  final TextStyle? textStyle;
  final double? horizontal;
  final double? vertical;
  final double? borderRadius;


  const MainAdvancedButton({Key? key, this.onTap, required this.text, this.buttonColor, this.textColor, this.horizontal, this.vertical, this.borderRadius, this.textStyle, }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal ?? 24, vertical: vertical ?? 24),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: buttonColor ?? MainColors.primaryColor,
            borderRadius: borderRadius != null ? BorderRadius.circular(borderRadius!) : BorderRadius.circular(100),
          ),
          child: Center(child: Text(text, textAlign: TextAlign.center, style: textStyle ?? MainStyles.boldTextStyle.copyWith(color: textColor ?? MainColors.black),)),
        ),
      ),
    );
  }
}

class MainAdvancedChildButton extends StatelessWidget {
  final Function()? onTap;
  final Widget child;
  final Color? buttonColor;
  final Color? textColor;
  final double? horizontal;
  final double? vertical;
  final double? borderRadius;
  final EdgeInsets? mainPadding;


  const MainAdvancedChildButton({Key? key, this.onTap, required this.child, this.buttonColor, this.textColor, this.horizontal, this.vertical, this.borderRadius, this.mainPadding, }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontal ?? 24, vertical: vertical ?? 24),
      child: GestureDetector(
        onTap: (){
          onTap!;
        },
        child: Container(
          width: double.infinity,

          padding: mainPadding ?? const EdgeInsets.fromLTRB(10, 16, 10, 16),
          decoration: BoxDecoration(
            color: buttonColor ?? MainColors.primaryColor,
            borderRadius: BorderRadius.circular(borderRadius ?? 20),
          ),
          child: child,
        ),
      ),
    );
  }
}