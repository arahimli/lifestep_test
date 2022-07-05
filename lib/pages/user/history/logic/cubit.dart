
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/config/exception.dart';
import 'package:lifestep/config/main_config.dart';
import 'package:lifestep/model/donation/donation-history.dart';
import 'package:lifestep/pages/user/history/logic/state.dart';
import 'package:lifestep/repositories/donation.dart';
import 'package:lifestep/repositories/service/web_service.dart';

class DonationHistoryListBloc extends  Cubit<DonationHistoryListState> {

  final DonationRepository donationRepository;
  DonationHistoryListBloc({required this.donationRepository}) : assert(donationRepository != null), super(DonationHistoryListLoading()){
    this.search('');
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

  search(String? searchValue, {bool reset:false}) async {
    var currentState = state;
    if(reset){
      currentState = DonationHistoryListLoading();
      emit(DonationHistoryListLoading());
      dioToken.cancel();
      dioToken = CancelToken();
      pageValue = 1;
    }
    // await Future.delayed(Duration(seconds: 20));
    if (!_hasReachedMax(currentState)) {
      //////// print(currentState);
      try {
        if (currentState is DonationHistoryListLoading) {
          emit(DonationHistoryListFetching());
          // emit(DonationHistoryListLoading());
          searchText = searchValue != null ? searchValue : searchText;
          List listData = await donationRepository.getUserDonations(searchText: searchText, pageValue: pageValue, token: dioToken);
          // print("listData__listData__listData__listData__listData__listData__DonationHistoryListLoading");
          //////// print(listData);
          if(listData[2] == WEB_SERVICE_ENUM.SUCCESS) {
            pageValue = 2;

            DonationHistoryListResponse donationHistoryListResponse = DonationHistoryListResponse.fromJson(listData[1]);
            emit(DonationHistoryListSuccess(
                dataList: donationHistoryListResponse.data,
                hasReachedMax: donationHistoryListResponse.data!.length <
                    MainConfig.main_app_data_count ? true : false));
            return;
          }else{
            emit(
                DonationHistoryListError(
                    errorCode: listData[2],
                    errorText: listData[1]
                )
            );

          }
        }
        if (currentState is DonationHistoryListSuccess) {
          // print("listData__listData__listData__listData__listData__listData__DonationHistoryListSuccess");
          // print(!isLoading);
          if(!isLoading) {
            isLoading = true;
            List listData = await donationRepository.getUserDonations(
                searchText: searchText, pageValue: pageValue, token: dioToken);
            isLoading = false;
            // print(!isLoading);
            // print(listData[2]);
            if (listData[2] == WEB_SERVICE_ENUM.SUCCESS) {

              DonationHistoryListResponse donationHistoryListResponse = DonationHistoryListResponse
                  .fromJson(listData[1]);
              emit(DonationHistoryListSuccess(
                  dataList: List.from(currentState.dataList!)
                    ..addAll(donationHistoryListResponse.data!),
                  hasReachedMax: donationHistoryListResponse.data!.length <
                      MainConfig.main_app_data_count ? true : false));
              _updatePageValue(pageValue);
              return;
            }else if (listData[2] == WEB_SERVICE_ENUM.UN_AUTH){
              emit( DonationHistoryListError(errorCode: listData[2], errorText: listData[1]));
            }
          }
        }
      } catch (exception) {
        if (exception is HTTPException) {
          emit(DonationHistoryListError(errorCode: WEB_SERVICE_ENUM.UNEXCEPTED_ERROR, errorText: "error_went_wrong"));
        }
      }
    }else{

    }
  }

  void _updatePageValue(int page) {
    if (page >= 1) pageValue = page + 1;
  }


  bool _hasReachedMax(DonationHistoryListState state) =>
      state is DonationHistoryListSuccess && state.hasReachedMax;
}