
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lifestep/src/tools/config/main_colors.dart';
import 'package:lifestep/src/tools/config/styles.dart';
import 'package:lifestep/src/ui/notifications/logic/cubit.dart';
import 'package:lifestep/src/ui/notifications/view.dart';
import 'package:lifestep/src/ui/user/repositories/auth.dart';

class AuthNotificationAppbar extends StatelessWidget {
  final Function()? onTap;

  final bool backPermit;
  final String title;
  final TextStyle? textStyle;
  final bool? hideNotificationIcon;

  const AuthNotificationAppbar({Key? key, this.onTap, required this.title, this.textStyle, this.hideNotificationIcon = false, this.backPermit= true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 12, left: 8, right: 8, ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => backPermit ? Navigator.pop(context) : {},
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100)
                  ),
                  padding: const EdgeInsets.fromLTRB(
                    8,
                    8,
                    8,
                    8,
                  ),
                  //                  padding: EdgeInsets.all(4),
                  // child: Text("d"),
                  child: SvgPicture.asset("assets/svgs/menu/back.svg", height: 24, color: backPermit ? null : MainColors.transparent ,),
                ),
              ),
              Flexible(
                  flex: 1,
                  child:
                  Container(
                    padding: const EdgeInsets.only(
                      top: 8,
                      // bottom: 8,
                      left: 8,
                      right: 8,
                    ),
                    child: Text(title,
                      style: textStyle ?? MainStyles.boldTextStyle.copyWith(fontSize: 20), textAlign: TextAlign.left,),
                  )
              ),
              Row(
                children: [
                  GestureDetector(
                    // color: MainColors.white,
                    onTap: hideNotificationIcon! ? null: onTap ?? () => Navigator.push(context, MaterialPageRoute(builder: (context) => MultiBlocProvider(
                        providers: [
                          BlocProvider<NotificationListCubit>(create: (BuildContext context) => NotificationListCubit(
                            userRepository: UserRepository(),
                          )),
                        ],
                        child: const NotificationListView()))),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100)
                      ),
                      padding: const EdgeInsets.fromLTRB(
                        8,
                        8,
                        8,
                        8,
                      ),
                      //                  padding: EdgeInsets.all(4),
                      // child: Text("d"),
                      child: SvgPicture.asset("assets/svgs/menu/notifications.svg", height: 24, color: hideNotificationIcon! ? MainColors.transparent : null,),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}