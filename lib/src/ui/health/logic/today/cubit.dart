

import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/health.dart';
import 'package:lifestep/src/ui/health/logic/today/state.dart';
import 'package:lifestep/src/tools/constants/health/element.dart';

class HealthTodayCubit extends Cubit<HealthTodayState>{
  HealthTodayCubit() : super(HealthTodayLoading()) {
    fetchData();
  }

  List<HealthDataPoint> _healthDataList = [];

  // create a HealthFactory for use in the app
  HealthFactory health = HealthFactory();

  /// Fetch data points from the health plugin and show them in the app.
  Future fetchData() async {

    // define the types to get
    final types = Platform.isIOS ? TypesIOS : TypesAndroid;
    // with coresponsing permissions
    final permissions = types.map((e) => HealthDataAccess.READ).toList();
    int steps = 0;
    int stepsFull = 0;
    num calories = 0;
    num distance = 0;

    // get data within the last 24 hours
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    // requesting access to the data types before reading them
    // note that strictly speaking, the [permissions] are not
    // needed, since we only want READ access.
    bool requested = await health.requestAuthorization(types, permissions: permissions);

    if (requested) {
      try {
        // fetch health data
        // steps = await health.getTotalStepsInInterval(midnight, now);
        _healthDataList = await health.getHealthDataFromTypes(midnight, now, types);
        stepsFull = (await health.getTotalStepsInInterval(midnight, now)) ?? 0;
      } catch (error) {
        //////// print("Exception in getHealthDataFromTypes: $error");
      }

      // filter out duplicates
      // _healthDataList = HealthFactory.removeDuplicates(_healthDataList);

      // print the results

      _healthDataList.forEach((x) {
        // if(x.type == HealthDataType.ACTIVE_ENERGY_BURNED){
        //   //////// print(x.value);
        //   calories += x.value;
        // }

        if (Platform.isAndroid && x.type == HealthDataType.STEPS && x.sourceId.contains(":user_input")) {
          steps += x.value.toInt();
        }
        if (Platform.isIOS && x.type == HealthDataType.STEPS && x.sourceId.startsWith("com.apple.Health")) {
          steps += x.value.toInt();
        }
        if(Platform.isIOS && x.type == HealthDataType.BASAL_ENERGY_BURNED){
          //////// print(x.value);
          calories += x.value;
        }
        if(Platform.isAndroid && x.type == HealthDataType.ACTIVE_ENERGY_BURNED){
          //////// print(x.value);
          calories += x.value;
        }
        if(Platform.isIOS && x.type == HealthDataType.DISTANCE_WALKING_RUNNING){
          //////// print(x.value);
          distance += x.value;
        }
        if(Platform.isAndroid && x.type == HealthDataType.DISTANCE_DELTA){
          //////// print(x.value);
          distance += x.value;
        }
      });
        emit(HealthTodaySuccess(stepCount: stepsFull - steps, calories: calories, distance: distance));
    } else {
      //////// print("Authorization not granted");
      // setState(() =>
      emit(HealthTodayNotGranted());
      // _state = AppState.DATA_NOT_FETCHED;
      // );
    }
  }

}