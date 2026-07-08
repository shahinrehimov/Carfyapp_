import 'package:carfy/common/error/failure.dart';
import 'package:carfy/common/mixin/repository_safe_call_mixin.dart';
import 'package:carfy/data/datasources/setting_remote_data_source.dart';
import 'package:carfy/domain/entities/setting/app_setting.dart';
import 'package:carfy/domain/repositories/setting_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SettingRepository)
class SettingRepositoryImpl extends SettingRepository with RepositorySafeCallMixin {
  final SettingRemoteDataSource _remoteDataSource;

  SettingRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, AppSetting>> getAppSetting() {
    return safeCall(() async {
      final res = await _remoteDataSource.getAppSetting();
      return AppSetting(
        phone: res.phone,
        email: res.email,
        iosMinVersion: res.iosMinVersion,
        androidMinVersion: res.androidMinVersion,
      );
    });
  }
}
