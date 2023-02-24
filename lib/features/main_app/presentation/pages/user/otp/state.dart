import 'package:lifestep/features/main_app/presentation/pages/user/form_submission_status.dart';

class OtpState {
  final String? otp;
  final bool isValidOtp;
  final bool isWrongOtp;
  final int endTime;
  // bool get isValidOtp => otp != null && otp!.length > 3;


  final FormSubmissionStatus formStatus;

  OtpState({
    this.otp = '',
    this.isValidOtp = true,
    this.isWrongOtp = false,
    this.endTime = 0,
    this.formStatus = const InitialFormStatus(),
  });

  OtpState copyWith({
    String? otp,
    bool? isValidOtp,
    bool? isWrongOtp,
    int? endTime,
    FormSubmissionStatus? formStatus,
  }) {
    return OtpState(
      otp: otp ?? this.otp,
      isValidOtp: isValidOtp ?? this.isValidOtp,
      isWrongOtp: isWrongOtp ?? this.isWrongOtp,
      endTime: endTime ?? this.endTime,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}