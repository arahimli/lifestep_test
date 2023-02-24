import 'dart:convert' as jsonp;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lifestep/features/main_app/data/models/general/gallery.dart';
import 'package:lifestep/features/tools/config/endpoint_config.dart';
import 'package:lifestep/features/tools/config/main_config.dart';
import 'package:lifestep/features/tools/constants/enum.dart';
import 'package:sprintf/sprintf.dart';

class ChallengeListResponse {
  bool? status;
  List<ChallengeModel>? data;
  String? message;

  ChallengeListResponse({this.status, this.data, this.message});

  ChallengeListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <ChallengeModel>[];
      json['data'].forEach((v) {
        data!.add(ChallengeModel.fromJson(v));
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




class ChallengeModel {
  int? id;
  String? name;
  String? description;
  String? startDate;
  String? endDate;
  late CHALLENGE_TYPE type;
  String? image;
  List<GalleryModel>? gallery;
  List<String>? bulletedListArray;
  String? mapImage;
  double? distance;
  int? averageTime;
  String? styleUrl;
  String? embedLink;
  int? numberOfParticipants;
  int? difficultyLevel;
  bool? isJoined;
  bool? isCompleted;
  bool? isExpired;
  double? startDistance;
  double? endDistance;
  double? startLat;
  double? startLong;
  double? endLat;
  double? endLong;
  double? booster;
  double? mapZoom;
  int? status;
  String? sponsorName;
  String? sponsorImage;
  String? mapJson;
  List<dynamic>? mapJsonObj;

  ChallengeModel(
      {this.id,
        this.name,
        this.description,
        this.startDate,
        this.endDate,
        this.type = CHALLENGE_TYPE.step,
        this.image,
        this.gallery,
        this.bulletedListArray,
        this.mapImage,
        this.distance,
        this.averageTime,
        this.styleUrl,
        this.embedLink,
        this.numberOfParticipants,
        this.difficultyLevel,
        this.isJoined,
        this.isCompleted,
        this.isExpired,
        this.startDistance = 20,
        this.endDistance = 0,
        this.startLat = 0,
        this.startLong = 0,
        this.endLat = 0,
        this.endLong = 0,
        this.booster,
        this.mapZoom,
        this.status,
        this.sponsorName,
        this.sponsorImage,
        this.mapJson,
        this.mapJsonObj,
      });

  ChallengeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    type = json['type'] == 2 ? CHALLENGE_TYPE.step : CHALLENGE_TYPE.checkPoint;
    image = json['image'] != null ? sprintf( EndpointConfig.imageUrl , [json['image']]) : null;
    if (json['gallery'] != null) {
      gallery = <GalleryModel>[];
      json['gallery'].forEach((v) {
        gallery!.add(GalleryModel.fromJson(v));
      });
    }
    try{bulletedListArray = json['bulleted_list_array'].cast<String>();}catch(_){}
    mapImage = json['map_image'] != null ? sprintf( EndpointConfig.imageUrl , [json['map_image']]) : null;
    distance = json['distance'] != null ? double.parse(json['distance'].toString()): 0;
    averageTime = json['average_time'];
    styleUrl = json['style_url'];
    embedLink = json['embed_link'];
    numberOfParticipants = json['number_of_participants'];
    difficultyLevel = json['difficulty_level'];
    isJoined = json['is_joined'] ?? false;
    isCompleted = json['is_completed'] ?? false;
    isExpired = json['is_expired'] ?? false;
    booster = json['booster'] != null ? double.parse(json['booster'].toString()): 0;
    mapZoom = json['map_zoom'] != null ? double.parse(json['map_zoom'].toString()): 13;
    startDistance = json['start_distance'] != null ? double.parse(json['start_distance'].toString()): 0;
    endDistance = json['end_distance'] != null ? double.parse(json['end_distance'].toString()): 0;
    startLat = json['start_lat'] != null ? double.parse(json['start_lat'].toString()): 0;
    startLong = json['start_long'] != null ? double.parse(json['start_long'].toString()): 0;
    endLat = json['end_lat'] != null ? double.parse(json['end_lat'].toString()): 0;
    endLong = json['end_long'] != null ? double.parse(json['end_long'].toString()): 0;
    status = json['status'];
    sponsorName = json['sponsor_name'];
    sponsorImage = json['sponsor_image'] != null ? sprintf( EndpointConfig.imageUrl , [json['sponsor_image']]) : null;
    mapJson = json['map_json'];
    try {
      mapJsonObj = jsonp.json.decode(json['map_json'] ?? '[]');
    }catch(e){
      mapJsonObj = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['type'] == (type == CHALLENGE_TYPE.step) ? 2 : 1;
    data['image'] = image;
    if (gallery != null) {
      data['gallery'] = gallery!.map((v) => v.toJson()).toList();
    }
    data['bulleted_list_array'] = bulletedListArray;
    data['map_image'] = mapImage;
    data['distance'] = distance;
    data['average_time'] = averageTime;
    data['style_url'] = styleUrl;
    data['embed_link'] = embedLink;
    data['number_of_participants'] = numberOfParticipants;
    data['difficulty_level'] = difficultyLevel;
    data['is_joined'] = isJoined;
    data['is_expired'] = isExpired;
    data['booster'] = booster;
    data['map_zoom'] = mapZoom;
    data['start_distance'] = startDistance;
    data['end_distance'] = endDistance;
    data['start_lat'] = startLat;
    data['start_long'] = startLong;
    data['end_lat'] = endLat;
    data['end_long'] = endLong;
    data['status'] = status;
    data['sponsor_name'] = sponsorName;
    data['sponsor_image'] = sponsorImage;
    data['map_json'] = mapJson;
    return data;
  }

  String getImage(){
    if(image != null){
      return image!;
    }else if(gallery != null && gallery!.isNotEmpty){
      return gallery!.first.image ?? MainConfig.defaultImage;
    }
    return MainConfig.defaultImage;
  }


  List<dynamic> mapJsonGet(){
    try {
      List<dynamic> ab = jsonp.json.decode(mapJson ?? '[]');
      return ab;
    }catch(e){
      return [];
    }
  }
  List<LatLng> getCoordinates(){
    try {
      return mapJsonGet().map((e) => LatLng(e[1], e[0])).toList();
    }catch(e){
      return [];
    }
  }


}