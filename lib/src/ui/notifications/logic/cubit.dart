
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/src/tools/config/exception.dart';
import 'package:lifestep/src/tools/config/main_config.dart';
import 'package:lifestep/src/models/common/notifications.dart';
import 'package:lifestep/src/ui/notifications/logic/state.dart';
import 'package:lifestep/src/ui/user/repositories/auth.dart';
import 'package:lifestep/src/resources/service/web_service.dart';

class NotificationListCubit extends  Cubit<NotificationListState> {

  final UserRepository userRepository;
  NotificationListCubit({required this.userRepository}) : assert(userRepository != null), super(NotificationListLoading()){
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
      currentState = NotificationListLoading();
      emit(NotificationListLoading());
      dioToken.cancel();
      dioToken = CancelToken();
      pageValue = 1;
    }
    if (!_hasReachedMax(currentState)) {
      //////// print(currentState);
      try {
        if (currentState is NotificationListLoading) {
          emit(NotificationListFetching());
          searchText = searchValue != null ? searchValue : searchText;
          List listData = await userRepository.getNotifications(pageValue: pageValue, token: dioToken);
          if(listData[2] == WEB_SERVICE_ENUM.SUCCESS) {
            pageValue = 2;

            NotificationListResponse notificationListResponse = NotificationListResponse.fromJson(listData[1]);
            emit(NotificationListSuccess(
                dataList: notificationListResponse.data,
                hasReachedMax: notificationListResponse.data!.length <
                    MainConfig.main_app_data_count ? true : false));
            return;
          }else{
            emit(
                NotificationListError(
                    errorCode: listData[2],
                    errorText: listData[1]
                )
            );

          }
        }
        if (currentState is NotificationListSuccess) {
          if(!isLoading) {
            isLoading = true;
            List listData = await userRepository.getNotifications(pageValue: pageValue, token: dioToken);
            isLoading = false;
            if (listData[2] == WEB_SERVICE_ENUM.SUCCESS) {

              NotificationListResponse notificationListResponse = NotificationListResponse
                  .fromJson(listData[1]);
              emit(NotificationListSuccess(
                  dataList: List.from(currentState.dataList!)
                    ..addAll(notificationListResponse.data!),
                  hasReachedMax: notificationListResponse.data!.length <
                      MainConfig.main_app_data_count ? true : false));
              _updatePageValue(pageValue);
              return;
            }else if (listData[2] == WEB_SERVICE_ENUM.UN_AUTH){
              emit( NotificationListError(errorCode: listData[2], errorText: listData[1]));
            }
          }
        }
      } catch (exception) {
        if (exception is HTTPException) {
          emit(NotificationListError(errorCode: WEB_SERVICE_ENUM.UNEXCEPTED_ERROR, errorText: "error_went_wrong"));
        }
      }
    }else{

    }
  }

  void _updatePageValue(int page) {
    if (page >= 1) pageValue = page + 1;
  }


  bool _hasReachedMax(NotificationListState state) =>
      state is NotificationListSuccess && state.hasReachedMax;
}