import 'package:flutter/material.dart';
import 'package:lifestep/tools/common/utlis.dart';
import 'package:lifestep/tools/components/error/standard-message-widget.dart';
import 'package:lifestep/tools/constants/enum.dart';

class InfoRemoveView extends StatefulWidget {
  const InfoRemoveView({Key? key}) : super(key: key);

  @override
  _InfoRemoveViewState createState() => _InfoRemoveViewState();
}

class _InfoRemoveViewState extends State<InfoRemoveView> {
  @override
  Widget build(BuildContext context) {
    return StandardMessageWidget(
      title: Utils.getString(context, "delete_user_info_view_title"),
      text: Utils.getString(context, "delete_user_info_view_text"),
      imageType: IMAGE_TYPE.SVG,
      imageUrl: "assets/svgs/dialog/user-delete.svg",
      buttonText: Utils.getString(context, "delete_user_info_view_button_text"),
      onTap: (){
        Navigator.pushReplacementNamed(context, "/apploading");
      }

    );
  }
}
