import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:carfy/common/theme/theme.dart';

class CustomTextField extends StatelessWidget {
  final TextInputType? keyboardType;
  final String? label, hint, title;
  final bool required;

  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffix;
  final Widget? prefix;
  final Color? color;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final double? dividerThickness;
  final VoidCallback? callbackSuffixIcon;
  final Function(String)? onChanged;
  final Function()? onTap;
  final Function()? onEditingComplete;
  final Function(String value)? onFieldSubmitted;
  final int? minLines, maxLines;
  final TextEditingController controller;
  final TextAlign? align;
  final double? height;
  final TextStyle? hintStyle;
  final Offset? clearIconOffset;
  final TextStyle? labelStyle;
  final TextStyle? floatingLabelStyle;
  final BoxConstraints? prefixIconConstraints;
  final EdgeInsets? padding;
  final EdgeInsets? scrollPadding;
  final double? fontSize;
  final bool isSuffixIconConstraints;
  final bool obscureText;
  final bool hasBorder;
  final bool hasUnderLineBorder;
  final Widget? underLineBorder;
  final double dividerScale;
  final bool autoFocus;
  final TextAlignVertical verticalTextAlign;
  final FontWeight fontWeight;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final bool showCursor;
  final double? clearIconHeight;
  final TextCapitalization? textCapitalization;
  final bool hasError;
  final String? errorText;
  final String? initialValue;
  final bool? enabled;
  final bool readOnly;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;
  final double borderRadius;

  const CustomTextField({
    super.key,
    this.keyboardType,
    this.label,
    this.title,
    this.required = false,
    this.textInputAction,
    this.focusNode,
    this.verticalTextAlign = TextAlignVertical.center,
    this.color,
    this.fillColor,
    this.borderColor,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.suffix,
    this.dividerScale = 1.01,
    this.hintStyle,
    this.labelStyle,
    this.prefixIconConstraints,
    this.floatingLabelStyle,
    this.clearIconHeight,
    this.clearIconOffset,
    this.dividerThickness,
    this.autoFocus = false,
    this.fontWeight = FontWeight.w400,
    this.height,
    this.showCursor = true,
    this.align = TextAlign.start,
    this.prefix,
    this.padding,
    this.scrollPadding,
    this.inputFormatters,
    this.minLines,
    this.maxLines,
    this.isSuffixIconConstraints = false,
    this.hint,
    this.hasError = false,
    this.errorText,
    this.hasBorder = false,
    this.obscureText = false,
    this.hasUnderLineBorder = false,
    this.underLineBorder,
    this.initialValue,
    this.fontSize,
    this.maxLength,
    required this.controller,
    this.callbackSuffixIcon,
    this.textCapitalization,
    this.enabled,
    this.validator,
    this.focusedBorderColor,
    this.readOnly = false,
    this.borderRadius = 40,
  });

  @override
  Widget build(BuildContext context) {
    final textField = TextFormField(
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: obscureText,
      textInputAction: textInputAction ?? TextInputAction.done,
      inputFormatters: inputFormatters ?? [],
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      initialValue: initialValue,
      validator: validator,
      autofocus: autoFocus,
      enableSuggestions: false,
      autocorrect: false,
      readOnly: readOnly,
      focusNode: focusNode,
      style: TextStyle(fontSize: fontSize ?? 14, color: color ?? context.theme.colors.textDark, fontWeight: fontWeight),
      controller: controller,
      onChanged: (text) {
        onChanged?.call(text);
      },
      textAlign: align!,
      showCursor: showCursor,
      onTap: () {
        if (onTap != null) onTap!.call();
      },
      keyboardType: keyboardType,
      enabled: enabled,
      textAlignVertical: verticalTextAlign,
      scrollPadding: scrollPadding ?? const EdgeInsets.only(bottom: 32),
      onFieldSubmitted: onFieldSubmitted,
      cursorColor: hasError ? context.theme.colors.error : context.theme.colors.black,
      decoration: InputDecoration(
        filled: fillColor == null ? false : true,
        fillColor: fillColor ?? Colors.transparent,
        errorText: errorText,
        errorMaxLines: 10,
        alignLabelWithHint: true,
        counterText: '',
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor ?? context.theme.colors.lightGray),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor ?? context.theme.colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor ?? context.theme.colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: focusedBorderColor ?? context.theme.colors.secondary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: context.theme.colors.error),
        ),
        prefixIcon: prefix,
        prefixIconConstraints: prefixIconConstraints,
        hintText: hint,
        suffixIcon: suffix,
        contentPadding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        hintStyle:
            hintStyle ?? TextStyle(color: context.theme.colors.textLight, fontSize: 14, fontWeight: FontWeight.w300),
        labelText: label,
        labelStyle:
            labelStyle ??
            TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: context.theme.colors.textDark, height: height),
        errorStyle: TextStyle(color: context.theme.colors.error, fontSize: 14),
      ),
      minLines: minLines,
      maxLines: maxLines,
      maxLength: maxLength,
    );

    if (title == null) return textField;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(title!, style: TextStyle(color: context.theme.colors.textLight, fontSize: 14)),
        ),
        const SizedBox(height: 4),
        textField,
      ],
    );
  }
}
