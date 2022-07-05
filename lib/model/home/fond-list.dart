import 'package:lifestep/model/donation/fonds.dart';

class HomeFondListResponse {
  bool? status;
  List<FondModel>? data;
  String? message;

  HomeFondListResponse({this.status, this.data, this.message});

  HomeFondListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <FondModel>[];
      json['data'].forEach((v) {
        data!.add(new FondModel.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}
