import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lifestep/src/tools/components/countdown/countdown_text.dart';

class CountdownTagWidget extends StatefulWidget {
  final CountdownTimerController controller;
  final String? icon;
  const CountdownTagWidget({Key? key, required this.controller, this.icon}) : super(key: key);

  @override
  State<CountdownTagWidget> createState() => _CountdownTagWidgetState();
}

class _CountdownTagWidgetState extends State<CountdownTagWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(500),
        child: BackdropFilter(
          blendMode: BlendMode.plus,
          filter: ImageFilter.blur(
            sigmaX: -double.infinity / 2,
            sigmaY: 20,
            // tileMode: TileMode.decal
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10, ),
            color: Colors.white.withOpacity(0.5),
            child: Row(
              children: [
                SvgPicture.asset(widget.icon ?? "assets/svgs/general/time.svg"),
                const SizedBox(width: 8,),

                CountdownText(
                  controller: widget.controller,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
