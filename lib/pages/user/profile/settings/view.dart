import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:lifestep/tools/common/language.dart';
import 'package:lifestep/tools/common/modal-utlis.dart';
import 'package:lifestep/tools/common/utlis.dart';
import 'package:lifestep/tools/components/buttons/big_borderd_button.dart';
import 'package:lifestep/tools/components/buttons/big_unborderd_button.dart';
import 'package:lifestep/tools/components/dialog/loading.dart';
import 'package:lifestep/tools/components/dialog/yesno.dart';
import 'package:lifestep/tools/components/error/general-widget.dart';
import 'package:lifestep/tools/components/static/html.dart';
import 'package:lifestep/config/main_colors.dart';
import 'package:lifestep/config/scroll_behavior.dart';
import 'package:lifestep/config/styles.dart';
import 'package:lifestep/logic/session/cubit.dart';
import 'package:lifestep/logic/term_privacy/cubit.dart';
import 'package:lifestep/logic/term_privacy/state.dart';
import 'package:lifestep/pages/notifications/logic/cubit.dart';
import 'package:lifestep/pages/notifications/view.dart';
import 'package:lifestep/pages/user/history/logic/cubit.dart';
import 'package:lifestep/pages/user/history/view.dart';
import 'package:lifestep/pages/user/profile/language/cubit.dart';
import 'package:lifestep/pages/user/profile/language/state.dart';
import 'package:lifestep/pages/user/repositories/auth.dart';
import 'package:lifestep/repositories/donation.dart';
import 'package:lifestep/repositories/service/web_service.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({Key? key}) : super(key: key);

  @override
  SettingsWidgetState createState() => SettingsWidgetState();
}

class SettingsWidgetState extends State<SettingsWidget> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ScrollConfiguration(
      behavior: MainScrollBehavior(),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // SizedBox(height: 16,),
              // Container(
              //   width: double.infinity,
              //   padding: EdgeInsets.symmetric(horizontal: size.width * 0.8 / 12, vertical: size.width * 0.8 / 12),
              //   decoration: BoxDecoration(
              //     color: MainColors.white,
              //     borderRadius: BorderRadius.circular(16)
              //   ),
              //   child: Wrap(
              //     alignment: WrapAlignment.spaceEvenly,
              //     crossAxisAlignment: WrapCrossAlignment.center,
              //     children: [
              //       BlocBuilder<ThemeCubit, ThemeState>(
              //         builder: (context, state) {
              //           return CupertinoSwitch(
              //             value:state.dark,
              //             onChanged: (value) async{
              //               // state = value;
              //               //////// print("DynamicTheme.of(context)!.setTheme(");
              //               //////// print(value);
              //               if(value) {
              //                 context.read<ThemeCubit>().applyTheme(AppThemes.DarkBlue);
              //                 await DynamicTheme.of(context)!.setTheme(AppThemes.DarkBlue);
              //               }else{
              //                 context.read<ThemeCubit>().applyTheme(AppThemes.LightBlue);
              //                 await DynamicTheme.of(context)!.setTheme(AppThemes.LightBlue);
              //               }
              //             },
              //             activeColor: MainColors.darkPink500,
              //             thumbColor: MainColors.middleGrey300,
              //             trackColor: MainColors.middleGrey100,
              //           );
              //         }
              //       ),
              //       Text(Utils.getString(context, "profile_view___tab_settings___theme_switch_text"),
              //         style: MainStyles.semiBoldTextStyle.copyWith(height: 1.1),
              //         textAlign: TextAlign.left,
              //         maxLines: 2,
              //         overflow: TextOverflow.ellipsis,
              //       )
              //     ],
              //   ),
              // ),
              SizedBox(height: 16,),
              InkWell(
                onTap: (){
                  showCupertinoModalBottomSheet(
                    expand: false,
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => BlocProvider(create: (context) => LocalLanguageCubit(),
                        child: _LanguageModal()
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: MainColors.middleGrey100!)
                      )
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                    title: Text(Utils.getString(context, "profile_view___tab_settings__language"),
                      style: MainStyles.semiBoldTextStyle.copyWith(height: 1.1, fontSize: 16),
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,),
                    trailing: SvgPicture.asset("assets/svgs/general/navigate-right.svg", color: MainColors.middleGrey900,),
                  ),
                ),
              ),
              // SizedBox(height: 16,),
              InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider<DonationHistoryListBloc>(create: (BuildContext context) => DonationHistoryListBloc(
                        donationRepository: GetIt.instance<DonationRepository>(),
                      )),
                    ],
                    child: DonationHistoryView()
                ))),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: MainColors.middleGrey100!)
                      )
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                    title: Text(Utils.getString(context, "profile_view___tab_settings__history"),
                      style: MainStyles.semiBoldTextStyle.copyWith(height: 1.1, fontSize: 16),
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,),
                    trailing: SvgPicture.asset("assets/svgs/general/navigate-right.svg", color: MainColors.middleGrey900,),
                  ),
                ),
              ),
              // SizedBox(height: 16,),
              InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider<NotificationListCubit>(create: (BuildContext context) => NotificationListCubit(
                        userRepository: GetIt.instance<UserRepository>(),
                      )),
                    ],
                    child: NotificationListView()))),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: MainColors.middleGrey100!)
                      )
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                    title: Text(Utils.getString(context, "profile_view___tab_settings__notifications"),
                      style: MainStyles.semiBoldTextStyle.copyWith(height: 1.1, fontSize: 16),
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,),
                    trailing: SvgPicture.asset("assets/svgs/general/navigate-right.svg", color: MainColors.middleGrey900,),
                  ),
                ),
              ),
              SizedBox(height: 24,),
              GestureDetector(
                onTap: (){
                  showCupertinoModalBottomSheet(
                    expand: false,
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => _TitleTextModalWidget(
                      title: Utils.getString(context, "profile_view___tab_settings__privacy_policy"),
                      widgetType: "privacy",

                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                  ),
                  child: Center(child: Text(Utils.getString(context, "profile_view___tab_settings__privacy_policy"),
                    style: MainStyles.semiBoldTextStyle.copyWith(height: 1.1, fontSize: 16, color: MainColors.darkBlue500),
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,)
                  ),
                ),
              ),
              SizedBox(height: 16,),
              GestureDetector(
                onTap: (){
                  showCupertinoModalBottomSheet(
                    expand: false,
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => _TitleTextModalWidget(
                      title: Utils.getString(context, "profile_view___tab_settings__terms_and_conditions"),
                      widgetType: "terms",
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                  ),
                  child: Center(child: Text(Utils.getString(context, "profile_view___tab_settings__terms_and_conditions"),
                    style: MainStyles.semiBoldTextStyle.copyWith(height: 1.1, fontSize: 16, color: MainColors.darkBlue500),
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )),
                ),
              ),
              SizedBox(height: 16,),
              GestureDetector(
                onTap: (){
                  // showCupertinoModalBottomSheet(
                  //   expand: false,
                  //   context: context,
                  //   backgroundColor: Colors.transparent,
                  //   builder: (context) => _AboutAppModalWidget(
                  //     title: Utils.getString(context, "profile_view___tab_settings__about"),
                  //     text: Utils.getString(context, "profile_view___tab_settings__about_text"),
                  //   ),
                  // );

                  showCupertinoModalBottomSheet(
                    expand: false,
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => _TitleTextModalWidget(
                      title: Utils.getString(context, "profile_view___tab_settings__about"),
                      widgetType: "about",
                      titleWidget: Column(
                        children: [
                          Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 32.0),
                              child: Image.asset("assets/images/logo/rib_digitalks-about.png",)
                          ),
                          Container(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Center(
                              child: AutoSizeText(Utils.getString(context, "profile_view___tab_settings__about_title"), style: MainStyles.extraBoldTextStyle.copyWith(fontSize: 20, height: 2.4),),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                  ),
                  child: Center(child: Text(Utils.getString(context, "profile_view___tab_settings__about"),
                    style: MainStyles.semiBoldTextStyle.copyWith(height: 1.1, fontSize: 16, color: MainColors.darkBlue500),
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )),
                ),
              ),
              SizedBox(height: 16,),
              GestureDetector(
                onTap: ()async{

                  bool shouldClose = true;
                  showYesNoDialog(context, Utils.getString(context, "profile_view___tab_settings__logout_dialog"),() async{
                    //////// print("dsds");
                    showLoading(context, Utils.getString(context, "general__loading_text"));
                    List data = await BlocProvider.of<SessionCubit>(context).logout();
                    closeLoading(context);
                    switch (data[2]) {
                      case WEB_SERVICE_ENUM.SUCCESS:
                        {
                          BlocProvider.of<SessionCubit>(context).setUser(null);
                          Navigator.pushReplacementNamed(context, "/apploading");
                        }
                        break;
                      case WEB_SERVICE_ENUM.UN_AUTH:
                        {
                          BlocProvider.of<SessionCubit>(context).setUser(null);
                          Navigator.pushReplacementNamed(context, "/apploading");
                        }
                        break;
                      case WEB_SERVICE_ENUM.INTERNET_ERROR:
                        {
                          Utils.showErrorModal(context, size,
                              errorCode: data[2],
                              title: Utils.getString(
                                  context, data[1] ?? "internet_connection_error"));
                        }
                        break;
                      default:
                        {
                          Utils.showErrorModal(context, size,
                              errorCode: data[2],
                              title: Utils.getString(
                                  context, data[1] ?? "error_went_wrong"));
                          //////// print("internet error");
                        }
                        break;
                    }
                  }, () {
                    shouldClose = false;
                    Navigator.of(context).pop();
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                  ),
                  child: Center(child: Text(Utils.getString(context, "profile_view___tab_settings__logout"),
                    style: MainStyles.semiBoldTextStyle.copyWith(height: 1.1, fontSize: 16, color: MainColors.darkBlue500),
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,)
                  ),
                ),
              ),
              SizedBox(height: 16,),
              GestureDetector(
                onTap: ()async{
                  ModalUtils.removeUserBottomModal(context, size, onTap: (context){

                    showYesNoDialog(context, Utils.getString(context, "profile_view___tab_settings__delete_user__yes_no_modal_title"),() async{
                      //////// print("dsds");
                      Navigator.of(context).pop();
                      showLoading(context, Utils.getString(context, "general__loading_text"));
                      List data = await BlocProvider.of<SessionCubit>(context).deleteUser();
                      closeLoading(context);
                      switch (data[2]) {
                        case WEB_SERVICE_ENUM.SUCCESS:
                          {
                            // BlocProvider.of<SessionCubit>(context).setUser(null);
                            Navigator.pushNamed(context, "/otp-remove");
                          }
                          break;
                        case WEB_SERVICE_ENUM.UN_AUTH:
                          {
                            BlocProvider.of<SessionCubit>(context).setUser(null);
                            Navigator.pushReplacementNamed(context, "/apploading");
                          }
                          break;
                        case WEB_SERVICE_ENUM.INTERNET_ERROR:
                          {
                            Utils.showErrorModal(context, size,
                                errorCode: data[2],
                                title: Utils.getString(
                                    context, data[1] ?? "internet_connection_error"));
                          }
                          break;
                        default:
                          {
                            Utils.showErrorModal(context, size,
                                errorCode: data[2],
                                title: Utils.getString(
                                    context, data[1] ?? "error_went_wrong"));
                            //////// print("internet error");
                          }
                          break;
                      }
                    }, () {
                      // shouldClose = false;
                      Navigator.of(context).pop();
                    });
                  });
                  // bool shouldClose = true;
                },
                child: Container(
                  decoration: BoxDecoration(
                  ),
                  child: Center(child: Text(Utils.getString(context, "profile_view___tab_settings__delete_user"),
                    style: MainStyles.semiBoldTextStyle.copyWith(height: 1.1, fontSize: 16, color: MainColors.darkPink500),
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,)
                  ),
                ),
              ),
              SizedBox(height: 16,),
            ],
          ),
        ),
      ),
    );
  }
}



class _LanguageModal extends StatelessWidget {
  const _LanguageModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocBuilder<LocalLanguageCubit, LocalLanguageState>(
          builder: (context, state) {
            return SafeArea(
              top: false,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[

                    Center(
                      child: Container(
                          width: 64,
                          height: 4,
                          decoration: BoxDecoration(
                              color: MainColors.middleGrey200,
                              borderRadius:
                              BorderRadius.circular(30))),
                    ),
                    SizedBox(height: 12,),
                    ListTile(
                      title: Text(Utils.getString(context, "language__az_title"), style: MainStyles.semiBoldTextStyle,),
                      onTap: () async{
                        context.read<LocalLanguageCubit>().setLanguage('az');
                        // await EasyLocalization.of(context).locale
                        // Navigator.of(context).pop();
                      },
                      trailing: SvgPicture.asset("assets/svgs/general/check.svg",
                        color: state.language == 'az' ? Colors.green : Colors.transparent,),
                    ),
                    ListTile(
                      title: Text(Utils.getString(context, "language__ru_title"), style: MainStyles.semiBoldTextStyle),
                      onTap: () async{
                        context.read<LocalLanguageCubit>().setLanguage('ru');
                        // await EasyLocalization.of(context).locale
                        // Navigator.of(context).pop();
                      },
                      trailing: SvgPicture.asset("assets/svgs/general/check.svg",
                        color: state.language == 'ru' ? Colors.green : Colors.transparent,),
                      // color: EasyLocalization.of(context)!.locale.languageCode != 'az' ? Colors.green : Colors.transparent,),
                    ),
                    // ListTile(
                    //   title: Text(Utils.getString(context, "language__en_title"), style: MainStyles.semiBoldTextStyle),
                    //   onTap: () async{
                    //     context.read<LocalLanguageCubit>().setLanguage('en');
                    //     // await EasyLocalization.of(context).locale
                    //     // Navigator.of(context).pop();
                    //   },
                    //   trailing: SvgPicture.asset("assets/svgs/general/check.svg",
                    //     color: state.language == 'en' ? Colors.green : Colors.transparent,),
                    //   // color: EasyLocalization.of(context)!.locale.languageCode != 'az' ? Colors.green : Colors.transparent,),
                    // ),
                    SizedBox(height: 12,),
                    Row(
                      children: [
                        Flexible(
                            flex: 1,
                            child: BigUnBorderedButton(
                              buttonColor: state.changed ? null : MainColors.middleBlue100 ,
                              text: Utils.getString(context, "language__button_display"),
                              onTap: ()async{
                                if(state.changed) {
                                  showLoading(context, Utils.getString(context, "general__loading_text"));
                                  await EasyLocalization.of(context)?.setLocale(
                                      Language(languageCode: state.language!,
                                          countryCode: state.language!.toUpperCase(),
                                          name: state.language!.toUpperCase()).toLocale());
                                  await context.read<LocalLanguageCubit>().applyLanguage();
                                  // await Future.delayed(Duration(seconds: 1));
                                  await BlocProvider.of<TermsPrivacyCubit>(context).getTermsPrivacy();
                                  await BlocProvider.of<SessionCubit>(context).resetUser();
                                  await BlocProvider.of<SessionCubit>(context).setUser(BlocProvider.of<SessionCubit>(context).currentUser);
                                  closeLoading(context);
                                  Navigator.of(context).pop();
                                  Navigator.pushReplacementNamed(context, "/apploading");
                                }
                              },
                            )
                        ),
                        SizedBox(width: 16),
                        Flexible(
                            flex: 1,
                            child: BigBorderedButton(
                              text: Utils.getString(context, "language__button_cancel"),
                              onTap: () => Navigator.of(context).pop(),
                            )
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }
      ),
    );
  }
}




class _TitleTextModalWidget extends StatelessWidget {
  final String title;
  final String widgetType;
  final Widget? titleWidget;
  const _TitleTextModalWidget({Key? key, required this.title, required this.widgetType, this.titleWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool refresh = true;
    BlocProvider.of<TermsPrivacyCubit>(context).resetErrorTermsPrivacy(refresh: refresh).then((data){
      refresh = false;
    });
    return Material(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100)
                ),
                padding: EdgeInsets.fromLTRB(
                  8,
                  8,
                  8,
                  8,
                ),
                //                  padding: EdgeInsets.all(4),
                // child: Text("d"),
                child: SvgPicture.asset("assets/svgs/menu/back.svg", height: 24,),
              ),
            ), middle: Text(title, textAlign: TextAlign.center,)),
        child: SafeArea(
          bottom: false,
          child: BlocBuilder<TermsPrivacyCubit, TermsPrivacyState>(

              builder: (context, state) {
                return Container(
                    padding: EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 8),
                    height: double.infinity,
                    width: double.infinity,
                    child:
                    state is TermsPrivacyStateLoaded ?
                    Scrollbar(
                      child: ScrollConfiguration(
                        behavior: MainScrollBehavior(),
                        child: Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: SingleChildScrollView(
                            child: widgetType == 'about' ?
                             Column(
                               children: [
                                 if(titleWidget != null)
                                 titleWidget! ,
                                 HtmlPageWidget(content: state.termsPrivacyModel != null && state.termsPrivacyModel!.about != null ? state.termsPrivacyModel!.about! : ''),
                               ],
                             ):
                            widgetType == 'privacy' ?
                              HtmlPageWidget(content: state.termsPrivacyModel != null && state.termsPrivacyModel!.privacy != null ? state.termsPrivacyModel!.privacy! : '')
                              :HtmlPageWidget(content: state.termsPrivacyModel != null && state.termsPrivacyModel!.terms != null ? state.termsPrivacyModel!.terms! : ''),
                          ),
                        ),
                      ),
                    ):
                    state is TermsPrivacyError ?
                    Center(
                      child: GeneralErrorLoadAgainWidget(
                        onTap: (){
                          BlocProvider.of<TermsPrivacyCubit>(context).resetErrorTermsPrivacy(refresh: true);
                        },
                      ),
                    ):
                    state is TermsPrivacyLoading ?
                    Container(child: Center(child: CircularProgressIndicator(),),):
                    Container()
                );
              }
          ),
        ),
      ),
    );
  }
}


class _AboutAppModalWidget extends StatelessWidget {
  final String title;
  final String text;
  const _AboutAppModalWidget({Key? key, required this.title, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100)
                ),
                padding: EdgeInsets.fromLTRB(
                  8,
                  8,
                  8,
                  8,
                ),
                //                  padding: EdgeInsets.all(4),
                // child: Text("d"),
                child: SvgPicture.asset("assets/svgs/menu/back.svg", height: 24,),
              ),
            ), middle: Text(title, textAlign: TextAlign.center,)),
        child: SafeArea(
          bottom: false,
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              height: double.infinity,
              width: double.infinity,
              child:
              SingleChildScrollView(
                child: Column(
                  children: [
                    // Container(
                    //     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                    //     child: SvgPicture.asset("assets/svgs/logo/rib_digitalks.svg")
                    // ),

                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 32.0),
                        child: Image.asset("assets/images/logo/rib_digitalks-about.png",)
                    ),
                    HtmlPageWidget(content: text),


                    // Container(
                    //     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                    //     child: Image.asset("assets/images/logo/rib_digitalks-about.png",)
                    // ),
                    // Container(
                    //     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                    //     child: Image.asset("assets/images/logo/riib_logo.png",)
                    // ),
                    // Container(
                    //     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                    //     child: Image.asset("assets/images/logo/digitalks_logo.png",)
                    // ),
                  ],
                )
              )
          ),
        ),
      ),
    );
  }
}


