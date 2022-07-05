class VersionCheckResponse {
  int? status;
  VersionCheckModel? data;
  String? message;

  VersionCheckResponse({this.status, this.data, this.message});

  VersionCheckResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    try {
      data = json['data'] != null ? VersionCheckModel.fromJson(json['data']) : null;
    }catch(e){

    }
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['device_os'] = this.deviceOs;
    data['app_version'] = this.appVersion;
    data['is_required'] = this.isRequired;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
