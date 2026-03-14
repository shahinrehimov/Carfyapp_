import 'package:carfy/common/widgets/shimmer_wrapper.dart';
import 'package:flutter/material.dart';

import 'package:carfy/common/theme/theme.dart';

class CustomDropdownField<T> extends StatefulWidget {
  final List<T> items;
  final T? value;
  final Function(T?)? onChanged;
  final String? hint;
  final String? errorText;
  final Widget? prefix;
  final Widget? suffix;
  final String Function(T)? itemLabelBuilder;
  final Widget Function(T)? itemWidgetBuilder;
  final bool isLoading;
  final bool searchable;
  final bool enabled;

  const CustomDropdownField({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.hint,
    this.errorText,
    this.prefix,
    this.suffix,
    this.itemLabelBuilder,
    this.itemWidgetBuilder,
    this.isLoading = false,
    this.searchable = false,
    this.enabled = true,
  });

  @override
  State<CustomDropdownField<T>> createState() => _CustomDropdownFieldState<T>();
}

class _CustomDropdownFieldState<T> extends State<CustomDropdownField<T>> {
  T? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value;
  }

  @override
  void didUpdateWidget(CustomDropdownField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _selectedValue = widget.value;
    }
  }

  String _labelOf(T item) => widget.itemLabelBuilder?.call(item) ?? item.toString();

  Future<void> _openBottomSheet() async {
    final result = await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DropdownBottomSheet<T>(
        items: widget.items,
        selectedValue: _selectedValue,
        isLoading: widget.isLoading,
        searchable: widget.searchable,
        labelOf: _labelOf,
        itemWidgetBuilder: widget.itemWidgetBuilder,
      ),
    );
    if (result != null) {
      setState(() => _selectedValue = result);
      widget.onChanged?.call(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = _selectedValue != null;
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: widget.enabled ? _openBottomSheet : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: hasError ? context.theme.colors.error : context.theme.colors.border,
              ),
            ),
            child: Row(
              children: [
                if (widget.prefix != null) ...[widget.prefix!, const SizedBox(width: 8)],
                Expanded(
                  child: Text(
                    hasValue ? _labelOf(_selectedValue as T) : (widget.hint ?? ''),
                    style: TextStyle(
                      fontSize: 14,
                      color: hasValue ? context.theme.colors.textDark : context.theme.colors.textLight,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                widget.suffix ??
                    Icon(Icons.arrow_drop_down, color: context.theme.colors.textDark),
              ],
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 16),
            child: Text(
              widget.errorText!,
              style: TextStyle(color: context.theme.colors.error, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

class _DropdownBottomSheet<T> extends StatefulWidget {
  final List<T> items;
  final T? selectedValue;
  final bool isLoading;
  final bool searchable;
  final String Function(T) labelOf;
  final Widget Function(T)? itemWidgetBuilder;

  const _DropdownBottomSheet({
    required this.items,
    required this.selectedValue,
    required this.isLoading,
    required this.searchable,
    required this.labelOf,
    this.itemWidgetBuilder,
  });

  @override
  State<_DropdownBottomSheet<T>> createState() => _DropdownBottomSheetState<T>();
}

class _DropdownBottomSheetState<T> extends State<_DropdownBottomSheet<T>> {
  late List<T> _filtered;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filtered = widget.items;
    _searchController.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final q = _searchController.text.toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? widget.items
          : widget.items.where((item) => widget.labelOf(item).toLowerCase().contains(q)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: context.theme.colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Drag handle
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.theme.colors.border,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              // Search field
              if (widget.searchable)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Axtar...',
                      hintStyle: TextStyle(color: context.theme.colors.textLight, fontSize: 14),
                      prefixIcon: Icon(Icons.search, color: context.theme.colors.textLight, size: 20),
                      filled: true,
                      fillColor: context.theme.colors.bg,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              // List
              Expanded(
                child: widget.isLoading
                    ? _ShimmerList()
                    : _filtered.isEmpty
                        ? Center(
                            child: Text(
                              'Nəticə tapılmadı',
                              style: TextStyle(color: context.theme.colors.textLight, fontSize: 14),
                            ),
                          )
                        : ListView.builder(
                            controller: scrollController,
                            padding: const EdgeInsets.only(bottom: 16),
                            itemCount: _filtered.length,
                            itemBuilder: (context, index) {
                              final item = _filtered[index];
                              final isSelected = widget.selectedValue == item;
                              return InkWell(
                                onTap: () => Navigator.pop(context, item),
                                child: widget.itemWidgetBuilder?.call(item) ??
                                    Container(
                                      color: isSelected
                                          ? context.theme.colors.secondary.withValues(alpha: 0.08)
                                          : Colors.transparent,
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              widget.labelOf(item),
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                                color: isSelected
                                                    ? context.theme.colors.secondary
                                                    : context.theme.colors.textDark,
                                              ),
                                            ),
                                          ),
                                          if (isSelected)
                                            Icon(Icons.check, size: 18, color: context.theme.colors.secondary),
                                        ],
                                      ),
                                    ),
                              );
                            },
                          ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      itemCount: 6,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ShimmerWrapper(
          child: Container(
            height: 20,
            decoration: BoxDecoration(
              color: context.theme.colors.border,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
