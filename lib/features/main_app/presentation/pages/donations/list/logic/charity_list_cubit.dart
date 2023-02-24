
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/features/main_app/domain/repositories/donation/repository.dart';
import 'package:lifestep/features/tools/config/exception.dart';
import 'package:lifestep/features/tools/config/main_config.dart';
import 'package:lifestep/features/main_app/data/models/donation/charities.dart';
import 'package:lifestep/features/main_app/presentation/pages/donations/list/logic/charity_state.dart';
import 'package:lifestep/features/main_app/resources/service/web_service.dart';

class CharityListCubit extends  Cubit<CharityListState> {

  final IDonationRepository donationRepository;
  CharityListCubit({required this.donationRepository}) : super(CharityListLoading()){
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

  search(String? searchValue, {bool reset = false}) async {
    var currentState = state;
    if(reset){
      currentState = CharityListLoading();
      emit(CharityListLoading());
      dioToken.cancel();
      dioToken = CancelToken();
      pageValue = 1;
    }
    // await Future.delayed( const Duration(seconds: 3));
    if (!_hasReachedMax(currentState)) {
      try {
        if (currentState is CharityListLoading) {
          emit(CharityListFetching());
          searchText = searchValue ?? searchText;
          List listData = await donationRepository.getCharities(searchText: searchText, pageValue: pageValue, token: dioToken);
          if(listData[2] == WEB_SERVICE_ENUM.success) {
            pageValue = 2;

            CharityListResponse charityListResponse = CharityListResponse.fromJson(listData[1]);
            emit(CharityListSuccess(
                dataList: charityListResponse.data,
                hasReachedMax: charityListResponse.data!.length <
                    MainConfig.mainAppDataCount ? true : false));
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
            if (listData[2] == WEB_SERVICE_ENUM.success) {
              CharityListResponse charityListResponse = CharityListResponse
                  .fromJson(listData[1]);
              emit(CharityListSuccess(
                  dataList: List.from(currentState.dataList!)
                    ..addAll(charityListResponse.data!),
                  hasReachedMax: charityListResponse.data!.length <
                      MainConfig.mainAppDataCount ? true : false));
              _updatePageValue(pageValue);
              return;
            }else if (listData[2] == WEB_SERVICE_ENUM.unAuth){
              emit( CharityListError(errorCode: listData[2], errorText: listData[1]));
            }
          }
        }
      } catch (exception) {
        if (exception is HTTPException) {
          emit(const CharityListError(errorCode: WEB_SERVICE_ENUM.unexpectedError, errorText: "error_went_wrong"));
        }
      }
    }else{

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
    await Future.delayed( const Duration(milliseconds: 10));

    // emit(CharityListLoading());
    emit(CharityListSuccess(
        dataList: returnValue,
        hasReachedMax: boolValue));
    emit(CharityUpdateListSuccess(
        dataList: returnValue,
        hasReachedMax: boolValue));
  }

  // List<CharityModel> updateData(List<CharityModel> listValue, CharityModel value){
  //   listValue[listValue.indexWhere((element) => element.id == value.id)] = value;
  //   return listValue;
  // }
}