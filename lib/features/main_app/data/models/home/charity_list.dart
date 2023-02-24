import 'package:lifestep/features/main_app/data/models/donation/charities.dart';

class HomeCharityListResponse {
  bool? status;
  List<CharityModel>? data;
  String? message;

  HomeCharityListResponse({this.status, this.data, this.message});

  HomeCharityListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <CharityModel>[];
      json['data'].forEach((v) {
        data!.add(CharityModel.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}
