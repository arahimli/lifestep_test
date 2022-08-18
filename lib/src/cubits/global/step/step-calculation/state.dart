import 'package:equatable/equatable.dart';
import 'package:lifestep/src/models/general/achievement-list.dart';
import 'package:lifestep/src/resources/service/web_service.dart';

abstract class GeneralStepCalculationState extends Equatable {
  const GeneralStepCalculationState();

  @override
  List<Object> get props => [];
}

class GeneralStepCalculationLoading extends GeneralStepCalculationState {}

class GeneralStepCalculationSuccess extends GeneralStepCalculationState {
  final bool balanceResult;
  final List<UserAchievementModel>? userAchievementModels;
  final bool dailyResult;

  const GeneralStepCalculationSuccess({ this.balanceResult = false, this.dailyResult = false, this.userAchievementModels, });

  GeneralStepCalculationSuccess copyWith({
    bool? balanceResult,
    bool? dailyResult,
    List<UserAchievementModel>? userAchievementModels,
  }) {
    return GeneralStepCalculationSuccess(
      balanceResult: balanceResult ?? this.balanceResult,
      dailyResult: dailyResult ?? this.dailyResult,
      userAchievementModels: userAchievementModels,
    );
  }

  @override
  List<Object> get props => [balanceResult, dailyResult, userAchievementModels != null ? userAchievementModels! : []];

  @override
  String toString() =>
      'GeneralStepCalculationSuccess { mainData: ${ balanceResult } { dailyResult: ${ dailyResult } { dailyResult: ${ (userAchievementModels != null ? userAchievementModels! : []).length }';
}

// class GeneralStepCalculationSuccessLoading extends GeneralStepCalculationState {
//   final bool dailyResult;
//   final bool balanceResult;
//
//   const GeneralStepCalculationSuccessLoading({ this.dailyResult: false, this.balanceResult: false});
//
//   GeneralStepCalculationSuccessLoading copyWith({
//     bool? dailyResult,
//     bool? balanceResult,
//   }) {
//     return GeneralStepCalculationSuccessLoading(
//       dailyResult: dailyResult ?? this.dailyResult,
//       balanceResult: balanceResult ?? this.balanceResult,
//     );
//   }
//
//   @override
//   List<Object> get props => [balanceResult, dailyResult];
//
//   @override
//   String toString() =>
//       'GeneralStepCalculationSuccessLoading { mainData: ${ balanceResult } { dailyResult: ${ dailyResult }';
// }

class GeneralStepCalculationError extends GeneralStepCalculationState {
  final WEB_SERVICE_ENUM errorCode;

  const GeneralStepCalculationError({required this.errorCode});

  @override
  List<Object> get props => [errorCode];
}
class GeneralStepCalculationNotGranted extends GeneralStepCalculationState {
  final int stepCountDay;
  final DateTime selectedDate;

  const GeneralStepCalculationNotGranted({ this.stepCountDay:0 ,required this.selectedDate});

  @override
  List<Object> get props => [];
}