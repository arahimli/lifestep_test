import 'package:lifestep/model/challenge/challenges.dart';
import 'package:lifestep/model/donation/fonds.dart';

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