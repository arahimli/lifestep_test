import 'package:lifestep/features/tools/config/endpoint_config.dart';
import 'package:sprintf/sprintf.dart';

class FondListResponse {
  bool? status;
  List<FondModel>? data;
  String? message;

  FondListResponse({this.status, this.data, this.message});

  FondListResponse.fromJson(Map<String, dynamic> json) {
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

class FondModel {
  int? id;
  String? name;
  String? description;
  String? image;
  int? totalSteps;
  double? amount;
  int? status;

  FondModel(
      {this.id,
        this.name,
        this.description,
        this.image,
        this.totalSteps,
        this.amount,
        this.status});

  FondModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = json['image'] != null ? sprintf( EndpointConfig.imageUrl , [json['image']]) : null;
    totalSteps = json['total_steps'];
    amount = json['amount'] != null ? double.parse(json['amount'].toString()) : 0;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['image'] = image;
    data['total_steps'] = totalSteps;
    data['amount'] = amount;
    data['status'] = status;
    return data;
  }
}
