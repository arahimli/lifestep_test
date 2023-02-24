import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/features/main_app/presentation/pages/user/otp/logic/state.dart';


class OtpNumpadCubit extends Cubit<OtpNumpadState> {
  OtpNumpadCubit() : super(OtpNumpadState());

  void otpChange(String value){
    emit(state.copyWith(otp: value));
  }

}