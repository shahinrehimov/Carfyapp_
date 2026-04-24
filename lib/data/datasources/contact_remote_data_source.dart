import 'package:carfy/common/constants/endpoint_paths.dart';
import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/mixin/datasource_mixin.dart';
import 'package:carfy/common/network/network_manager.dart';
import 'package:carfy/data/dtos/contact/send_contact_dto.dart';
import 'package:injectable/injectable.dart';

abstract class ContactRemoteDataSource {
  Future<void> sendContact(SendContactDto dto);
}

@Injectable(as: ContactRemoteDataSource)
class ContactRemoteDataSourceImpl extends ContactRemoteDataSource with DataSourceMixin {
  final NetworkManager _networkManager = getIt<NetworkManager>();

  @override
  Future<void> sendContact(SendContactDto dto) {
    return handleResponse(
      () => _networkManager.post(EndpointPaths.contactSend, data: dto.toJson()),
    );
  }
}
