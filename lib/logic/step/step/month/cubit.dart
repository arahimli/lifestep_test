
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/config/exception.dart';
import 'package:lifestep/model/step/user-order.dart';
import 'package:lifestep/repositories/service/web_service.dart';
import 'package:lifestep/repositories/step.dart';

import 'state.dart';

class GeneralUserLeaderBoardMonthStepCubit extends  Cubit<GeneralUserLeaderBoardMonthStepState> {

  final StepRepository stepRepository;
  GeneralUserLeaderBoardMonthStepCubit({required this.stepRepository}) : assert(stepRepository != null), super(GeneralUserLeaderBoardMonthStepLoading()){
    this.search(reset:true);
  }


  bool isLoading = false;
  String raitingType = "1";
  String rangeType = "2";
  CancelToken dioToken = CancelToken();
  TextEditingController searchTextController = TextEditingController();

  ScrollController scrollController = ScrollController();
  Future<void> refresh()async{
    await search(reset: true);
  }
  @override
  search({bool reset:false}) async {
    var currentState = state;
    if(reset){
      currentState = GeneralUserLeaderBoardMonthStepLoading();
      emit(GeneralUserLeaderBoardMonthStepLoading());
      dioToken.cancel();
      dioToken = CancelToken();
    }

    try {
      if (currentState is GeneralUserLeaderBoardMonthStepLoading) {
        // print('GeneralUserLeaderBoardMonthStepCubit mapEventToState GeneralUserLeaderBoardMonthStepLoading listCount: $listCount');
        emit(GeneralUserLeaderBoardMonthStepLoading());
        List listData = await stepRepository.getUserOrderRatingStepStatistic(raitingType: raitingType, rangeType: rangeType, token: dioToken);
         // print("listData__listData__listData__listData__listData__listData__");
         // print(listData);
        if(listData[2] == WEB_SERVICE_ENUM.SUCCESS) {

          UserOrderResponse userOrderResponse = UserOrderResponse.fromJson(listData[1]);
          emit(GeneralUserLeaderBoardMonthStepSuccess(
              mainData: userOrderResponse.data!
          ));
          return;
        }else{
          emit(
              GeneralUserLeaderBoardMonthStepError(
                  errorCode: listData[2],
                  errorText: listData[1]
              )
          );

        }
      }
      if (currentState is GeneralUserLeaderBoardMonthStepSuccess) {
        if(!isLoading) {
          isLoading = true;
          List listData = await stepRepository.getUserOrderRatingStepStatistic(raitingType: raitingType, rangeType: rangeType, token: dioToken);
          isLoading = false;
          if (listData[2] == WEB_SERVICE_ENUM.SUCCESS) {

            UserOrderResponse userOrderResponse = UserOrderResponse.fromJson(listData[1]);
            emit(GeneralUserLeaderBoardMonthStepSuccess(
                mainData: userOrderResponse.data!
            ));
            return;
          }
        }
      }
    } catch (exception) {
      if (exception is HTTPException) {
        emit(GeneralUserLeaderBoardMonthStepError(errorCode: WEB_SERVICE_ENUM.UNEXCEPTED_ERROR, errorText: "error_went_wrong"));
      }
    }

  }
}