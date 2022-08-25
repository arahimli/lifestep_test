import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lifestep/src/tools/config/styles.dart';
import 'package:lifestep/src/ui/notifications/logic/cubit.dart';
import 'package:lifestep/src/ui/notifications/view.dart';
import 'package:lifestep/src/ui/user/repositories/auth.dart';

class AuthLeftAppBar extends StatelessWidget {
  final Function()? onTap;
  final String title;
  final TextStyle? textStyle;

  const AuthLeftAppBar({Key? key, this.onTap, required this.title, this.textStyle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 12, left: 8, right: 8, ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(title != null)
                  Flexible(
                    flex: 1,
                      child:
                      Container(
                        padding: EdgeInsets.only(
                          top: 8,
                          left: 8,
                          right: 8,
                        ),
                        child: Text("${title}",
                          style: textStyle ?? MainStyles.boldTextStyle.copyWith(fontSize: 20), textAlign: TextAlign.left,),
                      )
                  ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: onTap ?? () => Navigator.push(context, MaterialPageRoute(builder: (context) => MultiBlocProvider(
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
                        child: SvgPicture.asset("assets/svgs/menu/notifications.svg", height: 24,),
                      ),
                    ),
                    // GestureDetector(
                    //   // color: MainColors.white,
                    //   onTap: onTap ?? () => Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    //       MultiBlocProvider(
                    //         providers: [
                    //
                    //           BlocProvider<ProfileInformationCubit>(
                    //             create: (BuildContext context) => ProfileInformationCubit(
                    //                 sessionCubit: BlocProvider.of<SessionCubit>(context),
                    //                 authRepo: UserRepository()
                    //             ),
                    //           ),
                    //
                    //           BlocProvider<AchievementListCubit>(
                    //             create: (BuildContext context) => AchievementListCubit(
                    //                 authRepo: UserRepository()
                    //             ),
                    //           ),
                    //
                    //           BlocProvider<ThemeCubit>(
                    //             create: (BuildContext context) => ThemeCubit(
                    //             ),
                    //           ),
                    //         ],
                    //       child: ProfileView()
                    //   ))),
                    //   child: Container(
                    //     decoration: const BoxDecoration(
                    //         borderRadius: BorderRadius.circular(100)
                    //     ),
                    //     padding: EdgeInsets.fromLTRB(
                    //       8,
                    //       8,
                    //       8,
                    //       8,
                    //     ),
                    //     //                  padding: EdgeInsets.all(4),
                    //     // child: Text("d"),
                    //     child: SvgPicture.asset("assets/svgs/menu/profile.svg", height: 24,),
                    //   ),
                    // ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}