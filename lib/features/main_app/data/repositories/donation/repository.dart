
import 'package:dio/dio.dart';
import 'package:lifestep/features/main_app/domain/repositories/donation/repository.dart';
import 'package:lifestep/features/main_app/resources/service/web_service.dart';
import 'package:lifestep/features/tools/config/endpoint_config.dart';
import 'package:lifestep/features/tools/config/main_config.dart';
import 'package:sprintf/sprintf.dart';

class DonationRepository implements IDonationRepository{

  @override
  Future<List> getUserDonations({required String searchText, required int pageValue, required CancelToken token}) async {

    String requestUrl = sprintf(EndpointConfig.userDonations, [MainConfig.mainAppDataCount * (pageValue - 1), MainConfig.mainAppDataCount, searchText]);
    List listData = await WebService.getCall(url: requestUrl,);
    return listData ;
  }

  @override
  Future<List> getCharities({required String searchText, required int pageValue, required CancelToken token}) async {

    String requestUrl = sprintf(EndpointConfig.charities, [MainConfig.mainAppDataCount * (pageValue - 1), MainConfig.mainAppDataCount, searchText]);
    List listData = await WebService.getCall(url: requestUrl);
    return listData ;
  }

  @override
  Future<List> getFonds({required String searchText, required int pageValue, required CancelToken token}) async {

    String requestUrl = sprintf(EndpointConfig.funds, [MainConfig.mainAppDataCount * (pageValue - 1), MainConfig.mainAppDataCount, searchText]);
    List listData = await WebService.getCall(url: requestUrl);
    return listData ;
  }
  @override
  Future<List> getCharityDonors({required String requestUrl, required CancelToken token}) async {

    List listData = await WebService.getCall(url: requestUrl);
    return listData ;
  }

  @override
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

  @override
  Future<List> getFondDonors({required String requestUrl, required CancelToken token}) async {

    List listData = await WebService.getCall(url: requestUrl);
    return listData ;
  }

  @override
  Future<List> homeCharities() async {
    String requestUrl = EndpointConfig.homeCharities;
    List listData = await WebService.getCall(url: requestUrl);
    return listData ;
  }

}
