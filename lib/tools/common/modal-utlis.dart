import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:health/health.dart';
import 'package:lifestep/tools/common/utlis.dart';
import 'package:lifestep/tools/components/buttons/advanced_button.dart';
import 'package:lifestep/tools/components/buttons/big_unborderd_button.dart';
import 'package:lifestep/tools/components/common/confetti.dart';
import 'package:lifestep/config/endpoints.dart';
import 'package:lifestep/config/main_colors.dart';
import 'package:lifestep/config/main_config.dart';
import 'package:lifestep/config/styles.dart';
import 'package:lifestep/model/challenge/map.dart';
import 'package:lifestep/tools/constants/health/element.dart';
import 'package:lifestep/pages/index/logic/navigation_bloc.dart';
import 'package:lifestep/repositories/service/web_service.dart';
import 'package:lifestep/tools/packages/humanize/humanize_big_int_base.dart';
import 'package:meta/meta.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sprintf/sprintf.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

class ModalUtils {
  ModalUtils._();


  static dynamic removeUserBottomModal(BuildContext context, Size size, {Function? onTap}) {

    return showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return Container(
            // height: size.height / (812 / 664),
            padding: EdgeInsets.symmetric(
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
                        decoration: BoxDecoration(
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
            decoration: BoxDecoration(
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


}