import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/presentation/product_list/state/product_list_params_ui.dart';
import 'package:flutter/material.dart';

import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/domain/entities/categories/category.dart';

class CategoryItem extends StatelessWidget {
  final Category category;
  final VoidCallback? onTap;

  const CategoryItem({super.key, required this.category, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          onTap ??
          () => context.pushRoute(ProductListRoute(params: ProductListPageParams(categories: [category.slug]))),
      child: Container(
        width: 124,
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: context.theme.colors.white,
          border: Border.all(width: 1, color: context.theme.colors.border2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CachedNetworkImage(imageUrl: category.image, fit: BoxFit.contain, height: 32),
            const SizedBox(height: 4),
            Text(
              category.title,
              style: TextStyle(color: context.theme.colors.primary, fontSize: 10, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
