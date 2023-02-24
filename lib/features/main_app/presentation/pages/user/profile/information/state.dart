import 'package:lifestep/features/main_app/presentation/pages/user/form_submission_status.dart';

class ProfileInformationState {
  final String? fullName;
  final bool isValidFullName;
  final String? phone;
  final bool isValidPhone;
  final String? birthdate;
  final bool isValidBirthdate;
  final String? height;
  final bool isValidHeight;
  final String? weight;
  final bool isValidWeight;
  final String? goalStepsPerDay;
  final bool isValidGoalStepsPerDay;
  final String? email;
  final bool isValidEmail;
  final String? gender;
  final bool isValidGender;
  // bool get isValidPhone => phone != null && phone!.length > 3;


  final FormSubmissionStatus formStatus;

  ProfileInformationState({
    this.fullName = '',
    this.isValidFullName = true,
    this.phone = '',
    this.isValidPhone = true,

    this.birthdate = '',
    this.isValidBirthdate = true,

    this.height = '',
    this.isValidHeight = true,

    this.weight = '',
    this.isValidWeight = true,

    this.goalStepsPerDay = '',
    this.isValidGoalStepsPerDay = true,

    this.email = '',
    this.isValidEmail = true,

    this.gender = '',
    this.isValidGender = true,

    this.formStatus = const InitialFormStatus(),
  });

  ProfileInformationState copyWith({

    String? fullName,
    bool? isValidFullName,
    String? phone,
    bool? isValidPhone,
    String? birthdate,
    bool? isValidBirthdate,
    String? height,
    bool? isValidHeight,
    String? weight,
    bool? isValidWeight,
    String? goalStepsPerDay,
    bool? isValidGoalStepsPerDay,
    String? email,
    bool? isValidEmail,
    String? gender,
    bool? isValidGender,
    FormSubmissionStatus? formStatus,
  }) {
    return ProfileInformationState(
      fullName: fullName ?? this.fullName,
      isValidFullName: isValidFullName ?? this.isValidFullName,
      phone: phone ?? this.phone,
      isValidPhone: isValidPhone ?? this.isValidPhone,
      birthdate: birthdate ?? this.birthdate,
      isValidBirthdate: isValidBirthdate ?? this.isValidBirthdate,
      height: height ?? this.height,
      isValidHeight: isValidHeight ?? this.isValidHeight,
      weight: weight ?? this.weight,
      isValidWeight: isValidWeight ?? this.isValidWeight,
      goalStepsPerDay: goalStepsPerDay ?? this.goalStepsPerDay,
      isValidGoalStepsPerDay: isValidGoalStepsPerDay ?? this.isValidGoalStepsPerDay,
      email: email ?? this.email,
      isValidEmail: isValidEmail ?? this.isValidEmail,
      gender: gender ?? this.gender,
      isValidGender: isValidGender ?? this.isValidGender,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}