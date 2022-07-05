import 'dart:async';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:lifestep/pages/test/color.dart';
import 'package:pedometer/pedometer.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:intl/intl.dart';


class StepsTrackerScreen extends StatefulWidget {
  @override
  _StepsTrackerScreenState createState() => _StepsTrackerScreenState();
}

class _StepsTrackerScreenState extends State<StepsTrackerScreen>{
  bool? isPause = true;


  int? targetSteps;
  TextEditingController targetStepController = TextEditingController();

  int? totalSteps = 0;
  int? currentStepCount = 0 ;
  int? oldStepCount = 0;

  double? distance;

  String? duration;
  int? time;
  int? oldTime;

  double? calories;
  int? height;
  int? weight;

  bool? isKmSelected = true;
  // ignore: cancel_subscriptions
  StreamSubscription<StepCount>? _stepCountStream;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );
  List<String> allDaysInSingleWord =
      DateFormat.EEEE('en').dateSymbols.NARROWWEEKDAYS;

  List<String> weekDates = [];

  int? last7DaysSteps;


  @override
  void initState() {
    calculateDistance();
    super.initState();
  }



  DateTime currentDate = DateTime.now();

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  Map<String, int> map = {};

  List<double>? stepsPercentValue = [];

  @override
  Widget build(BuildContext context) {
    var fullHeight = MediaQuery.of(context).size.height;
    var fullWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colur.common_bg_dark,
      body: SafeArea(
          child: Container(
            child: Column(
              children: [

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        buildStepIndiactorRow(context, fullHeight, fullWidth),

                        Container(
                          margin: EdgeInsets.only(top: fullHeight * 0.08),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildWeekCircularIndicator(
                                  fullHeight,
                                  allDaysInSingleWord[1],
                                  stepsPercentValue!.isNotEmpty
                                      ? stepsPercentValue![0]
                                      : 0.0),
                              buildWeekCircularIndicator(
                                  fullHeight,
                                  allDaysInSingleWord[2],
                                  stepsPercentValue!.isNotEmpty
                                      ? stepsPercentValue![1]
                                      : 0.0),
                              buildWeekCircularIndicator(
                                  fullHeight,
                                  allDaysInSingleWord[3],
                                  stepsPercentValue!.isNotEmpty
                                      ? stepsPercentValue![2]
                                      : 0.0),
                              buildWeekCircularIndicator(
                                  fullHeight,
                                  allDaysInSingleWord[4],
                                  stepsPercentValue!.isNotEmpty
                                      ? stepsPercentValue![3]
                                      : 0.0),
                              buildWeekCircularIndicator(
                                  fullHeight,
                                  allDaysInSingleWord[5],
                                  stepsPercentValue!.isNotEmpty
                                      ? stepsPercentValue![4]
                                      : 0.0),
                              buildWeekCircularIndicator(
                                  fullHeight,
                                  allDaysInSingleWord[6],
                                  stepsPercentValue!.isNotEmpty
                                      ? stepsPercentValue![5]
                                      : 0.0),
                              buildWeekCircularIndicator(
                                  fullHeight,
                                  allDaysInSingleWord[0],
                                  stepsPercentValue!.isNotEmpty
                                      ? stepsPercentValue![6]
                                      : 0.0),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),

              ],
            ),
          )
      ),
    );
  }


  buildWeekCircularIndicator(double fullHeight, String weekDay, double value) {
    return Column(
      children: [
        CircularProgressIndicator(
          strokeWidth: 5,
          value: value,
          valueColor: AlwaysStoppedAnimation(Colur.txt_green),
          backgroundColor: Colur.progress_background_color,
        ),
        Container(
          margin: EdgeInsets.only(top: fullHeight * 0.02),
          child: Text(
            weekDay,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colur.txt_white),
          ),
        ),
      ],
    );
  }

  buildStepIndiactorRow(
      BuildContext context, double fullHeight, double fullWidth) {
    return Container(
      margin: EdgeInsets.only(
        left: fullWidth * 0.02,
        right: fullWidth * 0.02,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                isPause = !isPause!;
              });

              Future.delayed(Duration(milliseconds: 100), () {
                if (isPause == true) {
                  if (currentStepCount! > 0) {
                    currentStepCount = currentStepCount! - 1;
                  }else {
                    currentStepCount = 0;
                  }
                  _stopWatchTimer.onExecute.add(StopWatchExecute.start);
                  countStep();
                } else {
                  _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                  _stepCountStream!.cancel();
                }
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colur.progress_background_color,
                  ),
                ),

              ],
            ),
          ),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                margin: EdgeInsets.only(top: fullHeight * 0.02),
                width: fullWidth * 0.7,
                height: fullHeight * 0.3,
                child: stepsIndicator(),
              ),
              isPause!
                  ? Text(
                "txtSteps",
                style: TextStyle(
                    color: Colur.txt_green,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              )
                  : Container(
                padding: EdgeInsets.all(8),
                height: 30,
                width: 80,
                decoration: BoxDecoration(
                  color: Colur.progress_background_color,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    "txtPaused",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colur.txt_white,
                        fontSize: 14,
                        fontWeight: FontWeight.w300),
                  ),
                ),
              )
            ],
          ),

          InkWell(
            onTap: () {

            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colur.progress_background_color,
                  ),
                ),
                Image.asset(
                  "assets/icons/ic_statistics.png",
                  height: 15,
                  width: 19,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  editTargetStepsBottomDialog(double fullHeight, double fullWidth) {
    return showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colur.white,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: fullHeight * 0.5,
            color: Colur.common_bg_dark,
            child: Container(
              decoration: new BoxDecoration(
                  color: Colur.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32))),
              child: Container(
                margin: EdgeInsets.symmetric(
                    vertical: fullHeight * 0.04, horizontal: fullWidth * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "txtEditTargetSteps",
                      style: TextStyle(
                          color: Colur.txt_black,
                          fontSize: 24,
                          fontWeight: FontWeight.w700),
                    ),

                    SizedBox(height: fullHeight * 0.01),

                    Text(
                      "txtEditStepsTargetDesc",
                      style: TextStyle(
                          color: Colur.txt_grey,
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                    ),

                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: fullHeight * 0.04),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "txtSteps",
                              style: TextStyle(
                                  color: Colur.txt_black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600),
                            ),
                            Container(
                              height: 60,
                              width: 167,
                              decoration: BoxDecoration(
                                  color: Colur.txt_grey,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                              child: TextFormField(
                                maxLines: 1,
                                maxLength: 7,
                                controller: targetStepController,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                style: TextStyle(
                                    color: Colur.txt_white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700),
                                cursorColor: Colur.txt_white,
                                decoration: InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                ),
                                onEditingComplete: () {
                                  FocusScope.of(context).unfocus();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: fullHeight * 0.04),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 165,
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Colur.light_red_stop_gredient1,
                                Colur.light_red_gredient2
                              ]),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0.0, 25),
                                  spreadRadius: 2,
                                  blurRadius: 50,
                                  color: Colur.red_gradient_shadow,
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colur.transparent,
                              child: InkWell(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    Navigator.pop(context);
                                  },
                                  child: Center(
                                    child: Text(
                                      "txtCancel",
                                      style: TextStyle(
                                          color: Colur.txt_white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  )),
                            ),
                          ),

                          Container(
                            width: 165,
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Colur.green_gradient_color1,
                                Colur.green_gradient_color2
                              ]),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0.0, 25),
                                  spreadRadius: 2,
                                  blurRadius: 50,
                                  color: Colur.green_gradient_shadow,
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colur.transparent,
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      targetSteps =
                                          int.parse(targetStepController.text);
                                    });
                                    if (targetSteps! > 50) {
                                      FocusScope.of(context).unfocus();
                                      Navigator.pop(context);
                                    } else {
                                      //TODO
                                    }
                                  },
                                  child: Center(
                                    child: Text(
                                      "txtSave",
                                      style: TextStyle(
                                          color: Colur.txt_white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  )),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ).whenComplete(() {
      FocusScope.of(context).unfocus();
    });
  }

  stepsIndicator() {
    return Container(
      height: 200,
      width: 200,
      color: Colors.red,
      child: Center(
        child: Text(currentStepCount.toString(), style: TextStyle(color:Colors.white, fontSize: 100),)
      )
    );
  }

  countStep() {
    _stepCountStream = Pedometer.stepCountStream.listen((value) async {

      if (!mounted) {
        totalSteps = value.steps;

        currentStepCount = currentStepCount! + 1;
      } else{
        setState(() {
          totalSteps = value.steps;

          currentStepCount = currentStepCount! + 1;
        });
      }
      calculateDistance();
      calculateCalories();
      getTodayStepsPercent();
    }, onError: (error) {
      totalSteps = 0;
    }, cancelOnError: false);
  }

  getTodayStepsPercent() {
    var todayDate = getDate(DateTime.now()).toString();
    if (targetSteps == null) {
      targetSteps = 6000;
    }
    for (int i = 0; i < weekDates.length; i++) {
      if (todayDate == weekDates[i]) {
        if (!mounted){
          double value =
              currentStepCount!.toDouble() / targetSteps!.toDouble();
          if (value <= 1.0) {
            if (stepsPercentValue!.isNotEmpty) {
              stepsPercentValue![i] = value;
            }
          } else {
            stepsPercentValue![i] = 1.0;
          }
        }else{
          setState(() {
            double value =
                currentStepCount!.toDouble() / targetSteps!.toDouble();
            if (value <= 1.0) {
              if (stepsPercentValue!.isNotEmpty) {
                stepsPercentValue![i] = value;
              }
            } else {
              stepsPercentValue![i] = 1.0;
            }

          });
        }
      }
    }
  }




  calculateDistance() {
    if(!mounted) {
      if (isKmSelected!) {
        distance = currentStepCount! * 0.0008;
      } else {
        distance = currentStepCount! * 0.0008 * 0.6214;
      }
    } else {
      setState(() {
        if (isKmSelected!) {
          distance = currentStepCount! * 0.0008;
        } else {
          distance = currentStepCount! * 0.0008 * 0.6214;
        }
      });
    }
  }


  calculateCalories() {
    if(!mounted) {
      calories = currentStepCount! * 0.04;
    }else {
      setState(() {
        calories = currentStepCount! * 0.04;
      });
    }
  }



}
