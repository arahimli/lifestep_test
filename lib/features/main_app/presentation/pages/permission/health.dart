
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:lifestep/features/main_app/data/models/config/settings.dart';
import 'package:lifestep/features/tools/common/utlis.dart';
import 'package:lifestep/features/main_app/presentation/widgets/buttons/big_unborderd_button.dart';
import 'package:lifestep/features/tools/config/main_colors.dart';
import 'package:lifestep/features/tools/config/styles.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:lifestep/features/tools/config/get_it.dart';

class HealthPermissionHandleView extends StatefulWidget {
  const HealthPermissionHandleView({Key? key}) : super(key: key);

  @override
  _HealthPermissionHandleViewState createState() => _HealthPermissionHandleViewState();
}

class _HealthPermissionHandleViewState extends State<HealthPermissionHandleView> {
  bool clicked = false;
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
              Platform.isAndroid ?
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Image.asset("assets/images/general/google-fit.png", height: size.width * 6 / 10)
                          ),
                          Text(
                            Utils.getString(context, "permission__page__google_fit_title"),
                            style: MainStyles.boldTextStyle.copyWith(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12,),
                          Text(
                            Utils.getString(context, "permission__page__google_fit_description"),
                            style: MainStyles.boldTextStyle.copyWith(fontSize: 16, color: MainColors.textPrimaryLightColor),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24,),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: Text(
                                    Utils.getString(context, "permission__page__google_fit_step1_title"),
                                    style: MainStyles.boldTextStyle.copyWith(fontSize: 20),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: Text(
                                    Utils.getString(context, "permission__page__google_fit_step1_text"),
                                    style: MainStyles.extraBoldTextStyle.copyWith(fontSize: 14, color: const Color(0xFF797C81)),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: Text(
                                    Utils.getString(context, "permission__page__google_fit_step2_title"),
                                    style: MainStyles.boldTextStyle.copyWith(fontSize: 20),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: Text(
                                    Utils.getString(context, "permission__page__google_fit_step2_text"),
                                    style: MainStyles.extraBoldTextStyle.copyWith(fontSize: 14, color: const Color(0xFF797C81)),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: Text(
                                    Utils.getString(context, "permission__page__google_fit_step3_title"),
                                    style: MainStyles.boldTextStyle.copyWith(fontSize: 20),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 24.0),
                                  child: Text(
                                    Utils.getString(context, "permission__page__google_fit_step3_text"),
                                    style: MainStyles.extraBoldTextStyle.copyWith(fontSize: 14, color: const Color(0xFF797C81)),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ):
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 48),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Image.asset("assets/images/general/apple-health.png", width: size.width - 48)
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 32.0),
                              child: Text(
                                Utils.getString(context, "permission__page__health_title"),
                                style: MainStyles.boldTextStyle.copyWith(fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Text(
                              Utils.getString(context, "permission__page__health_text"),
                              style: MainStyles.extraBoldTextStyle.copyWith(fontSize: 14, color: const Color(0xFF797C81)),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Platform.isIOS ?
              BigUnBorderedButton(
                vertical: 8,
                buttonColor: MainColors.generalColor,
                onTap: () => clickButton(context),
                borderRadius: 100,
                text: Utils.getString(context, !clicked ? "permission__page__google_fit_button" : "permission__page__health_button_text"),
              )
              // :InkWell(
              //   onTap: () => clickButton(context),
              //   child: Container(
              //     margin: const EdgeInsets.symmetric(vertical: size.width * 3 / 100),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Container(
              //           height: size.width * 12 / 100,
              //           width: size.width * 12 / 100,
              //           padding: const EdgeInsets.symmetric(horizontal: size.width * 3 / 100),
              //           decoration: BoxDecoration(
              //               border: Border.all(
              //                   color: Color(0xFF346EF1),
              //                   style:BorderStyle.solid
              //               )
              //           ),
              //           child: Image.asset("assets/images/social/google.png"),
              //         ),
              //         Container(
              //           height: size.width * 12 / 100,
              //           padding: const EdgeInsets.symmetric(horizontal: size.width * 4 / 100),
              //           decoration: BoxDecoration(
              //             color: Color(0xFF346EF1),
              //               border: Border.all(
              //                   color: Color(0xFF346EF1),
              //                   style:BorderStyle.solid
              //               )
              //           ),
              //           child: Center(child: Text(Utils.getString(context, "permission__page__google_fit_button_text"), style: MainStyles.boldTextStyle.copyWith(color: Colors.white),)),
              //         )
              //       ],
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> clickButton(BuildContext context) async{

    if(Platform.isIOS) {
      await Permission.appTrackingTransparency.request();
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
    if(Platform.isAndroid && !clicked) {
      setState(() {
        clicked = true;
      });
      Utils.launchPlayStoreApp("com.google.android.apps.fitness");

      return;
    }
    if(!(await Utils.checkHealthPermissions())) {
      // Utils.launchPlayStoreApp("com.google.android.apps.fitness");
      return;
    }
    if(await Utils.checkStandardPermissions()){
      sl<Settings>().accessToken = sl<Settings>().accessHalfToken;
      Navigator.pushReplacementNamed(context, "/index");
    }else {
      Navigator.pushReplacementNamed(context, "/permission-list-standard");
    }
  }
}
