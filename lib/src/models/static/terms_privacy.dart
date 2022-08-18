class TermsPrivacyResponse {
  bool? status;
  TermsPrivacyModel? data;
  String? message;

  TermsPrivacyResponse({this.status, this.data, this.message});

  TermsPrivacyResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? TermsPrivacyModel.fromJson(json['data']) : null;
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

class TermsPrivacyModel {
  String? privacy;
  String? terms;
  String? about;

  TermsPrivacyModel({this.privacy, this.terms});

  TermsPrivacyModel.fromJson(Map<String, dynamic> json) {
    privacy = json['privacy'];
    terms = json['terms'];
    about = json['about'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    data['privacy'] = privacy;
    data['terms'] = terms;
    data['about'] = about;
    return data;
  }
}
