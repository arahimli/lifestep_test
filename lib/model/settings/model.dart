class SettingsResponse {
  bool? status;
  SettingsModel? data;
  String? message;

  SettingsResponse({this.status, this.data, this.message});

  SettingsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new SettingsModel.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class SettingsModel {
  double step = 0;
  int maintenance = 0;

  SettingsModel({required this.step});

  SettingsModel.fromJson(Map<String, dynamic> json) {
    step = json['step'] != null ? double.parse(json['step'].toString()) : 0;
    maintenance = json['maintenance'] != null ? json['maintenance'] : 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['step'] = this.step;
    data['maintenance'] = this.maintenance;
    return data;
  }
}
