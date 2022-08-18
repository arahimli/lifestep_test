import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/src/models/challenge/challenges.dart';
import 'package:lifestep/src/ui/challenges/challenge/logic/step/state.dart';
import 'package:lifestep/src/resources/challenge.dart';
import 'package:pedometer/pedometer.dart';

import 'package:jiffy/jiffy.dart';



class StepSectionCubit extends Cubit<StepSectionState> {
  final ChallengeRepository challengeRepository;
  final ChallengeModel challengeModel;
  final int step;
  int stepLocal = 0;
  String statusLocal = '';
  bool firstTime = true;
  int firstStep = 0;

  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;



  late int todaySteps;

  Future<int> getTodaySteps(int value) async {
    //////// print(value);
    int savedStepsCountKey = 999999;
    int savedStepsCount = 0;

    int todayDayNo = Jiffy(DateTime.now()).dayOfYear;
    if (value < savedStepsCount) {
      // Upon device reboot, pedometer resets. When this happens, the saved counter must be reset as well.
      savedStepsCount = 0;
      // persist this value using a package of your choice here
    }

    // load the last day saved using a package of your choice here
    int lastDaySavedKey = 0;

    // When the day changes, reset the daily steps count
    // and Update the last day saved as the day changes.

    // setState(() {
      todaySteps = value - savedStepsCount;
    // });
    return todaySteps; // this is your daily steps value.
  }


  StepSectionCubit( {required this.challengeRepository, required this.challengeModel, required this.step}) : super(StepSectionState(step: step)){
    stepLocal = step;
    initPlatformState();
  }


  changeState(int stepValue, String statusValue, ) async {
    emit(StepSectionState(step: stepValue, status: statusValue, ));
  }

  void initPlatformState() async{
      _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
      _pedestrianStatusStream
          .listen(onPedestrianStatusChanged)
          .onError(onPedestrianStatusError);
      _stepCountStream = Pedometer.stepCountStream;
      _stepCountStream.listen(onStepCount)
          .onError(onStepCountError);

  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    // //////// print(event);
    //   statusLocal = event.status;
      // emit(StepSectionState(step: stepLocal, status: event.status));

  }
  void onStepCount(StepCount event) {
      if(firstTime){
        firstTime =  false;
        firstStep =  event.steps;
      }
      stepLocal = event.steps - firstStep;
      emit(StepSectionState(step: stepLocal, status: statusLocal));
  }

  void onPedestrianStatusError(error) {
    /// Handle the error
  }

  void onStepCountError(error) {
    /// Handle the error
  }


}
