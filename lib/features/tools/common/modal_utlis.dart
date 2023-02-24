import 'package:auto_size_text/auto_size_text.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lifestep/features/tools/common/utlis.dart';
import 'package:lifestep/features/main_app/presentation/widgets/buttons/big_unborderd_button.dart';
import 'package:lifestep/features/main_app/presentation/widgets/common/confetti.dart';
import 'package:lifestep/features/tools/config/main_colors.dart';
import 'package:lifestep/features/tools/config/styles.dart';
import 'package:flutter/material.dart';

class ModalUtils {
  ModalUtils._();


  static dynamic removeUserBottomModal(BuildContext context, Size size, {Function? onTap}) {

    return showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return Container(
            // height: size.height / (812 / 664),
            padding: const EdgeInsets.symmetric(
                vertical:
                16,
                horizontal:
                16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                        width: 64,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          // borderRadius: BorderRadius.circular(10)
                        )
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
                    child: SvgPicture.asset("assets/svgs/dialog/user-delete-modal.svg"),
                  ),
                  AutoSizeText(Utils.getString(context, "profile_view___tab_settings__delete_user__modal_title"), style: MainStyles.appbarStyle,),
                  SizedBox(height: size.height * 0.2 / 10,),
                  AutoSizeText(Utils.getString(context, "profile_view___tab_settings__delete_user__modal_text"), style: MainStyles.mediumTextStyle,),
                  SizedBox(height: size.height * 0.15 / 10,),
                  // Divider(),
                  BigUnBorderedButton(
                    text: Utils.getString(context, "profile_view___tab_settings__delete_user__modal_cancel"),
                    onTap: (){
                      Navigator.pop(ctx);
                    },
                    horizontal: 0,
                    vertical: size.height * 0.1 / 10,
                  ),
                  SizedBox(height: size.height * 0.05 / 10,),
                  GestureDetector(
                    onTap: (){
                      onTap!(ctx);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                      child: AutoSizeText(Utils.getString(context, "profile_view___tab_settings__delete_user__modal_delete"), style: MainStyles.boldTextStyle.copyWith(fontSize: 18, color: MainColors.generalColor),)
                    ),
                  ),
                  SizedBox(height: size.height * 0.05 / 10,),
                ],
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.only(
                  topLeft: Radius
                      .circular(30),
                  topRight:
                  Radius.circular(
                      30))
            ),
          );
        },
        isScrollControlled: true);
  }




  static dynamic showGeneralInfoModal(BuildContext context, Size size, {String? title, String? text, TextStyle? titleStyle, TextStyle? textStyle, String? image, String? buttonText, Function? onTap, ConfettiController? controllerTopCenter, }) {

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Dialog(
                shape: const RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.all(
                        Radius.circular(12.0)
                    )
                ),
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    // border: Border.all(color: Colors.blueAccent,width: 2),
                      borderRadius:
                      BorderRadius.all(Radius.circular(10.0))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8,),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
                        child: SvgPicture.asset(image ?? "assets/svgs/dialog/success.svg"),
                      ),
                      if(title!=null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            title,
                            style: titleStyle ?? MainStyles.extraBoldTextStyle.copyWith(fontSize: 32),
                          ),
                        ),
                      if(title!=null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: const SizedBox(height: 24,),
                        ),
                      if(text!=null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Center(
                            child: Text(
                              text,
                              style: textStyle ?? MainStyles.mediumTextStyle.copyWith(fontSize: 18),textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      if(text!=null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: const SizedBox(height: 24,),
                        ),
                      Divider(color: MainColors.middleGrey200,height: 0,),
                      BigUnBorderedButton(
                        text: buttonText ?? Utils.getString(context, "general__close_button_text"),
                        buttonColor: MainColors.middleGrey100,
                        textColor: MainColors.darkBlue500,
                        borderRadius: 0,
                        onTap: () => onTap ?? Navigator.pop(context) ,
                      )
                    ],
                  ),
                )),
            if(controllerTopCenter != null)
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: controllerTopCenter,
                  blastDirectionality: BlastDirectionality
                      .explosive, // don't specify a direction, blast randomly
                  shouldLoop:
                  true, // start again as soon as the animation is finished
                  colors: const [
                    Colors.green,
                    Colors.blue,
                    Colors.pink,
                    Colors.orange,
                    Colors.purple
                  ], // manually specify the colors to be used
                  createParticlePath: drawStarPath,
                ),
              ),
          ],
        );
      },
    );
  }


}