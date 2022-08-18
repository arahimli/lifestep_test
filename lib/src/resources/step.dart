import 'package:dio/dio.dart';
import 'package:lifestep/src/tools/config/endpoint_config.dart';
import 'package:lifestep/src/resources/service/web_service.dart';
import 'package:sprintf/sprintf.dart';

class StepRepository {

  final donationProvider = StepProvider();

  Future<List> getStepStatistic({required String ratingType, required int listCount, required CancelToken token}) => donationProvider.getStepStatistic(ratingType, listCount, token);
  Future<List> getStepStatisticByDate({required String ratingType, required int listCount, required int dateType, required CancelToken token}) => donationProvider.getStepStatisticByDate(ratingType, listCount, dateType, token);
  Future<List> getUserOrderRatingStepStatistic({required String raitingType, required String rangeType, required CancelToken token}) => donationProvider.getUserOrderRatingStepStatistic(raitingType, rangeType, token);

}


class StepProvider {

  Future<List> getStepStatistic(String ratingType, int listCount, CancelToken token) async {

    String requestUrl = sprintf(EndpointConfig.getStepStatistic, [ ratingType, listCount.toString()]);
    List data = await WebService.getCall(url: requestUrl);
    return data;
  }

  Future<List> getStepStatisticByDate(String ratingType, int listCount, int dateType, CancelToken token) async {

    String requestUrl = sprintf(EndpointConfig.getStepStatisticDate, [ ratingType, dateType.toString(), listCount.toString(), ]);
   ///////// print(requestUrl);
    List data = await WebService.getCall(url: requestUrl);
    return data;
  }

  Future<List> getUserOrderRatingStepStatistic(String raitingType, String rangeType, CancelToken token) async {

    String requestUrl = sprintf(EndpointConfig.getStepUserRatingOrder, [ raitingType, rangeType ]);
    List data = await WebService.getCall(url: requestUrl);
    return data;
  }

}
