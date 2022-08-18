import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:lifestep/src/tools/common/utlis.dart';
import 'package:lifestep/src/tools/components/dialog/loading.dart';
import 'package:lifestep/src/tools/config/main_colors.dart';
import 'package:lifestep/src/tools/config/main_config.dart';
import 'package:lifestep/src/cubits/global/session/cubit.dart';
import 'package:lifestep/src/models/auth/social_login.dart';
import 'package:lifestep/src/ui/user/logic/cubit.dart';
import 'package:lifestep/src/resources/service/web_service.dart';
import 'package:sprintf/sprintf.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class FacebookLoginButton extends StatefulWidget {
  final AuthCubit authCubit;
  const FacebookLoginButton({Key? key, required this.authCubit}) : super(key: key);

  @override
  _FacebookLoginButtonState createState() => _FacebookLoginButtonState();
}

class _FacebookLoginButtonState extends State<FacebookLoginButton> {

  final plugin = FacebookLogin(debug: false);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () =>  Platform.isIOS ? _onPressedLogInButton(context, size) : _onPressedLogInButton(context, size) ,
      child: SizedBox(
        height: size.height * 7.5 / 100,
        width: Platform.isIOS ? size.width * 1 / 3 : size.width * 1 / 2,
        // color:Colors.grey,
        child: Center(child: Container(
          height: size.height * 4 / 100,
          width: size.height * 4 / 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              image: DecorationImage(
                  image: AssetImage("assets/images/social/facebook.png")
              )
          ),
        )),
      ),
    );
  }
  // Future<void> _onPressedLogInButton() async {
  //   await plugin.logIn(permissions: [
  //     FacebookPermission.publicProfile,
  //     FacebookPermission.email,
  //   ]);
  //   await _updateLoginInfo();
  // }

  Future<void> _onPressedLogInButton(BuildContext context, Size size) async {

   ///////// print("facebookLoginResult =");
    FacebookLoginResult facebookLoginResult = await plugin.logIn(permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email,
      ]);
     ///////// print("facebookLoginResult = ${facebookLoginResult.status}");
      final token = await plugin.accessToken;
      FacebookUserProfile? profile;
      String? email;
      String? imageUrl;
      if(facebookLoginResult.status == FacebookLoginStatus.success) {
        if (token != null) {
          profile = await plugin.getUserProfile();
          if (token.permissions.contains(FacebookPermission.email.name)) {
            email = await plugin.getUserEmail();
          }
          imageUrl = await plugin.getProfileImageUrl(width: 100);
        }
       ///////// print("profile__profile");
        if (profile != null) {
          widget.authCubit.fullName = sprintf("%s %s", [profile.firstName, profile.lastName]);
          widget.authCubit.authType = AuthType.FACEBOOK;
          widget.authCubit.email = email ?? '';
          widget.authCubit.socialToken = token!.token;
          showLoading(
              context, Utils.getString(context, "general__loading_text"));
          widget.authCubit.socialLogin(data: {
            "social_auth": profile.userId,
            "social_token": widget.authCubit.socialToken,
            "login_method": 'facebook',
          }).then((data) async {
           ///////// print(data[2]);
            closeLoading(context);
            switch (data[2]) {
              case WEB_SERVICE_ENUM.SUCCESS:
                {
                  if (data[0] == 210) {
                   ///////// print(widget.authCubit.userStatusCode);
                    widget.authCubit.showSignUp();
                  } else if (data[0] == 211) {
                    SocialLoginResponse socialLoginResponse = SocialLoginResponse
                        .fromJson(data[1]);
                    BlocProvider.of<SessionCubit>(context).setUser(
                        socialLoginResponse.data!.user);
                    // if(await Utils.checkPermissions())
                    //   Navigator.pushReplacementNamed(context, "index");
                    // else
                    Navigator.pushReplacementNamed(
                        context, "/permission-list-health");
                  }
                }
                break;
              case WEB_SERVICE_ENUM.INTERNET_ERROR:
                {
                  Utils.showErrorModal(context, size,
                      errorCode: WEB_SERVICE_ENUM.INTERNET_ERROR,
                      title: Utils.getString(
                          context, data[1] ?? "internet_connection_error"));
                }
                break;
              default:
                {
                  Utils.showErrorModal(context, size,
                      errorCode: data[2],
                      title: Utils.getString(
                          context, data[1] ?? "error_went_wrong"));
                }
                break;
            }
          }).catchError((e) {
            Utils.showErrorModal(context, size,
                title: Utils.getString(context, "error_went_wrong"));
            closeLoading(context);
          });
        }
        else {
          Utils.showErrorModal(context, size,
              title: Utils.getString(context, "error_went_wrong"));
        }
      }else if(facebookLoginResult.status == FacebookLoginStatus.error) {
        Utils.showErrorModal(context, size,
            title: Utils.getString(context, "error_went_wrong"));
      }else{
        showTopSnackBar(
          context,
          CustomSnackBar.error(
            message: Utils.getString(context, "social_login_cancelled"),
            backgroundColor: MainColors.darkPink500!,
            messagePadding: EdgeInsets.symmetric(horizontal: 24, vertical: 2,  ),
            textStyle: TextStyle(fontFamily: MainConfig.main_default_font_family,fontSize: 16, height: 1.1, fontWeight: FontWeight.w600, color: MainColors.white),
            icon: Container(),
            boxShadow: [],
          ),
        );
      }
  }


  Future<void> _onPressedExpressLogInButton(BuildContext context, Size size) async {
   ///////// print("Clicked");
    final res = await plugin.expressLogin();
    if (res.status == FacebookLoginStatus.success) {
      await _updateLoginInfo();
    } else {
      await showDialog<Object>(
        context: context,
        builder: (context) => const AlertDialog(
          content: Text("Can't make express log in. Try regular log in."),
        ),
      );
    }
  }

  Future<void> _updateLoginInfo() async {
    // final plugin = plugin;
    await plugin.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    final token = await plugin.accessToken;
    FacebookUserProfile? profile;
    String? email;
    String? imageUrl;

    if (token != null) {
      profile = await plugin.getUserProfile();
      if (token.permissions.contains(FacebookPermission.email.name)) {
        email = await plugin.getUserEmail();
      }
      imageUrl = await plugin.getProfileImageUrl(width: 100);
    }
   ///////// print("profile__profile");
    if(profile != null){
      widget.authCubit.fullName = sprintf("%s %s", [profile.firstName, profile.lastName]);
      widget.authCubit.authType = AuthType.FACEBOOK;
      widget.authCubit.email = email ?? '';
      widget.authCubit.socialToken = token!.token;
      widget.authCubit.showSignUp();
    }
  }

  // Future<void> _onPressedLogOutButton() async {
  //   await plugin.logOut();
  //   await _updateLoginInfo();
  // }


}
