import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/presentation/product_list/state/product_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductListHeader extends StatelessWidget {
  const ProductListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 12, top: 16),
      child: BlocBuilder<ProductListCubit, ProductListState>(
        buildWhen: (prev, curr) => prev.totalCount != curr.totalCount || prev.hasFilters != curr.hasFilters,
        builder: (context, state) {
          final headerTitle = state.hasFilters ? context.localization.searchResults : context.localization.allProducts;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                headerTitle,
                style: TextStyle(color: context.theme.colors.primary, fontSize: 12, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Text(
                '${state.totalCount} ${context.localization.productsFound}',
                style: const TextStyle(color: Color(0xFF5F5F5F), fontSize: 12, fontWeight: FontWeight.w300),
              ),
            ],
          );
        },
      ),
    );
  }
}
