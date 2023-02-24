import 'package:flutter/material.dart';
import 'package:lifestep/features/tools/config/main_config.dart';
import 'package:lifestep/features/tools/common/utlis.dart';
import 'package:lifestep/features/main_app/presentation/widgets/error/standard_message_widget.dart';
import 'package:lifestep/features/tools/constants/enum.dart';

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
        imageType: IMAGE_TYPE.svg,
        imageUrl: "assets/svgs/dialog/user-delete.svg",
        buttonText: Utils.getString(context, "delete_user_by_admin_info_view_button_text"),
        onTap: (){
          Utils.launchUrl(MainConfig.appUrl);
          Navigator.pushReplacementNamed(context, "/apploading");
        }

    );
  }
}
