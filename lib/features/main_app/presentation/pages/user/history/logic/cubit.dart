
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/features/main_app/domain/repositories/donation/repository.dart';
import 'package:lifestep/features/tools/config/exception.dart';
import 'package:lifestep/features/tools/config/main_config.dart';
import 'package:lifestep/features/main_app/data/models/donation/donation_history.dart';
import 'package:lifestep/features/main_app/presentation/pages/user/history/logic/state.dart';
import 'package:lifestep/features/main_app/resources/service/web_service.dart';

class DonationHistoryListBloc extends  Cubit<DonationHistoryListState> {

  final IDonationRepository donationRepository;
  DonationHistoryListBloc({required this.donationRepository}) : super(DonationHistoryListLoading()){
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
      currentState = DonationHistoryListLoading();
      emit(DonationHistoryListLoading());
      dioToken.cancel();
      dioToken = CancelToken();
      pageValue = 1;
    }
    // await Future.delayed( const Duration(seconds: 20));
    if (!_hasReachedMax(currentState)) {
      try {
        if (currentState is DonationHistoryListLoading) {
          emit(DonationHistoryListFetching());
          // emit(DonationHistoryListLoading());
          searchText = searchValue ?? searchText;
          List listData = await donationRepository.getUserDonations(searchText: searchText, pageValue: pageValue, token: dioToken);
          if(listData[2] == WEB_SERVICE_ENUM.success) {
            pageValue = 2;

            DonationHistoryListResponse donationHistoryListResponse = DonationHistoryListResponse.fromJson(listData[1]);
            emit(DonationHistoryListSuccess(
                dataList: donationHistoryListResponse.data,
                hasReachedMax: donationHistoryListResponse.data!.length <
                    MainConfig.mainAppDataCount ? true : false));
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
          if(!isLoading) {
            isLoading = true;
            List listData = await donationRepository.getUserDonations(
                searchText: searchText, pageValue: pageValue, token: dioToken);
            isLoading = false;
            if (listData[2] == WEB_SERVICE_ENUM.success) {

              DonationHistoryListResponse donationHistoryListResponse = DonationHistoryListResponse
                  .fromJson(listData[1]);
              emit(DonationHistoryListSuccess(
                  dataList: List.from(currentState.dataList!)
                    ..addAll(donationHistoryListResponse.data!),
                  hasReachedMax: donationHistoryListResponse.data!.length <
                      MainConfig.mainAppDataCount ? true : false));
              _updatePageValue(pageValue);
              return;
            }else if (listData[2] == WEB_SERVICE_ENUM.unAuth){
              emit( DonationHistoryListError(errorCode: listData[2], errorText: listData[1]));
            }
          }
        }
      } catch (exception) {
        if (exception is HTTPException) {
          emit(const DonationHistoryListError(errorCode: WEB_SERVICE_ENUM.unexpectedError, errorText: "error_went_wrong"));
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