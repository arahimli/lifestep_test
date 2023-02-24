
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lifestep/features/tools/common/utlis.dart';
import 'package:lifestep/features/main_app/presentation/widgets/buttons/big_unborderd_button.dart';
import 'package:lifestep/features/tools/config/main_colors.dart';
import 'package:lifestep/features/tools/config/styles.dart';

class CustomYesNoDialogWidget extends StatefulWidget {
  final String text;
  final String? svgAsset;
  final Function()? yesTap;
  final Function()? noTap;
  final String? yesText;
  final String? noText;
  final Color? yesTextColor;
  final Color? noTextColor;

  const CustomYesNoDialogWidget({Key? key, required this.text, this.yesTap, this.noTap, this.svgAsset, this.yesText, this.noText, this.yesTextColor, this.noTextColor}) : super(key: key);
  @override
  _CustomYesNoDialogWidgetState createState() => _CustomYesNoDialogWidgetState();
}

class _CustomYesNoDialogWidgetState extends State<CustomYesNoDialogWidget> {

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    return Material(
      type: MaterialType.transparency,
      child: Dialog(
          shape: const RoundedRectangleBorder(
              borderRadius:
              BorderRadius.all(Radius.circular(12.0))),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              // border: Border.all(color: Colors.blueAccent,width: 2),
                borderRadius:
                BorderRadius.all(Radius.circular(10.0))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if(widget.svgAsset != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 24),
                    child: SvgPicture.asset(
                      widget.svgAsset!,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
                  child: AutoSizeText(
                    widget.text, style: MainStyles.mediumTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),

                Divider(color: MainColors.middleGrey200,height: 0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                right: BorderSide(
                                    color: MainColors.middleGrey200!
                                )
                            )
                        ),
                        child: BigUnBorderedButton(
                          onTap: widget.yesTap,
                          text: Utils.getString(context, "general__dialog__option_yes"),
                          buttonColor: MainColors.middleGrey100,
                          textColor: widget.yesTextColor ?? MainColors.generalColor,
                          borderRadius: 0,
                        ),
                      ),
                    ),
                    Expanded(
                      child: BigUnBorderedButton(
                        onTap: widget.noTap,
                        text: Utils.getString(context, "general__dialog__option_cancel"),
                        buttonColor: MainColors.middleGrey100,
                        textColor: widget.noTextColor ?? MainColors.generalColor,
                        borderRadius: 0,
                      ),
                    ),
                  ],
                ),

              ],
            ),
          )),
    );
  }
}




void showCustomYesNoDialog(BuildContext context, String text, Function() yesTap, Function() noTap, {String? svgAsset, String? yesText, String? noText, Color? yesTextColor, Color? noTextColor}){
  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () => Future.value(true),
          child: CustomYesNoDialogWidget(
            text: text,
            svgAsset: svgAsset,
            yesTap: yesTap,
            noTap: noTap,
          ),
        );
      }
  );
}


void closeCustomYesNoDialog(BuildContext context){
  Navigator.of(context, rootNavigator: true).pop();
}