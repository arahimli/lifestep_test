import 'package:flutter/material.dart';
import 'package:lifestep/features/tools/config/main_config.dart';
import 'package:lifestep/features/tools/common/utlis.dart';
import 'package:lifestep/features/main_app/presentation/widgets/error/standard_message_widget.dart';
import 'package:lifestep/features/tools/constants/enum.dart';

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
        imageType: IMAGE_TYPE.svg,
        imageUrl: "assets/svgs/dialog/user-blocked.svg",
        buttonText: Utils.getString(context, "blocked_user_info_view_button_text"),
        onTap: (){
          Utils.launchUrl(MainConfig.appUrl);
          Navigator.pushReplacementNamed(context, "/apploading");
        }

    );
  }
}
