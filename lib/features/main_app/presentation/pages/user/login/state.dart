import 'package:lifestep/features/main_app/presentation/pages/user/form_submission_status.dart';

class LoginState {
  final String? phone;
  final bool isValidPhone;
  // bool get isValidPhone => phone != null && phone!.length > 3;


  final FormSubmissionStatus formStatus;

  LoginState({
    this.phone = '',
    this.isValidPhone = true,
    this.formStatus = const InitialFormStatus(),
  });

  LoginState copyWith({
    String? phone,
    bool? isValidPhone,
    FormSubmissionStatus? formStatus,
  }) {
    return LoginState(
      phone: phone ?? this.phone,
      isValidPhone: isValidPhone ?? this.isValidPhone,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}