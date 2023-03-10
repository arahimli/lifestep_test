
import 'package:lifestep/features/main_app/data/models/donation/charities.dart';
import 'package:lifestep/features/main_app/data/models/donation/fonds.dart';
import 'package:lifestep/features/main_app/data/models/home/challenge_list.dart';
import 'package:lifestep/features/main_app/data/models/index/banner.dart';

class IndexPageModel{
  final BannerResponseData? bannerData;
  final List<CharityModel> charityList;
  final List<FondModel> fondList;
  final HomeChallengeListResponseData? homeChallengeListData;

  IndexPageModel({
    this.bannerData,
    this.charityList = const [],
    this.fondList = const [],
    this.homeChallengeListData,
});

  IndexPageModel copyWith({
    BannerResponseData? bannerData,
    List<CharityModel>? charityList,
    List<FondModel>? fondList,
    HomeChallengeListResponseData? homeChallengeListData,
  }) {
    return IndexPageModel(
      bannerData: bannerData ?? this.bannerData,
      charityList: charityList ?? this.charityList,
      fondList: fondList ?? this.fondList,
      homeChallengeListData: homeChallengeListData ?? this.homeChallengeListData,
    );
  }
}