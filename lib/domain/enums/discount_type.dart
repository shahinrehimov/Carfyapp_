enum DiscountType {
  percentage('by_percentage'),
  amount('by_amount');

  final String value;

  const DiscountType(this.value);

  static DiscountType? fromString(String? value) {
    if (value == null) return null;
    for (final type in DiscountType.values) {
      if (type.value == value) return type;
    }
    return null;
  }
}
