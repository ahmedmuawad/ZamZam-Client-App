import 'package:flutter_grocery/data/model/response/language_model.dart';

class AppConstants {
  static const String APP_NAME = 'ZamZam';

  static const String BASE_URL = 'https://zamzamapp.store/app';
  static const String CONFIG_URI = '/api/v1/config';
  static const String BANNER_URI = '/api/v1/banners';
  static const String CATEGORY_URI = '/api/v1/categories';
  static const String SUB_CATEGORY_URI = '/api/v1/categories/childes/';
  static const String CATEGORY_PRODUCT_URI = '/api/v1/categories/products/';
  static const String POPULAR_PRODUCT_URI = '/api/v1/products/latest';
  static const String DAILY_ITEM_URI = '/api/v1/products/daily-needs';
  static const String SEARCH_PRODUCT_URI = '/api/v1/products/details/';
  static const String SEARCH_URI = '/api/v1/products/search?name=';
  static const String MESSAGE_URI = '/api/v1/customer/message/get';
  static const String SEND_MESSAGE_URI = '/api/v1/customer/message/send';
  static const String NOTIFICATION_URI = '/api/v1/notifications';
  static const String REGISTER_URI = '/api/v1/auth/register';
  static const String LOGIN_URI = '/api/v1/auth/login';
  static const String FORGET_PASSWORD_URI = '/api/v1/auth/forgot-password';
  static const String RESET_PASSWORD_URI = '/api/v1/auth/reset-password';
  static const String CHECK_PHONE_URI = '/api/v1/auth/check-phone?phone=';
  static const String VERIFY_PHONE_URI = '/api/v1/auth/verify-phone';
  static const String CHECK_EMAIL_URI = '/api/v1/auth/check-email';
  static const String VERIFY_EMAIL_URI = '/api/v1/auth/verify-email';
  static const String VERIFY_TOKEN_URI = '/api/v1/auth/verify-token';
  static const String PRODUCT_DETAILS_URI = '/api/v1/products/details/';
  static const String SUBMIT_REVIEW_URI = 'api/v1/products/reviews/submit';
  static const String COUPON_URI = '/api/v1/coupon/list';
  static const String COUPON_APPLY_URI = '/api/v1/coupon/apply?code=';
  static const String CUSTOMER_INFO_URI = '/api/v1/customer/info';
  static const String UPDATE_PROFILE_URI = '/api/v1/customer/update-profile';
  static const String ADDRESS_LIST_URI = '/api/v1/customer/address/list';
  static const String REMOVE_ADDRESS_URI =
      '/api/v1/customer/address/delete?address_id=';

  static const String GET_SUBCATEGORY = '/api/v1/categories/get_subcategories';
  static const String GET_SUBSUBCATEGORY =
      '/api/v1/categories/get_subsubcategories';
  static const String UPDATE_BALANCE = '/api/v1/customer/balance';

  //Cart Feature

  static const String GET_CART = '/api/v1/customer/cart/my_cart';
  static const String ADD_TO_CART = '/api/v1/customer/cart/add';
  static const String INCREAMENT = '/api/v1/customer/cart/increament';
  static const String DECREAMENT = '/api/v1/customer/cart/decreament';
  static const String DELETE = '/api/v1/customer/cart/delete';

  // End Cart Feature

  static const String ADD_ADDRESS_URI = '/api/v1/customer/address/add';
  static const String UPDATE_ADDRESS_URI = '/api/v1/customer/address/update/';
  static const String ORDER_LIST_URI = '/api/v1/customer/order/list';
  static const String ORDER_CANCEL_URI = '/api/v1/customer/order/cancel';
  static const String ORDER_DETAILS_URI =
      '/api/v1/customer/order/details?order_id=';
  static const String ORDER_Balance_URI =
      '/api/v1/customer/order/get_order?order_id=';
  //
  static const String TRACK_URI = '/api/v1/customer/order/track?order_id=';
  static const String PLACE_ORDER_URI = '/api/v1/customer/order/place';
  static const String LAST_LOCATION_URI =
      '/api/v1/delivery-man/last-location?order_id=';
  static const String TIMESLOT_URI = '/api/v1/timeSlot';
  static const String TOKEN_URI = '/api/v1/customer/cm-firebase-token';
  static const String UPDATE_METHOD_URI =
      '/api/v1/customer/order/payment-method';
  static const String REVIEW_URI = '/api/v1/products/reviews/submit';
  static const String DELIVER_MAN_REVIEW_URI =
      '/api/v1/delivery-man/reviews/submit';
  static const String DISTANCE_MATRIX_URI = '/api/v1/mapapi/distance-api';
  static const String SEARCH_LOCATION_URI =
      '/api/v1/mapapi/place-api-autocomplete';
  static const String PLACE_DETAILS_URI = '/api/v1/mapapi/place-api-details';
  static const String GEOCODE_URI = '/api/v1/mapapi/geocode-api';

  // Shared Key
  static const String THEME = 'theme';
  static const String TOKEN = 'token';
  static const String COUNTRY_CODE = 'country_code';
  static const String LANGUAGE_CODE = 'language_code';
  static const String CART_LIST = 'cart_list';
  static const String USER_PASSWORD = 'user_password';
  static const String USER_ADDRESS = 'user_address';
  static const String USER_NUMBER = 'user_number';
  static const String SEARCH_ADDRESS = 'search_address';
  static const String TOPIC = 'grofresh';

  static List<LanguageModel> languages = [
    LanguageModel(
        imageUrl: '',
        languageName: 'Arabic',
        countryCode: 'SA',
        languageCode: 'ar'),
    LanguageModel(
        imageUrl: '',
        languageName: 'English',
        countryCode: 'US',
        languageCode: 'en'),
  ];
}
