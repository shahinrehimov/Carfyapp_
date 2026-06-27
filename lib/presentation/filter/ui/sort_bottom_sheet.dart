import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/domain/entities/products/sort_option.dart';
import 'package:carfy/presentation/filter/state/filter_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SortSelection {
  final String sort;
  final String sortType;

  const SortSelection({required this.sort, required this.sortType});
}

class SortBottomSheet extends StatelessWidget {
  final String? currentSort;
  final String? currentSortType;

  const SortBottomSheet({super.key, this.currentSort, this.currentSortType});

  static Future<SortSelection?> show(BuildContext context, {String? currentSort, String? currentSortType}) {
    final cubit = context.read<FilterCubit>();
    return showModalBottomSheet<SortSelection>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: SortBottomSheet(currentSort: currentSort, currentSortType: currentSortType),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filters = context.read<FilterCubit>().state.filtersData;
    final sortOptions = filters?.sortOptions ?? const <SortOption>[];
    final sortTypes = filters?.sortTypes ?? const <SortOption>[];

    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 11, bottom: 8),
            child: Container(
              width: 54,
              height: 3,
              decoration: BoxDecoration(color: const Color(0xFFD9D9D9), borderRadius: BorderRadius.circular(100)),
            ),
          ),
          Text(
            context.localization.sorting,
            style: TextStyle(color: context.theme.colors.textDark, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          for (final option in sortOptions)
            for (final type in sortTypes)
              _SortRow(
                title: '${option.title} - ${type.title}',
                selected: currentSort == option.id && currentSortType == type.id,
                onTap: () {
                  Navigator.of(context).pop(SortSelection(sort: option.id, sortType: type.id));
                },
              ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _SortRow extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _SortRow({required this.title, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: context.theme.colors.textDark,
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: selected ? context.theme.colors.primary : const Color(0xFFDFDFDF), width: 2),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: context.theme.colors.primary),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
