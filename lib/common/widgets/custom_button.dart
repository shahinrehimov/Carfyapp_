import 'package:flutter/material.dart';
import '../theme/theme.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    this.prefix,
    this.suffix,
    required this.text,
    this.borderRadius,
    this.height,
    this.width,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.backgroundColor,
    this.loading,
    this.prefixPadding,
    this.suffixPadding,
    this.outlineColor,
    this.child,
  });

  final VoidCallback onPressed;
  final double? height;
  final double? width;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final Color? backgroundColor;
  final Color? outlineColor;
  final Widget? prefix;
  final Widget? suffix;
  final Widget? child;
  final String? text;
  final bool? loading;
  final double? borderRadius;
  final double? prefixPadding;
  final double? suffixPadding;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.colors; // assuming you have primary & secondary there

    return SizedBox(
      height: height ?? 48,
      width: width,
      child: ElevatedButton(
        clipBehavior: Clip.none,
        style: ButtonStyle(
          padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
          elevation: WidgetStateProperty.all(0),
          backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 40),
              side: BorderSide(color: outlineColor ?? Colors.transparent),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Ink(
          decoration: BoxDecoration(
            gradient: backgroundColor == null
                ? LinearGradient(
                    colors: [colors.secondary, colors.primary],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : null,
            borderRadius: BorderRadius.circular(borderRadius ?? 40),
          ),
          child: Container(
            alignment: Alignment.center,
            child: loading == true
                ? CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation<Color>(colors.white))
                : child ??
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (prefix != null) ...[prefix!, SizedBox(width: prefixPadding ?? 10)],
                          Text(
                            text!,
                            style: TextStyle(
                              fontWeight: fontWeight ?? FontWeight.w400,
                              fontSize: fontSize ?? 16,
                              color: color ?? colors.white,
                            ),
                          ),
                          if (suffix != null) ...[SizedBox(width: suffixPadding ?? 10), suffix!],
                        ],
                      ),
          ),
        ),
      ),
    );
  }
}
