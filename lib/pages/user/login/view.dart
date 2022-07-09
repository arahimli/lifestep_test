import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/tools/components/buttons/big_unborderd_button.dart';
import 'package:lifestep/tools/components/dialog/loading.dart';
import 'package:lifestep/model/auth/login.dart';
import 'package:lifestep/pages/user/cubit/cubit.dart';
import 'package:lifestep/pages/user/form-submission-status.dart';
import 'package:lifestep/pages/user/login/cubit.dart';
import 'package:lifestep/pages/user/login/state.dart';
import 'package:lifestep/tools/common/utlis.dart';
import 'package:lifestep/tools/components/appbar/general.dart';
import 'package:lifestep/config/main_colors.dart';
import 'package:lifestep/pages/user/otp/view.dart';
import 'package:lifestep/pages/user/components/number.dart';
import 'package:lifestep/repositories/service/web_service.dart';

class AuthView extends StatefulWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  _AuthViewState createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  @override
  void initState() {
    BlocProvider.of<LoginBloc>(context).initialize();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double headerSectionHeight = 120;
    double topSectionHeight = 80;
    double buttonSectionHeight = size.height * 12 / 100;
    double safeArea = MediaQuery.of(context).viewPadding.top;
    return Scaffold(
      body: SafeArea(
        child: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              final formStatus = state.formStatus;
              if (formStatus is SubmissionFailed) {
                _showSnackBar(context, formStatus.exception.toString());
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // 120
                Container(
                  // color: Colors.red,
                  height: headerSectionHeight,
                  padding: EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 16, ),
                  child: GeneralAppBar(
                    title: Utils.getString(context, "auth_title"),
                    showBack: false,
                    onTap: () => BlocProvider.of<AuthCubit>(context).showLogin(),
                  ),
                ),
                BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
                  return  Numpad( initalValue: BlocProvider.of<AuthCubit>(context).phone, length: 9, height: (size.height - (headerSectionHeight + topSectionHeight + buttonSectionHeight + safeArea)), onChange:  (value) {
                      BlocProvider.of<LoginBloc>(context).phoneChanged(
                        value
                      );
                    },
                    completed: state.phone != null && state.phone != '' && state.isValidPhone, buttonText: Utils.getString(context, "send_code"), extraData: [Dot(isActive: false, value: "+"), Dot(isActive: false, value: "9"), Dot(isActive: false, value: "9"), Dot(isActive: false, value: "4", isSpace: true), ],);
                }),
                // 80
                BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
                  //////// print("sdsdsd");
                  return  BigUnBorderedButton(
                    horizontal: 16,
                    buttonColor: state.phone != null && state.phone != '' && state.isValidPhone ? MainColors.darkBlue100 : MainColors.middleBlue100,
                    onTap:  (){

                      if(state.phone != null && state.phone != '' && state.isValidPhone) {
                        showLoading(context, Utils.getString(context, "general__loading_text"));
                        BlocProvider.of<LoginBloc>(context).loginSubmit(state
                            .phone!).then((data) {

                          closeLoading(context);
                          switch (data[2]) {
                            case WEB_SERVICE_ENUM.SUCCESS:
                              {
                                LoginResponse loginResponse = LoginResponse
                                    .fromJson(data[1]);

                                BlocProvider.of<AuthCubit>(context).showOtp();
                                BlocProvider.of<AuthCubit>(context).phone = state.phone ?? '';
                              }
                              break;
                            case WEB_SERVICE_ENUM.INTERNET_ERROR:
                              {
                                Utils.showErrorModal(context, size,
                                    errorCode: WEB_SERVICE_ENUM.INTERNET_ERROR,
                                    title: Utils.getString(
                                        context, data[1] ?? "internet_connection_error"));
                                //////// print("internet error");
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
                      }
                    },
                    borderRadius: 100,
                    text: Utils.getString(context, "send_code"),
                    vertical: 12,
                  );
                }),
                // size.height * 16 / 100
                Container(
                  height: buttonSectionHeight,
                  decoration: BoxDecoration(
                    color: MainColors.backgroundColor,
                    border: Border(
                        top: BorderSide(
                            color: Color(0xFFECECEC),
                            width: 2
                        )
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        // color: Colors.red,
                        // height: size.height * 7.5 / 100,
                        child: Row(
                          children: [
                            // GoogleLoginButton(),
                            // FacebookLoginButton(authCubit: BlocProvider.of<AuthCubit>(context),),
                            // AppleLoginButton(),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
        ),
      ),
    );
  }
  //
  // Widget _loginButton() {
  //   return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
  //     return state.formStatus is FormSubmitting
  //         ? CircularProgressIndicator()
  //         : ElevatedButton(
  //       onPressed: () {
  //         if (_formKey.currentState!.validate()) {
  //           context.read<LoginBloc>().add(LoginSubmitted());
  //         }
  //       },
  //       child: Text('Login'),
  //     );
  //   });
  // }

  Widget _showSignUpButton(BuildContext context) {
    return SafeArea(
      child: TextButton(
        child: Text('Don\'t have an account? Sign up.'),
        onPressed: () => context.read<AuthCubit>().showSignUp(),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}