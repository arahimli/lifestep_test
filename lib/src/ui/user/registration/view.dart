import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lifestep/src/tools/common/input_format.dart';
import 'package:lifestep/src/tools/common/utlis.dart';
import 'package:lifestep/src/tools/components/appbar/general.dart';
import 'package:lifestep/src/tools/components/buttons/big_unborderd_button.dart';
import 'package:lifestep/src/tools/components/dialog/loading.dart';
import 'package:lifestep/src/tools/components/form/datefield/general.dart';
import 'package:lifestep/src/tools/components/form/select/selectable/view.dart';
import 'package:lifestep/src/tools/components/form/textfield/general.dart';
import 'package:lifestep/src/tools/config/main_colors.dart';
import 'package:lifestep/src/tools/config/main_constants.dart';
import 'package:lifestep/src/tools/config/scroll_behavior.dart';
import 'package:lifestep/src/tools/config/styles.dart';
import 'package:lifestep/src/cubits/global/session/cubit.dart';
import 'package:lifestep/src/models/auth/profile.dart';
import 'package:lifestep/src/ui/user/logic/cubit.dart';
import 'package:lifestep/src/ui/user/registration/cubit.dart';
import 'package:lifestep/src/ui/user/registration/state.dart';
import 'package:lifestep/src/resources/service/web_service.dart';

class RegistrationView extends StatefulWidget {
  const RegistrationView({Key? key}) : super(key: key);

  @override
  _RegistrationViewState createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> with TickerProviderStateMixin {
  late TabController tabController;


  @override
  void initState() {

    tabController = TabController(length: 3,
        // animationDuration: Duration(milliseconds: 300),
        initialIndex: 0, vsync: this);
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final now = DateTime.now();
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: MainColors.backgroundColor,
          // main
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                constraints: BoxConstraints(
                  minHeight: size.height * 1 / 10,
                ),
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 16),
                child: GeneralAppBar(
                  title: Utils.getString(context, "registration_view___title"),
                  showBack: true,
                  onTap: () => BlocProvider.of<AuthCubit>(context).showLogin(),
                ),
              ),
              Flexible(
                flex: 1,
                child: ScrollConfiguration(
                  behavior: MainScrollBehavior(),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          Flexible(
                            flex: 1,
                            child: Container(
                              // height: double.infinity,
                              constraints: BoxConstraints(
                                minHeight: size.height * 4.5 / 10,
                              ),
                              decoration: BoxDecoration(
                                color: MainColors.backgroundColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [

                                    BlocBuilder<RegistrationBloc, RegistrationState>(builder: (context, state) {
                                      return  Container(
                                        padding: const EdgeInsets.only(bottom: 12),
                                        child: GeneralTextField(
                                          size: size,
                                          label: Utils.getString(context, "registration_view___form_field__name_label"),
                                          hintText: Utils.getString(context, "registration_view___form_field__name_hint"),
                                          hasError: !state.isValidFullName,
                                          errorText: Utils.getString(context, "registration_view___form_field__name_error_text"),
                                          controller: BlocProvider.of<RegistrationBloc>(context).fullNameController,
                                          format: [
                                            FilteringTextInputFormatter.allow(RegExp("[a-zA-Zа-яА-ЯƏəÖöĞğİiÇçŞş ]")),
                                            LengthLimitingTextInputFormatter(40),
                                          ],
                                          toDo: (value){
                                            BlocProvider.of<RegistrationBloc>(context).fullNameChanged(
                                                value
                                            );
                                          },
                                        ),
                                      );
                                    }),
                                    BlocBuilder<RegistrationBloc, RegistrationState>(builder: (context, state) {
                                      return  Container(
                                        padding: const EdgeInsets.only(bottom: 12),
                                        child: GeneralTextField(
                                          enabled: !(BlocProvider.of<AuthCubit>(context).authType == AuthType.otp),
                                          size: size,
                                          label: Utils.getString(context, "registration_view___form_field__phone_label"),
                                          hintText: Utils.getString(context, "registration_view___form_field__phone_hint"),
                                          prefixText: "+994 ",
                                          hasError: !state.isValidPhone,
                                          errorText: Utils.getString(context, "registration_view___form_field__phone_error_text"),
                                          controller: BlocProvider.of<RegistrationBloc>(context).phoneController,
                                          toDo: (value){
                                            BlocProvider.of<RegistrationBloc>(context).phoneChanged(
                                                value
                                            );
                                          },
                                          suffixIcon: SvgPicture.asset("assets/svgs/form/phone.svg"),
                                        ),
                                      );
                                    }),
                                    BlocBuilder<RegistrationBloc, RegistrationState>(builder: (context, state) {
                                      return  Container(
                                        padding: const EdgeInsets.only(bottom: 12),
                                        child: GeneralDateField(
                                          valueDate: state.birthdate  == 'empty' || state.birthdate == null ? null : Utils.stringToDate(value: state.birthdate , format: "dd.MM.yyyy", defaultDate: DateTime(now.year - 18, now.month, now.day)),
                                          size: size,
                                          initialDate: DateTime(now.year - 18, now.month, now.day),
                                          lastDate: DateTime(now.year - 18, now.month, now.day),
                                          label: Utils.getString(context, "registration_view___form_field__birthday_label"),
                                          hintText: Utils.getString(context, "registration_view___form_field__birthday_hint"),
                                          hasError: !state.isValidBirthdate,
                                          errorText: Utils.getString(context, "registration_view___form_field__birthday_error_text"),
                                          controller: BlocProvider.of<RegistrationBloc>(context).birthdateController,
                                          toDo: (value){
                                            BlocProvider.of<RegistrationBloc>(context).birthdayChanged(
                                                value
                                            );
                                          },
                                          suffixIcon: SvgPicture.asset("assets/svgs/form/calendar.svg"),
                                        ),
                                      );
                                    }),
                                    Container(
                                      padding: const EdgeInsets.only(bottom: 16),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Flexible(
                                                flex: 2,
                                                child:
                                                BlocBuilder<RegistrationBloc, RegistrationState>(builder: (context, state) {
                                                  return  GeneralTextField(
                                                    size: size,
                                                    label: Utils.getString(context, "registration_view___form_field__weight_label"),
                                                    hintText: Utils.getString(context, "registration_view___form_field__weight_label"),
                                                    // hasError: !state.isValidWeight,
                                                    hasError: false,
                                                    errorText: Utils.getString(context, "registration_view___form_field__weight_error_text"),
                                                    controller: BlocProvider.of<RegistrationBloc>(context).weightController,
                                                    keyboardType: TextInputType.number,
                                                    format: [
                                                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                                                      DecimalTextInputFormatter(decimalRange: 2),
                                                      LengthLimitingTextInputFormatter(3),
                                                    ],
                                                    toDo: (value){
                                                      BlocProvider.of<RegistrationBloc>(context).weightChanged(
                                                          value
                                                      );
                                                    },
                                                    suffixIcon: Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                      child: Text(Utils.getString(context, "general_form_kg"), style: MainStyles.boldTextStyle.copyWith(color: MainColors.middleGrey300)),
                                                    ),
                                                  );
                                                }),
                                              ),
                                              const SizedBox(width: 16,),
                                              Flexible(
                                                flex: 2,
                                                child:
                                                BlocBuilder<RegistrationBloc, RegistrationState>(builder: (context, state) {
                                                  return  GeneralTextField(
                                                    size: size,
                                                    label: Utils.getString(context, "registration_view___form_field__height_label"),
                                                    hintText: Utils.getString(context, "registration_view___form_field__height_hint"),
                                                    // hasError: !state.isValidHeight,
                                                    hasError: false,
                                                    errorText: Utils.getString(context, "registration_view___form_field__height_error_text"),
                                                    controller: BlocProvider.of<RegistrationBloc>(context).heightController,
                                                    keyboardType: TextInputType.number,
                                                    format: [
                                                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                                                      DecimalTextInputFormatter(decimalRange: 2),
                                                      LengthLimitingTextInputFormatter(3),
                                                    ],
                                                    toDo: (value){
                                                      BlocProvider.of<RegistrationBloc>(context).heightChanged(
                                                          value
                                                      );
                                                    },
                                                    suffixIcon: Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                      child: Text(Utils.getString(context, "general_form_cm"), style: MainStyles.boldTextStyle.copyWith(color: MainColors.middleGrey300)),
                                                    ),
                                                  );
                                                }),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Flexible(
                                                flex: 2,
                                                child:
                                                BlocBuilder<RegistrationBloc, RegistrationState>(builder: (context, state) {
                                                  return !state.isValidWeight ? Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8, ),
                                                    child: Text(Utils.getString(context, "registration_view___form_field__weight_error_text"), style: MainStyles.semiBoldTextStyle.copyWith(color: MainColors.red, fontSize: 14),),
                                                  ):Container();
                                                }),
                                              ),
                                              const SizedBox(width: 16,),
                                              Flexible(
                                                flex: 2,
                                                child:
                                                BlocBuilder<RegistrationBloc, RegistrationState>(builder: (context, state) {
                                                  return !state.isValidHeight ? Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8, ),
                                                    child: Text(Utils.getString(context, "registration_view___form_field__height_error_text"), style: MainStyles.semiBoldTextStyle.copyWith(color: MainColors.red, fontSize: 14),),
                                                  ):Container();
                                                }),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    BlocBuilder<RegistrationBloc, RegistrationState>(
                                        builder: (context, state) {
                                          return Padding(
                                            padding: const EdgeInsets.only(bottom: 16),
                                            child: SelectableField(
                                              size: size,
                                              label: Utils.getString(context, "profile_view___tab_information___form_field__gender_label"),
                                              hintText: Utils.getString(context, "profile_view___tab_information___form_field__gender_hint"),
                                              errorText: Utils.getString(context, "profile_view___tab_information___form_field__gender_error_text"),
                                              hasError: !state.isValidGender,
                                              controller: context.read<RegistrationBloc>().genderController,
                                              requiredInput: true,
                                              initialValue: state.gender ?? '',
                                              dataMap: MainConst.genderDataMap,
                                              validateFunction: context.read<RegistrationBloc>().formValidator.validGender,
                                              toDo: (value){
                                                context.read<RegistrationBloc>().genderChanged(
                                                    value,
                                                    req: true
                                                );
                                              },
                                              // suffixIcon: SvgPicture.asset("assets/svgs/form/gender.svg"),
                                            ),
                                          );
                                        }
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            // height: double.infinity,
                            constraints: BoxConstraints(
                              minHeight: size.height * 4.5 / 10,
                            ),
                            decoration: BoxDecoration(
                              color: MainColors.white,
                              borderRadius: const BorderRadius.only(topRight: Radius.circular(24), topLeft: Radius.circular(24), ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: AutoSizeText(Utils.getString(context, "registration_view___second_part_title"), style: MainStyles.extraBoldTextStyle.copyWith(fontSize: 16, color: MainColors.middleGrey400),),
                                  ),
                                  BlocBuilder<RegistrationBloc, RegistrationState>(builder: (context, state) {
                                    return  GeneralTextField(
                                      requiredInput: false,
                                      size: size,
                                      label: Utils.getString(context, "registration_view___form_field__goal_steps_per_day_label"),
                                      hintText: Utils.getString(context, "registration_view___form_field__goal_steps_per_day_hint"),
                                      hasError: !state.isValidGoalStepsPerDay,
                                      errorText: Utils.getString(context, "registration_view___form_field__goal_steps_per_day_error_text"),
                                      controller: BlocProvider.of<RegistrationBloc>(context).goalStepsPerDayController,
                                      keyboardType: TextInputType.number,
                                      format: [
                                        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                      toDo: (value){
                                        BlocProvider.of<RegistrationBloc>(context).goalStepChanged(
                                            value
                                        );
                                      },
                                    );
                                  }),
                                  BlocBuilder<RegistrationBloc, RegistrationState>(builder: (context, state) {
                                    return  GeneralTextField(
                                      requiredInput: false,
                                      size: size,
                                      label: Utils.getString(context, "registration_view___form_field__email_label"),
                                      hintText: Utils.getString(context, "registration_view___form_field__email_hint"),
                                      hasError: !state.isValidEmail,
                                      errorText: Utils.getString(context, "registration_view___form_field__email_error_text"),
                                      controller: BlocProvider.of<RegistrationBloc>(context).emailController,
                                      format: [
                                        // FilteringTextInputFormatter.allow(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")),
                                        LengthLimitingTextInputFormatter(50),
                                      ],
                                      toDo: (value){
                                        BlocProvider.of<RegistrationBloc>(context).emailChanged(
                                            value,
                                          req: false
                                        );
                                      },
                                      suffixIcon: SvgPicture.asset("assets/svgs/form/email.svg"),
                                    );
                                  }),

                                  // BlocBuilder<RegistrationBloc, RegistrationState>(builder: (context, state) {
                                  //   return  GeneralTextField(
                                  //     requiredInput: false,
                                  //     size: size,
                                  //     label: Utils.getString(context, "registration_view___form_field__invitation_code_label"),
                                  //     hintText: Utils.getString(context, "registration_view___form_field__invitation_code_hint"),
                                  //     hasError: !state.isValidInvitationCode,
                                  //     errorText: Utils.getString(context, "registration_view___form_field__invitation_code_error_text"),
                                  //     controller: BlocProvider.of<RegistrationBloc>(context).invitationCodeController,
                                  //     format: [
                                  //       LengthLimitingTextInputFormatter(50),
                                  //     ],
                                  //     toDo: (value){
                                  //       BlocProvider.of<RegistrationBloc>(context).inviteChanged(
                                  //           value
                                  //       );
                                  //     },
                                  //   );
                                  // }),
                                  // const SizedBox(height: 12,),


                                  BlocBuilder<RegistrationBloc, RegistrationState>(builder: (context, state) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 12, top: 12),
                                      child: BigUnBorderedButton(
                                          buttonColor: (
                                              (state.isValidFullName && state.fullName != null && state.fullName != '' ) &&
                                              (state.isValidPhone && state.phone != null && state.phone != '' ) &&
                                              (state.isValidBirthdate && state.birthdate != null && state.birthdate != '' ) &&
                                              (state.isValidGender && state.gender != null && state.gender != '' ) &&
                                              (state.isValidWeight && state.weight != null && state.weight != '' ) &&
                                              (state.isValidHeight && state.height != null && state.height != '' ) &&
                                              (state.isValidEmail) &&
                                              (state.isValidInvitationCode) &&
                                              (state.isValidGoalStepsPerDay)
                                          ) ? null : MainColors.middleBlue100,
                                          onTap: (){
                                            Utils.focusClose(context);
                                            if(
                                            (state.isValidFullName && state.fullName != null && state.fullName != '' ) &&
                                                (state.isValidPhone && state.phone != null && state.phone != '' ) &&
                                                (state.isValidBirthdate && state.birthdate != null && state.birthdate != '' ) &&
                                                (state.isValidGender && state.gender != null && state.gender != '' ) &&
                                                (state.isValidWeight && state.weight != null && state.weight != '' ) &&
                                                (state.isValidHeight && state.height != null && state.height != '' ) &&
                                                (state.isValidEmail) &&
                                                (state.isValidInvitationCode) &&
                                                (state.isValidGoalStepsPerDay)
                                            ){

                                              showLoading(context, Utils.getString(context, "general__loading_text"));
                                              BlocProvider.of<RegistrationBloc>(context).registerSubmit().then((data) async{
                                                closeLoading(context);
                                                switch (data[2]) {
                                                  case WEB_SERVICE_ENUM.SUCCESS:
                                                    {

                                                      ProfileResponse profileResponse = ProfileResponse.fromJson(data[1]);
                                                      BlocProvider.of<SessionCubit>(context).setUser(profileResponse.data);

                                                      // if(await Utils.checkPermissions())
                                                      //   Navigator.pushReplacementNamed(context, "index");
                                                      // else
                                                        Navigator.pushReplacementNamed(context, "/permission-list-health");
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
                                                    }
                                                    break;
                                                }
                                              }).catchError((e){
                                                closeLoading(context);
                                              });
                                            }
                                          },
                                          text: Utils.getString(context, "registration_view___button_title")
                                      ),
                                    );
                                  }),

                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
