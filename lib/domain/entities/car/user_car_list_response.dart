import 'package:carfy/domain/entities/car/user_car.dart';

class UserCarListResponse {
  final List<UserCar> cars;
  final int lastPage;

  UserCarListResponse({required this.cars, required this.lastPage});
}
