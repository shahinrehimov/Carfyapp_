import 'package:carfy/common/theme/theme.dart';
import 'package:flutter/material.dart';

class ProductDescriptionSection extends StatelessWidget {
  final String description;

  const ProductDescriptionSection({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 8),
      child: Text(
        description,
        textAlign: TextAlign.justify,
        style: TextStyle(color: context.theme.colors.textDark, fontSize: 10, fontWeight: FontWeight.w300),
      ),
    );
  }
}
