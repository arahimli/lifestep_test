
import 'package:lifestep/model/challenge/challenges.dart';
import 'package:lifestep/model/donation/charities.dart';
import 'package:lifestep/model/donation/fonds.dart';
import 'package:lifestep/model/index/banner.dart';

class IndexPageModel{
  final BannerResponseData? bannerData;
  final List<CharityModel> charityList;
  final List<FondModel> fondList;
  final List<ChallengeModel> challengeList;

  IndexPageModel({
    this.bannerData,
    this.charityList : const [],
    this.fondList : const [],
    this.challengeList : const [],
});

  IndexPageModel copyWith({
    BannerResponseData? bannerData,
    List<CharityModel>? charityList,
    List<FondModel>? fondList,
    List<ChallengeModel>? challengeList,
  }) {
    return IndexPageModel(
      bannerData: bannerData ?? this.bannerData,
      charityList: charityList ?? this.charityList,
      fondList: fondList ?? this.fondList,
      challengeList: challengeList ?? this.challengeList,
    );
  }
}