import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/config/endpoints.dart';
import 'package:lifestep/model/auth/login.dart';
import 'package:lifestep/pages/user/cubit/cubit.dart';
import 'package:lifestep/pages/user/form-submission-status.dart';
import 'package:lifestep/pages/user/login/state.dart';
import 'package:lifestep/pages/user/repositories/auth.dart';
import 'package:lifestep/repositories/service/web_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBloc extends Cubit<LoginState> {
  final UserRepository authRepo;
  final AuthCubit authCubit;
  FormValidator formValidator = FormValidator();
  initialize(){
    state.copyWith(phone: authCubit.phone);
    emit(state.copyWith(phone: authCubit.phone, isValidPhone: formValidator.validPhone(authCubit.phone)));
  }
  LoginBloc({required this.authRepo, required this.authCubit}) : super(LoginState());

  void phoneChanged(String value){
    emit(state.copyWith(phone: value, isValidPhone: formValidator.validPhone(value)));
  }
  Future<List> loginSubmit(String value) async{

      emit(state.copyWith(formStatus: FormSubmitting()));

      final data = await authRepo.loginWithCredential(
        phone: state.phone ?? '',
      );
      if(data[2] == WEB_SERVICE_ENUM.SUCCESS){
        LoginResponse loginResponse = LoginResponse.fromJson(data[1]);
        // authCubit.otp = loginResponse.data!.otp ?? '';
        authCubit.userStatusCode = data[0] ?? 0;
        // authCubit.token = loginResponse.data!.token ?? '';
      }
      state.copyWith(formStatus: SubmissionSuccess());
      return data;

  }
}

class FormValidator {
  validPhone(String value, {bool req=true}){
    if(value != null && value != ''){
      if(value.length != 9)return false;
      else {
        if((value.trim().startsWith("50") || value.trim().startsWith("51") || value.trim().startsWith("70") || value.trim().startsWith("77") || value.trim().startsWith("10") || value.trim().startsWith("99") || value.trim().startsWith("60") || value.trim().startsWith("55")))
          return true;
        else{
          return false;
        }
      }
    }else{
      if(req)return false;
      else return true;
    }
  }
}