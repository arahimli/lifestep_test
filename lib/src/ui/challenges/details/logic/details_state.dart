import 'package:lifestep/src/models/challenge/challenges.dart';

class ChallengeDetailState {
  final ChallengeModel challengeModel;

  const ChallengeDetailState(
      {required this.challengeModel});

  ChallengeDetailState copyWith({
    required ChallengeModel challengeModel,
  }) {
    return ChallengeDetailState(
      challengeModel: challengeModel,
    );
  }
}