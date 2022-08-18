
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/src/tools/config/exception.dart';
import 'package:lifestep/src/tools/config/main_config.dart';
import 'package:lifestep/src/models/donation/charities.dart';
import 'package:lifestep/src/ui/donations/list/logic/charity_state.dart';
import 'package:lifestep/src/resources/donation.dart';
import 'package:lifestep/src/resources/service/web_service.dart';

class CharityListCubit extends  Cubit<CharityListState> {

  final DonationRepository donationRepository;
  CharityListCubit({required this.donationRepository}) : assert(donationRepository != null), super(CharityListLoading()){
    search('');
    // //////// print("CharityListCubit--------");
  }


  int pageValue = 1;
  bool isLoading = false;
  String searchText = "";
  CancelToken dioToken = CancelToken();

  ScrollController scrollController = ScrollController();
  Future<void> refresh()async{
    // print("refresh");
    await search(searchText, reset: true);
  }

  @override
  search(String? searchValue, {bool reset = false}) async {
    var currentState = state;
    if(reset){
      currentState = CharityListLoading();
      emit(CharityListLoading());
      dioToken.cancel();
      dioToken = CancelToken();
      pageValue = 1;
    }
    // await Future.delayed(Duration(seconds: 3));
    if (!_hasReachedMax(currentState)) {
      //////// print(currentState);
      try {
        if (currentState is CharityListLoading) {
          emit(CharityListFetching());
          searchText = searchValue != null ? searchValue : searchText;
          List listData = await donationRepository.getCharities(searchText: searchText, pageValue: pageValue, token: dioToken);
          //////// print("listData__listData__listData__listData__listData__listData__");
          //////// print(listData);
          if(listData[2] == WEB_SERVICE_ENUM.SUCCESS) {
            pageValue = 2;

            CharityListResponse charityListResponse = CharityListResponse.fromJson(listData[1]);
            emit(CharityListSuccess(
                dataList: charityListResponse.data,
                hasReachedMax: charityListResponse.data!.length <
                    MainConfig.main_app_data_count ? true : false));
            return;
          }else{

            emit(
                CharityListError(
                  errorCode: listData[2],
                  errorText: listData[1],
                )
            );

          }
        }
        if (currentState is CharityListSuccess) {
          if(!isLoading) {
            isLoading = true;
            List listData = await donationRepository.getCharities(
                searchText: searchText, pageValue: pageValue, token: dioToken);
            isLoading = false;
            if (listData[2] == WEB_SERVICE_ENUM.SUCCESS) {
              CharityListResponse charityListResponse = CharityListResponse
                  .fromJson(listData[1]);
              emit(CharityListSuccess(
                  dataList: List.from(currentState.dataList!)
                    ..addAll(charityListResponse.data!),
                  hasReachedMax: charityListResponse.data!.length <
                      MainConfig.main_app_data_count ? true : false));
              _updatePageValue(pageValue);
              return;
            }else if (listData[2] == WEB_SERVICE_ENUM.UN_AUTH){
              emit( CharityListError(errorCode: listData[2], errorText: listData[1]));
            }
          }
        }
      } catch (exception) {
        //////// print('CharityListCubit mapEventToState exception: $exception');
        if (exception is HTTPException) {
          emit(CharityListError(errorCode: WEB_SERVICE_ENUM.UNEXCEPTED_ERROR, errorText: "error_went_wrong"));
        }
      }
    }else{

      //////// print("else if (event is FetchCharityList && !_hasReachedMax(currentState)) {");
    }
  }

  void _updatePageValue(int page) {
    if (page >= 1) pageValue = page + 1;
  }


  bool _hasReachedMax(CharityListState state) =>
      state is CharityListSuccess && state.hasReachedMax;


  changeCharity({required List<CharityModel> listValue, required bool boolValue, required CharityModel value, required int index}) async {
    List<CharityModel> returnValue = listValue;
    returnValue[index] = value;
    await Future.delayed(Duration(milliseconds: 10));

    // emit(CharityListLoading());
    emit(CharityListSuccess(
        dataList: returnValue,
        hasReachedMax: boolValue));
    emit(CharityUpdateListSuccess(
        dataList: returnValue,
        hasReachedMax: boolValue));
  }

  List<CharityModel> updateData(List<CharityModel> listValue, CharityModel value){
    listValue[listValue.indexWhere((element) => element.id == value.id)] = value;
    return listValue;
  }
}