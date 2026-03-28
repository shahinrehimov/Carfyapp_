import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/widgets/shimmer_wrapper.dart';
import 'package:carfy/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductDetailLoading extends StatelessWidget {
  const ProductDetailLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => context.router.maybePop(),
                  icon: SvgPicture.asset(Assets.icons.arrowNarrowLeft),
                ),
              ],
            ),
          ),
          Expanded(
            child: ShimmerWrapper(
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
            ),
          ),
        ],
      ),
    );
  }
}
