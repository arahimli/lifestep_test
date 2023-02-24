import 'package:dio/dio.dart';

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
