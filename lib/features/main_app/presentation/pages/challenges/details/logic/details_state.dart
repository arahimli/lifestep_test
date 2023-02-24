import 'package:equatable/equatable.dart';
import 'package:lifestep/features/main_app/data/models/challenge/challenges.dart';
import 'package:lifestep/features/tools/common/utlis.dart';

class ChallengeDetailState extends Equatable{
  final ChallengeModel challengeModel;
  final String hashCodeData;

  const ChallengeDetailState(
      {required this.challengeModel, required this.hashCodeData});

  ChallengeDetailState copyWith({
    required ChallengeModel challengeModel,
    String? hashCodeData,
  }) {
    return ChallengeDetailState(
      challengeModel: challengeModel,
      hashCodeData: hashCodeData ?? Utils.generateRandomString(10),
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [hashCodeData];
}