import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/util/input_formatters.dart';
import 'package:carfy/common/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class CustomPhoneField extends StatefulWidget {
  final TextEditingController controller;
  final String? errorText;
  final String? hint;

  const CustomPhoneField({super.key, required this.controller, this.errorText, this.hint});

  @override
  State<CustomPhoneField> createState() => _CustomPhoneFieldState();
}

class _CustomPhoneFieldState extends State<CustomPhoneField> {
  late final TextEditingController _displayController;

  @override
  void initState() {
    super.initState();
    _displayController = TextEditingController();
  }

  @override
  void dispose() {
    _displayController.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    final digits = value.replaceAll(' ', '');
    widget.controller.text = '994$digits';
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
