class AddCarParams {
  final int brandModelId;
  final int carTypeId;
  final int year;
  final int? engineVolumeId;
  final int? fuelTypeId;
  final int? transmissionTypeId;
  final String? engineNumber;
  final String? vinNumber;
  final String? photoPath;

  AddCarParams({
    required this.brandModelId,
    required this.carTypeId,
    required this.year,
    this.engineVolumeId,
    this.fuelTypeId,
    this.transmissionTypeId,
    this.engineNumber,
    this.vinNumber,
    this.photoPath,
  });
}
