
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/health.dart';
import 'package:lifestep/features/main_app/presentation/blocs/global/session/cubit.dart';
import 'package:lifestep/features/tools/constants/health/element.dart';
import 'package:lifestep/features/main_app/presentation/pages/index/logic/dailystep/state.dart';
import 'package:lifestep/features/main_app/presentation/pages/user/repositories/auth.dart';

class HomeDailyStepCubit extends Cubit<HomeDailyStepState>{
  final UserRepository authRepo;
  final SessionCubit sessionCubit;


  CancelToken dioToken = CancelToken();

  HomeDailyStepCubit({required this.authRepo, required this.sessionCubit}) : super(HomeDailyStepLoading()) {
    // initalData();
    fetchData();
  }

  DateTime selectedDate = DateTime.now();
  int stepCountDay = 0;

  // create a HealthFactory for use in the app
  HealthFactory health = HealthFactory();


  Future fetchData() async {

    // define the types to get
    final types = Platform.isIOS ? typesIOSOnlySteps : typesAndroidOnlySteps;
    // with coresponsing permissions
    final permissions = types.map((e) => HealthDataAccess.READ).toList();
    int stepsFullDay = 0;
    num stepsInputDay = 0;
    num stepsDay = 0;

    // requesting access to the data types before reading them
    // note that strictly speaking, the [permissions] are not
    // needed, since we only want READ access.
    try {
      bool requested = await health.requestAuthorization(
          types, permissions: permissions);

      if (requested) {
        try {
          stepsFullDay = (await health.getTotalStepsInInterval(
              DateTime(selectedDate.year, selectedDate.month, selectedDate.day),
              DateTime(
                  selectedDate.year, selectedDate.month, selectedDate.day, 23,
                  59))) ?? 0;

          List<HealthDataPoint> _healthDataList = [];
          _healthDataList = await health.getHealthDataFromTypes(
              DateTime(selectedDate.year, selectedDate.month, selectedDate.day),
              DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 23,59), types);

          _healthDataList = HealthFactory.removeDuplicates(_healthDataList);

          for (HealthDataPoint x in _healthDataList) {
            if(Platform.isAndroid && x.type == HealthDataType.STEPS && x.sourceId.contains(":user_input")){
              stepsInputDay += x.value;
            }
            if(Platform.isIOS && x.type == HealthDataType.STEPS && x.sourceId.startsWith("com.apple.Health")){
              stepsInputDay += x.value;
            }
            // if(Platform.isIOS && x.type == HealthDataType.STEPS){
            //////// print("${x.sourceName } - ${ x.sourceId }");
            // }
          }
        } catch (_) {
        }


        emit(HomeDailyStepSuccess(
            stepCountDay: (stepsFullDay - stepsInputDay.toInt()) > 0 ? stepsFullDay - stepsInputDay.toInt() : 0, selectedDate: selectedDate));
      } else {
        emit(HomeDailyStepNotGranted(
            stepCountDay: (stepsFullDay - stepsInputDay.toInt()) > 0 ? stepsFullDay - stepsInputDay.toInt() : 0, selectedDate: selectedDate));
      }
      stepCountDay = stepsDay.toInt();
    }catch(_){
      emit(HomeDailyStepNotGranted(
          stepCountDay: 0, selectedDate: selectedDate));
      stepCountDay = 0;
    }
  }
  Future dateChanged(DateTime selectedDate, int stepCountDay) async{
    this.selectedDate = selectedDate;
    emit(HomeDailyStepSuccessLoading(stepCountDay: stepCountDay, selectedDate: selectedDate));
    fetchData();

  }

  Future refresh() async{
    emit(HomeDailyStepSuccessLoading(stepCountDay: stepCountDay, selectedDate: selectedDate));
    fetchData();

  }



}