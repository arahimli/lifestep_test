import 'package:flutter/material.dart';
import 'package:lifestep/config/main_colors.dart';
import 'package:lifestep/config/styles.dart';

class BigUnBorderedButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final Color? buttonColor;
  final Color? textColor;
  final TextStyle? textStyle;
  final double? horizontal;
  final double? vertical;
  final double? borderRadius;
  const BigUnBorderedButton({Key? key, this.onTap, required this.text, this.buttonColor, this.textColor, this.textStyle, this.horizontal, this.vertical, this.borderRadius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.yellow,
      padding: EdgeInsets.symmetric(horizontal: horizontal ?? 0, vertical: vertical ?? 0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 64,
          decoration: BoxDecoration(
            color: buttonColor ?? MainColors.generalSubtitleColor,
            borderRadius: borderRadius != null ? BorderRadius.circular(borderRadius!) : BorderRadius.circular(100),
          ),
          child: Center(child: Text(text, textAlign: TextAlign.center, style: textStyle ?? MainStyles.boldTextStyle.copyWith(color: textColor ?? MainColors.white),)),
        ),
      ),
    );
  }
}
