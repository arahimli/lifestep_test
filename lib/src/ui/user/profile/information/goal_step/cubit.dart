import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/src/tools/common/validator.dart';
import 'package:lifestep/src/tools/config/endpoints.dart';
import 'package:lifestep/src/cubits/global/session/cubit.dart';
import 'package:lifestep/src/models/auth/profile.dart';
import 'package:lifestep/src/ui/user/profile/information/goal_step/state.dart';
import 'package:lifestep/src/ui/user/repositories/auth.dart';
import 'package:lifestep/src/resources/service/web_service.dart';


class GoalStepCubit extends Cubit<GoalStepState> {
  final SessionCubit sessionCubit;
  final UserRepository authRepo;
  String? amount = '0';
  TextEditingController inputController = TextEditingController();
  FormValidator formValidator = FormValidator();


  inputChanged(String value) {
    amount = formValidator.validGoalStep(value) ? value : amount ?? '0';
    emit(GoalStepState(amount: value, isValidAmount: formValidator.validGoalStep(value)));
  }

  GoalStepCubit({required this.sessionCubit, required this.authRepo, }) : super(GoalStepState(amount: sessionCubit.currentUser!.targetSteps != null ? sessionCubit.currentUser!.targetSteps.toString() : '0')) {
    initialize();
  }

  Future<void> initialize() async {
    amount = state.amount;
    inputController.text = amount!;
  }


  Future<List> profileChangeSubmit() async{


    final data = await authRepo.editUser(
        data: {
          "target_steps": state.amount,
        },
        header: {
          'Authorization': "Bearer $TOKEN",
          'Accept-Language': LANGUAGE,
          'Accept': 'application/json'
        }
    );

    //////// print("resultResponse.data - 0");
    //////// print(data[2]);
    if(data[2] == WEB_SERVICE_ENUM.SUCCESS){
      try {
        ProfileResponse resultResponse = ProfileResponse.fromJson(data[1]);
        //////// print("resultResponse.data");
        //////// print(data[0]);
        //////// print(resultResponse.data);
        sessionCubit.setUser(resultResponse.data);
      }catch(e, stack){
        //////// print(e);
        //////// print(stack);
      }
    }
    return data;

  }


}
