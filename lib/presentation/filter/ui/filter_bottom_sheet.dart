import 'package:carfy/common/constants/preference_keys.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/util/pref_util.dart';
import 'package:carfy/common/widgets/custom_button.dart';
import 'package:carfy/common/widgets/custom_dropdown.dart';
import 'package:carfy/common/widgets/shimmer_wrapper.dart';
import 'package:carfy/domain/entities/products/brand_model_item.dart';
import 'package:carfy/domain/entities/products/filter_brand.dart';
import 'package:carfy/domain/entities/products/product_filters.dart';
import 'package:carfy/gen/assets.gen.dart';
import 'package:carfy/presentation/filter/state/filter_cubit.dart';
import 'package:carfy/presentation/filter/ui/car_picker_bottom_sheet.dart';
import 'package:carfy/presentation/filter/ui/category_picker_bottom_sheet.dart';
import 'package:carfy/presentation/filter/ui/multi_select_picker_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  static Future<bool?> show(BuildContext context) {
    final cubit = context.read<FilterCubit>();
    cubit.saveSnapshot();
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(value: cubit, child: const FilterBottomSheet()),
    ).then((applied) {
      if (applied != true) {
        cubit.restoreSnapshot();
      }
      return applied;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.95,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      snap: true,
      snapSizes: const [0.95],
      shouldCloseOnMinExtent: true,
      builder: (context, scrollController) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.white,
            body: BlocBuilder<FilterCubit, FilterState>(
              buildWhen: (prev, curr) => prev.loadStatus != curr.loadStatus,
              builder: (context, state) {
                return state.loadStatus.maybeWhen(
                  success: () => _FilterContent(scrollController: scrollController),
                  loading: () => _FilterLoading(scrollController: scrollController),
                  orElse: () => _FilterLoading(scrollController: scrollController),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _FilterContent extends StatelessWidget {
  final ScrollController scrollController;

  const _FilterContent({required this.scrollController});

  List<int> _buildYearList(ProductFilters filters) {
    final yearRange = filters.yearRange;
    if (yearRange == null) return [];
    return List.generate(yearRange.max - yearRange.min + 1, (i) => yearRange.max - i);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterCubit, FilterState>(
      builder: (context, state) {
        final filters = state.filtersData!;
        final cubit = context.read<FilterCubit>();

        return ListView(
          controller: scrollController,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
          children: [
            // Drag handle
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 11, bottom: 8),
                child: Container(
                  width: 54,
                  height: 3,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ),
            // Title
            Center(
              child: Text(
                context.localization.filter,
                style: TextStyle(
                  color: context.theme.colors.textDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Brand
            // Category
            GestureDetector(
              onTap: () async {
                final result = await CategoryPickerBottomSheet.show(
                  context,
                  categories: filters.categories,
                  initialCategories: state.selectedCategories,
                  initialSubCategories: state.selectedSubCategories,
                );
                if (result != null) {
                  cubit.setCategories(result.categories, result.subCategories);
                }
              },
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: context.theme.colors.border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        state.selectedCategoryCount > 0
                            ? '${state.selectedCategoryCount} ${context.localization.categoriesSelected}'
                            : context.localization.categories,
                        style: TextStyle(
                          fontSize: 14,
                          color: state.selectedCategoryCount > 0
                              ? context.theme.colors.textDark
                              : context.theme.colors.textLight,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_drop_down, color: context.theme.colors.textDark),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Brand
            CustomDropdownField<FilterBrand>(
              items: filters.brands,
              value: state.selectedBrand,
              hint: context.localization.brand,
              searchable: true,
              itemLabelBuilder: (b) => b.title,
              onChanged: (b) => cubit.selectBrand(b),
            ),
            const SizedBox(height: 12),
            // Model
            CustomDropdownField<BrandModelItem>(
              items: state.selectedBrand?.models ?? [],
              value: state.selectedModel,
              hint: context.localization.filterModel,
              searchable: true,
              itemLabelBuilder: (m) => m.title,
              onChanged: (m) => cubit.selectModel(m),
              enabled: state.selectedBrand != null,
            ),
            const SizedBox(height: 12),
            // City
            _MultiSelectField(
              hint: context.localization.city,
              selectedCount: state.selectedCityIds.length,
              onTap: () async {
                final result = await MultiSelectPickerBottomSheet.show<int>(
                  context,
                  title: context.localization.city,
                  doneText: context.localization.categoryDone,
                  items: filters.cities.map((c) => c.id).toList(),
                  initialSelected: state.selectedCityIds,
                  labelBuilder: (id) => filters.cities.firstWhere((c) => c.id == id).title,
                );
                if (result != null) cubit.setCities(result);
              },
            ),
            const SizedBox(height: 12),
            // Color
            _MultiSelectField(
              hint: context.localization.filterColor,
              selectedCount: state.selectedColorSlugs.length,
              onTap: () async {
                final result = await MultiSelectPickerBottomSheet.show<String>(
                  context,
                  title: context.localization.filterColor,
                  doneText: context.localization.categoryDone,
                  items: filters.colors.map((c) => c.slug).toList(),
                  initialSelected: state.selectedColorSlugs,
                  labelBuilder: (slug) => filters.colors.firstWhere((c) => c.slug == slug).title,
                );
                if (result != null) cubit.setColors(result);
              },
            ),
            const SizedBox(height: 12),
            // Year range
            _SplitDropdownRow(
              leftHint: context.localization.filterYearMin,
              rightHint: context.localization.filterYearMax,
              leftValue: state.minYear?.toString(),
              rightValue: state.maxYear?.toString(),
              items: _buildYearList(filters).map((y) => y.toString()).toList(),
              onLeftChanged: (v) => cubit.selectMinYear(v != null ? int.tryParse(v) : null),
              onRightChanged: (v) => cubit.selectMaxYear(v != null ? int.tryParse(v) : null),
            ),
            const SizedBox(height: 12),
            // Price range
            _RangeRow(
              minHint: context.localization.filterPriceMin,
              maxHint: context.localization.filterPriceMax,
              minValue: state.minPrice ?? '',
              maxValue: state.maxPrice ?? '',
              onMinChanged: cubit.setMinPrice,
              onMaxChanged: cubit.setMaxPrice,
              allowDecimal: true,
            ),
            const SizedBox(height: 12),
            // Condition
            _MultiSelectField(
              hint: context.localization.filterCondition,
              selectedCount: state.selectedConditionSlugs.length,
              onTap: () async {
                final result = await MultiSelectPickerBottomSheet.show<String>(
                  context,
                  title: context.localization.filterCondition,
                  doneText: context.localization.categoryDone,
                  items: filters.conditions.map((c) => c.slug).toList(),
                  initialSelected: state.selectedConditionSlugs,
                  labelBuilder: (slug) => filters.conditions.firstWhere((c) => c.slug == slug).title,
                );
                if (result != null) cubit.setConditions(result);
              },
            ),
            if (PrefUtil.getString(AppPreferenceKeys.authToken) != null) ...[
              const SizedBox(height: 16),
              // Search by car button
              CustomButton(
                onPressed: () async {
                  final car = await CarPickerBottomSheet.show(context);
                  if (car != null && context.mounted) {
                    cubit.selectByCar(car.brand.id, car.brandModel.id);
                    cubit.apply();
                    Navigator.pop(context, true);
                  }
                },
                text: context.localization.filterSearchByCar,
                height: 48,
              ),
            ],
            const SizedBox(height: 16),
            // Apply button
            CustomButton(
              onPressed: () {
                cubit.apply();
                Navigator.pop(context, true);
              },
              text: context.localization.filterShow,
              height: 56,
            ),
            const SizedBox(height: 16),
            // Reset
            GestureDetector(
              onTap: () => cubit.reset(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.localization.filterReset,
                    style: TextStyle(color: context.theme.colors.primary, fontSize: 14, fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(width: 4),
                  SvgPicture.asset(Assets.icons.reset1),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}

class _RangeRow extends StatelessWidget {
  final String minHint;
  final String maxHint;
  final String minValue;
  final String maxValue;
  final ValueChanged<String> onMinChanged;
  final ValueChanged<String> onMaxChanged;
  final bool allowDecimal;

  const _RangeRow({
    required this.minHint,
    required this.maxHint,
    required this.minValue,
    required this.maxValue,
    required this.onMinChanged,
    required this.onMaxChanged,
    this.allowDecimal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: const Color(0xFFEAEAF0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _RangeInput(hint: minHint, value: minValue, onChanged: onMinChanged, allowDecimal: allowDecimal),
          ),
          Container(width: 1, height: 48, color: const Color(0xFFD8D6D6)),
          Expanded(
            child: _RangeInput(hint: maxHint, value: maxValue, onChanged: onMaxChanged, allowDecimal: allowDecimal),
          ),
        ],
      ),
    );
  }
}

class _RangeInput extends StatefulWidget {
  final String hint;
  final String value;
  final ValueChanged<String> onChanged;
  final bool allowDecimal;

  const _RangeInput({required this.hint, required this.value, required this.onChanged, this.allowDecimal = false});

  @override
  State<_RangeInput> createState() => _RangeInputState();
}

class _RangeInputState extends State<_RangeInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(_RangeInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      keyboardType: TextInputType.numberWithOptions(decimal: widget.allowDecimal),
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      inputFormatters: [
        widget.allowDecimal
            ? FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))
            : FilteringTextInputFormatter.digitsOnly,
      ],
      style: TextStyle(color: context.theme.colors.textDark, fontSize: 14, fontWeight: FontWeight.w300),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: TextStyle(color: context.theme.colors.textDark, fontSize: 14, fontWeight: FontWeight.w300),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}

class _SplitDropdownRow extends StatelessWidget {
  final String leftHint;
  final String rightHint;
  final String? leftValue;
  final String? rightValue;
  final List<String> items;
  final ValueChanged<String?> onLeftChanged;
  final ValueChanged<String?> onRightChanged;

  const _SplitDropdownRow({
    required this.leftHint,
    required this.rightHint,
    this.leftValue,
    this.rightValue,
    required this.items,
    required this.onLeftChanged,
    required this.onRightChanged,
  });

  Future<void> _showPicker(BuildContext context, String? current, ValueChanged<String?> onChanged) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        expand: false,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final isSelected = item == current;
              return InkWell(
                onTap: () => Navigator.pop(context, item),
                child: Container(
                  color: isSelected ? const Color(0x143696E7) : Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? const Color(0xFF3696E7) : const Color(0xFF242323),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
    if (result != null) onChanged(result);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: const Color(0xFFEAEAF0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _showPicker(context, leftValue, onLeftChanged),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        leftValue ?? leftHint,
                        style: const TextStyle(color: Color(0xFF242323), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down, color: Color(0xFF242323), size: 26),
                  ],
                ),
              ),
            ),
          ),
          Container(width: 1, height: 48, color: const Color(0xFFD8D6D6)),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _showPicker(context, rightValue, onRightChanged),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        rightValue ?? rightHint,
                        style: const TextStyle(color: Color(0xFF242323), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down, color: Color(0xFF242323), size: 26),
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

class _MultiSelectField extends StatelessWidget {
  final String hint;
  final int selectedCount;
  final VoidCallback onTap;

  const _MultiSelectField({
    required this.hint,
    required this.selectedCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: context.theme.colors.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedCount > 0 ? '$selectedCount seçilib' : hint,
                style: TextStyle(
                  fontSize: 14,
                  color: selectedCount > 0
                      ? context.theme.colors.textDark
                      : context.theme.colors.textLight,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Icon(Icons.arrow_drop_down, color: context.theme.colors.textDark),
          ],
        ),
      ),
    );
  }
}

class _FilterLoading extends StatelessWidget {
  final ScrollController scrollController;

  const _FilterLoading({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 11, bottom: 8),
            child: Container(
              width: 54,
              height: 3,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
        ),
        Center(
          child: Text(
            context.localization.filter,
            style: TextStyle(
              color: context.theme.colors.textDark,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ShimmerWrapper(
          child: Column(
            children: List.generate(
              6,
              (_) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(40)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
