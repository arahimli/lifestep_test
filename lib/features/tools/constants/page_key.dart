
class PageKeyConstant {
  static final signUp = PageKeyModel(
    key: "1",
    name: "sign_up",
    description: "user registration event",
  );
  static final signIn = PageKeyModel(
    key: "2",
    name: "sign_in",
    description: "user login event",
  );
  static final firstOpen = PageKeyModel(
    key: "3",
    name: "first_open",
    description: "user first open of the app (first time opened, no registration made)",
  );
  static final donateView = PageKeyModel(
    key: "4",
    name: "donate_view",
    description: "button that leads to all donations screen",
  );
  static final donate = PageKeyModel(
    key: "5",
    name: "donate",
    description: "when user makes a donation",
  );
  static final allRanking = PageKeyModel(
    key: "6",
    name: "all_ranking",
    description: "button that leads to all ranking section",
  );
  static final bannerGifts = PageKeyModel(
    key: "7",
    name: "banner_gifts",
    description: "track clicks on banner with gifts",
  );
  static final userProfile = PageKeyModel(
    key: "8",
    name: "user_profile",
    description: "users that opend achievements section",
  );
  static final achievements = PageKeyModel(
    key: "9",
    name: "achievements",
    description: "users that opend achievements section",
  );
  static final notifications = PageKeyModel(
    key: "9",
    name: "notifications",
    description: "users that opend achievements section",
  );
  static final fitnessData = PageKeyModel(
    key: "10",
    name: "fitness_data",
    description: "click on the blue button on the main page that leads to the detailed fitness data",
  );
  static final stepChallengeStart = PageKeyModel(
    key: "11",
    name: "step_challenge_start",
    description: "user clicks on start button in the challenge",
  );
  static final stepChallengeEnd = PageKeyModel(
    key: "12",
    name: "step_challenge_end",
    description: "user clicks on cancel button in the callenge",
  );
}

class PageKeyModel{
  final String key;
  final String? name;
  final String? description;

    PageKeyModel({
      required this.key,
      this.name,
      this.description,
  });
}