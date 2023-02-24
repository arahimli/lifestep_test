

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:lifestep/features/main_app/data/models/general/gallery.dart';
import 'package:lifestep/features/tools/constants/enum.dart';

@immutable
class ChallengeEntity  extends Equatable{

  final int? id;
  final String? name;
  final String? description;
  final String? startDate;
  final String? endDate;
  final CHALLENGE_TYPE type;
  final String? image;
  final List<GalleryModel>? gallery;
  final List<String>? bulletedListArray;
  final String? mapImage;
  final double? distance;
  final int? averageTime;
  final String? styleUrl;
  final String? embedLink;
  final int? numberOfParticipants;
  final int? difficultyLevel;
  final bool? isJoined;
  final bool? isCompleted;
  final bool? isExpired;
  final double? startDistance;
  final double? endDistance;
  final double? startLat;
  final double? startLong;
  final double? endLat;
  final double? endLong;
  final double? booster;
  final double? mapZoom;
  final int? status;
  final String? sponsorName;
  final String? sponsorImage;
  final String? mapJson;
  final List<dynamic>? mapJsonObj;

  const ChallengeEntity(
      {
        this.id,
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

  @override
  // TODO: implement props
  List<Object?> get props => [id, isJoined, isCompleted, isExpired, status];

}