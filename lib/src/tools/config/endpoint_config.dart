
class EndpointConfig {
  EndpointConfig._();

  static const String siteUrl = 'https://lifestep.az';
  static const String apiBaseUrl = 'https://app-dev.lifestep.az';
  static const String apiUrl = '${apiBaseUrl}/api/';
  static const String imageUrl = '${apiBaseUrl}/storage/%s';

  static const String termsPrivacy = 'terms-privacy';
  static const String settings = 'settings';
  static const String sendingLogInfo = 'add-user-postgre-event';
  static const String appVersionCheck = 'last-app-version?os=%s&user_version=%s';


  static const String getUser = 'get-user';
  static const String getLastUserStep = 'last-user-step';
  static const String editUser = 'edit-profile';
  static const String socialLogin = 'login-social-accounts';

  static const String login = 'login';
  static const String logout = 'logout';
  static const String registration = 'register';
  static const String confirm = 'confirm-otp';
  static const String resendOtp = 'minute-code-again';






  static const String challenges = 'challenges/%s/%s?search=%s';
  static const String challengeUsers = 'challenge-users/%s';
  static const String challengeStepBaseStage = 'step-challenge/%s';
  static const String joinChallenge = 'join-challenge';
  static const String joinStepBaseChallenge = 'user-join-step-challenge/%s';
  static const String cancelStepBaseChallenge = 'stop-join-step-challenge/%s';
  static const String challengeStepBaseUsers = 'recently-step-challenge-users/%s/%s';
  static const String cancelChallenge = 'delete-user-join/%s';
  static const String successChallenge = 'challenge-user-data/%s';


  static const String funds = 'funds/%s/%s?search=%s';
  static const String fundUsers = 'fund-users/%s';
  static const String userDonations = 'user-donaties/%s/%s?search=%s';
  static const String charities = 'charities/%s/%s?search=%s';
  static const String charityDonation = 'user-step-charity';
  static const String fundDonation = 'user-step-fund';
  static const String charityUsers = 'charity-users/%s';
  static const String detailDonation = 'all-donations';



  static const String notifications = 'user-notifications/%s/%s';
  static const String achievements = 'user-achievements';
  static const String stepInfo = 'last-user-step';
  static const String setStepInfo = 'add-user-step';
  static const String setStepInfo2 = 'add-user-step2';
  static const String userAchievementsControl = 'user-steps-achievements-control';
  static const String stepDailyInfo = 'last-day-user-step';
  static const String setStepDailyInfo = 'add-user-step-daily';
  static const String stepDailyInfo2 = 'last-day-user-step2';
  static const String setStepDailyInfo2 = 'add-user-step-daily2';
  static const String getStepStatistic = 'users-ratings-all/%s/%s';
  static const String getStepUserRatingOrder = 'user-rating-order/%s/%s';
  static const String getStepStatisticDate = 'users-ratings/%s/%s/%s';
}