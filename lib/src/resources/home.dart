import 'package:lifestep/src/tools/config/endpoints.dart';
import 'package:lifestep/src/resources/service/web_service.dart';


abstract class IHomeRepository {

  Future<List> getSlider();
  Future<List> homeFonds();
  Future<List> homeChallenges();

}



class HomeRepository implements IHomeRepository{

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


