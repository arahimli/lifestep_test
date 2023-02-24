
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lifestep/features/tools/common/utlis.dart';
import 'package:lifestep/features/main_app/presentation/widgets/buttons/big_unborderd_button.dart';
import 'package:lifestep/features/tools/config/main_colors.dart';
import 'package:lifestep/features/tools/config/main_config.dart';
import 'package:lifestep/features/tools/config/styles.dart';

class UpdateWarningView extends StatefulWidget {
  const UpdateWarningView({Key? key}) : super(key: key);

  @override
  _UpdateWarningViewState createState() => _UpdateWarningViewState();
}

class _UpdateWarningViewState extends State<UpdateWarningView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: ()async{
        return Future.value(false);
      },
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 32.0),
                            child: Image.asset("assets/images/error/update.png", width: size.width, height: size.width,)
                        ),

                        Text(
                          Utils.getString(context, "update_app_warning_message"),
                          style: MainStyles.boldTextStyle.copyWith(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
              ),

              BigUnBorderedButton(
                buttonColor: MainColors.generalColor,
                onTap: (){
                    Utils.launchUrl(Platform.isIOS ? MainConfig.appAppSotreUrl : MainConfig.appPlayStoreUrl);
                },
                borderRadius: 100,
                text: Utils.getString(context, "update_app_warning_button_text"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
