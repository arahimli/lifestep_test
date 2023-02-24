import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:lifestep/features/main_app/data/models/config/settings.dart';
import 'package:lifestep/features/tools/config/endpoint_config.dart';
import 'package:lifestep/features/tools/common/validator.dart';
import 'package:lifestep/features/tools/config/endpoints.dart';
import 'package:lifestep/features/main_app/data/models/auth/otp.dart';
import 'package:lifestep/features/main_app/presentation/pages/user/logic/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/user/form_submission_status.dart';
import 'package:lifestep/features/main_app/presentation/pages/user/otp/state.dart';
import 'package:lifestep/features/main_app/presentation/pages/user/repositories/auth.dart';
import 'package:lifestep/features/main_app/resources/service/web_service.dart';

import 'package:lifestep/features/tools/config/get_it.dart';

class OtpBloc extends Cubit<OtpState> {
  final UserRepository authRepo;
  final AuthCubit authCubit;
  FormValidator formValidator = FormValidator();

  CountdownTimerController _countdownTimerController = CountdownTimerController(endTime: DateTime.now().millisecondsSinceEpoch + 1000 * 180);
  CountdownTimerController get countdownTimerController => _countdownTimerController;
  late int endTime;
  // set endTime(int value) {
  //   endTime = value;
  // }
  //
  // int get endTime => endTime;
  // initialize(){
  //   state.copyWith(otp: authCubit.otp);
  //   emit(state.copyWith(otp: authCubit.otp, isValidOtp: formValidator.validOtp(authCubit.otp)));
  // }
  OtpBloc({required this.authRepo, required this.authCubit}) : super(OtpState(endTime: DateTime.now().millisecondsSinceEpoch + 1000 * 180)){

    endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 180;
    _countdownTimerController = CountdownTimerController(endTime: endTime);

  }

  void otpChanged(String value){
    emit(state.copyWith(otp: value, isValidOtp: formValidator.validOtp(value, 6), isWrongOtp: (!formValidator.validOtp(value, 6) && value.length == 6)));
  }

  Future<List> changeEndTime()async{

      var data = await WebService.postCall(
          data: {
            "phone": authCubit.phone
          },
          url: EndpointConfig.resendOtp,
          headers: {
            'Authorization': "Bearer ${authCubit.token}",
            'Accept-Language': languageGlobal,
            'Accept': 'application/json'
          });
      if (data[0] == 200) {
        endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 180;
        _countdownTimerController = CountdownTimerController(endTime: endTime);
        emit(state.copyWith(otp: null, isValidOtp: false, endTime: endTime));
      }
      return data;
  }
  Future<List> otpSubmit() async{

      emit(state.copyWith(formStatus: FormSubmitting()));
      final data = await authRepo.loginOtp(
        data: {
          'otp': state.otp ?? '',
          'phone': authCubit.phone,
        },
        header: {
          'Authorization': "Bearer ${authCubit.token}",
          'Accept-Language': languageGlobal,
          'Accept': 'application/json'
        }
      );
      if(authCubit.userStatusCode == 211 || authCubit.userStatusCode == 210){
        if(data[2] == WEB_SERVICE_ENUM.success){
          OtpResponse otpResponse = OtpResponse.fromJson(data[1]);
          authCubit.token = otpResponse.data != null && otpResponse.data!.token != null ? otpResponse.data!.token! : '';
          // HALF_TOKEN = authCubit.token;
          sl<Settings>().accessHalfToken = authCubit.token;
        }
      }

      state.copyWith(formStatus: SubmissionSuccess());
      return data;

  }
}