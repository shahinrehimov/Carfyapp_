import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../theme/theme.dart';

class ShimmerWrapper extends StatelessWidget {
  final Widget child;

  const ShimmerWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.theme.colors.shimmerBaseColor,
      highlightColor: context.theme.colors.shimmerHighlightColor,
      child: child,
    );
  }
}
