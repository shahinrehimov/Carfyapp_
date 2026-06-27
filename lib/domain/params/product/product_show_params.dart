class ProductShowParams {
  final String cpvUuid;
  final bool otherSellers;
  final bool withRelated;

  ProductShowParams({required this.cpvUuid, this.otherSellers = false, this.withRelated = false});
}
