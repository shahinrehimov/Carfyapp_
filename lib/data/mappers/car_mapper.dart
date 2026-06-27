import 'package:carfy/data/models/car/car_color_model.dart';
import 'package:carfy/data/models/car/car_library_item_model.dart';
import 'package:carfy/data/models/car/engine_volume_model.dart';
import 'package:carfy/data/models/car/user_car_model.dart';
import 'package:carfy/domain/entities/car/car_color.dart';
import 'package:carfy/domain/entities/car/car_library_item.dart';
import 'package:carfy/domain/entities/car/engine_volume.dart';
import 'package:carfy/domain/entities/car/user_car.dart';
import 'package:injectable/injectable.dart';

@injectable
class CarMapper {
  CarLibraryItem mapLibraryItem(CarLibraryItemModel model) => CarLibraryItem(id: model.id, title: model.title);

  EngineVolume mapEngineVolume(EngineVolumeModel model) =>
      EngineVolume(id: model.id, title: model.title, valueLiters: model.valueLiters, valueCc: model.valueCc);

  CarColor mapCarColor(CarColorModel model) => CarColor(id: model.id, title: model.title, hexCode: model.hexCode);

  UserCar mapUserCar(UserCarModel model) => UserCar(
    id: model.id,
    photo: model.photo,
    brand: mapLibraryItem(model.brand),
    brandModel: mapLibraryItem(model.brandModel),
    carType: mapLibraryItem(model.carType),
    engineVolume: model.engineVolume != null ? mapEngineVolume(model.engineVolume!) : null,
    fuelType: model.fuelType != null ? mapLibraryItem(model.fuelType!) : null,
    transmissionType: model.transmissionType != null ? mapLibraryItem(model.transmissionType!) : null,
    carColor: model.carColor != null ? mapCarColor(model.carColor!) : null,
    seatCount: model.seatCount,
    year: model.year,
    engineNumber: model.engineNumber,
    vinNumber: model.vinNumber,
    createdAt: model.createdAt,
  );
}
