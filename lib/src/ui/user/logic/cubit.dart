import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lifestep/src/tools/config/endpoints.dart';
import 'package:lifestep/src/models/auth/social_login.dart';
import 'package:lifestep/src/ui/user/repositories/auth.dart';
import 'package:lifestep/src/resources/service/web_service.dart';

enum AuthState { login, signUp, confirmation }
enum AuthType { OTP, APPLE, GOOGLE, FACEBOOK }

class AuthCubit extends Cubit<AuthState> {
  // final SessionCubit sessionCubit;

  final _dioToken = CancelToken();
  AuthCubit() : super(AuthState.login);

  // AuthCredentials? credentials;
  AuthType _authType = AuthType.OTP;

  String? _token;

  String? _phone;

  String? _email;

  String? _socialToken;

  String? _fullName;

  String? _otp;

  String get phone => _phone ?? '';

  set phone(String value) {
    _phone = value;
  }

  String get token => _token ?? '';

  set token(String value) {
    _token = value;
  }

  String get socialToken => _socialToken ?? '';

  set socialToken(String value) {
    _socialToken = value;
  }

  String get fullName => _fullName ?? '';

  set fullName(String value) {
    _fullName = value;
  }

  String get email => _email ?? '';

  set email(String value) {
    _email = value;
  }

  AuthType get authType => _authType;

  set authType(AuthType value) {
    _authType = value;
  }

  String get otp => _otp ?? '';

  set otp(String? value) {
    _otp = value;
  }

  int? _userStatusCode;

  int get userStatusCode => _userStatusCode ?? 0;

  set userStatusCode(int? value) {
    _userStatusCode = value;
  }

  void showLogin() => emit(AuthState.login);
  void showOtp() {
    // otp = value;
    emit(AuthState.confirmation);
  }
  void showSignUp() => emit(AuthState.signUp);

  Future<List> socialLogin({required Map<String, dynamic> data}) async{
    UserRepository userRepository = GetIt.instance<UserRepository>();
    final listData = await userRepository.socialLogin(data: data, token: _dioToken);
    userStatusCode = listData[0];
    // if(userStatusCode == 211 || userStatusCode == 210){
   ///////// print(listData[2]);
    if(listData[2] == WEB_SERVICE_ENUM.SUCCESS){
      // SharedPreferences pref = await SharedPreferences.getInstance();

      SocialLoginResponse socialLoginResponse = SocialLoginResponse.fromJson(listData[1]);
     ///////// print(socialLoginResponse.data!.token);
      token  = socialLoginResponse.data!.token ?? '';
      HALF_TOKEN = token;
      // if(authCubit.token != null)
      // pref.setString('token', authCubit.token);
    }
    return listData;
  }
  // void showConfirmSignUp({
  //   String? username,
  //   String? email,
  //   String? password,
  // }) {
  //   credentials = AuthCredentials(
  //     username: username,
  //     email: email,
  //     password: password,
  //   );
  //   emit(AuthState.confirmation);
  // }

  // void launchSession(AuthCredentials credentials) =>
  //     sessionCubit.showSession(credentials);
}