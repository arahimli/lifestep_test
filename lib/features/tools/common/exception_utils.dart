

import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:lifestep/features/main_app/resources/service/web_service.dart';

class ExceptionUtils{
  ExceptionUtils._();

  static DioErrorHandleModel dioErrorHandle(DioError e, StackTrace stacktrace){

    log("[LOG] DioErrorHandleModel : ${e.error.toString()}");
    log("[LOG] DioErrorHandleModel : ${e.response.toString()}");

    String errorText = 'error_went_wrong';
    int success = 0;
    WEB_SERVICE_ENUM errorEnum = WEB_SERVICE_ENUM.standardError;
    try {
      if (e.error is SocketException) {
        errorText = "internet_connection_error";
        errorEnum = WEB_SERVICE_ENUM.internetError;
      } else if (e.response == null) {
        errorEnum = WEB_SERVICE_ENUM.unexpectedError;
      } else {
        success = e.response!.statusCode!;
        switch (e.response!.statusCode) {
          case 401:
            {
              errorText = 'error_went_wrong';
              errorEnum = WEB_SERVICE_ENUM.unAuth;
            }
            break;
          case 410:
            {
              errorText = 'blocked_user';
              errorEnum = WEB_SERVICE_ENUM.block;
            }
            break;
          case 411:
            {
              errorText = 'deleted_user';
              errorEnum = WEB_SERVICE_ENUM.deleted;
            }
            break;
          case 500:
            {
              errorText = 'error_went_wrong';
            }
            break;
          default:
            {
              errorText = 'error_went_wrong';
            }
            break;
        }
      }
    }catch(e){
      errorText = "internet_connection_error";
      errorEnum = WEB_SERVICE_ENUM.internetError;
    }
    
    return DioErrorHandleModel(
      success: success,
      errorEnum: errorEnum,
      errorText: errorText,
    );
  }

}

class DioErrorHandleModel{

  final String errorText;
  final int success;
  final WEB_SERVICE_ENUM errorEnum;

  DioErrorHandleModel({this.errorText = 'error_went_wrong', this.success = 0, this.errorEnum = WEB_SERVICE_ENUM.standardError});

  errorToList(){
    return [success, errorText, errorEnum];
  }
  
}