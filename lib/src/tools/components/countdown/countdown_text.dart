import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:lifestep/src/tools/common/utlis.dart';
import 'package:lifestep/src/tools/config/styles.dart';
import 'package:sprintf/sprintf.dart';

class CountdownText extends StatefulWidget {
  final CountdownTimerController controller;
  const CountdownText({Key? key, required this.controller}) : super(key: key);

  @override
  State<CountdownText> createState() => _CountdownTextState();
}

class _CountdownTextState extends State<CountdownText> {
  @override
  Widget build(BuildContext context) {
    return CountdownTimer(
      controller: widget.controller,
      widgetBuilder: (_, CurrentRemainingTime? time) {
        if (time == null) {
          return Text(
            sprintf(
                '%s %s %s%s:%s%s:%s%s',
                [
                  '0', Utils.getString(context, "general_days_long").toUpperCase(),
                  '00', '',
                  '00', '',
                  '00', '',
                ]
            ),
            style: MainStyles.boldTextStyle.copyWith(fontSize: 12),
          );
        }
        return Text(
          sprintf(
              '%s %s %s%s:%s%s:%s%s',
              [
                time.days ?? '0', Utils.getString(context, "general_days_long").toUpperCase(),
                time.hours != null ? time.hours.toString().padLeft(2, '0') : '00', '',
                time.min != null ? time.min.toString().padLeft(2, '0') : '00', '',
                time.sec != null ? time.sec.toString().padLeft(2, '0') : '00', '',
              ]
          ),
          style: MainStyles.boldTextStyle.copyWith(fontSize: 12),
        );
      },
    );
  }
}
