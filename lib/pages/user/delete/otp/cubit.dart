import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:lifestep/pages/user/delete/otp/state.dart';
import 'package:lifestep/tools/common/validator.dart';
import 'package:lifestep/config/endpoints.dart';
import 'package:lifestep/model/auth/otp.dart';
import 'package:lifestep/pages/user/cubit/cubit.dart';
import 'package:lifestep/pages/user/form-submission-status.dart';
import 'package:lifestep/pages/user/otp/state.dart';
import 'package:lifestep/pages/user/repositories/auth.dart';
import 'package:lifestep/repositories/service/web_service.dart';

class OtpRemoveCubit extends Cubit<OtpRemoveState> {
  final UserRepository authRepo;
  FormValidator formValidator = FormValidator();

  CountdownTimerController _countdownTimerController = CountdownTimerController(endTime: DateTime.now().millisecondsSinceEpoch + 1000 * 180);
  CountdownTimerController get countdownTimerController => _countdownTimerController;
  late int _endTime;
  set endTime(int value) {
    _endTime = value;
  }

  int get endTime => _endTime;
  // initialize(){
  //   state.copyWith(otp: authCubit.otp);
  //   emit(state.copyWith(otp: authCubit.otp, isValidOtp: formValidator.validOtp(authCubit.otp)));
  // }
  OtpRemoveCubit({required this.authRepo}) : super(OtpRemoveState(endTime: DateTime.now().millisecondsSinceEpoch + 1000 * 180)){

    _endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 180;
    _countdownTimerController = CountdownTimerController(endTime: _endTime);

  }

  void otpChanged(String value){
    emit(state.copyWith(otp: value, isValidOtp: formValidator.validOtp(value, 6), isWrongOtp: (!formValidator.validOtp(value, 6) && value.length == 6)));
  }

  Future<List> otpSubmit() async{

      emit(state.copyWith(formStatus: FormSubmitting()));
      final data = await authRepo.deleteOtp(
        data: {
          'otp': state.otp ?? '',
        },
      );
      // if(data[2] == WEB_SERVICE_ENUM.SUCCESS){
      //  
      // }

      state.copyWith(formStatus: SubmissionSuccess());
      return data;

  }
  Future<List> changeEndTime() async{

      emit(state.copyWith(formStatus: FormSubmitting()));
      final data = await authRepo.deleteUser(
        data: {
        },
      );
      print(data);
      if (data[0] == 200) {
        _endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 180;
        _countdownTimerController = CountdownTimerController(endTime: _endTime);
        emit(state.copyWith(otp: null, isValidOtp: false, endTime: _endTime));
      }
      return data;
  }
}