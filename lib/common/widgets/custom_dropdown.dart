import 'package:flutter/material.dart';

import 'package:carfy/common/theme/theme.dart';

class CustomDropdownField<T> extends StatefulWidget {
  final List<T> items;
  final T? value;
  final Function(T?)? onChanged;
  final String? label, hint, title;
  final bool required;
  final Widget? suffix;
  final Widget? prefix;
  final Color? color;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final TextStyle? floatingLabelStyle;
  final EdgeInsets? prefixIconConstraints;
  final EdgeInsets? padding;
  final double? fontSize;
  final bool obscureText;
  final bool hasBorder;
  final TextAlignVertical verticalTextAlign;
  final FontWeight fontWeight;
  final int? maxLength;
  final bool showCursor;
  final bool hasError;
  final String? errorText;
  final bool? enabled;
  final FormFieldValidator<T>? validator;
  final FocusNode? focusNode;
  final Widget? titleWidget;
  final String Function(T)? itemLabelBuilder;
  final Widget Function(T)? itemWidgetBuilder;
  final TextAlign? align;
  final double? height;

  const CustomDropdownField({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.label,
    this.title,
    this.required = false,
    this.focusNode,
    this.verticalTextAlign = TextAlignVertical.center,
    this.color,
    this.fillColor,
    this.borderColor,
    this.hintStyle,
    this.labelStyle,
    this.floatingLabelStyle,
    this.suffix,
    this.fontWeight = FontWeight.w400,
    this.height,
    this.showCursor = true,
    this.align = TextAlign.start,
    this.prefix,
    this.padding,
    this.hint,
    this.hasError = false,
    this.errorText,
    this.hasBorder = false,
    this.obscureText = false,
    this.fontSize,
    this.maxLength,
    this.enabled,
    this.validator,
    this.focusedBorderColor,
    this.titleWidget,
    this.itemLabelBuilder,
    this.itemWidgetBuilder,
    this.prefixIconConstraints,
  });

  @override
  State<CustomDropdownField<T>> createState() => _CustomDropdownFieldState<T>();
}

class _CustomDropdownFieldState<T> extends State<CustomDropdownField<T>> with SingleTickerProviderStateMixin {
  late T? _selectedValue;
  late FocusNode _focusNode;
  late AnimationController _animationController;
  bool _isOpen = false;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value;
    _focusNode = widget.focusNode ?? FocusNode();
    _animationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
  }

  @override
  void didUpdateWidget(CustomDropdownField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _selectedValue = widget.value;
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _animationController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _animationController.forward();
    setState(() => _isOpen = true);

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _closeDropdown,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned(
              left: offset.dx,
              top: offset.dy + size.height + 8,
              width: size.width,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(12),
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.95, end: 1.0).animate(_animationController),
                  alignment: Alignment.topCenter,
                  child: FadeTransition(
                    opacity: _animationController,
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
                      constraints: const BoxConstraints(maxHeight: 300),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: widget.items.length,

                        itemBuilder: (context, index) {
                          final item = widget.items[index];
                          final isSelected = _selectedValue == item;

                          return GestureDetector(
                            onTap: () {
                              setState(() => _selectedValue = item);
                              widget.onChanged?.call(item);
                              _closeDropdown();
                            },
                            child: Container(
                              color: isSelected
                                  ? (widget.focusedBorderColor ?? context.theme.colors.secondary).withValues(alpha: 0.1)
                                  : Colors.transparent,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              child:
                                  widget.itemWidgetBuilder?.call(item) ??
                                  Text(
                                    widget.itemLabelBuilder?.call(item) ?? item.toString(),
                                    style: TextStyle(
                                      fontSize: widget.fontSize ?? 14,
                                      color: isSelected
                                          ? (widget.focusedBorderColor ?? context.theme.colors.secondary)
                                          : (widget.color ?? context.theme.colors.textDark),
                                      fontWeight: isSelected ? FontWeight.w600 : widget.fontWeight,
                                    ),
                                  ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeDropdown() {
    _animationController.reverse();
    setState(() => _isOpen = false);
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      initialValue: _selectedValue,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (FormFieldState<T> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.titleWidget != null) widget.titleWidget!,
            GestureDetector(
              onTap: widget.enabled != false ? _toggleDropdown : null,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: _isOpen
                        ? (widget.focusedBorderColor ?? context.theme.colors.secondary)
                        : (widget.hasError
                              ? context.theme.colors.error
                              : (widget.borderColor ?? context.theme.colors.border)),
                    width: 1,
                  ),
                  color: widget.fillColor ?? Colors.transparent,
                ),
                child: Padding(
                  padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Row(
                    children: [
                      if (widget.prefix != null) ...[widget.prefix!, const SizedBox(width: 8)],
                      Expanded(
                        child: Text(
                          _selectedValue != null
                              ? (widget.itemLabelBuilder?.call(_selectedValue as T) ?? _selectedValue.toString())
                              : (widget.hint ?? ''),
                          style: TextStyle(
                            fontSize: widget.fontSize ?? 14,
                            color: _selectedValue != null
                                ? (widget.color ?? context.theme.colors.textDark)
                                : (widget.hintStyle?.color ?? context.theme.colors.textLight),
                            fontWeight: widget.fontWeight,
                          ),
                        ),
                      ),
                      if (widget.suffix != null) ...[
                        const SizedBox(width: 8),
                        widget.suffix!,
                      ] else
                        RotationTransition(
                          turns: Tween(begin: 0.0, end: 0.5).animate(_animationController),
                          child: Icon(Icons.arrow_drop_down, color: widget.color ?? context.theme.colors.textDark),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(field.errorText ?? '', style: TextStyle(color: context.theme.colors.error, fontSize: 12)),
              ),
          ],
        );
      },
    );
  }
}
