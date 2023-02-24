
import 'package:flutter/material.dart';
import 'package:lifestep/features/tools/config/main_colors.dart';
import 'package:shimmer/shimmer.dart';

class SkeltonWidget extends StatefulWidget {
  final double? height, width, borderRadius;
  final Color? color;
  final EdgeInsets? padding;
  const SkeltonWidget({Key? key, this.height, this.width, this.borderRadius, this.color, this.padding}) : super(key: key);

  @override
  _SkeltonWidgetState createState() => _SkeltonWidgetState();
}

class _SkeltonWidgetState extends State<SkeltonWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(0),
      child: Shimmer.fromColors(
        highlightColor: widget.color != null ? widget.color!.withOpacity(0.4) : MainColors.middleGrey150!.withOpacity(0.5),
        baseColor: widget.color ?? MainColors.middleGrey150!,
        child: Container(
          height: widget.height,
          width: widget.width,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: widget.color ?? MainColors.middleGrey150,
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 16),
            shape: BoxShape.rectangle,
            // gradient: LinearGradient(
            //   begin: Alignment.centerLeft,
            //   end: Alignment.centerRight,
            //   colors: [
            //     Color(0xfff6f7f9),
            //     Color(0xffe9ebee),
            //     Color(0xfff6f7f9),
            //     // Color(0xfff6f7f9),
            //   ],
            // ),
          ),
        ),
      ),
    );
  }
}
