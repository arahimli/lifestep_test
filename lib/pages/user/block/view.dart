import 'package:flutter/material.dart';
import 'package:lifestep/tools/common/utlis.dart';
import 'package:lifestep/tools/components/error/standard-message-widget.dart';
import 'package:lifestep/tools/constants/enum.dart';

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
          Navigator.pushReplacementNamed(context, "/apploading");
        }

    );
  }
}
