import 'package:lifestep/config/endpoints.dart';
import 'package:sprintf/sprintf.dart';


enum SLIDER_LINK_TYPE {LINK, STATIC, MODULE, NULL}

class BannerResponse {
  bool? status;
  BannerResponseData? data;
  String? message;

  BannerResponse({this.status, this.data, this.message});

  BannerResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new BannerResponseData.fromJson(json['data']) : null;
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

class BannerResponseData {
  List<BannerModel>? topBanners;
  List<BannerModel>? bottomBanners;

  BannerResponseData({this.topBanners, this.bottomBanners});

  BannerResponseData.fromJson(Map<String, dynamic> json) {
    if (json['top_banners'] != null) {
      topBanners = <BannerModel>[];
      json['top_banners'].forEach((v) {
        topBanners!.add(new BannerModel.fromJson(v));
      });
    }
    if (json['bottom_banners'] != null) {
      bottomBanners = <BannerModel>[];
      json['bottom_banners'].forEach((v) {
        bottomBanners!.add(new BannerModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.topBanners != null) {
      data['top_banners'] = this.topBanners!.map((v) => v.toJson()).toList();
    }
    if (this.bottomBanners != null) {
      data['bottom_banners'] =
          this.bottomBanners!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BannerModel {
  int? id;
  String? image;
  int? order;
  int? type;
  String? header;
  String? text;
  String? typeValue;
  String? value;
  SLIDER_LINK_TYPE linkType = SLIDER_LINK_TYPE.NULL;


  BannerModel(
      {this.id, this.image, this.order, this.type, this.header, this.text, this.typeValue, this.value,});

  BannerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'] != null ? sprintf( IMAGE_URL , [json['image']]) : null;
    order = json['order'];
    type = json['type'];
    header = json['header'];
    text = json['text'];
    value = json['value'];
    typeValue = json['type_value'];
    switch(json['type_value'].toString()) {
      case 'module': {
        linkType = SLIDER_LINK_TYPE.MODULE;
      }
      break;

      case 'text': {
        linkType = SLIDER_LINK_TYPE.STATIC;
      }
      break;

      case 'link': {
        linkType = SLIDER_LINK_TYPE.LINK;
      }
      break;

      default: {
        linkType = SLIDER_LINK_TYPE.NULL;
      }
      break;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['order'] = this.order;
    data['type'] = this.type;
    data['header'] = this.header;
    data['text'] = this.text;
    data['type_value'] = this.typeValue;
    data['value'] = this.value;
    return data;
  }
}
