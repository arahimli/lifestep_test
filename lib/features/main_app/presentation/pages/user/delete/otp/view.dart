import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lifestep/features/main_app/presentation/pages/user/otp/logic/cubit.dart';
import 'package:lifestep/features/tools/common/utlis.dart';
import 'package:lifestep/features/main_app/presentation/widgets/appbar/general.dart';
import 'package:lifestep/features/main_app/presentation/widgets/buttons/big_unborderd_button.dart';
import 'package:lifestep/features/main_app/presentation/widgets/dialog/loading.dart';
import 'package:lifestep/features/main_app/presentation/widgets/error/general_widget.dart';
import 'package:lifestep/features/main_app/presentation/widgets/static/html.dart';
import 'package:lifestep/features/tools/config/main_colors.dart';
import 'package:lifestep/features/tools/config/main_config.dart';
import 'package:lifestep/features/tools/config/scroll_behavior.dart';
import 'package:lifestep/features/tools/config/styles.dart';
import 'package:lifestep/features/main_app/presentation/blocs/global/session/cubit.dart';
import 'package:lifestep/features/main_app/presentation/blocs/global/term_privacy/cubit.dart';
import 'package:lifestep/features/main_app/presentation/blocs/global/term_privacy/state.dart';
import 'package:lifestep/features/main_app/presentation/pages/user/components/otp_number.dart';
import 'package:lifestep/features/main_app/resources/service/web_service.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sprintf/sprintf.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

import 'cubit.dart';
import 'state.dart';

class OtpRemoveView extends StatefulWidget {
  const OtpRemoveView({Key? key}) : super(key: key);

  @override
  _OtpRemoveViewState createState() => _OtpRemoveViewState();
}

class _OtpRemoveViewState extends State<OtpRemoveView> {
  int length = 6;

  onChange(String number){
    if(number.length == length){
      // TODO
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double headerSectionHeight = 120;
    double topSectionHeight = 80;
    double bottomSectionHeight = 130;
    double safeArea = MediaQuery.of(context).viewPadding.top;
    return Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: headerSectionHeight,
                padding: const EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 16, ),
                child: GeneralAppBar(
                  title: Utils.getString(context, "delete_user_otp_view_page_title"),
                  showBack: true,
                ),
              ),
              OtpNumpad(
                  length: length, onChange: (value) => context.read<OtpRemoveCubit>().otpChanged(value),
                  completed: false, buttonText: Utils.getString(context, "delete_user_otp_view_button_text"), extraData: const []
                  , height: (size.height - (headerSectionHeight + topSectionHeight + bottomSectionHeight + safeArea + 20))
              ),

              BlocBuilder<OtpRemoveCubit, OtpRemoveState>(builder: (context, state) {
                return  BigUnBorderedButton(
                  horizontal: 16,
                  buttonColor: state.otp != null && state.otp != '' && state.isValidOtp ? MainColors.darkBlue100 : MainColors.middleBlue100,
                  onTap:  (){
                    if(state.otp != null && state.otp != '' && state.isValidOtp) {
                      showLoading(context, Utils.getString(context, "general__loading_text"));
                      BlocProvider.of<OtpRemoveCubit>(context).otpSubmit().then((data) async{
                        closeLoading(context);
                        switch (data[2]) {
                          case WEB_SERVICE_ENUM.success:
                            {
                              BlocProvider.of<SessionCubit>(context).setUser(null);
                              Navigator.pushReplacementNamed(context, "/info-remove");
                            }
                            break;
                          case WEB_SERVICE_ENUM.internetError:
                            {
                              Utils.showErrorModal(context, size,
                                  errorCode: WEB_SERVICE_ENUM.internetError,
                                  title: Utils.getString(
                                      context, data[1] ?? "internet_connection_error"));
                            }
                            break;
                          default:
                            {
                              if(data[0] == 412){
                                showTopSnackBar(
                                  context,
                                  CustomSnackBar.success(
                                    message: Utils.getString(context, "otp_wrong_snackbar"),
                                    backgroundColor: MainColors.darkPink500!,
                                    textStyle: TextStyle(fontFamily: MainConfig.mainDefaultFontFamily,fontSize: 16, height: 1.1, fontWeight: FontWeight.w600, color: MainColors.white),
                                    icon: Container(),
                                    boxShadow: const [],
                                  ),
                                );
                              }else if(data[0] == 411){
                                // BlocProvider.of<AuthCubit>(context).showLogin();
                                showTopSnackBar(
                                  context,
                                  CustomSnackBar.success(
                                    message: Utils.getString(context, "otp_wrong_3times"),
                                    backgroundColor: MainColors.darkPink500!,
                                    textStyle: TextStyle(fontFamily: MainConfig.mainDefaultFontFamily,fontSize: 16, height: 1.1, fontWeight: FontWeight.w600, color: MainColors.white),
                                    icon: Container(),
                                    boxShadow: const [],
                                  ),
                                );
                              }else if(data[0] == 410){
                                showTopSnackBar(
                                  context,
                                  CustomSnackBar.success(
                                    message: Utils.getString(context, "otp_wrong_expiry"),
                                    backgroundColor: MainColors.darkPink500!,
                                    textStyle: TextStyle(fontFamily: MainConfig.mainDefaultFontFamily,fontSize: 16, height: 1.1, fontWeight: FontWeight.w600, color: MainColors.white),
                                    icon: Container(),
                                    boxShadow: const [],
                                  ),
                                );
                              }else{
                                Utils.showErrorModal(context, size,
                                    errorCode: data[2],
                                    title: Utils.getString(
                                        context, data[1] ?? "error_went_wrong"));
                              }
                            }
                            break;
                        }
                      });
                    }
                  },
                  borderRadius: 100,
                  text: Utils.getString(context, "otp_button_text"),
                  vertical: 12,
                );
              }),
              BlocConsumer<OtpRemoveCubit, OtpRemoveState>(
                  listener: (context, state) async{
                    if(state.isWrongOtp){
                      // showTopSnackBar(
                      //   context,
                      //   CustomSnackBar.success(
                      //     message: Utils.getString(context, "otp_wrong_snackbar"),
                      //     backgroundColor: MainColors.darkPink500!,
                      //     textStyle: TextStyle(fontFamily: MainConfig.mainDefaultFontFamily,fontSize: 16, height: 1.1, fontWeight: FontWeight.w600, color: MainColors.white),
                      //     icon: Container(),
                      //     boxShadow: [],
                      //   ),
                      // );
                    }
                  },
                  builder: (context, state) {
                return CountdownTimer(
                    controller: context.read<OtpRemoveCubit>().countdownTimerController,
                    endTime: state.endTime,
                    widgetBuilder: (_, CurrentRemainingTime? time) {
                      if (time != null) {
                        return Container(
                          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 18, top: 6, ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sprintf(Utils.getString(context, "otp_timer_text"), [
                                  "${time.min != null ? '0' + time.min.toString() : '00'}:${time.sec! < 10 ? '0' + time.sec.toString() : time.sec}"
                                ]),
                                style: MainStyles.semiBoldTextStyle,
                              )
                            ],
                          ),
                        );
                      } else {
                        return Container(
                          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 18, top: 8, ),
                          child: Center(
                            child: GestureDetector(
                              onTap: () async{
                                showLoading(context, Utils.getString(context, "general__loading_text"));
                                context.read<OtpRemoveCubit>().changeEndTime().then((data) {

                                  closeLoading(context);
                                  switch (data[2]) {
                                    case WEB_SERVICE_ENUM.success:
                                      {
                                        BlocProvider.of<OtpNumpadCubit>(context).otpChange("");
                                      }
                                      break;
                                    case WEB_SERVICE_ENUM.internetError:
                                      {
                                        Utils.showErrorModal(context, size,
                                            errorCode: WEB_SERVICE_ENUM.internetError,
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
                                      }
                                      break;
                                  }
                                });
                              },
                              child: AutoSizeText(
                                  Utils.getString(context, "otp_send_again_text"),
                                  textAlign: TextAlign.center,

                                  style: MainStyles.boldTextStyle.copyWith(fontSize: 14,
                                      color: MainColors.middleBlue400)),
                            ),
                          ),
                        );
                      }
                    });
              }),


              Container(
                width: double.infinity,
                height: bottomSectionHeight,
                decoration: BoxDecoration(
                  color: MainColors.backgroundColor,
                  border: const Border(
                      top: BorderSide(
                          color: Color(0xFFECECEC),
                          width: 2
                      )
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 1.2 / 10),
                  child: Center(
                    child: Text(
                      Utils.getString(context, "delete_user_otp_view_bottom_text"),
                      style: MainStyles.semiBoldTextStyle.copyWith(height: 1.5, fontSize: 14),
                      textAlign: TextAlign.center,
                    )
                  ),
                ),
              )
            ],
          ),
        )
    );
  }

  showTerms(BuildContext context){
    showCupertinoModalBottomSheet(
      expand: false,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _TitleTextModalWidget(
        title: Utils.getString(context, "profile_view___tab_settings__terms_and_conditions"),
        widgetType: "terms",
      ),
    );
  }
  showPrivacy(BuildContext context){
    showCupertinoModalBottomSheet(
      expand: false,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _TitleTextModalWidget(
        title: Utils.getString(context, "profile_view___tab_settings__privacy_policy"),
        widgetType: "privacy",
      ),
    );
  }
}



class _TitleTextModalWidget extends StatelessWidget {
  final String title;
  final String widgetType;
  const _TitleTextModalWidget({Key? key, required this.title, required this.widgetType}) : super(key: key);

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
                padding: const EdgeInsets.fromLTRB(
                  8,
                  8,
                  8,
                  8,
                ),
                //                  padding: const EdgeInsets.all(4),
                // child: Text("d"),
                child: SvgPicture.asset("assets/svgs/menu/back.svg", height: 24,),
              ),
            ), middle: Text(title, textAlign: TextAlign.center,)),
        child: SafeArea(
          bottom: false,
          child: BlocBuilder<TermsPrivacyCubit, TermsPrivacyState>(
              builder: (context, state) {
                return Container(
                    padding: const EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 8),
                    height: double.infinity,
                    width: double.infinity,
                    child:
                    state is TermsPrivacyStateLoaded ?
                    Scrollbar(
                      child: ScrollConfiguration(
                        behavior: MainScrollBehavior(),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: SingleChildScrollView(
                            child: widgetType == 'privacy' ?
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
                    const Center(child: CircularProgressIndicator(),):
                    Container()
                );
              }
          ),
        ),
      ),
    );
  }
}