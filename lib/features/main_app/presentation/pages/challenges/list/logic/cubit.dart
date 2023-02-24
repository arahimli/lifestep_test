

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/features/tools/common/utlis.dart';
import 'package:lifestep/features/tools/config/exception.dart';
import 'package:lifestep/features/tools/config/main_config.dart';
import 'package:lifestep/features/main_app/data/models/challenge/challenges.dart';
import 'package:lifestep/features/main_app/presentation/pages/challenges/list/logic/state.dart';
import 'package:lifestep/features/main_app/resources/challenge.dart';
import 'package:lifestep/features/main_app/resources/service/web_service.dart';

class ChallengeListCubit extends  Cubit<ChallengeListState> {

  final IChallengeRepository challengeRepository;
  ChallengeListCubit({required this.challengeRepository}) /* : assert(challengeRepository != null), */ : super(ChallengeListLoading()){
    search('');
  }


  int pageValue = 1;
  bool isLoading = false;
  String searchText = "";
  CancelToken dioToken = CancelToken();
  TextEditingController searchTextController = TextEditingController();

  ScrollController scrollController = ScrollController();
  Future<void> refresh()async{
    await search(searchText, reset: true);
  }
  search(String? searchValue, {bool reset = false}) async {
    var currentState = state;
    if(reset){
      currentState = ChallengeListLoading();
      emit(ChallengeListLoading());
      dioToken.cancel();
      dioToken = CancelToken();
      pageValue = 1;
    }
    dioToken.cancel();
    // await Future.delayed( const Duration(seconds: 10));
    if (!_hasReachedMax(currentState)) {
      try {
        if (currentState is ChallengeListLoading) {
          emit(ChallengeListFetching());
          searchText = searchValue ?? searchText;
          List listData = await challengeRepository.getChallenges(searchText: searchText, pageValue: pageValue, token: dioToken);
          if(listData[2] == WEB_SERVICE_ENUM.success) {
            pageValue = 2;

            ChallengeListResponse challengeListResponse = ChallengeListResponse.fromJson(listData[1]);
            emit(ChallengeListSuccess(
                dataList: challengeListResponse.data,
                hasReachedMax: challengeListResponse.data!.length <
                    MainConfig.mainAppDataCount ? true : false,
                hash: Utils.generateRandomString(10)
            ));
            return;
          }else{

            emit(
                ChallengeListError(
                    errorCode: listData[2],
                    errorText: listData[1]
                )
            );

          }
        }
        if (currentState is ChallengeListSuccess) {
          if(!isLoading) {
            isLoading = true;
            List listData = await challengeRepository.getChallenges(searchText: searchText, pageValue: pageValue, token: dioToken);
            isLoading = false;
            if (listData[2] == WEB_SERVICE_ENUM.success) {

              ChallengeListResponse challengeListResponse = ChallengeListResponse.fromJson(listData[1]);
              emit(currentState.copyWith(
                  dataList: List.from(currentState.dataList!)
                    ..addAll(challengeListResponse.data!),
                  hasReachedMax: challengeListResponse.data!.length <
                      MainConfig.mainAppDataCount ? true : false));
              _updatePageValue(pageValue);
              return;
            }else if (listData[2] == WEB_SERVICE_ENUM.unAuth){
              emit( ChallengeListError(errorCode: listData[2], errorText: listData[1] ));
            }
          }
        }
      } catch (exception, _) {
        if (exception is HTTPException) {
          emit(const ChallengeListError(errorCode: WEB_SERVICE_ENUM.unexpectedError, errorText: "error_went_wrong"));
        }
      }
    }else{

    }
  }

  void _updatePageValue(int page) {
    if (page >= 1) pageValue = page + 1;
  }


  bool _hasReachedMax(ChallengeListState state) =>
      state is ChallengeListSuccess && state.hasReachedMax;



  changeChallenge({required List<ChallengeModel> listValue, required bool boolValue, required ChallengeModel value, required int index}) async {
    List<ChallengeModel> returnValue = listValue;
    returnValue[index] = value;
    await Future.delayed( const Duration(milliseconds: 1));

    // emit(ChallengeListLoading());
    emit(ChallengeListSuccess(
        dataList: returnValue,
        hasReachedMax: boolValue,
        hash: Utils.generateRandomString(10)
      
    ));
  }


}