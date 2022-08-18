import 'package:dio/dio.dart';
import 'package:lifestep/src/tools/config/endpoint_config.dart';
import 'package:lifestep/src/tools/config/endpoints.dart';
import 'package:lifestep/src/tools/config/main_config.dart';
import 'package:lifestep/src/resources/service/web_service.dart';
import 'package:sprintf/sprintf.dart';

class DonationRepository {

  final donationProvider = DonationProvider();

  // Future<List> getCharities() => donationProvider.getCharities();

  Future<List> getUserDonations({required String searchText, required int pageValue, required CancelToken token}) => donationProvider.getUserDonations(searchText, pageValue, token);
  Future<List> getCharities({required String searchText, required int pageValue, required CancelToken token}) => donationProvider.getCharities(searchText, pageValue, token);
  Future<List> getFonds({required String searchText, required int pageValue, required CancelToken token}) => donationProvider.getFonds(searchText, pageValue, token);
  Future<List> getCharityDonors({required String requestUrl, required CancelToken token}) => donationProvider.getCharityDonors(requestUrl, token);
  Future<List> donateStepCharity({required Map<String, dynamic> data, required CancelToken token}) => donationProvider.donateStepCharity(data, token);
  Future<List> donateStepFond({required Map<String, dynamic> data, required CancelToken token}) => donationProvider.donateStepFond(data, token);
  Future<List> getFondDonors({required String requestUrl, required CancelToken token}) => donationProvider.getFondDonors(requestUrl, token);
  Future<List> homeCharities() => donationProvider.homeCharities();
}


class DonationProvider {


  Future<List> getUserDonations(String searchText, int pageValue, CancelToken token) async {

    String requestUrl = sprintf(EndpointConfig.userDonations, [MainConfig.main_app_data_count * (pageValue - 1), MainConfig.main_app_data_count, searchText]);
    List data = await WebService.getCall(url: requestUrl,);
    return data;
  }


  Future<List> getCharities(String searchText, int pageValue, CancelToken token) async {

    String requestUrl = sprintf(EndpointConfig.charities, [MainConfig.main_app_data_count * (pageValue - 1), MainConfig.main_app_data_count, searchText]);
    List data = await WebService.getCall(url: requestUrl);
    return data;
  }

  Future<List> getFonds(String searchText, int pageValue, CancelToken token) async {

    String requestUrl = sprintf(EndpointConfig.funds, [MainConfig.main_app_data_count * (pageValue - 1), MainConfig.main_app_data_count, searchText]);
    List data = await WebService.getCall(url: requestUrl);
    return data;
  }

  Future<List> getCharityDonors(String requestUrl, CancelToken token) async {

    List data = await WebService.getCall(url: requestUrl);
    return data;
  }

  Future<List> donateStepCharity(Map<String, dynamic> dataMap, CancelToken token) async {
    String requestUrl = EndpointConfig.charityDonation;
    List data = await WebService.postCall(url: requestUrl, data: dataMap);
    return data;
  }


  Future<List> donateStepFond(Map<String, dynamic> dataMap, CancelToken token) async {
    String requestUrl = EndpointConfig.fundDonation;
    List data = await WebService.postCall(url: requestUrl, data: dataMap);
    return data;
  }

  Future<List> getFondDonors(String requestUrl, CancelToken token) async {

    List data = await WebService.getCall(url: requestUrl);
    return data;
  }

  Future<List> homeCharities() async {
    String requestUrl = HOME_CHARITIES_URL;
    List data = await WebService.getCall(url: requestUrl);
    return data;
  }

}
