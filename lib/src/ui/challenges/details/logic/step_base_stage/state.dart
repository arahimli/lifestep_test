import 'package:equatable/equatable.dart';
import 'package:lifestep/src/models/challenge/challenges.dart';
import 'package:lifestep/src/models/challenge/inner.dart';
import 'package:lifestep/src/models/challenge/participants.dart';
import 'package:lifestep/src/resources/service/web_service.dart';

abstract class StepBaseStageState extends Equatable {
  const StepBaseStageState();

  @override
  List<Object> get props => [];
}

class StepBaseStageLoading extends StepBaseStageState {}

class StepBaseStageFetching extends StepBaseStageState {}

class StepBaseStageSuccess extends StepBaseStageState {
  final List<ChallengeLevelModel> challengeLevels;
  final int userSteps;
  final ChallengeModel challenge;

  const StepBaseStageSuccess({this.challengeLevels = const [], this.userSteps: 0, required this.challenge, });

  StepBaseStageSuccess copyWith({
    required List<ChallengeLevelModel> challengeLevels,
    required int userSteps,
    required ChallengeModel challenge,
  }) {
    return StepBaseStageSuccess(
      challengeLevels: challengeLevels,
      userSteps: userSteps,
      challenge: challenge,
    );
  }

  @override
  List<Object> get props => [challengeLevels, userSteps, challenge];

  @override
  String toString() =>
      'StepBaseStageSuccess { mainData: ${challengeLevels != null ? challengeLevels.length : 0} }';
}

class StepBaseStageError extends StepBaseStageState {
  final WEB_SERVICE_ENUM errorCode;

  const StepBaseStageError({required this.errorCode});

  @override
  List<Object> get props => [errorCode];
}