import 'languages.dart';

class LanguageAz extends Languages {
  @override
  String get appName => "Carfy";

  @override
  String get $continue => 'Davam et';

  @override
  String get mainBasket => 'Səbət';

  @override
  String get mainFavorite => 'Seçilmişlər';

  @override
  String get mainHome => 'Əsas';

  @override
  String get mainMessage => 'Mesaj';

  @override
  String get mainProfile => 'Profil';

  @override
  String get messagesNotLoggedText => 'Mesajları görmək üçün\nhesabınıza daxil olun.';

  @override
  String get favoritesNotLoggedText => 'Seçilmişləri görmək üçün\nhesabınıza daxil olun.';

  @override
  String get basketNotLoggedText => 'Sifarişi formalaşdırmaq\nüçün daxil olun.';

  @override
  String get profileNotLoggedText => 'Hesabınızı görmək üçün\nzəhmət olmasa daxil olun.';

  @override
  String get or => 'Ya da';

  @override
  String get connectionFailure => 'Şəbəkə xətası. İnternet bağlantınızı yoxlayın.';

  @override
  String get serverFailure => 'Xəta baş verdi. Bir az sonra yenidən cəhd edin.';

  @override
  String get withNumber => 'Nömrə ilə';

  @override
  String get withEmail => 'Elektron poçt ilə';

  @override
  String get entranceToAccount => 'Kabinetə giriş';

  @override
  String get email => 'Elektron poçt';

  @override
  String get mobileNumber => 'Mobil nömrə';

  @override
  String get password => 'Şifrə';

  @override
  String get forward => 'İrəli';

  @override
  String get requiredFieldErrorText => 'Bu xana boş ola bilməz';

  @override
  String get invalidEmailText => 'Eloktron poçt ünvanı düzgün deyil';

  @override
  String get forgotPassword => 'Şifrəni unutmusunuz?';

  @override
  String get doNotHaveAccount => 'Hesabınız yoxdur?';

  @override
  String get signUp => 'Qeydiyyatdan keçin';

  @override
  String get google => 'Google';

  @override
  String get apple => 'Apple';

  @override
  String get signUpTermsText =>
      'Qeydiyyatdan keçərək və ya xidmətdən istifadə etməyə davam edərək, siz avtomatik olaraq Carfy istifadəçi razılaşmaları və məxfilik siyasəti ilə razılaşırsınız.';

  @override
  String get invalidFormat => 'Format düzgün deyil';

  @override
  String get phoneVerification => 'Nömrənin təstiqlənməsi';

  @override
  String  otpSentToNumber(number) => '$number nömrəsinə SMS-kod göndərildi';

  @override
  String get confirm => 'Təsdiqlə';

  @override
  String get passwordRecovery => 'Şifrə bərpası';
}
