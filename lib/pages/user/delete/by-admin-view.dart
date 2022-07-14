import 'package:flutter/material.dart';
import 'package:lifestep/tools/common/utlis.dart';
import 'package:lifestep/tools/components/error/standard-message-widget.dart';
import 'package:lifestep/tools/constants/enum.dart';

class UserRemovedByAdminView extends StatefulWidget {
  const UserRemovedByAdminView({Key? key}) : super(key: key);

  @override
  _UserRemovedByAdminViewState createState() => _UserRemovedByAdminViewState();
}

class _UserRemovedByAdminViewState extends State<UserRemovedByAdminView> {
  @override
  Widget build(BuildContext context) {
    return StandardMessageWidget(
        title: Utils.getString(context, "delete_user_by_admin_info_view_title"),
        text: Utils.getString(context, "delete_user_by_admin_info_view_text"),
        imageType: IMAGE_TYPE.SVG,
        imageUrl: "assets/svgs/dialog/user-delete.svg",
        buttonText: Utils.getString(context, "delete_user_by_admin_info_view_button_text"),
        onTap: (){
          Navigator.pushReplacementNamed(context, "/apploading");
        }

    );
  }
}
