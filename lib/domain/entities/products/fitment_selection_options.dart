class FitmentSelectionOptions {
  final bool anyBrand;
  final List<FitmentBrandOption> brands;

  FitmentSelectionOptions({required this.anyBrand, required this.brands});
}

class FitmentBrandOption {
  final int id;
  final String title;
  final bool anyModel;
  final List<FitmentModelOption> models;

  FitmentBrandOption({
    required this.id,
    required this.title,
    required this.anyModel,
    required this.models,
  });
}

class FitmentModelOption {
  final int id;
  final String title;

  FitmentModelOption({required this.id, required this.title});
}
