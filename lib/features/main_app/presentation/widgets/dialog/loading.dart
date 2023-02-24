
import 'package:flutter/material.dart';
import 'package:lifestep/features/tools/config/main_colors.dart';
import 'package:lifestep/features/tools/config/styles.dart';

class LoadingDialogWidget extends StatefulWidget {
  final String text;

  const LoadingDialogWidget({Key? key, required this.text}) : super(key: key);
  @override
  _LoadingDialogWidgetState createState() => _LoadingDialogWidgetState();
}

class _LoadingDialogWidgetState extends State<LoadingDialogWidget> {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      type: MaterialType.transparency,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Center(
          child: SizedBox(
//          width: 120.0,
//          height: 120.0,
            child: Container(
              decoration: ShapeDecoration(
                color: MainColors.transparent,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(MainColors.primaryColor), strokeWidth: 10,),
                    height: size.width * 2.5/ 10,
                    width: size.width * 2.5/ 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20.0,
                    ),
                    child: Text(widget.text, style: MainStyles.boldTextStyle.copyWith(color: MainColors.white),),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


void showLoading(BuildContext context,String text){
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: LoadingDialogWidget(text: text,
          ),
        );
      }
  );
}


void closeLoading(BuildContext context){
  Navigator.of(context, rootNavigator: true).pop();
}

void closeGeneralDialog(BuildContext context){
  Navigator.of(context, rootNavigator: true).pop();
}