import 'package:lifestep/src/tools/config/endpoints.dart';
import 'package:lifestep/src/resources/service/web_service.dart';

class HomeRepository {
  final homeProvider = HomeProvider();

  Future<List> getSlider() => homeProvider.getSlider();
  Future<List> homeFonds() => homeProvider.homeFonds();
  Future<List> homeChallenges() => homeProvider.homeChallenges();

}



class HomeProvider {

  Future<List> getSlider() async {
    String requestUrl = GET_SLIDER_URL;
    List data = await WebService.getCall(url: requestUrl);
    return data;
  }

  Future<List> homeCharities() async {
    String requestUrl = HOME_CHARITIES_URL;
    List data = await WebService.getCall(url: requestUrl);
    return data;
  }

  Future<List> homeFonds() async {
    String requestUrl = HOME_FOND_URL;
    List data = await WebService.getCall(url: requestUrl);
    return data;
  }
  Future<List> homeChallenges() async {
    String requestUrl = HOME_CHALLENGES_URL;
    List data = await WebService.getCall(url: requestUrl);
    return data;
  }
}


