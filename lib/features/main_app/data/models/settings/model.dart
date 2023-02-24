import 'package:lifestep/features/tools/common/utlis.dart';

class SettingsResponse {
  bool? status;
  SettingsModel? data;
  String? message;

  SettingsResponse({this.status, this.data, this.message});

  SettingsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? SettingsModel.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class SettingsModel {
  double step = 0;
  int balanceLimit = 0;
  int maintenance = 0;

  SettingsModel({required this.step, required this.balanceLimit, required this.maintenance});

  SettingsModel.fromJson(Map<String, dynamic> json) {
    step = json['step'] != null ? double.parse(json['step'].toString()) : 0;
    maintenance = Utils.checkNullToZero(json['maintenance']);
    balanceLimit = Utils.checkNullToZero(json['balance_limit']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    data['step'] = step;
    data['maintenance'] = maintenance;
    data['balance_limit'] = balanceLimit;
    return data;
  }
}
