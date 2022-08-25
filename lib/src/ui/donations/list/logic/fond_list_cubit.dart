
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/src/tools/config/exception.dart';
import 'package:lifestep/src/tools/config/main_config.dart';
import 'package:lifestep/src/models/donation/fonds.dart';
import 'package:lifestep/src/ui/donations/list/logic/fond_state.dart';
import 'package:lifestep/src/resources/donation.dart';
import 'package:lifestep/src/resources/service/web_service.dart';

class FondListCubit extends  Cubit<FondListState> {

  final IDonationRepository donationRepository;
  FondListCubit({required this.donationRepository}) : super(FondListLoading()){
    search('');
    // //////// print("FondListCubit--------");
  }


  int pageValue = 1;
  bool isLoading = false;
  String searchText = "";
  CancelToken dioToken = CancelToken();

  ScrollController scrollController = ScrollController();

  Future<void> refresh()async{
    await search(searchText, reset: true);
  }

  @override
  search(String? searchValue, {bool reset = false}) async {
    var currentState = state;
    if(reset){
      currentState = FondListLoading();
      emit(FondListLoading());
      dioToken.cancel();
      dioToken = CancelToken();
      pageValue = 1;
    }
    // await Future.delayed(Duration(seconds: 3));
    if (!_hasReachedMax(currentState)) {
      //////// print(currentState);
      try {
        if (currentState is FondListLoading) {
          emit(FondListFetching());
          searchText = searchValue ?? searchText;
          List listData = await donationRepository.getFonds(searchText: searchText, pageValue: pageValue, token: dioToken);
          //////// print("listData__listData__listData__listData__listData__listData__");
          //////// print(listData);
          if(listData[2] == WEB_SERVICE_ENUM.SUCCESS) {
            pageValue = 2;

            FondListResponse charityListResponse = FondListResponse.fromJson(listData[1]);
            emit(FondListSuccess(
                dataList: charityListResponse.data,
                hasReachedMax: charityListResponse.data!.length <
                    MainConfig.main_app_data_count ? true : false));
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
            if (listData[2] == WEB_SERVICE_ENUM.SUCCESS) {

              FondListResponse charityListResponse = FondListResponse
                  .fromJson(listData[1]);
              emit(FondListSuccess(
                  dataList: List.from(currentState.dataList!)
                    ..addAll(charityListResponse.data!),
                  hasReachedMax: charityListResponse.data!.length <
                      MainConfig.main_app_data_count ? true : false));
              _updatePageValue(pageValue);
              return;
            }else if (listData[2] == WEB_SERVICE_ENUM.UN_AUTH){
              emit( FondListError(errorCode: listData[2], errorText: listData[1]));
            }
          }
        }
      } catch (exception) {
        //////// print('FondListCubit mapEventToState exception: $exception');
        if (exception is HTTPException) {
          emit(FondListError(errorCode: WEB_SERVICE_ENUM.UNEXCEPTED_ERROR, errorText: "error_went_wrong"));
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
    await Future.delayed(Duration(milliseconds: 10));

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


