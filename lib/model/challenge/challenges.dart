import 'dart:convert' as jsonp;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lifestep/config/endpoints.dart';
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
        data!.add(new ChallengeModel.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}




class ChallengeModel {
  int? id;
  String? name;
  String? description;
  String? startDate;
  String? endDate;
  String? image;
  String? mapImage;
  double? distance;
  int? averageTime;
  String? styleUrl;
  String? embedLink;
  int? numberOfParticipants;
  int? difficultyLevel;
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
        this.image,
        this.mapImage,
        this.distance,
        this.averageTime,
        this.styleUrl,
        this.embedLink,
        this.numberOfParticipants,
        this.difficultyLevel,
        this.startDistance : 20,
        this.endDistance : 0,
        this.startLat : 0,
        this.startLong : 0,
        this.endLat : 0,
        this.endLong : 0,
        this.booster,
        this.mapZoom,
        this.status,
        this.sponsorName,
        this.sponsorImage,
        this.mapJson,
        this.mapJsonObj
      });

  ChallengeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    image = json['image'] != null ? sprintf( IMAGE_URL , [json['image']]) : null;
    mapImage = json['map_image'] != null ? sprintf( IMAGE_URL , [json['map_image']]) : null;
    distance = json['distance'] != null ? double.parse(json['distance'].toString()): 0;
    averageTime = json['average_time'];
    styleUrl = json['style_url'];
    embedLink = json['embed_link'];
    numberOfParticipants = json['number_of_participants'];
    difficultyLevel = json['difficulty_level'];
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
    sponsorImage = json['sponsor_image'];
    mapJson = json['map_json'];
    try {
      mapJsonObj = jsonp.json.decode(json['map_json'] ?? '[]');
    }catch(e){
      mapJsonObj = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['image'] = this.image;
    data['map_image'] = this.mapImage;
    data['distance'] = this.distance;
    data['average_time'] = this.averageTime;
    data['style_url'] = this.styleUrl;
    data['embed_link'] = this.embedLink;
    data['number_of_participants'] = this.numberOfParticipants;
    data['difficulty_level'] = this.difficultyLevel;
    data['booster'] = this.booster;
    data['map_zoom'] = this.mapZoom;
    data['start_distance'] = this.startDistance;
    data['end_distance'] = this.endDistance;
    data['start_lat'] = this.startLat;
    data['start_long'] = this.startLong;
    data['end_lat'] = this.endLat;
    data['end_long'] = this.endLong;
    data['status'] = this.status;
    data['sponsor_name'] = this.sponsorName;
    data['sponsor_image'] = this.sponsorImage;
    data['map_json'] = this.mapJson;
    return data;
  }

  List<dynamic> mapJsonGet(){
    try {
      List<dynamic> ab = jsonp.json.decode(this.mapJson ?? '[]');
      return ab;
    }catch(e){
      return [];
    }
  }
  List<LatLng> getCoordinates(){
    try {
      return this.mapJsonGet().map((e) => LatLng(e[1], e[0])).toList();
    }catch(e){
      return [];
    }
  }


}