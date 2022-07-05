import 'package:lifestep/model/donation/fonds.dart';

class FondDetailsState {
  final FondModel fondModel;

  const FondDetailsState(
      {required this.fondModel});

  FondDetailsState copyWith({
    required FondModel fondModel,
  }) {
    return FondDetailsState(
      fondModel: fondModel,
    );
  }
}