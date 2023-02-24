
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lifestep/features/main_app/data/models/config/settings.dart';
import 'package:lifestep/features/tools/common/utlis.dart';
import 'package:lifestep/features/main_app/presentation/widgets/buttons/big_unborderd_button.dart';
import 'package:lifestep/features/tools/config/main_colors.dart';
import 'package:lifestep/features/tools/config/scroll_behavior.dart';
import 'package:lifestep/features/tools/config/styles.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:lifestep/features/tools/config/get_it.dart';

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
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0, bottom: 8.0, ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: SvgPicture.asset("assets/svgs/general/permission-page.svg", width: size.width - 48, height: size.width - 48,)
                    ),
                    Text(
                      Utils.getString(context, "permission__page__title_text"),
                      style: MainStyles.boldTextStyle.copyWith(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16,),
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
                              // padding: const PagePadding.leftRight16(),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  if(Platform.isAndroid)
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 12.0),
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
                                        padding: const EdgeInsets.only(bottom: 12.0),
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

                    // var statusnstallPackages = await Permission.requestInstallPackages.status;
                    // if (statusnstallPackages.isDenied) {
                    //   var status2 = await Permission.requestInstallPackages.request();
                    //   if (!status2.isGranted) {
                    //     return;
                    //   }
                    // }
                    var status = await Permission.activityRecognition.status;
                    if (status.isDenied) {
                      var status2 = await Permission.activityRecognition.request();
                      if (!status2.isGranted) {
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

                  sl<Settings>().accessToken = sl<Settings>().accessHalfToken;
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
