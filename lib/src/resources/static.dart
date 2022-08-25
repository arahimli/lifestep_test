import 'dart:convert';
import 'dart:io';

import 'package:lifestep/src/tools/config/endpoint_config.dart';
import 'package:lifestep/src/tools/config/main_config.dart';
import 'package:lifestep/src/resources/service/web_service.dart';
import 'package:sprintf/sprintf.dart';
import 'package:http/http.dart' as http;

abstract class IStaticRepository {

  Future<List> getTermsPrivacy();
  Future<List> getSettings();
  Future<List> checkUpdate();
  Future<Album> fetchAlbum(http.Client client);

}



class StaticRepository implements IStaticRepository{
  @override
  Future<List> getTermsPrivacy() async {
    String requestUrl = EndpointConfig.termsPrivacy;
    List data = await WebService.getCall(url: requestUrl);
    return data;
  }
  @override
  Future<List> getSettings() async {
    String requestUrl = EndpointConfig.settings;
    List data = await WebService.getCall(url: requestUrl);
    return data;
  }
  @override
  Future<List> checkUpdate() async {
    String requestUrl = sprintf(EndpointConfig.appVersionCheck, [Platform.isAndroid ? 2 : 1, Platform.isAndroid ? MainConfig.app_version_android : MainConfig.app_version_ios]);
    ////// print(requestUrl);
    List data = await WebService.getCall(url: requestUrl);
    return data;
  }
  @override
  Future<Album> fetchAlbum(http.Client client) async {
    final response = await client
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Album.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}

class Album {
  static Album fromJson(Map<String, dynamic>  map){
    return Album();
  }

}


