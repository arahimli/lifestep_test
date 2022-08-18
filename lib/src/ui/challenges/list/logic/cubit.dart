
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/src/tools/config/exception.dart';
import 'package:lifestep/src/tools/config/main_config.dart';
import 'package:lifestep/src/models/challenge/challenges.dart';
import 'package:lifestep/src/ui/challenges/list/logic/state.dart';
import 'package:lifestep/src/resources/challenge.dart';
import 'package:lifestep/src/resources/service/web_service.dart';

class ChallengeListCubit extends  Cubit<ChallengeListState> {

  final ChallengeRepository challengeRepository;
  ChallengeListCubit({required this.challengeRepository}) : assert(challengeRepository != null), super(ChallengeListLoading()){
    search('');
    // //////// print("ChallengeListCubit--------");
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
  @override
  search(String? searchValue, {bool reset = false}) async {
    var currentState = state;
    if(reset){
      currentState = ChallengeListLoading();
      emit(ChallengeListLoading());
      dioToken.cancel();
      dioToken = CancelToken();
      pageValue = 1;
    }
    // await Future.delayed(Duration(seconds: 10));
    if (!_hasReachedMax(currentState)) {
      //////// print(currentState);
      try {
        if (currentState is ChallengeListLoading) {
          // print('ChallengeListCubit mapEventToState ChallengeListLoading pageValue: $pageValue');
          emit(ChallengeListFetching());
          searchText = searchValue != null ? searchValue : searchText;
          List listData = await challengeRepository.getChallenges(searchText: searchText, pageValue: pageValue, token: dioToken);
          //////// print("listData__listData__listData__listData__listData__listData__");
          //////// print(listData);
          if(listData[2] == WEB_SERVICE_ENUM.SUCCESS) {
            pageValue = 2;

            ChallengeListResponse challengeListResponse = ChallengeListResponse.fromJson(listData[1]);
            emit(ChallengeListSuccess(
                dataList: challengeListResponse.data,
                hasReachedMax: challengeListResponse.data!.length <
                    MainConfig.main_app_data_count ? true : false));
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
            if (listData[2] == WEB_SERVICE_ENUM.SUCCESS) {

              ChallengeListResponse challengeListResponse = ChallengeListResponse
                  .fromJson(listData[1]);
              emit(ChallengeListSuccess(
                  dataList: List.from(currentState.dataList!)
                    ..addAll(challengeListResponse.data!),
                  hasReachedMax: challengeListResponse.data!.length <
                      MainConfig.main_app_data_count ? true : false));
              _updatePageValue(pageValue);
              return;
            }else if (listData[2] == WEB_SERVICE_ENUM.UN_AUTH){
              emit( ChallengeListError(errorCode: listData[2], errorText: listData[1] ));
            }
          }
        }
      } catch (exception) {
        if (exception is HTTPException) {
          emit(ChallengeListError(errorCode: WEB_SERVICE_ENUM.UNEXCEPTED_ERROR, errorText: "error_went_wrong"));
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
}