import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/src/tools/config/main_config.dart';
import 'package:lifestep/src/tools/common/utlis.dart';
import 'package:lifestep/src/tools/common/validator.dart';
import 'package:lifestep/src/tools/config/endpoints.dart';
import 'package:lifestep/src/tools/config/main_constants.dart';
import 'package:lifestep/src/ui/user/logic/cubit.dart';
import 'package:lifestep/src/ui/user/form-submission-status.dart';
import 'package:lifestep/src/ui/user/registration/state.dart';
import 'package:lifestep/src/ui/user/repositories/auth.dart';
import 'package:lifestep/src/resources/service/web_service.dart';
import 'package:sprintf/sprintf.dart';

class RegistrationBloc extends Cubit<RegistrationState> {
  final UserRepository authRepo;
  final AuthCubit authCubit;
  FormValidator formValidator = FormValidator();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController birthdateController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController goalStepsPerDayController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController invitationCodeController = TextEditingController();


  initialize(){
    // state.copyWith(phone: authCubit.phone);
    if(authCubit.authType == AuthType.otp) {
      phoneController.text = authCubit.phone;
      emit(state.copyWith(phone: authCubit.phone,isValidPhone: formValidator.validPhone(authCubit.phone, req: false)));
    }
    if(authCubit.authType == AuthType.facebook) {
      if(formValidator.validFullName(authCubit.fullName)){
      fullNameController.text = authCubit.fullName;}
      if(formValidator.validEmail(authCubit.email)){
      emailController.text = authCubit.email;}
      emit(state.copyWith(fullName: authCubit.fullName, isValidFullName: formValidator.validFullName(authCubit.fullName), email: authCubit.email, isValidEmail: formValidator.validEmail(authCubit.email), ));
    }
  }
  RegistrationBloc({required this.authRepo, required this.authCubit}) : super(RegistrationState()){
    initialize();
  }

  void fullNameChanged(String value, {bool req=true}){
    //////// print("void fullNameChanged");
    //////// print(value);
    //////// print(formValidator.validFullName(value, req: req));
    emit(state.copyWith(fullName: formValidator.validFullName(value, req: req) ? value : '', isValidFullName: formValidator.validFullName(value, req: req)));
  }
  void phoneChanged(String value, {bool req=true}){
    //////// print("void phoneChanged");
    //////// print(value);
    //////// print(formValidator.validPhone(value, req: req));
    emit(state.copyWith(phone: formValidator.validPhone(value, req: req) ? value : '', isValidPhone: formValidator.validPhone(value, req: req)));
  }
  void birthdayChanged(String value, {bool req=true}){
    //////// print("void birthdayChanged");
    //////// print(value);
    //////// print(formValidator.validPhone(value, req: req));
    emit(state.copyWith(birthdate: formValidator.validDate(value, req: req) ? value : '', isValidBirthdate: formValidator.validDate(value, req: req)));
  }
  void weightChanged(String value, {bool req=true}){
    //////// print("void weightChanged");
    //////// print(value);
    //////// print(formValidator.validWeight(value));
    emit(state.copyWith(weight: formValidator.validWeight(value) ? value : '', isValidWeight: formValidator.validWeight(value)));
  }
  void heightChanged(String value, {bool req=true}){
    //////// print("void heightChanged");
    //////// print(value);
    //////// print(formValidator.validHeight(value));
    emit(state.copyWith(height: formValidator.validHeight(value) ? value : '', isValidHeight: formValidator.validHeight(value)));
  }


  void goalStepChanged(String value, {bool req=false}){
    //////// print("void heightChanged");
    //////// print(value);
    //////// print(formValidator.validGoalStep(value, req: req));
    emit(state.copyWith(goalStepsPerDay: formValidator.validGoalStep(value, req: req) ? value : '', isValidGoalStepsPerDay: formValidator.validGoalStep(value, req: req)));
  }
  void emailChanged(String value, {bool req=false}){
    //////// print("void emailChanged");
    //////// print(value);
    //////// print(formValidator.validEmail(value, req: req));
    emit(state.copyWith(email: formValidator.validEmail(value, req: req) ? value : '', isValidEmail: formValidator.validEmail(value, req: req)));
  }

  void inviteChanged(String value, {bool req=false}){
    //////// print("void validInvite");
    //////// print(value);
    //////// print(formValidator.validInviteCode(value, req: req));
    emit(state.copyWith(invitationCode: formValidator.validInviteCode(value, req: req) ? value : '', isValidInvitationCode: formValidator.validInviteCode(value, req: req)));
  }

  void genderChanged(String value, {bool req=false}){
    //////// print("void genderChanged");
    //////// print(value);
    //////// print(formValidator.validGender(value, MainConst.genderDataMap));
    emit(state.copyWith(gender: formValidator.validGender(value, MainConst.genderDataMap) ? value : '', isValidGender: formValidator.validGender(value, MainConst.genderDataMap)));
  }

  Future<List> registerSubmit() async{

      emit(state.copyWith(formStatus: FormSubmitting()));
      String playerId = await Utils.getPlayerId();

      final data = await authRepo.registerUser(
        data: {
          "full_name": state.fullName,
          "dob": state.birthdate,
          "weight": state.weight,
          "height": state.height,
          "email": state.email,
          "gender": state.gender,
          "target_steps": state.goalStepsPerDay,
        },
        header: {
            'Authorization': "Bearer ${authCubit.token}",
            'Accept-Language': LANGUAGE,
            'Accept': 'application/json'
          },
        extraUrl: sprintf("?player_id=%s&os=%s&app_version=%s", [playerId, Platform.isIOS ? 1 : 2, Platform.isIOS ? MainConfig.app_version_ios : MainConfig.app_version_android, ])
      );
      if(data[2] == WEB_SERVICE_ENUM.SUCCESS){
        // ProfileResponse loginResponse = ProfileResponse.fromJson(data[1]);
        //////// print("authCubit.otp");
        //////// print(data[0]);
        authCubit.otp = authCubit.otp;
        authCubit.userStatusCode = data[0] ?? 0;
        authCubit.token = authCubit.token;
        //////// print(authCubit.otp);
        HALF_TOKEN = authCubit.token;

      }
      state.copyWith(formStatus: SubmissionSuccess());
      return data;

  }
}

