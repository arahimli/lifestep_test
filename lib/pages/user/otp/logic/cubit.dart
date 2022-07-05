import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/pages/user/otp/logic/state.dart';


class OtpNumpadBloc extends Cubit<OtpNumpadState> {
  OtpNumpadBloc() : super(OtpNumpadState());

  void otpChange(String value){
    emit(state.copyWith(otp: value));
  }

}