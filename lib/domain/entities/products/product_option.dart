class ProductOption {
  final OptionInfo option;
  final OptionItem item;

  ProductOption({
    required this.option,
    required this.item,
  });
}

class OptionInfo {
  final int id;
  final String title;

  OptionInfo({
    required this.id,
    required this.title,
  });
}

class OptionItem {
  final int id;
  final String title;

  OptionItem({
    required this.id,
    required this.title,
  });
}
