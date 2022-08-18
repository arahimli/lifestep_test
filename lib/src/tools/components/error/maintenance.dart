
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifestep/src/tools/common/utlis.dart';
import 'package:lifestep/src/tools/components/buttons/big_borderd_button.dart';
import 'package:lifestep/src/tools/config/main_colors.dart';
import 'package:lifestep/src/tools/config/styles.dart';

class MaintenanceWarningView extends StatefulWidget {
  const MaintenanceWarningView({Key? key}) : super(key: key);

  @override
  _MaintenanceWarningViewState createState() => _MaintenanceWarningViewState();
}

class _MaintenanceWarningViewState extends State<MaintenanceWarningView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: ()async{
        return Future.value(false);
      },
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: [
              Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          child: Image.asset("assets/images/error/maintenance.png", width: size.width, height: size.width,)
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0, left: 32, right: 32),
                        child: Text(
                          Utils.getString(context, "maintenance_app_warning_title"),
                          style: MainStyles.boldTextStyle.copyWith(fontSize: 24, color: MainColors.darkPink500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0, left: 32, right: 32),
                        child: Text(
                          Utils.getString(context, "maintenance_app_warning_message"),
                          style: MainStyles.mediumTextStyle.copyWith(height: 1.3),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: BigBorderedButton(
                  horizontal: 16,
                  buttonColor: MainColors.generalColor,
                  onTap: (){
                    if(Platform.isAndroid)
                      SystemNavigator.pop();
                    else
                      exit(0);
                  },
                  borderRadius: 100,
                  text: Utils.getString(context, "maintenance_app_warning_button_text"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
