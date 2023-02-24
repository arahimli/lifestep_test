import 'package:flutter_test/flutter_test.dart';
import 'package:lifestep/features/main_app/presentation/pages/user/repositories/auth.dart';
import 'package:lifestep/features/main_app/resources/service/web_service.dart';

void main() {
  UserRepository userRepository = UserRepository();

  test('Login With Credential Test', () async{
    var result = await userRepository.loginWithCredential(phone: '501111111');
    expect(result[2], WEB_SERVICE_ENUM.success);
  });

  test('Get User UnAuth Test', () async{
    var result = await userRepository.getUser();
    expect(result[2], WEB_SERVICE_ENUM.unAuth);
  });

  // test('Get User Auth Test', () async{
  //   var result = await userRepository.getUser();
  //   TOKEN = "some token";
  //   expect(result[2], WEB_SERVICE_ENUM.SUCCESS);
  // });

}