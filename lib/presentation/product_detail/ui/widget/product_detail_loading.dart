import 'package:carfy/common/widgets/shimmer_wrapper.dart';
import 'package:flutter/material.dart';

class ProductDetailLoading extends StatelessWidget {
  const ProductDetailLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            ),
            const SizedBox(height: 16),
            Container(width: 250, height: 20, color: Colors.white),
            const SizedBox(height: 8),
            Container(width: 180, height: 16, color: Colors.white),
            const SizedBox(height: 16),
            Container(width: 120, height: 14, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
