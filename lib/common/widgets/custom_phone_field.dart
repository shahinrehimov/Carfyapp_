import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/util/input_formatters.dart';
import 'package:carfy/common/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class CustomPhoneField extends StatefulWidget {
  final TextEditingController controller;
  final String? errorText;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final double borderRadius;

  const CustomPhoneField({
    super.key,
    required this.controller,
    this.errorText,
    this.hint,
    this.onChanged,
    this.borderRadius = 40,
  });

  @override
  State<CustomPhoneField> createState() => _CustomPhoneFieldState();
}

class _CustomPhoneFieldState extends State<CustomPhoneField> {
  late final TextEditingController _displayController;

  @override
  void initState() {
    super.initState();
    final initial = widget.controller.text;
    String digits = initial.startsWith('994') ? initial.substring(3) : initial;
    digits = digits.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length > 9) digits = digits.substring(0, 9);
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i == 2 || i == 5 || i == 7) buffer.write(' ');
      buffer.write(digits[i]);
    }
    _displayController = TextEditingController(text: buffer.toString());
  }

  @override
  void dispose() {
    _displayController.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    final digits = value.replaceAll(' ', '');
    final full = '994$digits';
    widget.controller.text = full;
    widget.onChanged?.call(full);
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: _displayController,
      hint: widget.hint ?? '50 555 55 55',
      errorText: widget.errorText,
      keyboardType: TextInputType.number,
      inputFormatters: [InputFormatter.getLocalPhoneFormatter()],
      onChanged: _onChanged,
      borderRadius: widget.borderRadius,
      prefix: _Prefix(),
      prefixIconConstraints: const BoxConstraints(minHeight: 0, minWidth: 0),
    );
  }
}

class _Prefix extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 16),
        Text('+994', style: TextStyle(fontSize: 14, color: context.theme.colors.textDark)),
        const SizedBox(width: 8),
        SizedBox(height: 20, child: VerticalDivider(color: context.theme.colors.border, thickness: 1, width: 1)),
        const SizedBox(width: 8),
      ],
    );
  }
}
