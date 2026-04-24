class GroupsBulkParams {
  final List<GroupBulkRequest> groups;

  GroupsBulkParams({required this.groups});
}

class GroupBulkRequest {
  final String name;
  final int limit;

  const GroupBulkRequest({required this.name, required this.limit});
}
