import 'package:carfy/domain/params/group/groups_bulk_params.dart';

class GroupsBulkQueryParams {
  final List<GroupBulkRequest> groups;

  GroupsBulkQueryParams({required this.groups});

  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{};
    for (int i = 0; i < groups.length; i++) {
      params['groups[$i][name]'] = groups[i].name;
      params['groups[$i][limit]'] = groups[i].limit;
    }
    return params;
  }
}
