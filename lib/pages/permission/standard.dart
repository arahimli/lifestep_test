
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lifestep/tools/common/utlis.dart';
import 'package:lifestep/tools/components/buttons/big_unborderd_button.dart';
import 'package:lifestep/config/endpoints.dart';
import 'package:lifestep/config/main_colors.dart';
import 'package:lifestep/config/scroll_behavior.dart';
import 'package:lifestep/config/styles.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StandardPermissionHandleView extends StatefulWidget {
  const StandardPermissionHandleView({Key? key}) : super(key: key);

  @override
  _StandardPermissionHandleViewState createState() => _StandardPermissionHandleViewState();
}

class _StandardPermissionHandleViewState extends State<StandardPermissionHandleView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: ()async{
        return Future.value(false);
      },
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0, bottom: 8.0, ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        child: SvgPicture.asset("assets/svgs/general/permission-page.svg", width: size.width - 48, height: size.width - 48,)
                    ),
                    Text(
                      Utils.getString(context, "permission__page__title_text"),
                      style: MainStyles.boldTextStyle.copyWith(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16,),
                  ],
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                    builder: (context, constraints) {
                      return ScrollConfiguration(
                        behavior: MainScrollBehavior(),
                        child: SingleChildScrollView(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight
                              ),
                              // padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  if(Platform.isAndroid)
                                  Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 12.0),
                                        child: Text(
                                          Utils.getString(context, "permission__page__activity_title"),
                                          style: MainStyles.extraBoldTextStyle.copyWith(fontSize: 16),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Text(
                                        Utils.getString(context, "permission__page__activity_text"),
                                        style: MainStyles.semiBoldTextStyle.copyWith(fontSize: 14),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 12.0),
                                        child: Text(
                                          Utils.getString(context, "permission__page__location_title"),
                                          style: MainStyles.extraBoldTextStyle.copyWith(fontSize: 16),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Text(
                                        Utils.getString(context, "permission__page__location_text"),
                                        style: MainStyles.semiBoldTextStyle.copyWith(fontSize: 14),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                        ),
                      );
                    }
                ),
              ),
              BigUnBorderedButton(
                vertical: 8,
                buttonColor: MainColors.generalColor,
                onTap: () async{


                  if(Platform.isAndroid) {
                    var status = await Permission.activityRecognition.status;
                    if (status.isDenied) {
                      var status2 = await Permission.activityRecognition.request();
                      if (!status2.isGranted) {
                        //////// print("!status2.isGranted");
                        // stepsPermissionDialog();
                        return;
                      }

                    }
                  }
                  var status3 = await Permission.locationWhenInUse.status;
                  if(status3.isDenied) {
                    var status4 =await Permission.locationWhenInUse.request();
                    if(!status4.isGranted) {
                      //////// print("!status4.isGranted");
                      // stepsPermissionDialog();
                      return;
                    }
                  }

                  SharedPreferences pref = await SharedPreferences.getInstance();
                  TOKEN = HALF_TOKEN;
                  if(HALF_TOKEN != null)
                    pref.setString('token', HALF_TOKEN!);

                  Navigator.pushReplacementNamed(context, "/index");
                },
                borderRadius: 100,
                text: Utils.getString(context, "permission__page__button_text"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
