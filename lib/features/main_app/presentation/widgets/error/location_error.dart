
import 'package:flutter/material.dart';
import 'package:lifestep/features/tools/common/utlis.dart';
import 'package:lifestep/features/main_app/presentation/widgets/buttons/big_unborderd_button.dart';
import 'package:lifestep/features/tools/config/main_colors.dart';
import 'package:lifestep/features/tools/config/styles.dart';

class LocationErrorView extends StatefulWidget {
  final String? errorText;
  final Function? onTap;
  const LocationErrorView({Key? key, this.errorText, this.onTap}) : super(key: key);

  @override
  _LocationErrorViewState createState() => _LocationErrorViewState();
}

class _LocationErrorViewState extends State<LocationErrorView> {
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
                            child: Image.asset("assets/images/error/location.png", width: size.width, height: size.width,)
                        ),

                        Text(
                          widget.errorText ?? Utils.getString(context, "general_error__message_text"),
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
                  if(widget.onTap != null){
                    widget.onTap!();}
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
