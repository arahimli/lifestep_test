import 'package:lifestep/features/tools/config/endpoint_config.dart';
import 'package:sprintf/sprintf.dart';


enum SLIDER_LINK_TYPE {link, static, module, none}

class BannerResponse {
  bool? status;
  BannerResponseData? data;
  String? message;

  BannerResponse({this.status, this.data, this.message});

  BannerResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? BannerResponseData.fromJson(json['data']) : null;
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

class BannerResponseData {
  List<BannerModel>? topBanners;
  List<BannerModel>? bottomBanners;

  BannerResponseData({this.topBanners, this.bottomBanners});

  BannerResponseData.fromJson(Map<String, dynamic> json) {
    if (json['top_banners'] != null) {
      topBanners = <BannerModel>[];
      json['top_banners'].forEach((v) {
        topBanners!.add(BannerModel.fromJson(v));
      });
    }
    if (json['bottom_banners'] != null) {
      bottomBanners = <BannerModel>[];
      json['bottom_banners'].forEach((v) {
        bottomBanners!.add(BannerModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    if (topBanners != null) {
      data['top_banners'] = topBanners!.map((v) => v.toJson()).toList();
    }
    if (bottomBanners != null) {
      data['bottom_banners'] =
          bottomBanners!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BannerModel {
  int? id;
  String? image;
  String? imageLocalization;
  int? order;
  int? type;
  String? header;
  String? text;
  String? typeValue;
  String? value;
  SLIDER_LINK_TYPE linkType = SLIDER_LINK_TYPE.none;


  BannerModel(
      {this.id, this.image, this.imageLocalization, this.order, this.type, this.header, this.text, this.typeValue, this.value,});

  BannerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'] != null ? sprintf( EndpointConfig.imageUrl , [json['image']]) : null;
    imageLocalization = json['image_localization'] != null ? sprintf( EndpointConfig.imageUrl , [json['image_localization']]) : null;
    order = json['order'];
    type = json['type'];
    header = json['header'];
    text = json['text'];
    value = json['value'];
    typeValue = json['type_value'];
    switch(json['type_value'].toString()) {
      case 'module': {
        linkType = SLIDER_LINK_TYPE.module;
      }
      break;

      case 'text': {
        linkType = SLIDER_LINK_TYPE.static;
      }
      break;

      case 'link': {
        linkType = SLIDER_LINK_TYPE.link;
      }
      break;

      default: {
        linkType = SLIDER_LINK_TYPE.none;
      }
      break;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['image_localization'] = imageLocalization;
    data['order'] = order;
    data['type'] = type;
    data['header'] = header;
    data['text'] = text;
    data['type_value'] = typeValue;
    data['value'] = value;
    return data;
  }
}
