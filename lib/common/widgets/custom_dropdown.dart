import 'package:carfy/common/translations/translation_context_extension.dart';
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
  final bool hasError;
  final VoidCallback? onRetry;
  final bool searchable;
  final bool enabled;
  final double borderRadius;
  final String? sheetTitle;
  final String? title;

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
    this.hasError = false,
    this.onRetry,
    this.searchable = false,
    this.enabled = true,
    this.borderRadius = 40,
    this.sheetTitle,
    this.title,
  });

  @override
  State<CustomDropdownField<T>> createState() => _CustomDropdownFieldState<T>();
}

class _CustomDropdownFieldState<T> extends State<CustomDropdownField<T>> {
  T? _selectedValue;
  late final ValueNotifier<List<T>> _itemsNotifier;
  late final ValueNotifier<bool> _isLoadingNotifier;
  late final ValueNotifier<bool> _hasErrorNotifier;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value;
    _itemsNotifier = ValueNotifier(widget.items);
    _isLoadingNotifier = ValueNotifier(widget.isLoading);
    _hasErrorNotifier = ValueNotifier(widget.hasError);
  }

  @override
  void didUpdateWidget(CustomDropdownField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _selectedValue = widget.value;
    }
    final itemsChanged = oldWidget.items != widget.items;
    final loadingChanged = oldWidget.isLoading != widget.isLoading;
    final errorChanged = oldWidget.hasError != widget.hasError;
    if (itemsChanged || loadingChanged || errorChanged) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (itemsChanged) _itemsNotifier.value = widget.items;
        if (loadingChanged) _isLoadingNotifier.value = widget.isLoading;
        if (errorChanged) _hasErrorNotifier.value = widget.hasError;
      });
    }
  }

  @override
  void dispose() {
    _itemsNotifier.dispose();
    _isLoadingNotifier.dispose();
    _hasErrorNotifier.dispose();
    super.dispose();
  }

  String _labelOf(T item) => widget.itemLabelBuilder?.call(item) ?? item.toString();

  Future<void> _openBottomSheet() async {
    final result = await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DropdownBottomSheet<T>(
        itemsNotifier: _itemsNotifier,
        isLoadingNotifier: _isLoadingNotifier,
        hasErrorNotifier: _hasErrorNotifier,
        onRetry: widget.onRetry,
        selectedValue: _selectedValue,
        searchable: widget.searchable,
        labelOf: _labelOf,
        itemWidgetBuilder: widget.itemWidgetBuilder,
        title: widget.sheetTitle,
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
        if (widget.title != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(widget.title!, style: TextStyle(color: context.theme.colors.textLight, fontSize: 14)),
          ),
          const SizedBox(height: 8),
        ],
        GestureDetector(
          onTap: widget.enabled ? _openBottomSheet : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(color: hasError ? context.theme.colors.error : context.theme.colors.border),
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
                widget.suffix ?? Icon(Icons.arrow_drop_down, color: context.theme.colors.textDark),
              ],
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 16),
            child: Text(widget.errorText!, style: TextStyle(color: context.theme.colors.error, fontSize: 12)),
          ),
      ],
    );
  }
}

class _DropdownBottomSheet<T> extends StatefulWidget {
  final ValueNotifier<List<T>> itemsNotifier;
  final ValueNotifier<bool> isLoadingNotifier;
  final ValueNotifier<bool> hasErrorNotifier;
  final VoidCallback? onRetry;
  final T? selectedValue;
  final bool searchable;
  final String Function(T) labelOf;
  final Widget Function(T)? itemWidgetBuilder;
  final String? title;

  const _DropdownBottomSheet({
    required this.itemsNotifier,
    required this.isLoadingNotifier,
    required this.hasErrorNotifier,
    required this.selectedValue,
    required this.searchable,
    required this.labelOf,
    this.onRetry,
    this.itemWidgetBuilder,
    this.title,
  });

  @override
  State<_DropdownBottomSheet<T>> createState() => _DropdownBottomSheetState<T>();
}

class _DropdownBottomSheetState<T> extends State<_DropdownBottomSheet<T>> {
  List<T> _filtered = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filtered = widget.itemsNotifier.value;
    _searchController.addListener(_onSearch);
    widget.itemsNotifier.addListener(_onItemsChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    widget.itemsNotifier.removeListener(_onItemsChanged);
    super.dispose();
  }

  void _onItemsChanged() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final q = _searchController.text.toLowerCase();
      setState(() {
        _filtered = q.isEmpty
            ? widget.itemsNotifier.value
            : widget.itemsNotifier.value.where((item) => widget.labelOf(item).toLowerCase().contains(q)).toList();
      });
    });
  }

  void _onSearch() {
    final q = _searchController.text.toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? widget.itemsNotifier.value
          : widget.itemsNotifier.value.where((item) => widget.labelOf(item).toLowerCase().contains(q)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
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
              // Title
              if (widget.title != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    widget.title!,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: context.theme.colors.textDark),
                  ),
                ),
              // Search field
              if (widget.searchable)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: TextField(
                    controller: _searchController,
                    autofocus: false,
                    enableSuggestions: false,
                    onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: context.localization.searchHint,
                      hintStyle: TextStyle(color: context.theme.colors.textLight, fontSize: 14),
                      prefixIcon: Icon(Icons.search, color: context.theme.colors.textLight, size: 20),
                      filled: true,
                      fillColor: context.theme.colors.bg,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(40), borderSide: BorderSide.none),
                    ),
                  ),
                ),
              // List
              Expanded(
                child: ListenableBuilder(
                  listenable: Listenable.merge([widget.isLoadingNotifier, widget.hasErrorNotifier]),
                  builder: (context, _) {
                    final isLoading = widget.isLoadingNotifier.value;
                    final hasError = widget.hasErrorNotifier.value;
                    if (isLoading) return _ShimmerList();
                    if (hasError && _filtered.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.wifi_off_rounded, size: 40, color: context.theme.colors.textLight),
                            const SizedBox(height: 12),
                            Text(
                              'Xəta baş verdi',
                              style: TextStyle(color: context.theme.colors.textLight, fontSize: 14),
                            ),
                            if (widget.onRetry != null) ...[
                              const SizedBox(height: 12),
                              GestureDetector(
                                onTap: widget.onRetry,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(colors: [Color(0xFF3696E7), Color(0xFF00569C)]),
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: const Text(
                                    'Yenidən cəhd et',
                                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    }
                    if (_filtered.isEmpty) {
                      return Center(
                        child: Text(
                          'Nəticə tapılmadı',
                          style: TextStyle(color: context.theme.colors.textLight, fontSize: 14),
                        ),
                      );
                    }
                    return ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: _filtered.length,
                      itemBuilder: (context, index) {
                        final item = _filtered[index];
                        final isSelected = widget.selectedValue == item;
                        return InkWell(
                          onTap: () => Navigator.pop(context, item),
                          child:
                              widget.itemWidgetBuilder?.call(item) ??
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
                                    if (isSelected) Icon(Icons.check, size: 18, color: context.theme.colors.secondary),
                                  ],
                                ),
                              ),
                        );
                      },
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
            decoration: BoxDecoration(color: context.theme.colors.border, borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
    );
  }
}
