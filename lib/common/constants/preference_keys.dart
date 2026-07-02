class AppPreferenceKeys {
  AppPreferenceKeys._();

  static String selectedLanguage = 'selected_language';

  static String lastSavedRemoteLanguage(String lang) => 'last_saved_remote_language_$lang';

  static String guestIdentifier = 'guest_identifier';
  static String authToken = 'auth_token';

  static String searchHistory = 'search_history';
}
