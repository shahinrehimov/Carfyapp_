import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_button.dart';
import 'package:carfy/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MultiSelectPickerBottomSheet<T> extends StatefulWidget {
  final String title;
  final String doneText;
  final List<T> items;
  final Set<T> initialSelected;
  final String Function(T) labelBuilder;

  const MultiSelectPickerBottomSheet({
    super.key,
    required this.title,
    required this.doneText,
    required this.items,
    required this.initialSelected,
    required this.labelBuilder,
  });

  static Future<Set<T>?> show<T>(
    BuildContext context, {
    required String title,
    required String doneText,
    required List<T> items,
    required Set<T> initialSelected,
    required String Function(T) labelBuilder,
  }) {
    return showModalBottomSheet<Set<T>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MultiSelectPickerBottomSheet<T>(
        title: title,
        doneText: doneText,
        items: items,
        initialSelected: initialSelected,
        labelBuilder: labelBuilder,
      ),
    );
  }

  @override
  State<MultiSelectPickerBottomSheet<T>> createState() => _MultiSelectPickerBottomSheetState<T>();
}

class _MultiSelectPickerBottomSheetState<T> extends State<MultiSelectPickerBottomSheet<T>> {
  late Set<T> _selected;
  final _searchController = TextEditingController();
  List<T> _filtered = [];

  @override
  void initState() {
    super.initState();
    _selected = Set.from(widget.initialSelected);
    _filtered = widget.items;
    _searchController.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filtered = query.isEmpty
          ? widget.items
          : widget.items.where((item) => widget.labelBuilder(item).toLowerCase().contains(query)).toList();
    });
  }

  void _toggle(T item) {
    setState(() {
      if (_selected.contains(item)) {
        _selected.remove(item);
      } else {
        _selected.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Material(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: Column(
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
                widget.title,
                style: TextStyle(color: context.theme.colors.textDark, fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              // Search
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 12),
                child: TextField(
                  controller: _searchController,
                  onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
                  style: TextStyle(color: context.theme.colors.textDark, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: context.localization.searchHint,
                    hintStyle: TextStyle(color: context.theme.colors.textLight, fontSize: 14),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 8),
                      child: SvgPicture.asset(Assets.icons.search, width: 18),
                    ),
                    prefixIconConstraints: const BoxConstraints(maxHeight: 18),
                    filled: true,
                    fillColor: context.theme.colors.bg,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(40), borderSide: BorderSide.none),
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filtered.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFEDEDED)),
                  itemBuilder: (context, index) {
                    final item = _filtered[index];
                    final isChecked = _selected.contains(item);
                    return InkWell(
                      onTap: () => _toggle(item),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            _CheckboxIcon(checked: isChecked),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                widget.labelBuilder(item),
                                style: TextStyle(
                                  color: context.theme.colors.textDark,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 8,
                  bottom: MediaQuery.of(context).padding.bottom + 16,
                ),
                child: CustomButton(
                  onPressed: () => Navigator.pop(context, _selected),
                  text: widget.doneText,
                  height: 48,
                ),
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

  const _CheckboxIcon({required this.checked});

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
