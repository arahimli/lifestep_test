

import 'package:lifestep/model/auth/login.dart';
import 'package:lifestep/model/auth/profile.dart';


class BottomSectionState {
  final double height;


  BottomSectionState({
    this.height = 0,
  });

  BottomSectionState copyWith({
    required double height,
  }) {
    return BottomSectionState(
      height: height,
    );
  }
}