class VersionCheckResponse {
  int? status;
  VersionCheckModel? data;
  String? message;

  VersionCheckResponse({this.status, this.data, this.message});

  VersionCheckResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    try {
      data = json['data'] != null ? VersionCheckModel.fromJson(json['data']) : null;
    }catch(_){

    }
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

class VersionCheckModel {
  int? id;
  int? deviceOs;
  int? appVersion;
  int? isRequired;
  String? createdAt;
  String? updatedAt;

  VersionCheckModel(
      {this.id,
        this.deviceOs,
        this.appVersion,
        this.isRequired,
        this.createdAt,
        this.updatedAt});

  VersionCheckModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    deviceOs = json['device_os'];
    appVersion = json['app_version'];
    isRequired = json['is_required'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    data['id'] = id;
    data['device_os'] = deviceOs;
    data['app_version'] = appVersion;
    data['is_required'] = isRequired;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
