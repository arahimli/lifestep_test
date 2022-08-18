import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/src/tools/common/utlis.dart';
import 'package:lifestep/src/tools/common/validator.dart';
import 'package:lifestep/src/tools/config/endpoints.dart';
import 'package:lifestep/src/tools/config/main_constants.dart';
import 'package:lifestep/src/cubits/global/session/cubit.dart';
import 'package:lifestep/src/models/auth/profile.dart';
import 'package:lifestep/src/ui/user/form-submission-status.dart';
import 'package:lifestep/src/ui/user/profile/information/state.dart';
import 'package:lifestep/src/ui/user/repositories/auth.dart';
import 'package:lifestep/src/resources/service/web_service.dart';

class ProfileInformationCubit extends Cubit<ProfileInformationState> {
  final UserRepository authRepo;
  final SessionCubit sessionCubit;
  FormValidator formValidator = FormValidator();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController birthdateController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController goalStepsPerDayController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  initialize(){
    phoneController.text = sessionCubit.currentUser!.phone ?? '';
    fullNameController.text = sessionCubit.currentUser!.name ?? '';
    birthdateController.text = sessionCubit.currentUser!.dob ?? '';
    heightController.text = sessionCubit.currentUser!.height ?? '';
    weightController.text = sessionCubit.currentUser!.weight ?? '';
    emailController.text = sessionCubit.currentUser!.email ?? '';
    genderController.text = Utils.getListMapDisplay(sessionCubit.currentUser!.gender ?? '', MainConst.GENDER_DATA_MAP);
    emit(
        state.copyWith(
          phone: sessionCubit.currentUser!.phone, isValidPhone: formValidator.validPhone(sessionCubit.currentUser!.phone ?? ''),
          fullName: sessionCubit.currentUser!.name, isValidFullName: formValidator.validFullName(sessionCubit.currentUser!.name ?? ''),
          birthdate: sessionCubit.currentUser!.dob, isValidBirthdate: formValidator.validDate(sessionCubit.currentUser!.dob ?? ''),
          height: sessionCubit.currentUser!.height, isValidHeight: formValidator.validHeight(sessionCubit.currentUser!.height ?? ''),
          weight: sessionCubit.currentUser!.weight, isValidWeight: formValidator.validWeight(sessionCubit.currentUser!.weight ?? ''),
          email: sessionCubit.currentUser!.email, isValidEmail: formValidator.validEmail(sessionCubit.currentUser!.email ?? '', req: false),
          gender: sessionCubit.currentUser!.gender, isValidGender: formValidator.validGender(sessionCubit.currentUser!.gender ?? '', MainConst.GENDER_DATA_MAP, req: true),
        )
    );
  }

  reInitialize(BuildContext context){
    // print("reInitializereInitializereInitializereInitializereInitialize");
    genderController.text = Utils.getString(context, Utils.getListMapKey(sessionCubit.currentUser!.gender ?? '', MainConst.GENDER_DATA_MAP));
    // emit(
    //     state.copyWith(
    //       gender: sessionCubit.currentUser!.gender, isValidGender: formValidator.validGender(sessionCubit.currentUser!.gender ?? '', MainConst.GENDER_DATA_MAP, req: true),
    //     )
    // );
  }
  ProfileInformationCubit({required this.authRepo, required this.sessionCubit}) : super(ProfileInformationState()){
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
  void heightChanged(String value, {bool req=true}){
    //////// print("void heightChanged");
    //////// print(value);
    //////// print(formValidator.validHeight(value));
    emit(state.copyWith(height: formValidator.validHeight(value) ? value : '', isValidHeight: formValidator.validHeight(value)));
  }
  void weightChanged(String value, {bool req=true}){
    //////// print("void WeightChanged");
    //////// print(value);
    //////// print(formValidator.validWeight(value, req: req));
    emit(state.copyWith(weight: formValidator.validWeight(value, req: req) ? value : '', isValidWeight: formValidator.validWeight(value, req: req)));
  }


  void goalStepChanged(String value, {bool req=false}){
    //////// print("void goalStepChanged");
    //////// print(value);
    //////// print(formValidator.validGoalStep(value));
    emit(state.copyWith(goalStepsPerDay: formValidator.validGoalStep(value) ? value : '', isValidGoalStepsPerDay: formValidator.validGoalStep(value)));
  }
  void emailChanged(String value, {bool req=false}){
    //////// print("void emailChanged");
    //////// print(value);
    //////// print(formValidator.validEmail(value, req: req));
    emit(state.copyWith(email: formValidator.validEmail(value, req: req) ? value : '', isValidEmail: formValidator.validEmail(value, req: req)));
  }
  void genderChanged(String value, {bool req=false}){
    //////// print("void genderChanged");
    //////// print(value);
    //////// print(formValidator.validGender(value, MainConst.GENDER_DATA_MAP));
    emit(state.copyWith(gender: formValidator.validGender(value, MainConst.GENDER_DATA_MAP) ? value : '', isValidGender: formValidator.validGender(value, MainConst.GENDER_DATA_MAP)));
  }

  Future<List> profileChangeSubmit() async{

      emit(state.copyWith(formStatus: FormSubmitting()));

      final data = await authRepo.editUser(
        data: {
          "full_name": state.fullName,
          "dob": state.birthdate,
          "weight": state.weight,
          "height": state.height,
          "email": state.email,
          "gender": state.gender,
        },
        header: {
            'Authorization': "Bearer ${TOKEN}",
            'Accept-Language': LANGUAGE,
            'Accept': 'application/json'
          }
      );
      if(data[2] == WEB_SERVICE_ENUM.SUCCESS){
        ProfileResponse resultResponse = ProfileResponse.fromJson(data[1]);
        //////// print("resultResponse.data");
        //////// print(data[0]);
        //////// print(resultResponse.data);
        sessionCubit.setUser(resultResponse.data);

      }
      state.copyWith(formStatus: SubmissionSuccess());
      return data;

  }
}

