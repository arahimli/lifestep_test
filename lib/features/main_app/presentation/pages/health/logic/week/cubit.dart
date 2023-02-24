

import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/health.dart';
import 'package:lifestep/features/tools/constants/health/element.dart';
import 'package:lifestep/features/main_app/presentation/pages/health/logic/week/state.dart';

class HealthWeekCubit extends Cubit<HealthWeekState>{
  HealthWeekCubit() : super(HealthWeekLoading()) {
    fetchData();
  }

  List<HealthDataPoint> _healthWeekDayDataList = [];
  List<HealthDataPoint> _healthWeekDataList = [];
  DateTime selectedDate = DateTime.now();

  // create a HealthFactory for use in the app
  HealthFactory health = HealthFactory();

  /// Fetch data points from the health plugin and show them in the app.
  Future fetchData() async {

    // define the types to get
    final types = Platform.isIOS ? typesIOS : typesAndroid;
    // with coresponsing permissions
    final permissions = types.map((e) => HealthDataAccess.READ).toList();
    int stepsInputWeek = 0;
    int stepsInputWeekDay = 0;
    int stepsWeekFull = 0;
    int stepsWeekDayFull = 0;
    num calories = 0;
    num distance = 0;

    // get data within the last 24 hours
    DateTime now = DateTime.now();
    DateTime startOfWeekTime = now.subtract(Duration(days: (now.weekday - 1)));
    DateTime startOfWeekDate = DateTime(startOfWeekTime.year, startOfWeekTime.month, startOfWeekTime.day, );

    // requesting access to the data types before reading them
    // note that strictly speaking, the [permissions] are not
    // needed, since we only want READ access.
    bool requested = await health.requestAuthorization(types, permissions: permissions);

    if (requested) {
      try {
        // fetch health data
        _healthWeekDataList = await health.getHealthDataFromTypes(startOfWeekDate, now, types);
        _healthWeekDayDataList = await health.getHealthDataFromTypes(DateTime(selectedDate.year, selectedDate.month, selectedDate.day), DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 23, 59), types);

        stepsWeekFull = (await health.getTotalStepsInInterval(startOfWeekDate, now)) ?? 0;
        stepsWeekDayFull = (await health.getTotalStepsInInterval(DateTime(selectedDate.year, selectedDate.month, selectedDate.day), DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 23, 59))) ?? 0;
      } catch (error) {
        //////// print("Exception in getHealthDataFromTypes: $error");
      }

      // filter out duplicates
      _healthWeekDayDataList = HealthFactory.removeDuplicates(_healthWeekDayDataList);
      _healthWeekDataList = HealthFactory.removeDuplicates(_healthWeekDataList);

      // print the results


      for (HealthDataPoint x in _healthWeekDataList) {
        // if(x.type == HealthDataType.ACTIVE_ENERGY_BURNED){
        //   //////// print(x.value);
        //   calories += x.value;
        // }

        if (Platform.isAndroid && x.type == HealthDataType.STEPS &&  x.sourceId.contains(":user_input")) {
          stepsInputWeek += x.value.toInt();
        }
        if(Platform.isIOS && x.type == HealthDataType.STEPS && x.sourceId.startsWith("com.apple.Health")){
       ////// print("stepsInputWeek__ = ${x.value.toInt()}");
       ////// print("${ x.sourceName } - ${ x.sourceId } - ${ x.dateFrom } - ${ x.dateTo }");
          stepsInputWeek += x.value.toInt();
        }

        // if(Platform.isIOS && x.type == HealthDataType.STEPS){
        //////// print(Platform.isIOS && x.type == HealthDataType.STEPS && x.sourceId.startsWith("com.apple.Health"));
        //////// print("${ x.sourceId }");
        // }
      }

      for (HealthDataPoint x in _healthWeekDayDataList) {
        // if(x.type == HealthDataType.ACTIVE_ENERGY_BURNED){
        //  ///////// print(x.type.toString());
          // calories += x.value;
        // }

        if (Platform.isAndroid && x.type == HealthDataType.STEPS && x.sourceId.contains(":user_input")) {
          stepsInputWeekDay += x.value.toInt();
        }
        if(Platform.isIOS && x.type == HealthDataType.STEPS && x.sourceId.startsWith("com.apple.Health")){
          stepsInputWeekDay += x.value.toInt();
        }

        if(Platform.isIOS && x.type == HealthDataType.ACTIVE_ENERGY_BURNED){
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

      }

   ////// print("stepsWeekFull = ${stepsWeekFull}");
   ////// print("stepsInputWeek = ${stepsInputWeek}");
   //      if(this.isClosed)
        emit(HealthWeekSuccess(stepCount: (stepsWeekFull - stepsInputWeek.toInt()) > 0 ? stepsWeekFull - stepsInputWeek.toInt() : 0, stepCountDay: stepsWeekDayFull - stepsInputWeekDay, calories: calories, distance: distance, selectedDate: selectedDate));
    } else {
      //////// print("Authorization not granted");
      // setState(() =>
      emit(HealthWeekNotGranted());
      // _state = AppState.DATA_NOT_FETCHED;
      // );
    }
  }
  Future dateChanged(DateTime selectedDate, int stepCount) async{
    this.selectedDate = selectedDate;
    emit(HealthWeekSuccessLoading(stepCount: stepCount, selectedDate: selectedDate));
    fetchData();

  }

}