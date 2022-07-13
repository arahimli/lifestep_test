import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


enum WEB_SERVICE_ENUM {SUCCESS, STANDARD_ERROR, UNEXCEPTED_ERROR, INTERNET_ERROR, UN_AUTH}
class WebService {

  static BaseOptions options = BaseOptions(
      receiveDataWhenStatusError: true,
      connectTimeout: 60*1000, // 60 seconds
      receiveTimeout: 60*1000 // 60 seconds
  );

  static Future deleteCall({required String url, required Map<String, dynamic> data, headers}) async {
    Dio dio = Dio(options);
    try {
      Response response;
      dio..options.headers.addAll(headers);
      response = await dio.delete(url,data: data);
      return [response.statusCode, response.data, WEB_SERVICE_ENUM.SUCCESS];
    } on DioError catch (e, stacktrace) {
      String error_text = 'error_went_wrong';
      int success = 0;
      WEB_SERVICE_ENUM errorEnum = WEB_SERVICE_ENUM.STANDARD_ERROR;
      try {
        if (e.error is SocketException) {
          error_text = "internet_connection_error";
          errorEnum = WEB_SERVICE_ENUM.INTERNET_ERROR;
        } else if (e.response == null) {
          return [0, "error_went_wrong", WEB_SERVICE_ENUM.UNEXCEPTED_ERROR];
        } else {
          success = e.response!.statusCode!;
          switch (e.response!.statusCode) {
            case 401:
              {
                error_text = 'error_went_wrong';
                errorEnum = WEB_SERVICE_ENUM.UN_AUTH;
              }
              break;
            case 500:
              {
                error_text = 'error_went_wrong';
              }
              break;
            default:
              {
                error_text = 'error_went_wrong';
              }
              break;
          }
        }
      }catch(e){
        error_text = "internet_connection_error";
        errorEnum = WEB_SERVICE_ENUM.INTERNET_ERROR;
      }
      return [success, error_text, errorEnum];
    } catch (e) {
      return [0, "error_went_wrong", WEB_SERVICE_ENUM.UNEXCEPTED_ERROR];
    }
  }


  static Future postCall({required String url, required Map<String, dynamic> data, headers}) async {
    Dio dio = Dio(options);
    try {
      Response response;
      dio..options.headers.addAll(headers);
      response = await dio.post(url,data: data);
   ////// print(response.data);
      return [response.statusCode, response.data, WEB_SERVICE_ENUM.SUCCESS];
    } on DioError catch (e, stacktrace) {
   ////// print(headers);
   ////// print(e.error);
   // print(e.response);
   ////// print(stacktrace);
      String error_text = 'error_went_wrong';
      int success = 0;
      WEB_SERVICE_ENUM errorEnum = WEB_SERVICE_ENUM.STANDARD_ERROR;
      try {
        if (e.error is SocketException) {
          error_text = "internet_connection_error";
          errorEnum = WEB_SERVICE_ENUM.INTERNET_ERROR;
        } else if (e.response == null) {
          return [0, "error_went_wrong", WEB_SERVICE_ENUM.UNEXCEPTED_ERROR];
        } else {
          success = e.response!.statusCode!;
          switch (e.response!.statusCode) {
            case 401:
              {
                error_text = 'error_went_wrong';
                errorEnum = WEB_SERVICE_ENUM.UN_AUTH;
              }
              break;
            case 500:
              {
                error_text = 'error_went_wrong';
              }
              break;
            default:
              {
                error_text = 'error_went_wrong';
              }
              break;
          }
        }
      }catch(e){
        error_text = "internet_connection_error";
        errorEnum = WEB_SERVICE_ENUM.INTERNET_ERROR;
      }
      return [success, error_text, errorEnum];
    } catch (e) {
      return [0, "error_went_wrong", WEB_SERVICE_ENUM.UNEXCEPTED_ERROR];
    }
  }

  static Future getCall({required String url, headers, CancelToken? token}) async {
    Dio dio = Dio(options);
    try {
      Response response;
      dio..options.headers.addAll(headers);
      response = await dio.get(url, cancelToken: token);
      return [response.statusCode, response.data, WEB_SERVICE_ENUM.SUCCESS];
    } on DioError catch (e, stacktrace) {
      // print("stacktracestacktracestacktrace");
      // print(url);
      // print(e.response?.statusCode);
      // print(headers);
      // print(TOKEN);
      // print(e.response?.data);
      // print(stacktrace);
      String error_text = 'error_went_wrong';
      int success = 0;
      WEB_SERVICE_ENUM errorEnum = WEB_SERVICE_ENUM.STANDARD_ERROR;
      try {
        if (e.error is SocketException) {
          error_text = "internet_connection_error";
          errorEnum = WEB_SERVICE_ENUM.INTERNET_ERROR;
        } else if (e.response == null) {
          return [0, "error_went_wrong", WEB_SERVICE_ENUM.UNEXCEPTED_ERROR];
        } else {
          success = e.response!.statusCode!;
          switch (e.response!.statusCode) {
            case 401:
              {
                error_text = 'error_went_wrong';
                errorEnum = WEB_SERVICE_ENUM.UN_AUTH;
              }
              break;
            case 500:
              {
                error_text = 'error_went_wrong';
              }
              break;
            default:
              {
                error_text = 'error_went_wrong';
              }
              break;
          }
        }
      }catch(e){
        error_text = "internet_connection_error";
        errorEnum = WEB_SERVICE_ENUM.INTERNET_ERROR;
      }
      return [success, error_text, errorEnum];
    } catch (e) {
      return [0, "error_went_wrong", WEB_SERVICE_ENUM.UNEXCEPTED_ERROR];
    }
  }


  static Future getCallHttp({required String url, headers}) async {
    try {
      var response;
      response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      // If the call to the server was successful, parse the JSON.

      return [response.statusCode, json.decode(response.body)];
    } catch (e) {
    }
  }

}