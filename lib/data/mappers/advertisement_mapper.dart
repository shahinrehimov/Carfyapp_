import 'package:carfy/data/models/advertisements/advertisement_model.dart';
import 'package:carfy/domain/entities/advertisements/advertisement.dart';
import 'package:injectable/injectable.dart';

@injectable
class AdvertisementMapper {
  Advertisement mapAdvertisement(AdvertisementModel model) => Advertisement(
    title: model.title,
    key: model.key,
    imageUrl: model.imageUrl,
    link: model.link,
  );
}
