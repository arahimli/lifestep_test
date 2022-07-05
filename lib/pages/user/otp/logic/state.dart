

import 'package:equatable/equatable.dart';

class OtpNumpadState
    // extends Equatable
{
  final String otp;

  OtpNumpadState({
    this.otp = '',
  });

  OtpNumpadState copyWith({
    String? otp,
  }) {
    return OtpNumpadState(
      otp: otp ?? this.otp,
    );
  }

  // @override
  // // TODO: implement props
  // List<Object?> get props => [otp];

}