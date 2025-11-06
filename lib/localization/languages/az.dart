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
}
