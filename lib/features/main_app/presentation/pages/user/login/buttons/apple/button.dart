import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleLoginButton extends StatefulWidget {
  const AppleLoginButton({Key? key}) : super(key: key);

  @override
  _AppleLoginButtonState createState() => _AppleLoginButtonState();
}

class _AppleLoginButtonState extends State<AppleLoginButton> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Platform.isIOS ? InkWell(
      onTap: ()async{
        // UserRepository userRepository = GetIt.instance<UserRepository>();
        // AuthorizationCredentialAppleID result = await SignInWithApple.getAppleIDCredential(
        // scopes: [
        // AppleIDAuthorizationScopes.email,
        // AppleIDAuthorizationScopes.fullName,
        // ],);
        ////// print("UserCredential result = await signInWithApple()");
       ///////// print("getAppleIDCredential = ${result.toString()}");
       //  String? accToken = result.identityToken;
       //  String? email = result.email;
       ///////// print(result.givenName);
       ///////// print(result.familyName);
       ///////// print(result.email);
       ///////// print(result.userIdentifier);
       ///////// print(result.state);
       ///////// print(result.identityToken);

        //////// print(email);
        //////// print(accToken);
        //////// print(result.user!.displayName);
        //////// print(result.user!.phoneNumber);
        // //////// print(result.user.);
        // showLoading(context, Utils.getString(context, "general__loading_text"));
        // LoginResponse submitData = await userRepository.loginSocial(accToken, 'apple', email);
        // closeLoading(context);
        //////// print("submitData.success == null || submitData.success == 0");
        //////// print(submitData.status);
        //////// print(submitData.status == null || submitData.status == 0);
        // if (submitData.status == null || submitData.status == 0) {
        //   // drawer_bloc.getUser();
        //   // drawer_bloc.setUser(submitData);
        //
        // } else {
          // drawer_bloc.setUser(submitData);
          // storage.write(key: 'token', value: accToken);
          // storage.write(key: 'email', value: email);
          // storage.write(key: 'auth_type', value: "apple");
          // storage.write(key: 'usingBiometric', value: 'true');
          // IS_LOGIN = true;
          // Navigator.pushReplacement(
          // context, SlideRightRoute(page: StandartMainPage()));
        // }
      },
      child: SizedBox(
        height: size.height * 7.5 / 100,
        width: size.width * 1 / 3,
        // color:Colors.grey,
        child: Center(child: Container(
          height: size.height * 4 / 100,
          width: size.height * 4 / 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              image: const DecorationImage(
                  image: AssetImage("assets/images/social/apple.png")
              )
          ),
        )),
      ),
    ): Container();
  }
}
