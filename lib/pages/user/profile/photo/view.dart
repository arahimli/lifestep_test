import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lifestep/tools/common/input-format.dart';
import 'package:lifestep/tools/common/utlis.dart';
import 'package:lifestep/tools/components/buttons/big_unborderd_button.dart';
import 'package:lifestep/tools/components/dialog/loading.dart';
import 'package:lifestep/tools/components/form/datefield/general.dart';
import 'package:lifestep/tools/components/form/select/selectable/view.dart';
import 'package:lifestep/tools/components/form/textfield/general.dart';
import 'package:lifestep/config/main_colors.dart';
import 'package:lifestep/config/main_constants.dart';
import 'package:lifestep/config/scroll_behavior.dart';
import 'package:lifestep/config/styles.dart';
import 'package:lifestep/logic/session/cubit.dart';
import 'package:lifestep/logic/session/state.dart';
import 'package:lifestep/pages/user/cubit/cubit.dart';
import 'package:lifestep/pages/user/profile/information/goal_step/cubit.dart';
import 'package:lifestep/pages/user/profile/information/goal_step/state.dart';
import 'package:lifestep/pages/user/repositories/auth.dart';
import 'package:lifestep/repositories/service/web_service.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'cubit.dart';
import 'state.dart';

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
    return ScrollConfiguration(
      behavior: MainScrollBehavior(),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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

                    SizedBox(height: 12,),
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

                    SizedBox(height: 12,),
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