

import 'package:lifestep/model/auth/login.dart';
import 'package:lifestep/model/auth/profile.dart';


class PersonalDonateState {
  final String amount;
  final bool isValidAmount;
  final bool checked;
  // bool get changed => language != null && language!.length > 3;



  PersonalDonateState({
    this.amount = '0',
    this.isValidAmount = true,
    this.checked = false,
  });

  PersonalDonateState copyWith({
    required String amount,
    bool? isValidAmount,
    bool? checked,
  }) {
    return PersonalDonateState(
      amount: amount,
      isValidAmount: isValidAmount ?? this.isValidAmount,
      checked: checked ?? this.checked,
    );
  }
}