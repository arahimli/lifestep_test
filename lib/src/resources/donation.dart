import 'package:dio/dio.dart';
import 'package:lifestep/src/tools/config/endpoint_config.dart';
import 'package:lifestep/src/tools/config/endpoints.dart';
import 'package:lifestep/src/tools/config/main_config.dart';
import 'package:lifestep/src/resources/service/web_service.dart';
import 'package:sprintf/sprintf.dart';

abstract class IDonationRepository {

  Future<List> getUserDonations({required String searchText, required int pageValue, required CancelToken token});
  Future<List> getCharities({required String searchText, required int pageValue, required CancelToken token});
  Future<List> getFonds({required String searchText, required int pageValue, required CancelToken token});
  Future<List> getCharityDonors({required String requestUrl, required CancelToken token});
  Future<List> donateStepCharity({required Map<String, dynamic> data, required CancelToken token});
  Future<List> donateStepFond({required Map<String, dynamic> data, required CancelToken token});
  Future<List> getFondDonors({required String requestUrl, required CancelToken token});
  Future<List> homeCharities();
}


class DonationRepository implements IDonationRepository{
  
  @override
  Future<List> getUserDonations({required String searchText, required int pageValue, required CancelToken token}) async {

    String requestUrl = sprintf(EndpointConfig.userDonations, [MainConfig.main_app_data_count * (pageValue - 1), MainConfig.main_app_data_count, searchText]);
    List listData = await WebService.getCall(url: requestUrl,);
    return listData ;
  }


  Future<List> getCharities({required String searchText, required int pageValue, required CancelToken token}) async {

    String requestUrl = sprintf(EndpointConfig.charities, [MainConfig.main_app_data_count * (pageValue - 1), MainConfig.main_app_data_count, searchText]);
    List listData = await WebService.getCall(url: requestUrl);
    return listData ;
  }

  Future<List> getFonds({required String searchText, required int pageValue, required CancelToken token}) async {

    String requestUrl = sprintf(EndpointConfig.funds, [MainConfig.main_app_data_count * (pageValue - 1), MainConfig.main_app_data_count, searchText]);
    List listData = await WebService.getCall(url: requestUrl);
    return listData ;
  }

  Future<List> getCharityDonors({required String requestUrl, required CancelToken token}) async {

    List listData = await WebService.getCall(url: requestUrl);
    return listData ;
  }

  Future<List> donateStepCharity({required Map<String, dynamic> data, required CancelToken token}) async {
    String requestUrl = EndpointConfig.charityDonation;
    List listData = await WebService.postCall(url: requestUrl, data: data);
    return listData ;
  }

  @override
  Future<List> donateStepFond({required Map<String, dynamic> data, required CancelToken token}) async {
    String requestUrl = EndpointConfig.fundDonation;
    List listData = await WebService.postCall(url: requestUrl, data: data);
    return listData ;
  }

  Future<List> getFondDonors({required String requestUrl, required CancelToken token}) async {

    List listData = await WebService.getCall(url: requestUrl);
    return listData ;
  }

  Future<List> homeCharities() async {
    String requestUrl = HOME_CHARITIES_URL;
    List listData = await WebService.getCall(url: requestUrl);
    return listData ;
  }

}
