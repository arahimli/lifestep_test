

import 'package:lifestep/model/donation/charities.dart';

class CharityDetailsState {
  final CharityModel charityModel;

  const CharityDetailsState(
      {required this.charityModel});

  CharityDetailsState copyWith({
    required CharityModel charityModel,
  }) {
    return CharityDetailsState(
      charityModel: charityModel,
    );
  }
}