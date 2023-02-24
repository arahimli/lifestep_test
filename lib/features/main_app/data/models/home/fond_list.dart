import 'package:lifestep/features/main_app/data/models/donation/fonds.dart';

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
        data!.add(FondModel.fromJson(v));
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
