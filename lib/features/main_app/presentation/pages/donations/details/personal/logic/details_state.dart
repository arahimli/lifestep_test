

import 'package:lifestep/features/main_app/data/models/donation/charities.dart';

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