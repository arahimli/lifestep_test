
String? TOKEN = '';
String? HALF_TOKEN = '';
String? FCM_TOKEN = '';
String LANGUAGE = 'az';
String SITE_URL = 'https://lifestep.az';
String API_BASE_URL = 'https://app-dev.lifestep.az';
String API_URL = '${API_BASE_URL}/api/';
String IMAGE_URL = '${API_BASE_URL}/storage/%s';

String TERMS_PRIVACY_URL = '${API_URL}${'terms-privacy'}';
String SETTINGS_URL = '${API_URL}${'settings'}';
String APP_VERSION_CHECK_URL = '${API_URL}${'last-app-version?os=%s&user_version=%s'}';

String GET_USER_URL = '${API_URL}${'get-user'}';
String GET_LAST_USER_STEP_URL = '${API_URL}${'last-user-step'}';
String EDIT_USER_URL = '${API_URL}${'edit-profile'}';
String SOCIAL_LOGIN_URL = '${API_URL}${'login-social-accounts'}';
String LOGIN_URL = '${API_URL}${'login'}';
String LOGOUT_URL = '${API_URL}${'logout'}';
String REGISTRATION_URL = '${API_URL}${'register'}';
String CONFIRM_OTP_URL = '${API_URL}${'confirm-otp'}';
String RESEND_OTP_URL = '${API_URL}${'minute-code-again'}';

String DELETE_USER_URL = '${API_URL}${'user-profile-delete'}';
String DELETE_CONFIRM_OTP_URL = '${API_URL}${'user-profile-delete-confirm'}';
String RESEND_DELETE_OTP_URL = '${API_URL}${'user-profile-delete'}';

String NOTIFICATIONS_URL = '${API_URL}${'user-notifications/%s/%s'}';
String ACHIEVEMENTS_URL = '${API_URL}${'user-achievements'}';
String STEP_INFO_URL = '${API_URL}${'last-user-step'}';
String SET_STEP_INFO_URL = '${API_URL}${'add-user-step'}';
String SET_STEP_INFO_URL2 = '${API_URL}${'add-user-step2'}';
String USER_ACHIEVEMENTS_CONTROL_INFO_URL = '${API_URL}${'user-steps-achievements-control'}';
String STEP_DAILY_INFO_URL = '${API_URL}${'last-day-user-step'}';
String SET_STEP_DAILY_INFO_URL = '${API_URL}${'add-user-step-daily'}';
String STEP_DAILY_INFO_URL2 = '${API_URL}${'last-day-user-step2'}';
String SET_STEP_DAILY_INFO_URL2 = '${API_URL}${'add-user-step-daily2'}';
String GET_STEP_STATISTIC_URL = '${API_URL}${'users-ratings-all/%s/%s'}';
String GET_STEP_USER_RATING_ORDER_URL = '${API_URL}${'user-rating-order/%s/%s'}';
String GET_STEP_STATISTIC_DATE_URL = '${API_URL}${'users-ratings/%s/%s/%s'}';

String GET_SLIDER_URL = '${API_URL}${'banners'}';
String HOME_CHARITIES_URL = '${API_URL}${'home-charities'}';
String HOME_FOND_URL = '${API_URL}${'home-funds'}';
String HOME_CHALLENGES_URL = '${API_URL}${'home-challenges'}';

String CHALLENGES_URL = '${API_URL}${'challenges/%s/%s?search=%s'}';
String CHALLENGE_USERS_URL = '${API_URL}${'challenge-users/%s'}';
String JOIN_CHALLENGE_URL = '${API_URL}${'join-challenge'}';
String CANCEL_CHALLENGE_URL = '${API_URL}${'delete-user-join/%s'}';
String SUCCESS_CHALLENGE_URL = '${API_URL}${'challenge-user-data/%s'}';

String FONDS_URL = '${API_URL}${'funds/%s/%s?search=%s'}';
String FOND_USERS_URL = '${API_URL}${'fund-users/%s'}';
String USER_DONATIONS_URL = '${API_URL}${'user-donaties/%s/%s?search=%s'}';
String CHARITIES_URL = '${API_URL}${'charities/%s/%s?search=%s'}';
String CHARITIY_DONATION_URL = '${API_URL}${'user-step-charity'}';
String FOND_DONATION_URL = '${API_URL}${'user-step-fund'}';
String CHARITY_USERS_URL = '${API_URL}${'charity-users/%s'}';
String DETAIL_DONATION_URL = '${API_URL}${'all-donations'}';
