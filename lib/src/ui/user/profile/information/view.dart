import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:lifestep/src/tools/common/input-data.dart';
import 'package:lifestep/src/tools/common/input-format.dart';
import 'package:lifestep/src/tools/common/utlis.dart';
import 'package:lifestep/src/tools/components/buttons/big_unborderd_button.dart';
import 'package:lifestep/src/tools/components/dialog/loading.dart';
import 'package:lifestep/src/tools/components/form/datefield/general.dart';
import 'package:lifestep/src/tools/components/form/select/selectable/view.dart';
import 'package:lifestep/src/tools/components/form/textfield/general.dart';
import 'package:lifestep/src/tools/config/main_colors.dart';
import 'package:lifestep/src/tools/config/scroll_behavior.dart';
import 'package:lifestep/src/tools/config/styles.dart';
import 'package:lifestep/src/cubits/global/session/cubit.dart';
import 'package:lifestep/src/cubits/global/session/state.dart';
import 'package:lifestep/src/ui/user/logic/cubit.dart';
import 'package:lifestep/src/ui/user/profile/information/cubit.dart';
import 'package:lifestep/src/ui/user/profile/information/goal_step/cubit.dart';
import 'package:lifestep/src/ui/user/profile/information/goal_step/state.dart';
import 'package:lifestep/src/ui/user/profile/information/state.dart';
import 'package:lifestep/src/ui/user/repositories/auth.dart';
import 'package:lifestep/src/resources/service/web_service.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:lifestep/src/tools/general/padding/page-padding.dart';

class InformationWidget extends StatefulWidget {
  const InformationWidget({Key? key}) : super(key: key);

  @override
  InformationWidgetState createState() => InformationWidgetState();
}

class InformationWidgetState extends State<InformationWidget> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final now = DateTime.now();
    context.read<ProfileInformationCubit>().reInitialize(context);
    return ScrollConfiguration(
      behavior: MainScrollBehavior(),
      child: SingleChildScrollView(
        child: Padding(
          padding: PagePadding.all16(),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: PagePadding.all16(),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: MainColors.darkPink500!, width: 2)
                ),
                child: Column(
                  children: [

                    Text(
                      Utils.getString(context, "profile_view___tab_information___form_field__edit_goal_label"),
                      style: MainStyles.semiBoldTextStyle.copyWith(height: 1.1, fontSize: 16, color: MainColors.middleGrey400),
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8,),
                    BlocBuilder<SessionCubit, SessionState>(
                      builder: (context, state) {
                        return state.currentUser != null ? Text(
                          (state.currentUser!.targetSteps ?? 0).toString() ,
                          // Utils.humanizeInteger(context, state.currentUser!.targetSteps ?? 0) ,
                          style: MainStyles.semiBoldTextStyle.copyWith(height: 1.1, fontSize: 40, color: MainColors.darkPink500),
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ):Container();
                      }
                    ),
                    const SizedBox(height: 8,),
                    InkWell(
                      onTap: (){


                        showCupertinoModalBottomSheet(
                          expand: false,
                          context: context,

                          backgroundColor: Colors.transparent,
                          builder: (context) => BlocProvider<GoalStepCubit>(create: (context) => GoalStepCubit(
                            sessionCubit: BlocProvider.of<SessionCubit>(context),
                            authRepo: GetIt.instance<UserRepository>()
                          ),
                              child: _GoalStepModal()
                          ),
                        );

                      },
                      child: Text(
                        Utils.getString(context, "profile_view___tab_information___form_field__edit_goal"),
                        style: MainStyles.extraBoldTextStyle.copyWith(height: 1.1, fontSize: 14, color: MainColors.darkBlue50),
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 16,),

              BlocBuilder<ProfileInformationCubit, ProfileInformationState>(
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GeneralTextField(
                        size: size,
                        label: Utils.getString(context, "profile_view___tab_information___form_field__name_label"),
                        hintText: Utils.getString(context, "profile_view___tab_information___form_field__name_hint"),
                        errorText: Utils.getString(context, "profile_view___tab_information___form_field__name_error_text"),
                        hasError: !state.isValidFullName,
                        controller: context.read<ProfileInformationCubit>().fullNameController,
                        format: [
                          FilteringTextInputFormatter.allow(RegExp("[a-zA-Zа-яА-ЯƏəÖöĞğİiÇçŞş ]")),
                          LengthLimitingTextInputFormatter(40),
                        ],
                        toDo: (value){
                          context.read<ProfileInformationCubit>().fullNameChanged(
                              value
                          );
                        },
                      ),
                    );
                  }
              ),
              BlocBuilder<ProfileInformationCubit, ProfileInformationState>(
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GeneralTextField(
                        enabled: !(BlocProvider.of<SessionCubit>(context).currentUser!.loginMethod == AuthType.OTP),
                        size: size,
                        label: Utils.getString(context, "profile_view___tab_information___form_field__phone_label"),
                        hintText: Utils.getString(context, "profile_view___tab_information___form_field__phone_hint"),
                        errorText: Utils.getString(context, "profile_view___tab_information___form_field__phone_error_text"),
                        prefixText: "+994 ",
                        hasError: !state.isValidPhone,
                        controller: context.read<ProfileInformationCubit>().phoneController,
                        toDo: (value){
                          // context.read<ProfileInformationCubit>().phoneChanged(
                          //     value
                          // );
                        },
                        suffixIcon: SvgPicture.asset("assets/svgs/form/phone.svg"),
                      ),
                    );
                  }
              ),

              BlocBuilder<ProfileInformationCubit, ProfileInformationState>(
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GeneralDateField(
                        valueDate: state.birthdate  == '' || state.birthdate  == null ? null : Utils.stringToDate(value: state.birthdate , format: "dd.MM.yyyy"),
                        initialDate: DateTime(now.year - 18, now.month, now.day),
                        lastDate: DateTime(now.year - 18, now.month, now.day),
                        size: size,
                        label: Utils.getString(context, "profile_view___tab_information___form_field__birthday_label"),
                        hintText: Utils.getString(context, "profile_view___tab_information___form_field__birthday_hint"),
                        errorText: Utils.getString(context, "profile_view___tab_information___form_field__birthday_error_text"),
                        hasError: !state.isValidBirthdate,
                        controller: context.read<ProfileInformationCubit>().birthdateController,
                        format: [
                          FilteringTextInputFormatter.allow(RegExp(r"^([0-2][0-9]|(3)[0-1])(\.)(((0)[0-9])|((1)[0-2]))(\.)\d{4}$")),
                          LengthLimitingTextInputFormatter(10),
                        ],
                        toDo: (value){
                          context.read<ProfileInformationCubit>().birthdayChanged(
                              value
                          );
                        },
                        suffixIcon: SvgPicture.asset("assets/svgs/form/calendar.svg"),
                      ),
                    );
                  }
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: [
                    Row(
                      children: [


                        Flexible(
                          flex: 2,
                          child: BlocBuilder<ProfileInformationCubit, ProfileInformationState>(
                              builder: (context, state) {
                                return GeneralTextField(
                                  size: size,
                                  label: Utils.getString(context, "profile_view___tab_information___form_field__weight_label"),
                                  hintText: Utils.getString(context, "profile_view___tab_information___form_field__weight_hint"),
                                  errorText: Utils.getString(context, "profile_view___tab_information___form_field__weight_error_text"),
                                  hasError: false,
                                  keyboardType: TextInputType.number,
                                  // hasError: !state.isValidWeight,
                                  controller: context.read<ProfileInformationCubit>().weightController,
                                  format: [
                                    FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                                    DecimalTextInputFormatter(decimalRange: 2),
                                    LengthLimitingTextInputFormatter(3),
                                  ],
                                  toDo: (value){
                                    context.read<ProfileInformationCubit>().weightChanged(
                                        value,
                                        req: true
                                    );
                                  },
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                    child: Text(Utils.getString(context, "general_form_kg"), style: MainStyles.boldTextStyle.copyWith(color: MainColors.middleGrey300)),
                                  ),
                                );
                              }
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Flexible(
                          flex: 2,
                          child: BlocBuilder<ProfileInformationCubit, ProfileInformationState>(
                              builder: (context, state) {
                                return GeneralTextField(
                                  size: size,
                                  label: Utils.getString(context, "profile_view___tab_information___form_field__height_label"),
                                  hintText: Utils.getString(context, "profile_view___tab_information___form_field__height_hint"),
                                  errorText: Utils.getString(context, "profile_view___tab_information___form_field__height_error_text"),
                                  hasError: false,
                                  keyboardType: TextInputType.number,
                                  // hasError: !state.isValidHeight,
                                  controller: context.read<ProfileInformationCubit>().heightController,
                                  format: [
                                    FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                                    DecimalTextInputFormatter(decimalRange: 2),
                                    LengthLimitingTextInputFormatter(3),
                                  ],
                                  toDo: (value){
                                    context.read<ProfileInformationCubit>().heightChanged(
                                        value,
                                        req: true
                                    );
                                  },
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                    child: Text(Utils.getString(context, "general_form_cm"), style: MainStyles.boldTextStyle.copyWith(color: MainColors.middleGrey300)),
                                  ),                                );
                              }
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Flexible(
                          flex: 2,
                          child:
                          BlocBuilder<ProfileInformationCubit, ProfileInformationState>(builder: (context, state) {
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
                          BlocBuilder<ProfileInformationCubit, ProfileInformationState>(builder: (context, state) {
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

              BlocBuilder<ProfileInformationCubit, ProfileInformationState>(
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GeneralTextField(
                        size: size,
                        label: Utils.getString(context, "profile_view___tab_information___form_field__email_label"),
                        hintText: Utils.getString(context, "profile_view___tab_information___form_field__email_hint"),
                        errorText: Utils.getString(context, "profile_view___tab_information___form_field__email_error_text"),
                        hasError: !state.isValidEmail,
                        controller: context.read<ProfileInformationCubit>().emailController,
                        requiredInput: false,
                        format: [
                          // FilteringTextInputFormatter.allow(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")),
                          LengthLimitingTextInputFormatter(50),
                        ],
                        toDo: (value){
                          context.read<ProfileInformationCubit>().emailChanged(
                              value,
                              req: false
                          );
                        },
                        suffixIcon: SvgPicture.asset("assets/svgs/form/email.svg"),
                      ),
                    );
                  }
              ),

              BlocBuilder<ProfileInformationCubit, ProfileInformationState>(
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: SelectableField(
                        size: size,
                        label: Utils.getString(context, "profile_view___tab_information___form_field__gender_label"),
                        hintText: Utils.getString(context, "profile_view___tab_information___form_field__gender_hint"),
                        errorText: Utils.getString(context, "profile_view___tab_information___form_field__gender_error_text"),
                        hasError: !state.isValidGender,
                        controller: context.read<ProfileInformationCubit>().genderController,
                        requiredInput: true,
                        initialValue: state.gender ?? 'male',
                        dataMap: DataUtils.genderData(context),
                        validateFunction: context.read<ProfileInformationCubit>().formValidator.validGender,
                        toDo: (value){
                          context.read<ProfileInformationCubit>().genderChanged(
                              value,
                              req: true
                          );
                        },
                        // suffixIcon: SvgPicture.asset("assets/svgs/form/gender.svg"),
                      ),
                    );
                  }
              ),
              const SizedBox(height: 16,),

              BlocBuilder<ProfileInformationCubit, ProfileInformationState>(builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: BigUnBorderedButton(
                      buttonColor: (
                          (state.isValidFullName && state.fullName != null && state.fullName != '' ) &&
                              (state.isValidPhone && state.phone != null && state.phone != '' ) &&
                              (state.isValidBirthdate && state.birthdate != null && state.birthdate != '' ) &&
                              (state.isValidGender && state.gender != null && state.gender != '' ) &&
                              (state.isValidWeight && state.weight != null && state.weight != '' ) &&
                              (state.isValidHeight && state.height != null && state.height != '' ) &&
                              (state.isValidEmail)
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
                            (state.isValidEmail)
                        ){

                          showLoading(context, Utils.getString(context, "general__loading_text"));
                          BlocProvider.of<ProfileInformationCubit>(context).profileChangeSubmit().then((data) {
                            closeLoading(context);
                            switch (data[2]) {
                              case WEB_SERVICE_ENUM.SUCCESS:
                                {
                                  Utils.showInfoModal(context, size, image: "assets/svgs/general/profile-save-success.svg", title: Utils.getString(context, "profile_view___form_success_message"));
                                  // Navigator.pushReplacementNamed(context, "apploading");
                                }
                                break;
                              case WEB_SERVICE_ENUM.INTERNET_ERROR:
                                {
                                  Utils.showErrorModal(context, size,
                                      errorCode: WEB_SERVICE_ENUM.INTERNET_ERROR,
                                      title: Utils.getString(
                                          context, data[1] ?? "internet_connection_error"));
                                  // Utils.showErrorModal(context, size, image: "assets/svgs/dialog/error.svg", title: Utils.getString(context, "profile_view___form_success_message"));
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
                      text: Utils.getString(context, "profile_view___tab_information___button_title")
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}



class _GoalStepModal extends StatelessWidget {
  const _GoalStepModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      child: BlocBuilder<GoalStepCubit, GoalStepState>(
          builder: (context, state) {
            return SafeArea(
              top: false,
              child: Container(
                // padding:
                // EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                padding: EdgeInsets.only(left: 16, right: 16, bottom: MediaQuery.of(context).viewInsets.bottom + 16, top: 16),
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

                    const SizedBox(height: 12,),
                    GeneralTextField(
                      size: size,
                      label: Utils.getString(context, "profile_view___tab_information___form_field__goal_steps_per_day_label"),
                      hintText: Utils.getString(context, "profile_view___tab_information___form_field__goal_steps_per_day_hint"),
                      hasError: !state.isValidAmount,
                      errorText: Utils.getString(context, "profile_view___tab_information___form_field__goal_steps_per_day_error_text"),
                      controller: BlocProvider.of<GoalStepCubit>(context).inputController,
                      keyboardType: TextInputType.number,
                      format: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                        LengthLimitingTextInputFormatter(10),
                      ],
                      toDo: (value){
                        BlocProvider.of<GoalStepCubit>(context).inputChanged(
                            value
                        );
                      },
                    ),

                    const SizedBox(height: 12,),
                    Row(
                      children: [
                        Flexible(
                            flex: 1,
                            child: BigUnBorderedButton(
                              buttonColor: state.isValidAmount && Utils.stringToDouble(value: state.amount) > 0 ? null : MainColors.middleBlue100 ,
                              text: Utils.getString(context, "profile_view___tab_information__goal_steps_per_day___button_title"),
                              onTap: ()async{
                                  if(state.isValidAmount && Utils.stringToDouble(value: state.amount) > 0){
                                    showLoading(context, Utils.getString(context, "general__loading_text"));
                                    BlocProvider.of<GoalStepCubit>(context).profileChangeSubmit().then((data) {
                                      closeLoading(context);
                                      Navigator.of(context).pop();
                                      switch (data[2]) {
                                        case WEB_SERVICE_ENUM.SUCCESS:
                                          {
                                            Utils.showInfoModal(context, size, image: "assets/svgs/general/profile-save-success.svg", title: Utils.getString(context, "profile_view___form_success_message"));
                                            // Navigator.pushReplacementNamed(context, "apploading");
                                          }
                                          break;
                                        case WEB_SERVICE_ENUM.INTERNET_ERROR:
                                          {
                                            Utils.showErrorModal(context, size,
                                                errorCode: data[2],
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
                                    }).catchError((e){
                                      closeLoading(context);
                                    });
                                  }
                              },
                            )
                        )
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