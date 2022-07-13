import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lifestep/config/endpoints.dart';
import 'package:lifestep/config/main_config.dart';
import 'package:lifestep/model/challenge/map.dart';
import 'package:lifestep/model/donation/search_configuration.dart';
import 'package:lifestep/repositories/service/web_service.dart';
import 'package:lifestep/tools/constants/header/auth.dart';
import 'package:sprintf/sprintf.dart';

class StepRepository {

  final donationProvider = StepProvider();

  Future<List> getStepStatistic({required String ratingType, required int listCount, required CancelToken token}) => donationProvider.getStepStatistic(ratingType, listCount, token);
  Future<List> getStepStatisticByDate({required String ratingType, required int listCount, required int dateType, required CancelToken token}) => donationProvider.getStepStatisticByDate(ratingType, listCount, dateType, token);
  Future<List> getUserOrderRatingStepStatistic({required String raitingType, required String rangeType, required CancelToken token}) => donationProvider.getUserOrderRatingStepStatistic(raitingType, rangeType, token);

}


class StepProvider {

  Future<List> getStepStatistic(String ratingType, int listCount, CancelToken token) async {

    String requestUrl = sprintf(GET_STEP_STATISTIC_URL, [ ratingType, listCount.toString()]);
    List data = await WebService.getCall(url: requestUrl, headers: {
  'Authorization': "Bearer $TOKEN",
  'Accept-Language': LANGUAGE,
  'Accept': 'application/json'
});
    return data;
  }

  Future<List> getStepStatisticByDate(String ratingType, int listCount, int dateType, CancelToken token) async {

    String requestUrl = sprintf(GET_STEP_STATISTIC_DATE_URL, [ ratingType, dateType.toString(), listCount.toString(), ]);
   ///////// print(requestUrl);
    List data = await WebService.getCall(url: requestUrl, headers: {
  'Authorization': "Bearer $TOKEN",
  'Accept-Language': LANGUAGE,
  'Accept': 'application/json'
});
    return data;
  }

  Future<List> getUserOrderRatingStepStatistic(String raitingType, String rangeType, CancelToken token) async {

    String requestUrl = sprintf(GET_STEP_USER_RATING_ORDER_URL, [ raitingType, rangeType ]);
    List data = await WebService.getCall(url: requestUrl, headers: {
  'Authorization': "Bearer $TOKEN",
  'Accept-Language': LANGUAGE,
  'Accept': 'application/json'
});
    return data;
  }

}
