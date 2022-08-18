
class EndpointConfig {
  EndpointConfig._();

  static const String siteUrl = 'https://lifestep.az';
  static const String apiBaseUrl = 'https://app-dev.lifestep.az';
  static const String apiUrl = '${apiBaseUrl}/api/';
  static const String imageUrl = '${apiBaseUrl}/storage/%s';

  static const String termsPrivacy = '${apiUrl}terms-privacy';
  static const String settings = '${apiUrl}settings';
  static const String sendingLogInfo = '${apiUrl}add-user-postgre-event';
  static const String appVersionCheck = '${apiUrl}last-app-version?os=%s&user_version=%s';


  static const String getUser = '${apiUrl}get-user';
  static const String getLastUserStep = '${apiUrl}last-user-step';
  static const String editUser = '${apiUrl}edit-profile';
  static const String socialLogin = '${apiUrl}login-social-accounts';

  static const String login = '${apiUrl}login';
  static const String logout = '${apiUrl}logout';
  static const String registration = '${apiUrl}register';
  static const String confirm = '${apiUrl}confirm-otp';
  static const String resendOtp = '${apiUrl}minute-code-again';






  static const String challenges = '${apiUrl}challenges/%s/%s?search=%s';
  static const String challengeUsers = '${apiUrl}challenge-users/%s';
  static const String challengeStepBaseStage = '${apiUrl}step-challenge/%s';
  static const String joinChallenge = '${apiUrl}join-challenge';
  static const String cancelChallenge = '${apiUrl}delete-user-join/%s';
  static const String successChallenge = '${apiUrl}challenge-user-data/%s';


  static const String funds = '${apiUrl}funds/%s/%s?search=%s';
  static const String fundUsers = '${apiUrl}fund-users/%s';
  static const String userDonations = '${apiUrl}user-donaties/%s/%s?search=%s';
  static const String charities = '${apiUrl}charities/%s/%s?search=%s';
  static const String charityDonation = '${apiUrl}user-step-charity';
  static const String fundDonation = '${apiUrl}user-step-fund';
  static const String charityUsers = '${apiUrl}charity-users/%s';
  static const String detailDonation = '${apiUrl}all-donations';



  static const String notifications = '${apiUrl}user-notifications/%s/%s';
  static const String achievements = '${apiUrl}user-achievements';
  static const String stepInfo = '${apiUrl}last-user-step';
  static const String setStepInfo = '${apiUrl}add-user-step';
  static const String setStepInfo2 = '${apiUrl}add-user-step2';
  static const String userAchievementsControl = '${apiUrl}user-steps-achievements-control';
  static const String stepDailyInfo = '${apiUrl}last-day-user-step';
  static const String setStepDailyInfo = '${apiUrl}add-user-step-daily';
  static const String stepDailyInfo2 = '${apiUrl}last-day-user-step2';
  static const String setStepDailyInfo2 = '${apiUrl}add-user-step-daily2';
  static const String getStepStatistic = '${apiUrl}users-ratings-all/%s/%s';
  static const String getStepUserRatingOrder = '${apiUrl}user-rating-order/%s/%s';
  static const String getStepStatisticDate = '${apiUrl}users-ratings/%s/%s/%s';
}