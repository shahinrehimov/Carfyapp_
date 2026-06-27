import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_button.dart';
import 'package:carfy/domain/entities/products/filter_category.dart';
import 'package:flutter/material.dart';

class CategoryPickerResult {
  final Set<String> categories;
  final Set<String> subCategories;

  const CategoryPickerResult({required this.categories, required this.subCategories});
}

class CategoryPickerBottomSheet extends StatefulWidget {
  final List<FilterCategory> categories;
  final Set<String> initialCategories;
  final Set<String> initialSubCategories;

  const CategoryPickerBottomSheet({
    super.key,
    required this.categories,
    this.initialCategories = const {},
    this.initialSubCategories = const {},
  });

  static Future<CategoryPickerResult?> show(
    BuildContext context, {
    required List<FilterCategory> categories,
    Set<String> initialCategories = const {},
    Set<String> initialSubCategories = const {},
  }) {
    return showModalBottomSheet<CategoryPickerResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CategoryPickerBottomSheet(
        categories: categories,
        initialCategories: initialCategories,
        initialSubCategories: initialSubCategories,
      ),
    );
  }

  @override
  State<CategoryPickerBottomSheet> createState() => _CategoryPickerBottomSheetState();
}

class _CategoryPickerBottomSheetState extends State<CategoryPickerBottomSheet> {
  late Set<String> _selectedCategories;
  late Set<String> _selectedSubCategories;
  final Set<String> _expandedCategories = {};

  @override
  void initState() {
    super.initState();
    _selectedCategories = Set.from(widget.initialCategories);
    _selectedSubCategories = Set.from(widget.initialSubCategories);
    // Expand parent selections to children so toggle logic works correctly
    for (final parent in widget.categories) {
      if (_selectedCategories.contains(parent.slug) && parent.children.isNotEmpty) {
        for (final child in parent.children) {
          _selectedSubCategories.add(child.slug);
        }
      }
    }
  }

  bool _isParentChecked(FilterCategory parent) {
    if (_selectedCategories.contains(parent.slug)) return true;
    if (parent.children.isEmpty) return false;
    return parent.children.every((child) => _selectedSubCategories.contains(child.slug));
  }

  bool _isParentPartial(FilterCategory parent) {
    if (_selectedCategories.contains(parent.slug)) return false;
    if (parent.children.isEmpty) return false;
    final checkedCount = parent.children.where((c) => _selectedSubCategories.contains(c.slug)).length;
    return checkedCount > 0 && checkedCount < parent.children.length;
  }

  void _toggleParent(FilterCategory parent) {
    setState(() {
      if (_isParentChecked(parent)) {
        _selectedCategories.remove(parent.slug);
        for (final child in parent.children) {
          _selectedSubCategories.remove(child.slug);
        }
      } else {
        if (parent.children.isEmpty) {
          _selectedCategories.add(parent.slug);
        } else {
          _selectedCategories.remove(parent.slug);
          for (final child in parent.children) {
            _selectedSubCategories.add(child.slug);
          }
        }
      }
    });
  }

  void _toggleChild(FilterCategory parent, FilterCategory child) {
    setState(() {
      if (_selectedSubCategories.contains(child.slug)) {
        _selectedSubCategories.remove(child.slug);
        _selectedCategories.remove(parent.slug);
      } else {
        _selectedSubCategories.add(child.slug);
        // If all children selected, mark parent
        if (parent.children.every((c) => _selectedSubCategories.contains(c.slug))) {
          _selectedCategories.add(parent.slug);
        }
      }
    });
  }

  void _toggleExpand(String slug) {
    setState(() {
      if (_expandedCategories.contains(slug)) {
        _expandedCategories.remove(slug);
      } else {
        _expandedCategories.add(slug);
      }
    });
  }

  void _confirm() {
    // Clean up: if all children selected, use parent slug in categories instead of individual subs
    final resultCategories = <String>{};
    final resultSubCategories = <String>{};

    for (final parent in widget.categories) {
      if (parent.children.isEmpty) {
        if (_selectedCategories.contains(parent.slug)) {
          resultCategories.add(parent.slug);
        }
      } else {
        final allChildrenSelected = parent.children.every((c) => _selectedSubCategories.contains(c.slug));
        if (allChildrenSelected) {
          resultCategories.add(parent.slug);
        } else {
          for (final child in parent.children) {
            if (_selectedSubCategories.contains(child.slug)) {
              resultSubCategories.add(child.slug);
            }
          }
        }
      }
    }

    Navigator.pop(context, CategoryPickerResult(categories: resultCategories, subCategories: resultSubCategories));
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Material(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              // Drag handle
              Padding(
                padding: const EdgeInsets.only(top: 11, bottom: 8),
                child: Container(
                  width: 54,
                  height: 3,
                  decoration: BoxDecoration(color: const Color(0xFFD9D9D9), borderRadius: BorderRadius.circular(100)),
                ),
              ),
              // Title
              Text(
                context.localization.selectCategory,
                style: TextStyle(color: context.theme.colors.textDark, fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              // List
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: widget.categories.length,
                  itemBuilder: (context, index) {
                    final parent = widget.categories[index];
                    final isExpanded = _expandedCategories.contains(parent.slug);
                    final isChecked = _isParentChecked(parent);
                    final isPartial = _isParentPartial(parent);

                    return Column(
                      children: [
                        // Parent row
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => _toggleParent(parent),
                                behavior: HitTestBehavior.opaque,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: _CheckboxIcon(checked: isChecked, partial: isPartial),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: parent.children.isNotEmpty
                                      ? () => _toggleExpand(parent.slug)
                                      : () => _toggleParent(parent),
                                  behavior: HitTestBehavior.opaque,
                                  child: Text(
                                    parent.title,
                                    style: TextStyle(
                                      color: context.theme.colors.textDark,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              if (parent.children.isNotEmpty)
                                GestureDetector(
                                  onTap: () => _toggleExpand(parent.slug),
                                  behavior: HitTestBehavior.opaque,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: AnimatedRotation(
                                      turns: isExpanded ? 0.5 : 0,
                                      duration: const Duration(milliseconds: 200),
                                      child: Icon(
                                        Icons.keyboard_arrow_down,
                                        size: 24,
                                        color: context.theme.colors.textLight,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        // Children (accordion)
                        if (isExpanded && parent.children.isNotEmpty)
                          ...parent.children.map((child) {
                            final isChildChecked = _selectedSubCategories.contains(child.slug);
                            return InkWell(
                              onTap: () => _toggleChild(parent, child),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 36, top: 8, bottom: 8),
                                child: Row(
                                  children: [
                                    _CheckboxIcon(checked: isChildChecked),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        child.title,
                                        style: TextStyle(
                                          color: context.theme.colors.textDark,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        const Divider(height: 1, color: Color(0xFFEDEDED)),
                      ],
                    );
                  },
                ),
              ),
              // Done button
              Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 8,
                  bottom: MediaQuery.of(context).padding.bottom + 16,
                ),
                child: CustomButton(onPressed: _confirm, text: context.localization.categoryDone, height: 48),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CheckboxIcon extends StatelessWidget {
  final bool checked;
  final bool partial;

  const _CheckboxIcon({required this.checked, this.partial = false});

  @override
  Widget build(BuildContext context) {
    if (checked) {
      return Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(color: context.theme.colors.secondary, borderRadius: BorderRadius.circular(4)),
        child: const Icon(Icons.check, size: 16, color: Colors.white),
      );
    }
    if (partial) {
      return Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(color: context.theme.colors.secondary, borderRadius: BorderRadius.circular(4)),
        child: const Icon(Icons.remove, size: 16, color: Colors.white),
      );
    }
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD8D6D6), width: 1.5),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
