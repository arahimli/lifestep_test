import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);


class GoogleLoginButton extends StatefulWidget {
  const GoogleLoginButton({Key? key}) : super(key: key);

  @override
  _GoogleLoginButtonState createState() => _GoogleLoginButtonState();
}

class _GoogleLoginButtonState extends State<GoogleLoginButton> {



  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  loginWithGmail(BuildContext context) async {
    //////// print("loginWithGmail_loginWithGmail_loginWithGmail");
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email',
        'https://www.googleapis.com/auth/contacts.readonly',],
    );
    googleSignIn.signIn().then((GoogleSignInAccount? acc) async {
   ////// print('googleSignIngoogleSignIngoogleSignIngoogleSignIn');
      // String cashList = acc?.displayName;
      // //////// print("Gmail name = " + cashList.toString());
      // var nameUser = cashList != null && cashList.length > 0 ? cashList[0] : "";
      // var surnameUser =
      // cashList != null && cashList.length > 1 ? cashList[1] : "";
      // var image = acc != null && acc.photoUrl != null ? acc.photoUrl : "";
      //////// print((await acc!.authentication).accessToken);
   ////// print(acc?.id);
   ////// print(acc?.displayName);
   ////// print(acc?.email);

      // LoginResponse submitData = await loginBloc.loginSocial((await acc.authentication).accessToken, 'google', acc.email);
      // closeLoading(context);
      // if (submitData.success == null || submitData.success == 0) {
      //   // drawer_bloc.getUser();
      //   drawer_bloc.setUser(submitData);
      //   showDialog(
      //       context: context,
      //       builder: (BuildContext context) {
      //         return ErrorDialog(
      //           message: Utils.getString(context, submitData.error.first.toString()),
      //         );
      //       });
      // } else {
      //   widget.storage.write(key: 'token', value: (await acc.authentication).accessToken);
      //   widget.storage.write(key: 'email', value: acc.email);
      //   widget.storage.write(key: 'auth_type', value: "google");
      //   widget.storage.write(key: 'usingBiometric', value: 'true');
      //   IS_LOGIN = true;
      //   Navigator.pushReplacement(
      //       context, SlideRightRoute(page: StandartMainPage()));
      // }

    }).catchError((e, track) async{
      // await _googleSignIn.disconnect();
   ////// print(await _googleSignIn.isSignedIn());
   ////// print((await _googleSignIn.currentUser)?.id);
   ////// print((await _googleSignIn.clientId));
      // print((await _googleSignIn.));
   ////// print(track);
      // showDialog<dynamic>(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return ErrorDialog(
      //         message: e.toString(),
      //       );
      //     });
    });
  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: (){
        loginWithGmail(context);
      },
      child: Container(
        height: size.height * 7.5 / 100,
        width: Platform.isIOS ? size.width * 1 / 3 : size.width * 1 / 2,
        // color:Colors.grey,
        child: Center(child: Container(
          height: size.height * 4 / 100,
          width: size.height * 4 / 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              image: DecorationImage(
                  image: AssetImage("assets/images/social/google.png")
              )
          ),
        )),
      ),
    );
  }
}
