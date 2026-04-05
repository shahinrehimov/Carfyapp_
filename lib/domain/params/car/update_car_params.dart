class UpdateCarParams {
  final int carId;
  final int brandModelId;
  final int carTypeId;
  final int year;
  final int? engineVolumeId;
  final int? fuelTypeId;
  final int? transmissionTypeId;
  final int? carColorId;
  final int? seatCount;
  final String? engineNumber;
  final String? vinNumber;
  final String? photoPath;

  UpdateCarParams({
    required this.carId,
    required this.brandModelId,
    required this.carTypeId,
    required this.year,
    this.engineVolumeId,
    this.fuelTypeId,
    this.transmissionTypeId,
    this.carColorId,
    this.seatCount,
    this.engineNumber,
    this.vinNumber,
    this.photoPath,
  });
}
