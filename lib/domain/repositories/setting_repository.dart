import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/setting/app_setting.dart';
import 'package:dartz/dartz.dart';

abstract class SettingRepository {
  Future<Either<Failure, AppSetting>> getAppSetting();
}
