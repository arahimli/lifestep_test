import 'package:lifestep/config/endpoints.dart';
import 'package:lifestep/repositories/service/web_service.dart';
import 'package:lifestep/tools/constants/header/auth.dart';

class HomeRepository {
  final homeProvider = HomeProvider();

  Future<List> getSlider() => homeProvider.getSlider();
  Future<List> homeFonds() => homeProvider.homeFonds();
  Future<List> homeChallenges() => homeProvider.homeChallenges();

}



class HomeProvider {

  Future<List> getSlider() async {
    String requestUrl = GET_SLIDER_URL;
    List data = await WebService.getCall(url: requestUrl, headers: {
  'Authorization': "Bearer $TOKEN",
  'Accept-Language': LANGUAGE,
  'Accept': 'application/json'
});
    return data;
  }

  Future<List> homeCharities() async {
    String requestUrl = HOME_CHARITIES_URL;
    List data = await WebService.getCall(url: requestUrl, headers: {
  'Authorization': "Bearer $TOKEN",
  'Accept-Language': LANGUAGE,
  'Accept': 'application/json'
});
    return data;
  }

  Future<List> homeFonds() async {
    String requestUrl = HOME_FOND_URL;
    List data = await WebService.getCall(url: requestUrl, headers: {
  'Authorization': "Bearer $TOKEN",
  'Accept-Language': LANGUAGE,
  'Accept': 'application/json'
});
    return data;
  }
  Future<List> homeChallenges() async {
    String requestUrl = HOME_CHALLENGES_URL;
    List data = await WebService.getCall(url: requestUrl, headers: {
  'Authorization': "Bearer $TOKEN",
  'Accept-Language': LANGUAGE,
  'Accept': 'application/json'
});
    return data;
  }
}


