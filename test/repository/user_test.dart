
import 'package:flutter_test/flutter_test.dart';
import 'package:lifestep/config/endpoints.dart';
import 'package:lifestep/pages/user/repositories/auth.dart';
import 'package:lifestep/repositories/service/web_service.dart';

void main() {
  UserRepository userRepository = UserRepository();

  test('Login With Credential Test', () async{
    var result = await userRepository.loginWithCredential(phone: '501111111');
    expect(result[2], WEB_SERVICE_ENUM.SUCCESS);
  });

  test('Get User UnAuth Test', () async{
    var result = await userRepository.getUser();
    expect(result[2], WEB_SERVICE_ENUM.UN_AUTH);
  });

  // test('Get User Auth Test', () async{
  //   var result = await userRepository.getUser();
  //   TOKEN = "some token";
  //   expect(result[2], WEB_SERVICE_ENUM.SUCCESS);
  // });

}