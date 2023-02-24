
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/features/main_app/domain/repositories/donation/repository.dart';
import 'package:lifestep/features/tools/config/exception.dart';
import 'package:lifestep/features/tools/config/main_config.dart';
import 'package:lifestep/features/main_app/data/models/donation/fonds.dart';
import 'package:lifestep/features/main_app/presentation/pages/donations/list/logic/fond_state.dart';
import 'package:lifestep/features/main_app/resources/service/web_service.dart';

class FondListCubit extends  Cubit<FondListState> {

  final IDonationRepository donationRepository;
  FondListCubit({required this.donationRepository}) : super(FondListLoading()){
    search('');
  }


  int pageValue = 1;
  bool isLoading = false;
  String searchText = "";
  CancelToken dioToken = CancelToken();

  ScrollController scrollController = ScrollController();

  Future<void> refresh()async{
    await search(searchText, reset: true);
  }

  search(String? searchValue, {bool reset = false}) async {
    var currentState = state;
    if(reset){
      currentState = FondListLoading();
      emit(FondListLoading());
      dioToken.cancel();
      dioToken = CancelToken();
      pageValue = 1;
    }
    // await Future.delayed( const Duration(seconds: 3));
    if (!_hasReachedMax(currentState)) {
      try {
        if (currentState is FondListLoading) {
          emit(FondListFetching());
          searchText = searchValue ?? searchText;
          List listData = await donationRepository.getFonds(searchText: searchText, pageValue: pageValue, token: dioToken);
          if(listData[2] == WEB_SERVICE_ENUM.success) {
            pageValue = 2;

            FondListResponse charityListResponse = FondListResponse.fromJson(listData[1]);
            emit(FondListSuccess(
                dataList: charityListResponse.data,
                hasReachedMax: charityListResponse.data!.length <
                    MainConfig.mainAppDataCount ? true : false));
            return;
          }else{

            emit(
                FondListError(
                  errorCode: listData[2],
                  errorText: listData[1]
                )
            );

          }
        }
        if (currentState is FondListSuccess) {
          if(!isLoading) {
            isLoading = true;
            List listData = await donationRepository.getFonds(
                searchText: searchText, pageValue: pageValue, token: dioToken);
            isLoading = false;
            if (listData[2] == WEB_SERVICE_ENUM.success) {

              FondListResponse charityListResponse = FondListResponse
                  .fromJson(listData[1]);
              emit(FondListSuccess(
                  dataList: List.from(currentState.dataList!)
                    ..addAll(charityListResponse.data!),
                  hasReachedMax: charityListResponse.data!.length <
                      MainConfig.mainAppDataCount ? true : false));
              _updatePageValue(pageValue);
              return;
            }else if (listData[2] == WEB_SERVICE_ENUM.unAuth){
              emit( FondListError(errorCode: listData[2], errorText: listData[1]));
            }
          }
        }
      } catch (exception) {
        //////// print('FondListCubit mapEventToState exception: $exception');
        if (exception is HTTPException) {
          emit(const FondListError(errorCode: WEB_SERVICE_ENUM.unexpectedError, errorText: "error_went_wrong"));
        }
      }
    }else{

      //////// print("else if (event is FetchFondList && !_hasReachedMax(currentState)) {");
    }
  }

  void _updatePageValue(int page) {
    if (page >= 1) pageValue = page + 1;
  }


  bool _hasReachedMax(FondListState state) => state is FondListSuccess && state.hasReachedMax;




  changeFond({required List<FondModel> listValue, required bool boolValue, required FondModel value, required int index}) async {
    List<FondModel> returnValue = listValue;
    returnValue[index] = value;
    await Future.delayed( const Duration(milliseconds: 10));

    // emit(FondListLoading());
    emit(FondListSuccess(
        dataList: returnValue,
        hasReachedMax: boolValue));
    emit(FondUpdateListSuccess(
        dataList: returnValue,
        hasReachedMax: boolValue));
  }

  List<FondModel> updateData(List<FondModel> listValue, FondModel value){
    listValue[listValue.indexWhere((element) => element.id == value.id)] = value;
    return listValue;
  }

}


