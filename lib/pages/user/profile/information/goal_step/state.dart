

import 'package:lifestep/model/auth/login.dart';
import 'package:lifestep/model/auth/profile.dart';


class GoalStepState {
  final String amount;
  final bool isValidAmount;
  // bool get changed => language != null && language!.length > 3;



  GoalStepState({
    this.amount = '0',
    this.isValidAmount = true,
  });

  GoalStepState copyWith({
    String? amount,
    bool? isValidAmount,
  }) {
    return GoalStepState(
      amount: amount ?? this.amount,
      isValidAmount: isValidAmount ?? this.isValidAmount,
    );
  }
}