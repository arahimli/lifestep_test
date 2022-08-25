
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/src/models/challenge/challenges.dart';
import 'package:lifestep/src/models/home/challenge_list.dart';
import 'package:lifestep/src/resources/challenge.dart';
import 'package:lifestep/src/tools/common/utlis.dart';
import 'package:lifestep/src/tools/config/exception.dart';
import 'package:lifestep/src/ui/index/logic/challenge/state.dart';
import 'package:lifestep/src/resources/service/web_service.dart';

class HomeChallengeListCubit extends  Cubit<HomeChallengeListState> {

  final IChallengeRepository challengeRepository;
  HomeChallengeListCubit({required this.challengeRepository}) : super(HomeChallengeListLoading()){
    search();
    // //////// print("HomeChallengeListCubit--------");
  }


  bool isLoading = false;
  CancelToken dioToken = CancelToken();

  ScrollController scrollController = ScrollController();
  Future<void> refresh()async{
   ///////// print("refresh");
    await search(reset: true);
  }

  search({bool reset = false}) async {
    var currentState = state;
    if(reset){
      currentState = HomeChallengeListLoading();
      emit(HomeChallengeListLoading());
      dioToken.cancel();
      dioToken = CancelToken();
    }
    // await Future.delayed(Duration(seconds: 10));
      //////// print(currentState);
    try {
      if (currentState is HomeChallengeListLoading) {
        emit(HomeChallengeListFetching());
        List listData = await challengeRepository.homeChallenges();
        // List listData = await challengeRepository.getCharities(searchText: searchText, pageValue: pageValue, token: dioToken);
        //////// print("listData__listData__listData__listData__listData__listData__");
        //////// print(listData);
        if(listData[2] == WEB_SERVICE_ENUM.SUCCESS) {
          HomeChallengeListResponse homeChallengeListResponse = HomeChallengeListResponse.fromJson(listData[1]);
          emit(HomeChallengeListSuccess(
            dataList: homeChallengeListResponse.data!.challenges ?? [],
            stepInnerList: homeChallengeListResponse.data!.stepInner ?? [],
            hash: Utils.generateRandomString(10)
          ));
          return;
        }else{

          emit(
              HomeChallengeListError(
                errorCode: listData[2],
                errorText: listData[1],
              )
          );

        }
      }
      if (currentState is HomeChallengeListSuccess) {
        if(!isLoading) {
          isLoading = true;
          List listData = await challengeRepository.homeChallenges();
          isLoading = false;
          if (listData[2] == WEB_SERVICE_ENUM.SUCCESS) {

            HomeChallengeListResponse homeChallengeListResponse = HomeChallengeListResponse.fromJson(listData[1]);
            emit(HomeChallengeListSuccess(
                dataList: homeChallengeListResponse.data!.challenges ?? [],
                stepInnerList: homeChallengeListResponse.data!.stepInner ?? [],
                hash: Utils.generateRandomString(10)
            ));
            return;
          }else if (listData[2] == WEB_SERVICE_ENUM.UN_AUTH){
            emit( HomeChallengeListError(errorCode: listData[2], errorText: listData[1]));
          }
        }
      }
    } catch (exception) {
      //////// print('HomeChallengeListCubit mapEventToState exception: $exception');
      if (exception is HTTPException) {
        emit(const HomeChallengeListError(errorCode: WEB_SERVICE_ENUM.UNEXCEPTED_ERROR, errorText: "error_went_wrong"));
      }
    }
  }





  changeChallenge({required List<ChallengeModel> listValue, required List<StepInnerModel> listStepInnerModel, required bool boolValue, required ChallengeModel value, required int index}) async {
    List<ChallengeModel> returnValue = listValue;
    returnValue[index] = value;

      emit(HomeChallengeListSuccess(
          dataList: returnValue,
          stepInnerList: listStepInnerModel,
          hash: Utils.generateRandomString(10)
      ));
  }
}