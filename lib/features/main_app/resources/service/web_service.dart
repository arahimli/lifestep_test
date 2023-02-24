import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:lifestep/features/tools/common/exception_utils.dart';
import 'dart:convert';

import 'package:lifestep/features/tools/common/input_data.dart';
import 'package:lifestep/features/tools/config/endpoint_config.dart';


enum WEB_SERVICE_ENUM {success, standardError, unexpectedError, internetError, unAuth, block, deleted}
class WebService {

  static BaseOptions options = BaseOptions(
      baseUrl: EndpointConfig.apiUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: 60*1000, // 60 seconds
      receiveTimeout: 60*1000 // 60 seconds
  );
  static Dio dio = Dio(options);

  static Future deleteCall({required String url, required Map<String, dynamic> data, headers}) async {

    try {
      Response response;
      dio.options.headers.addAll(headers ?? DataUtils.getHeader());
      response = await dio.delete(url,data: data);
      return [response.statusCode, response.data, WEB_SERVICE_ENUM.success];
    } on DioError catch (e, stacktrace) {
      return ExceptionUtils.dioErrorHandle(e, stacktrace).errorToList();
    } catch (e) {
      return [0, "error_went_wrong", WEB_SERVICE_ENUM.unexpectedError];
    }
  }

  static Future postCall({required String url, required Map<String, dynamic> data, headers}) async {
    // Dio dio = Dio(options);
    try {
      Response response;
      dio.options.headers.addAll(headers ?? DataUtils.getHeader());
      response = await dio.post(url,data: data);
      return [response.statusCode, response.data, WEB_SERVICE_ENUM.success];
    } on DioError catch (e, stacktrace) {
       return ExceptionUtils.dioErrorHandle(e, stacktrace).errorToList();
    } catch (e) {
      return [0, "error_went_wrong", WEB_SERVICE_ENUM.unexpectedError];
    }
  }

  static Future getCall({required String url, headers, CancelToken? token}) async {
    // Dio dio = Dio(options);
    try {
      Response response;
      dio.options.headers.addAll(headers ?? DataUtils.getHeader());
      response = await dio.get(url, cancelToken: token);
      return [response.statusCode, response.data, WEB_SERVICE_ENUM.success];
    } on DioError catch (e, stacktrace) {
      return ExceptionUtils.dioErrorHandle(e, stacktrace).errorToList();
    } catch (e) {
      return [0, "error_went_wrong", WEB_SERVICE_ENUM.unexpectedError];
    }
  }

  static Future getCallHttp({required String url, headers}) async {
    try {
      var response = await http.get(
        Uri.parse(url),
        headers: headers ?? DataUtils.getHeader(),
      );

      // If the call to the server was successful, parse the JSON.

      return [response.statusCode, json.decode(response.body)];
    } catch (_) {
    }
  }

}