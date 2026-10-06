class FitmentSelection {
  final FitmentParty? brand;
  final FitmentParty? brandModel;

  FitmentSelection({this.brand, this.brandModel});

  String get displayLabel {
    final parts = <String>[];
    if (brand != null) parts.add(brand!.title);
    if (brandModel != null) parts.add(brandModel!.title);
    return parts.join(' ');
  }
}

class FitmentParty {
  final int id;
  final String title;

  FitmentParty({required this.id, required this.title});
}
