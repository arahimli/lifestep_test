import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lifestep/tools/common/utlis.dart';
import 'package:lifestep/tools/components/appbar/general.dart';
import 'package:lifestep/tools/components/buttons/big_unborderd_button.dart';
import 'package:lifestep/tools/components/dialog/loading.dart';
import 'package:lifestep/tools/components/error/general-widget.dart';
import 'package:lifestep/tools/components/static/html.dart';
import 'package:lifestep/config/endpoints.dart';
import 'package:lifestep/config/main_colors.dart';
import 'package:lifestep/config/main_config.dart';
import 'package:lifestep/config/scroll_behavior.dart';
import 'package:lifestep/config/styles.dart';
import 'package:lifestep/logic/session/cubit.dart';
import 'package:lifestep/logic/term_privacy/cubit.dart';
import 'package:lifestep/logic/term_privacy/state.dart';
import 'package:lifestep/model/auth/otp.dart';
import 'package:lifestep/model/auth/profile.dart';
import 'package:lifestep/pages/user/cubit/cubit.dart';
import 'package:lifestep/pages/user/otp/cubit.dart';
import 'package:lifestep/pages/user/otp/state.dart';
import 'package:lifestep/pages/user/components/otp-number.dart';
import 'package:lifestep/repositories/service/web_service.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sprintf/sprintf.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/tap_bounce_container.dart';

import 'logic/cubit.dart';
import 'logic/state.dart';

class OtpView extends StatefulWidget {
  const OtpView({Key? key}) : super(key: key);

  @override
  _OtpViewState createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
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
                padding: EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 16, ),
                child: GeneralAppBar(
                  title: Utils.getString(context, "otp_title"),
                  // title: BlocProvider.of<AuthCubit>(context).otp?? Utils.getString(context, "otp_title"),
                  showBack: true,
                  onTap: () => BlocProvider.of<AuthCubit>(context).showLogin(),
                ),
              ),
              OtpNumpad(
                  length: length, onChange: (value) => context.read<OtpBloc>().otpChanged(value),
                  completed: false, buttonText: Utils.getString(context, "otp_button_text"), extraData: []
                  , height: (size.height - (headerSectionHeight + topSectionHeight + bottomSectionHeight + safeArea + 20))
              ),

              BlocBuilder<OtpBloc, OtpState>(builder: (context, state) {
                return  BigUnBorderedButton(
                  horizontal: 16,
                  buttonColor: state.otp != null && state.otp != '' && state.isValidOtp ? MainColors.darkBlue100 : MainColors.middleBlue100,
                  onTap:  (){
                    if(state.otp != null && state.otp != '' && state.isValidOtp) {
                      showLoading(context, Utils.getString(context, "general__loading_text"));
                      BlocProvider.of<OtpBloc>(context).otpSubmit().then((data) async{
                        closeLoading(context);
                        switch (data[2]) {
                          case WEB_SERVICE_ENUM.SUCCESS:
                            {
                              if(BlocProvider.of<AuthCubit>(context).userStatusCode == 210){
                                BlocProvider.of<AuthCubit>(context).showSignUp();
                              }else if(BlocProvider.of<AuthCubit>(context).userStatusCode == 211){
                                OtpResponse otpResponse = OtpResponse.fromJson(data[1]);
                                BlocProvider.of<SessionCubit>(context).setUser(otpResponse.data!.user);
                                // Navigator.push(context, MaterialPageRoute(builder: (_) => IndexView()));
                                // if(await Utils.checkPermissions())
                                //   Navigator.pushReplacementNamed(context, "index");
                                // else
                                  Navigator.pushReplacementNamed(context, "/permission-list-health");
                              }
                            }
                            break;
                          case WEB_SERVICE_ENUM.INTERNET_ERROR:
                            {
                              Utils.showErrorModal(context, size,
                                  errorCode: WEB_SERVICE_ENUM.INTERNET_ERROR,
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
                                    textStyle: TextStyle(fontFamily: MainConfig.main_default_font_family,fontSize: 16, height: 1.1, fontWeight: FontWeight.w600, color: MainColors.white),
                                    icon: Container(),
                                    boxShadow: [],
                                  ),
                                );
                              }else if(data[0] == 411){
                                // BlocProvider.of<AuthCubit>(context).showLogin();
                                showTopSnackBar(
                                  context,
                                  CustomSnackBar.success(
                                    message: Utils.getString(context, "otp_wrong_3times"),
                                    backgroundColor: MainColors.darkPink500!,
                                    textStyle: TextStyle(fontFamily: MainConfig.main_default_font_family,fontSize: 16, height: 1.1, fontWeight: FontWeight.w600, color: MainColors.white),
                                    icon: Container(),
                                    boxShadow: [],
                                  ),
                                );
                              }else if(data[0] == 410){
                                showTopSnackBar(
                                  context,
                                  CustomSnackBar.success(
                                    message: Utils.getString(context, "otp_wrong_expiry"),
                                    backgroundColor: MainColors.darkPink500!,
                                    textStyle: TextStyle(fontFamily: MainConfig.main_default_font_family,fontSize: 16, height: 1.1, fontWeight: FontWeight.w600, color: MainColors.white),
                                    icon: Container(),
                                    boxShadow: [],
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
                  text: "${Utils.getString(context, "otp_button_text")}",
                  vertical: 12,
                );
              }),
              BlocConsumer<OtpBloc, OtpState>(
                  listener: (context, state) async{
                    if(state.isWrongOtp){
                      // showTopSnackBar(
                      //   context,
                      //   CustomSnackBar.success(
                      //     message: Utils.getString(context, "otp_wrong_snackbar"),
                      //     backgroundColor: MainColors.darkPink500!,
                      //     textStyle: TextStyle(fontFamily: MainConfig.main_default_font_family,fontSize: 16, height: 1.1, fontWeight: FontWeight.w600, color: MainColors.white),
                      //     icon: Container(),
                      //     boxShadow: [],
                      //   ),
                      // );
                    }
                  },
                  builder: (context, state) {
                return CountdownTimer(
                    controller: context.read<OtpBloc>().countdownTimerController,
                    endTime: state.endTime,
                    widgetBuilder: (_, CurrentRemainingTime? time) {
                      if (time != null) {
                        return Container(
                          padding: EdgeInsets.only(left: 16, right: 16, bottom: 18, top: 6, ),
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
                          padding: EdgeInsets.only(left: 16, right: 16, bottom: 18, top: 8, ),
                          child: Center(
                            child: GestureDetector(
                              onTap: () async{
                                showLoading(context, Utils.getString(context, "general__loading_text"));
                                context.read<OtpBloc>().changeEndTime().then((data) {

                                  closeLoading(context);
                                  switch (data[2]) {
                                    case WEB_SERVICE_ENUM.SUCCESS:
                                      {
                                        BlocProvider.of<OtpNumpadBloc>(context).otpChange("");
                                      }
                                      break;
                                    case WEB_SERVICE_ENUM.INTERNET_ERROR:
                                      {
                                        Utils.showErrorModal(context, size,
                                            errorCode: WEB_SERVICE_ENUM.INTERNET_ERROR,
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
                  border: Border(
                      top: BorderSide(
                          color: Color(0xFFECECEC),
                          width: 2
                      )
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 1.5 / 10),
                  child: Center(
                    child: LANGUAGE == "az" ?
                    Text.rich(
                      TextSpan(
                        text: 'Qeydiyyat hesabı yaratmaqla Siz bizim ',
                        style: MainStyles.semiBoldTextStyle.copyWith(height: 1.5),
                        children: <TextSpan>[
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                showPrivacy(context);
                              },
                            text: 'gizlilik siyasətimizlə',
                            style: MainStyles.semiBoldTextStyle.copyWith(
                                color: MainColors.middleBlue400, height: 1.5),
                          ),
                          TextSpan(
                            text: ' və ',
                            style: MainStyles.semiBoldTextStyle.copyWith(height: 1.5),
                          ),
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                showTerms(context);
                              },
                            text: 'istifadə qaydalarımızla',
                            style: MainStyles.semiBoldTextStyle.copyWith(
                                color: MainColors.middleBlue400, height: 1.5),
                          ),
                          TextSpan(
                            text: ' razılaşmış olursunuz',
                            style: MainStyles.semiBoldTextStyle.copyWith(height: 1.5),
                          ),
                          // can add more TextSpans here...
                        ],
                      ),

                    ): LANGUAGE == "ru" ?
                    Text.rich(
                      TextSpan(
                        text: 'Создавая учётную запись, Вы соглашаетесь с нашей ',
                        style: MainStyles.semiBoldTextStyle,
                        children: <TextSpan>[
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                showPrivacy(context);
                              },
                            text: 'политикой конфиденциальности',
                            style: MainStyles.semiBoldTextStyle.copyWith(
                                // decoration: TextDecoration.underline,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: MainColors.middleBlue400),
                          ),
                          TextSpan(
                            text: ' и ',
                            style: MainStyles.semiBoldTextStyle.copyWith(height: 1.5),
                          ),
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                showTerms(context);
                              },
                            text: 'пользовательское соглашение',
                            style: MainStyles.semiBoldTextStyle.copyWith(
                                // decoration: TextDecoration.underline,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: MainColors.middleBlue400),
                          ),
                          // can add more TextSpans here...
                        ],
                      ),
                    ):
                    Text.rich(
                      TextSpan(
                        text: 'By creating an accounting You agree with our ',
                        style: MainStyles.semiBoldTextStyle,
                        children: <TextSpan>[
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                showPrivacy(context);
                              },
                            text: 'Privacy policy',
                            style: MainStyles.semiBoldTextStyle.copyWith(
                                // decoration: TextDecoration.underline,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: MainColors.middleBlue400),
                          ),
                          // can add more TextSpans here...
                        ],
                      ),
                    ),
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