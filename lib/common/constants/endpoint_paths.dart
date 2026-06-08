class EndpointPaths {
  // Auth Endpoints
  static const getGoogleRedirect = '/app/auth/google';

  static const registerCheckEmail = '/app/register/with-email/check-email';
  static const registerWithEmail = '/app/register/with-email/submit';
  static const registerVerifyEmailOtp = '/app/register/with-email/verify-otp';

  static const registerSendPhoneOtp = '/app/register/with-phone/send-otp';
  static const registerCheckPhoneOtp = '/app/register/with-phone/check-otp';
  static const registerWithPhone = '/app/register/with-phone/submit';

  static const loginWithEmail = '/app/login/with-email';
  static const loginSendPhoneOtp = '/app/login/with-phone/send-otp';
  static const loginWithPhone = '/app/login/with-phone/submit';

  static const thirdPartyLogin = '/app/third-party-login';

  static const logout = '/app/logout';
  static const logoutAll = '/app/logout-all';

  static const sendVerificationEmail = '/app/send-verification-email';

  static const forgotPassword = '/app/forgot-password';

  static const generateIdentifier = '/app/guests/generate-identifier';

  // Version Endpoints
  static const versions = '/versions';

  static translations(String languageCode) => '/app/local-translations/$languageCode';

  // Category Endpoints
  static const categories = '/app/categories/list?with_subs=yes&with_image=yes';

  // Product Endpoints
  static const products = '/app/products/load';
  static const productFilters = '/app/products/filters';
  static String productShow(String parentSlug, String subSlug, String productSlug) =>
      '/app/products/show/$parentSlug/$subSlug/$productSlug';
  static String productShowTwoPart(String subSlug, String productSlug) =>
      '/app/products/show/$subSlug/$productSlug';
  static String otherSellers(int variantId) => '/app/products/$variantId/other-sellers';
  static String reviewStore(String cpvUuid) => '/app/products/$cpvUuid/reviews/store';
  static String reviewsLoad(String cpvUuid) => '/app/products/$cpvUuid/reviews/load';

  // Group Endpoints
  static const groupsList = '/app/groups/list';
  static String groupProducts(String slug) => '/app/groups/single/$slug/products/load';
  static const groupsBulkProducts = '/app/groups/bulk/products/load';

  // Wishlist Endpoints
  static const wishlist = '/app/wishlist/load';
  static const wishlistIds = '/app/wishlist/ids';
  static String wishlistAdd(String cpvUuid) => '/app/wishlist/add/$cpvUuid';
  static String wishlistRemove(String cpvUuid) => '/app/wishlist/remove/$cpvUuid';

  // Profile Endpoints
  static const profileMe = '/app/profile/me';
  static const profileUpdate = '/app/profile/update';
  static const sessionsLoad = '/app/profile/sessions/load';
  static String sessionLogout(int tokenId) => '/app/profile/sessions/$tokenId/logout';

  // Basket Endpoints
  static const basketLoad = '/app/basket/load';
  static String basketAdd(String cpvUuid) => '/app/basket/add/$cpvUuid';
  static String basketRemove(String cpvUuid) => '/app/basket/remove/$cpvUuid';
  static String basketIncrement(String cpvUuid) => '/app/basket/increment/$cpvUuid';
  static String basketDecrement(String cpvUuid) => '/app/basket/decrement/$cpvUuid';
  static String basketRemoveSet(String cpvUuid, int setItemId) => '/app/basket/remove/$cpvUuid/set/$setItemId';
  static String basketIncrementSet(String cpvUuid, int setItemId) => '/app/basket/increment/$cpvUuid/set/$setItemId';
  static String basketDecrementSet(String cpvUuid, int setItemId) => '/app/basket/decrement/$cpvUuid/set/$setItemId';

  // Car Endpoints
  static const carsLoad = '/app/profile/cars/load';
  static String carShow(int id) => '/app/profile/cars/show/$id';
  static const carsAdd = '/app/profile/cars/add';
  static String carUpdate(int id) => '/app/profile/cars/update/$id';
  static String carDelete(int id) => '/app/profile/cars/delete/$id';
  static String carDeletePhoto(int id) => '/app/profile/cars/delete-photo/$id';

  // Car Library Endpoints (public)
  static const carLibraryFuelTypes = '/app/car-libraries/fuel-types';
  static const carLibraryTransmissionTypes = '/app/car-libraries/transmission-types';
  static const carLibraryCarTypes = '/app/car-libraries/car-types';
  static const carLibraryEngineVolumes = '/app/car-libraries/engine-volumes';
  static const carLibraryCarColors = '/app/car-libraries/car-colors';

  // Address Endpoints
  static const addressesLoad = '/app/profile/addresses/load';
  static const addressesAdd = '/app/profile/addresses/add';
  static String addressUpdate(int id) => '/app/profile/addresses/update/$id';
  static String addressDelete(int id) => '/app/profile/addresses/delete/$id';
  static String addressSetDefault(int id) => '/app/profile/addresses/set-default/$id';
  static const addressTypes = '/app/services/load?services[0][key]=address_type';
  static const countriesWithCities = '/app/services/load?services[0][key]=country_and_city';

  // Brand Endpoints
  static const brands = '/app/car-libraries/brands';
  static String brandModels(int brandId) => '/app/car-libraries/brands/$brandId/models';

  // Advertisement Endpoints
  static const activeAdvertisements = '/app/advertisements/active';

  // Contact Endpoints
  static const contactSend = '/app/contact/send';

  // Order Endpoints
  static const checkoutPreview = '/app/orders/checkout-preview';
  static const checkout = '/app/orders/checkout';
  static const ordersLoad = '/app/orders/load';
  static String orderDetails(int id) => '/app/orders/details/$id';

  // Notification Endpoints
  static const notificationsLoad = '/app/notifications/load';
  static String notificationRead(int id) => '/app/notifications/$id/read';
  static const notificationsReadAll = '/app/notifications/read-all';
  static String notificationDelete(int id) => '/app/notifications/$id/delete';
  static const notificationsDeleteAll = '/app/notifications/delete-all';
  static const notificationsUnreadCount = '/app/notifications/unread-count';

  // Referral Endpoints
  static const referralMy = '/app/referral/my';
  static const referralBalance = '/app/referral/balance';
  static const referralUpdateCode = '/app/referral/update-code';
  static const referralPerks = '/app/referral/perks';
  static const referralEarnings = '/app/referral/earnings';
  static const referralReferrals = '/app/referral/referrals';
  static const referralWithdrawals = '/app/referral/withdrawals';

  // Payment Endpoints
  static const paymentMethods = '/app/payment/methods';
}
