// import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lifestep/tools/common/utlis.dart';
import 'package:lifestep/tools/components/dialog/loading.dart';
import 'package:lifestep/model/auth/login.dart';
import 'package:lifestep/pages/user/login/buttons/apple/data.dart';
import 'package:lifestep/pages/user/repositories/auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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
        UserRepository userRepository = UserRepository();
        AuthorizationCredentialAppleID result = await SignInWithApple.getAppleIDCredential(
        scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
        ],);
        ////// print("UserCredential result = await signInWithApple()");
       ///////// print("getAppleIDCredential = ${result.toString()}");
        String? acc_token = result.identityToken;
        String? email = result.email;
       ///////// print(result.givenName);
       ///////// print(result.familyName);
       ///////// print(result.email);
       ///////// print(result.userIdentifier);
       ///////// print(result.state);
       ///////// print(result.identityToken);

        //////// print(email);
        //////// print(acc_token);
        //////// print(result.user!.displayName);
        //////// print(result.user!.phoneNumber);
        // //////// print(result.user.);
        // showLoading(context, Utils.getString(context, "general__loading_text"));
        // LoginResponse submitData = await userRepository.loginSocial(acc_token, 'apple', email);
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
          // storage.write(key: 'token', value: acc_token);
          // storage.write(key: 'email', value: email);
          // storage.write(key: 'auth_type', value: "apple");
          // storage.write(key: 'usingBiometric', value: 'true');
          // IS_LOGIN = true;
          // Navigator.pushReplacement(
          // context, SlideRightRoute(page: StandartMainPage()));
        // }
      },
      child: Container(
        height: size.height * 7.5 / 100,
        width: size.width * 1 / 3,
        // color:Colors.grey,
        child: Center(child: Container(
          height: size.height * 4 / 100,
          width: size.height * 4 / 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              image: DecorationImage(
                  image: AssetImage("assets/images/social/apple.png")
              )
          ),
        )),
      ),
    ): Container();
  }
}
