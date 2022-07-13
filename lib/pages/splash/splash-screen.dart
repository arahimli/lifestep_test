import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lifestep/config/main_colors.dart';

class AppSplashScreen extends StatefulWidget {
  const AppSplashScreen({Key? key}) : super(key: key);

  @override
  _AppSplashScreenState createState() => _AppSplashScreenState();
}


class _AppSplashScreenState extends State<AppSplashScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: ()async{
        return Future.value(false);
      },
      child: Scaffold(
        body: Container(
          color: MainColors.generalColor,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 1.2 / 10),
              child: SvgPicture.asset("assets/svgs/logo/splash-logo-c.svg", height: double.infinity, width: double.infinity,),
            ),
          ),
        ),
      ),
    );
  }
}

