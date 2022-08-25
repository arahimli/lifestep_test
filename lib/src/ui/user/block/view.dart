import 'package:flutter/material.dart';
import 'package:lifestep/src/tools/config/main_config.dart';
import 'package:lifestep/src/tools/common/utlis.dart';
import 'package:lifestep/src/tools/components/error/standard_message_widget.dart';
import 'package:lifestep/src/tools/constants/enum.dart';

class UserBlockedView extends StatefulWidget {
  const UserBlockedView({Key? key}) : super(key: key);

  @override
  _UserBlockedViewState createState() => _UserBlockedViewState();
}

class _UserBlockedViewState extends State<UserBlockedView> {
  @override
  Widget build(BuildContext context) {
    return StandardMessageWidget(
        title: Utils.getString(context, "blocked_user_info_view_title"),
        text: Utils.getString(context, "blocked_user_info_view_text"),
        imageType: IMAGE_TYPE.SVG,
        imageUrl: "assets/svgs/dialog/user-blocked.svg",
        buttonText: Utils.getString(context, "blocked_user_info_view_button_text"),
        onTap: (){
          Utils.launchUrl(MainConfig.app_url);
          Navigator.pushReplacementNamed(context, "/apploading");
        }

    );
  }
}
