import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lifestep/tools/common/utlis.dart';
import 'package:lifestep/tools/components/buttons/big_unborderd_button.dart';
import 'package:lifestep/config/main_colors.dart';
import 'package:lifestep/config/styles.dart';
import 'package:lifestep/tools/constants/enum.dart';

class StandardMessageWidget extends StatefulWidget {
  final IMAGE_TYPE imageType;
  final String imageUrl;
  final String? title;
  final String? text;
  final String? buttonText;
  final Function? onTap;
  const StandardMessageWidget({Key? key, this.imageType : IMAGE_TYPE.SVG, this.title, this.text, required this.imageUrl, this.buttonText, this.onTap}) : super(key: key);

  @override
  _StandardMessageWidgetState createState() => _StandardMessageWidgetState();
}

class _StandardMessageWidgetState extends State<StandardMessageWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: ()async{
        return Future.value(false);
      },
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        widget.imageType == IMAGE_TYPE.IMAGE ?
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 32.0),
                            child: Image.asset(widget.imageUrl, width: size.width, height: size.width,)
                        )
                        :
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 32.0),
                            child: SvgPicture.asset(widget.imageUrl, width: size.width, height: size.width,)
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            widget.title ?? Utils.getString(context, "update_app_warning_message"),
                            style: MainStyles.boldTextStyle.copyWith(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            widget.text ?? Utils.getString(context, "update_app_warning_message"),
                            style: MainStyles.semiBoldTextStyle.copyWith(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  )
              ),

              BigUnBorderedButton(
                buttonColor: MainColors.generalColor,
                onTap: (){
                  if(widget.onTap != null)
                    widget.onTap!();
                },
                borderRadius: 100,
                text: widget.buttonText ?? Utils.getString(context, "update_app_warning_button_text"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
