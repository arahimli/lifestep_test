
import 'package:flutter/material.dart';
import 'package:lifestep/src/tools/common/utlis.dart';
import 'package:lifestep/src/tools/components/buttons/big_unborderd_button.dart';
import 'package:lifestep/src/tools/config/main_colors.dart';
import 'package:lifestep/src/tools/config/styles.dart';

class InternetConnectionErrorView extends StatefulWidget {
  final String? errorText;
  final Function? onTap;
  const InternetConnectionErrorView({Key? key, this.errorText, this.onTap}) : super(key: key);

  @override
  _InternetConnectionErrorViewState createState() => _InternetConnectionErrorViewState();
}

class _InternetConnectionErrorViewState extends State<InternetConnectionErrorView> {
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
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 32.0),
                            child: Image.asset("assets/images/error/internet.png", width: size.width, height: size.width,)
                        ),

                        Text(
                          widget.errorText ?? Utils.getString(context, "internet_connection_error"),
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
                  if(widget.onTap != null)
                    widget.onTap!();
                  else{
                    Navigator.pushReplacementNamed(context, "/apploading");
                  }
                },
                borderRadius: 100,
                text: Utils.getString(context, "general_error__button_text"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
