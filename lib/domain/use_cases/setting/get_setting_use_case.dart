import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/setting/app_setting.dart';
import 'package:carfy/domain/repositories/setting_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetSettingUseCase {
  final SettingRepository _repository;

  GetSettingUseCase(this._repository);

  Future<Either<Failure, AppSetting>> call() => _repository.getAppSetting();
}
