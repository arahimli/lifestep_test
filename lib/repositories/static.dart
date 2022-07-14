import 'dart:convert';
import 'dart:io';

import 'package:lifestep/config/endpoints.dart';
import 'package:lifestep/config/main_config.dart';
import 'package:lifestep/repositories/service/web_service.dart';
import 'package:lifestep/tools/constants/header/auth.dart';
import 'package:sprintf/sprintf.dart';
import 'package:http/http.dart' as http;

class StaticRepository {
  final staticProvider = StaticProvider();



  Future<List> getTermsPrivacy() => staticProvider.getTermsPrivacy();
  Future<List> getSettings() => staticProvider.getSettings();
  Future<List> checkUpdate() => staticProvider.checkUpdate();
  Future<Album> fetchAlbum(http.Client client) => staticProvider.fetchAlbum(client);

}



class StaticProvider {

  Future<List> getTermsPrivacy() async {
    String requestUrl = TERMS_PRIVACY_URL;
    List data = await WebService.getCall(url: requestUrl);
    return data;
  }
  Future<List> getSettings() async {
    String requestUrl = SETTINGS_URL;
    List data = await WebService.getCall(url: requestUrl);
    return data;
  }

  Future<List> checkUpdate() async {
    String requestUrl = sprintf(APP_VERSION_CHECK_URL, [Platform.isAndroid ? 2 : 1, Platform.isAndroid ? MainConfig.app_version_android : MainConfig.app_version_ios]);
 ////// print(requestUrl);
    List data = await WebService.getCall(url: requestUrl);
    return data;
  }

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


