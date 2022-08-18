

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/health.dart';
import 'package:lifestep/src/tools/constants/health/element.dart';
import 'package:lifestep/src/ui/health/logic/month/state.dart';
import 'package:rxdart/rxdart.dart';

class HealthMonthCubit extends Cubit<HealthMonthState>{
  HealthMonthCubit() : super(HealthMonthLoading()) {
    fetchData();
  }

  List<HealthDataPoint> _healthDataList = [];
  bool firstSuccess = false;
  ScrollController scrollController = ScrollController();
  int selectedMonth = DateTime.now().month;
  BehaviorSubject<List> monthlData = BehaviorSubject<List>.seeded([]);
  // create a HealthFactory for use in the app
  HealthFactory health = HealthFactory();

  /// Fetch data points from the health plugin and show them in the app.
  // fetchData() async {}
  Future fetchData() async {

    // define the types to get
    final types = Platform.isIOS ? TypesIOS : TypesAndroid;
    // with coresponsing permissions
    final permissions = types.map((e) => HealthDataAccess.READ).toList();
    int steps = 0;
    int stepsFull = 0;
    int? stepsDay = 0;
    int? stepsDayFull = 0;
    num calories = 0;
    num distance = 0;

    // get data within the last 24 hours
    DateTime now = DateTime.now();
    DateTime startOfMonthDate = DateTime(now.year, selectedMonth, 1, 0, 0, 1);
    // DateTime halfOfMonthDate = DateTime(now.year, selectedMonth, 15, 0, 0, 1);
    DateTime endOfMonthDate = selectedMonth == now.month ? now : DateTime(selectedMonth == 12 ? now.year + 1 : now.year, selectedMonth == 12 ? 1 : (selectedMonth + 1), 1,  0, 0, 1);

    // requesting access to the data types before reading them
    // note that strictly speaking, the [permissions] are not
    // needed, since we only want READ access.
    bool requested = await health.requestAuthorization(types, permissions: permissions);
    if (requested) {
      try {

        _healthDataList = await health.getHealthDataFromTypes(startOfMonthDate, endOfMonthDate, types);
        stepsFull = (await health.getTotalStepsInInterval(startOfMonthDate, endOfMonthDate)) ?? 0;
      } catch (error) {
        //////// print("Exception in getHealthDataFromTypes: $error");
      }

      _healthDataList = HealthFactory.removeDuplicates(_healthDataList);

      // print the results

      _healthDataList.forEach((x) {
        // if(x.type == HealthDataType.ACTIVE_ENERGY_BURNED){
        //   calories += x.value;
        // }

        if (Platform.isAndroid && x.type == HealthDataType.STEPS &&
            x.sourceId.contains(":user_input")) {
          steps += x.value.toInt();
        }
        if (Platform.isIOS && x.type == HealthDataType.STEPS &&
            x.sourceId.startsWith("com.apple.Health")) {
          steps += x.value.toInt();
        }


        if(Platform.isIOS && x.type == HealthDataType.BASAL_ENERGY_BURNED){
          calories += x.value;
        }
        if(Platform.isAndroid && x.type == HealthDataType.ACTIVE_ENERGY_BURNED){
          calories += x.value;
        }
        if(Platform.isIOS && x.type == HealthDataType.DISTANCE_WALKING_RUNNING){
          distance += x.value;
        }
        if(Platform.isAndroid && x.type == HealthDataType.DISTANCE_DELTA){
          distance += x.value;
        }
      });

      // //////// print("_healthDataList_healthDataList_healthDataList");
      // //////// print(_healthDataList.length);
      // //////// print(calories);
      // //////// print(distance);
      // //////// print(_healthDataList);
      // //////// print("_healthDataList_healthDataList_healthDataList");
      // if(_healthDataList.isEmpty)
      //   emit(HealthMonthError(errorCode: WEB_SERVICE_ENUM.UNEXCEPTED_ERROR));
      // else
        emit(HealthMonthSuccess(stepCount: stepsFull - steps, stepCountDay: stepsDay, calories: calories, distance: distance, selectedMonth: selectedMonth));
        await Future.delayed(Duration(milliseconds: 5));
        if(!firstSuccess){
          // scrollController.animateTo(scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 1), curve: Curves.easeOut);
        }
        firstSuccess = true;

    } else {
      //////// print("Authorization not granted");
      // setState(() =>
      emit(HealthMonthNotGranted());
      // _state = AppState.DATA_NOT_FETCHED;
      // );
    }
  }
  Future dateChanged(int selectedMonth) async{
    this.selectedMonth = selectedMonth;
    emit(HealthMonthSuccessLoading(selectedMonth: selectedMonth));
    fetchData();

  }
}