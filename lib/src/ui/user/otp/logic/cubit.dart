import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/src/ui/user/otp/logic/state.dart';


class OtpNumpadCubit extends Cubit<OtpNumpadState> {
  OtpNumpadCubit() : super(OtpNumpadState());

  void otpChange(String value){
    emit(state.copyWith(otp: value));
  }

}