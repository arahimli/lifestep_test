

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/health.dart';
import 'package:lifestep/tools/common/utlis.dart';
import 'package:lifestep/logic/session/cubit.dart';
import 'package:lifestep/logic/step/step-calculation/state.dart';
import 'package:lifestep/model/step/balance-step.dart';
import 'package:lifestep/model/step/daily-step.dart';
import 'package:lifestep/tools/constants/health/element.dart';
import 'package:lifestep/pages/user/repositories/auth.dart';
import 'package:lifestep/repositories/service/web_service.dart';

class GeneralStepCalculationCubit extends Cubit<GeneralStepCalculationState>{
  final UserRepository authRepo;
  final SessionCubit sessionCubit;
  bool balanceResult = false;
  bool dailyResult = false;

  CancelToken dioToken = CancelToken();

  GeneralStepCalculationCubit({required this.authRepo, required this.sessionCubit}) : super(GeneralStepCalculationLoading()) {
    dailyStepUpdate();
    // totalStepUpdate();
    // dailyStepUpdate2();
  }

  DateTime selectedDate = DateTime.now();
  int stepCountDay = 0;

  // create a HealthFactory for use in the app
  HealthFactory health = HealthFactory();

  /// Fetch data points from the health plugin and show them in the app.


  Future refresh() async{
    // emit(GeneralStepCalculationSuccessLoading(stepCountDay: this.stepCountDay, selectedDate: this.selectedDate));
    dailyStepUpdate();
    // totalStepUpdate();

  }



  Future dailyStepUpdate() async {

    // define the types to get
    final types = Platform.isIOS ? TypesIOSOnlySteps : TypesAndroidOnlySteps;
    // with coresponsing permissions
    final permissions = types.map((e) => HealthDataAccess.READ).toList();

    // requesting access to the data types before reading them
    // note that strictly speaking, the [permissions] are not
    // needed, since we only want READ access.
    bool requested = await health.requestAuthorization(types, permissions: permissions);
    int loop = 0;
    dailyResult = false;
    if (requested) {
      try {
        bool calculate = true;
        while(calculate) {
          ///////// print("while(calculate)");
          int totalSteps = 0;
          List sourceIdList = [];
          List listData = await authRepo.getDailyStepInfo(token: dioToken);
          if (listData[2] == WEB_SERVICE_ENUM.SUCCESS) {
            DailyStepStatusResponse stepStatusResponse = DailyStepStatusResponse.fromJson(listData[1]);
            DateTime datetime = stepStatusResponse.data!.datetime!;
            DateTime locDate = stepStatusResponse.data!.datetime!.add( Duration(days: loop));
            DateTime locDateEnd = stepStatusResponse.data!.datetime!.add( Duration(days: 1 + loop));
            if (stepStatusResponse.data!.currentdate != null && stepStatusResponse.data!.datetime != null) {
              int stepsDay = 0;
              int stepsDayFull = 0;
              try {
                // stepsDay = await health.getTotalStepsInInterval(
                //   DateTime(locDate.year, locDate.month, locDate.day, 0, 0, 0),
                //   DateTime(locDateEnd.year, locDateEnd.month, locDateEnd.day, locDateEnd.hour, 0, 0, 0),
                // );

                stepsDayFull = (await health.getTotalStepsInInterval(
                  DateTime(locDate.year, locDate.month, locDate.day, 0, 0, 0),
                  DateTime(locDateEnd.year, locDateEnd.month, locDateEnd.day, locDateEnd.hour, 0, 0, 0),)
                ) ?? 0;

                List<HealthDataPoint> _healthDataList = [];
                _healthDataList = await health.getHealthDataFromTypes(
                    DateTime(locDate.year, locDate.month, locDate.day, 0, 0, 0),
                    DateTime(locDateEnd.year, locDateEnd.month, locDateEnd.day, locDateEnd.hour, 0, 0, 0),
                    types);
                _healthDataList.forEach((x) {
                  if( x.type == HealthDataType.STEPS )
                    sourceIdList.add(x.sourceId.toString());
                  if (Platform.isAndroid && x.type == HealthDataType.STEPS &&
                      x.sourceId.contains(":user_input")) {
                    stepsDay += x.value.toInt();
                  }
                  if (Platform.isIOS && x.type == HealthDataType.STEPS &&
                      x.sourceId.startsWith("com.apple.Health")) {
                    stepsDay += x.value.toInt();
                  }
                });

                totalSteps = stepsDayFull - stepsDay;
              } catch (_) {

              }
            }
            // print("______________________________________________________________________________ daily start");
            // print(loop);
            // print(totalSteps);
            // print(stepStatusResponse.data!.currentdate);
            // print(stepStatusResponse.data!.datetime);
            // print(loop);
            // print(DateTime(locDate.year, locDate.month, locDate.day, 0, 0, 0));
            // print(DateTime(locDateEnd.year, locDateEnd.month, locDateEnd.day, locDateEnd.hour, 0, 0, 0));
            // print({"steps": totalSteps, "date" : Utils.dateToString(DateTime(locDate.year, locDate.month, locDate.day, 0, 0, 0), format: "dd.MM.yyyy")});
            // print("______________________________________________________________________________ daily end");
            if(!DateTime(locDate.year, locDate.month, locDate.day, 0, 0, 0).isAfter(stepStatusResponse.data!.currentdate!)){
              try {
                List listData2 = await authRepo.setDailyStepInfo(
                    data: {
                      "steps": totalSteps,
                      "date" : Utils.dateToString(DateTime(locDate.year, locDate.month, locDate.day, 0, 0, 0),format: "dd.MM.yyyy"),
                      "source_ids": json.encode([...{...sourceIdList}])
                    }, token: dioToken);
                ///////// print(listData2);
                if (listData2[2] == WEB_SERVICE_ENUM.SUCCESS) {
                  dailyResult = true;
                  loop = 1;
                }else{
                  ///////// print("listData2[2]listData2[2]listData2[2]listData2[2]");
                  calculate = false;
                  break;
                }
              } catch (e) {
                calculate = false;
                break;
              }
            }
            if(datetime.add(Duration(days: 1 + loop)).isAfter(stepStatusResponse.data!.currentdate!.add(Duration(days: 0 + loop)))){
              calculate = false;
              break;
            }
          }else{
            dailyResult = false;
          }

        }
      } catch (error) {
        dailyResult = false;
      }

    } else {
      dailyResult = false;
    }

    emit(GeneralStepCalculationSuccess(balanceResult: false, dailyResult: dailyResult));

    try {
      List listData2 = await authRepo.getAchievementsControlInfo(token: dioToken);
      if(listData2[2] == WEB_SERVICE_ENUM.SUCCESS) {
        BalanceStepResponse balanceStepResponse = BalanceStepResponse.fromJson(listData2[1]);
        // print("balanceStepResponse = ${balanceStepResponse.data!.userAchievements!.length}");
        sessionCubit.setUser(balanceStepResponse.data!.user);
        balanceResult = true;
        emit(GeneralStepCalculationSuccess(balanceResult: balanceResult, dailyResult: false, userAchievementModels: balanceStepResponse.data != null ? balanceStepResponse.data!.userAchievements : []));
      }
    }catch(e){
      balanceResult = false;
    }
  }


  //
  //
  // Future totalStepUpdate() async {
  //   final types = Platform.isIOS ? TypesIOSOnlySteps : TypesAndroidOnlySteps;
  //   // with coresponsing permissions
  //   final permissions = types.map((e) => HealthDataAccess.READ).toList();
  //
  //   // requesting access to the data types before reading them
  //   // note that strictly speaking, the [permissions] are not
  //   // needed, since we only want READ access.
  //   bool requested = await health.requestAuthorization(types, permissions: permissions);
  //
  //   int totalSteps = 0;
  //   if (requested) {
  //  ////// print(health.hashCode.toString());
  //     try {
  //       List listData = await authRepo.getStepInfo(token: dioToken);
  //       if(listData[2] == WEB_SERVICE_ENUM.SUCCESS){
  //         StepStatusResponse stepStatusResponse = StepStatusResponse.fromJson(listData[1]);
  //         if(stepStatusResponse.data!.currentdate != null && stepStatusResponse.data!.datetime != null){
  //           int i = 0;
  //           // print(stepStatusResponse.data!.datetime);
  //           while(stepStatusResponse.data!.currentdate!.isAfter(stepStatusResponse.data!.datetime!.add(Duration(days: i * 15))) ) {
  //             int stepsDay = 0;
  //             int stepsDayFull = 0;
  //             try {
  //               stepsDayFull = (await health.getTotalStepsInInterval(
  //                   stepStatusResponse.data!.datetime!.add(
  //                       Duration(days: i * 15)),
  //                   stepStatusResponse.data!.datetime!.add(
  //                       Duration(days: (i + 1) * 15)))) ?? 0;
  //
  //               List<HealthDataPoint> _healthDataList = [];
  //               _healthDataList = await health.getHealthDataFromTypes(
  //                   stepStatusResponse.data!.datetime!.add(Duration(days: i * 15)),
  //                   stepStatusResponse.data!.datetime!.add(Duration(days: (i + 1) * 15)),
  //                   types);
  //               _healthDataList.forEach((x) {
  //                 if (Platform.isAndroid && x.type == HealthDataType.STEPS &&
  //                     x.sourceId.contains(":user_input")) {
  //                   stepsDay += x.value.toInt();
  //                 }
  //                 if (Platform.isIOS && x.type == HealthDataType.STEPS &&
  //                     x.sourceId.startsWith("com.apple.Health")) {
  //                   stepsDay += x.value.toInt();
  //                 }
  //               });
  //               totalSteps += (stepsDayFull - stepsDay);
  //               i++;
  //             }catch(_){
  //
  //             }
  //           }
  //         }
  //         // print("totalSteps = ${totalSteps}");
  //         // if(totalSteps > 0){
  //         try {
  //           List listData2 = await authRepo.setStepInfo2( data: {"steps": totalSteps}, token: dioToken);
  //           if(listData2[2] == WEB_SERVICE_ENUM.SUCCESS) {
  //             BalanceStepResponse balanceStepResponse = BalanceStepResponse.fromJson(listData2[1]);
  //             // print("balanceStepResponse = ${balanceStepResponse.data!.userAchievements!.length}");
  //             sessionCubit.setUser(balanceStepResponse.data!.user);
  //             balanceResult = true;
  //             emit(GeneralStepCalculationSuccess(balanceResult: balanceResult, dailyResult: false, userAchievementModels: balanceStepResponse.data != null ? balanceStepResponse.data!.userAchievements : []));
  //           }
  //         }catch(e){
  //           balanceResult = false;
  //         }
  //         // }else{
  //         //   balanceResult = false;
  //         // }
  //       }
  //
  //     } catch (error) {
  //       balanceResult = false;
  //     }
  //
  //   } else {
  //     balanceResult = false;
  //   }
  // }
  //
  //
  // Future dailyStepUpdate2() async {
  //
  //   // define the types to get
  //   final types = Platform.isIOS ? TypesIOSOnlySteps : TypesAndroidOnlySteps;
  //   // with coresponsing permissions
  //   final permissions = types.map((e) => HealthDataAccess.READ).toList();
  //
  //   // requesting access to the data types before reading them
  //   // note that strictly speaking, the [permissions] are not
  //   // needed, since we only want READ access.
  //   bool requested = await health.requestAuthorization(types, permissions: permissions);
  //   int loop = 0;
  //   dailyResult = false;
  //   if (requested) {
  //     try {
  //       bool calculate = true;
  //       while(calculate) {
  //         ///////// print("while(calculate)");
  //         int totalSteps = 0;
  //         List listData = await authRepo.getDailyStepInfo2(token: dioToken);
  //      ////// print("222222");
  //      ////// print(listData);
  //         if (listData[2] == WEB_SERVICE_ENUM.SUCCESS) {
  //           DailyStepStatusResponse stepStatusResponse = DailyStepStatusResponse.fromJson(listData[1]);
  //           DateTime datetime = stepStatusResponse.data!.datetime!;
  //           DateTime locDate = stepStatusResponse.data!.datetime!.add( Duration(days: loop));
  //           DateTime locDateEnd = stepStatusResponse.data!.datetime!.add( Duration(days: 1 + loop));
  //           if (stepStatusResponse.data!.currentdate != null && stepStatusResponse.data!.datetime != null) {
  //             int stepsDay = 0;
  //             int stepsDayFull = 0;
  //             try {
  //               // stepsDay = await health.getTotalStepsInInterval(
  //               //   DateTime(locDate.year, locDate.month, locDate.day, 0, 0, 0),
  //               //   DateTime(locDateEnd.year, locDateEnd.month, locDateEnd.day, locDateEnd.hour, 0, 0, 0),
  //               // );
  //
  //               stepsDayFull = (await health.getTotalStepsInInterval(
  //                 DateTime(locDate.year, locDate.month, locDate.day, 0, 0, 0),
  //                 DateTime(locDateEnd.year, locDateEnd.month, locDateEnd.day, locDateEnd.hour, 0, 0, 0),)
  //               ) ?? 0;
  //
  //               List<HealthDataPoint> _healthDataList = [];
  //               _healthDataList = await health.getHealthDataFromTypes(
  //                   DateTime(locDate.year, locDate.month, locDate.day, 0, 0, 0),
  //                   DateTime(locDateEnd.year, locDateEnd.month, locDateEnd.day, locDateEnd.hour, 0, 0, 0),
  //                   types);
  //               _healthDataList.forEach((x) {
  //                 if (Platform.isAndroid && x.type == HealthDataType.STEPS &&
  //                     x.sourceId.contains(":user_input")) {
  //                   stepsDay += x.value.toInt();
  //                 }
  //                 if (Platform.isIOS && x.type == HealthDataType.STEPS &&
  //                     x.sourceId.startsWith("com.apple.Health")) {
  //                   stepsDay += x.value.toInt();
  //                 }
  //               });
  //
  //               totalSteps = stepsDayFull - stepsDay;
  //             } catch (_) {
  //
  //             }
  //           }
  //           // print("______________________________________________________________________________ daily start");
  //           // print(loop);
  //           // print(totalSteps);
  //           // print(stepStatusResponse.data!.currentdate);
  //           // print(stepStatusResponse.data!.datetime);
  //           // print(loop);
  //           // print(DateTime(locDate.year, locDate.month, locDate.day, 0, 0, 0));
  //           // print(DateTime(locDateEnd.year, locDateEnd.month, locDateEnd.day, locDateEnd.hour, 0, 0, 0));
  //           // print({"steps": totalSteps, "date" : Utils.dateToString(DateTime(locDate.year, locDate.month, locDate.day, 0, 0, 0), format: "dd.MM.yyyy")});
  //           // print("______________________________________________________________________________ daily end");
  //           if(!DateTime(locDate.year, locDate.month, locDate.day, 0, 0, 0).isAfter(stepStatusResponse.data!.currentdate!)){
  //             try {
  //               List listData2 = await authRepo.setDailyStepInfo2(
  //                   data: {"steps": totalSteps, "date" : Utils.dateToString(DateTime(locDate.year, locDate.month, locDate.day, 0, 0, 0), format: "dd.MM.yyyy")}, token: dioToken);
  //               ///////// print(listData2);
  //               if (listData2[2] == WEB_SERVICE_ENUM.SUCCESS) {
  //                 dailyResult = true;
  //                 loop = 1;
  //               }else{
  //                 ///////// print("listData2[2]listData2[2]listData2[2]listData2[2]");
  //                 calculate = false;
  //                 break;
  //               }
  //             } catch (e) {
  //               calculate = false;
  //               break;
  //             }
  //           }
  //           if(datetime.add(Duration(days: 1 + loop)).isAfter(stepStatusResponse.data!.currentdate!.add(Duration(days: 0 + loop)))){
  //             calculate = false;
  //             break;
  //           }
  //         }else{
  //           dailyResult = false;
  //         }
  //
  //       }
  //     } catch (error) {
  //       dailyResult = false;
  //     }
  //
  //   } else {
  //     dailyResult = false;
  //   }
  //   // emit(GeneralStepCalculationSuccess(balanceResult: false, dailyResult: dailyResult));
  //
  // }

}




