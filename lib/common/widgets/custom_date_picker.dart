import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/theme.dart';

class CustomDatePickerField extends StatefulWidget {
  final DateTime? value;
  final Function(DateTime?)? onChanged;
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
  final TextAlignVertical verticalTextAlign;
  final FontWeight fontWeight;
  final bool hasError;
  final String? errorText;
  final bool? enabled;
  final FormFieldValidator<DateTime>? validator;
  final FocusNode? focusNode;
  final Widget? titleWidget;
  final String Function(DateTime, BuildContext)? dateFormatBuilder;
  final TextAlign? align;
  final double? height;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const CustomDatePickerField({
    super.key,
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
    this.align = TextAlign.start,
    this.prefix,
    this.padding,
    this.hint,
    this.hasError = false,
    this.errorText,
    this.fontSize,
    this.enabled,
    this.validator,
    this.focusedBorderColor,
    this.titleWidget,
    this.dateFormatBuilder,
    this.prefixIconConstraints,
    this.firstDate,
    this.lastDate,
  });

  @override
  State<CustomDatePickerField> createState() => _CustomDatePickerFieldState();
}

class _CustomDatePickerFieldState extends State<CustomDatePickerField> {
  late DateTime? _selectedDate;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.value;
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void didUpdateWidget(CustomDatePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _selectedDate = widget.value;
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _openDatePicker() {
    showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: CupertinoColors.white,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.4,
          ),
          child: SafeArea(
            top: false,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: _selectedDate ?? DateTime.now(),
              minimumDate: widget.firstDate ?? DateTime(1900),
              maximumDate: widget.lastDate ?? DateTime(2100),
              onDateTimeChanged: (DateTime newDateTime) {
                setState(() => _selectedDate = newDateTime);
                widget.onChanged?.call(newDateTime);
              },
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    if (widget.dateFormatBuilder != null) {
      return widget.dateFormatBuilder!(date, context);
    }
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      initialValue: _selectedDate,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (FormFieldState<DateTime> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.titleWidget != null) widget.titleWidget!,
            GestureDetector(
              onTap: widget.enabled != false ? _openDatePicker : null,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: widget.hasError
                        ? context.theme.colors.error
                        : (widget.borderColor ?? context.theme.colors.border),
                    width: 1,
                  ),
                  color: widget.fillColor ?? Colors.transparent,
                ),
                child: Padding(
                  padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  child: Row(
                    children: [
                      if (widget.prefix != null) ...[widget.prefix!, const SizedBox(width: 8)],
                      Expanded(
                        child: Text(
                          _selectedDate != null ? _formatDate(_selectedDate!) : (widget.hint ?? ''),
                          style: TextStyle(
                            fontSize: widget.fontSize ?? 14,
                            color: _selectedDate != null
                                ? (widget.color ?? context.theme.colors.textDark)
                                : (widget.hintStyle?.color ?? context.theme.colors.textLight),
                            fontWeight: widget.fontWeight,
                          ),
                        ),
                      ),
                      if (widget.suffix != null) ...[
                        const SizedBox(width: 8),
                        widget.suffix!,
                      ]
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
