import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_button.dart';
import 'package:carfy/common/widgets/custom_text_field.dart';
import 'package:carfy/common/widgets/custom_toast.dart';
import 'package:carfy/common/widgets/state_status_toast.dart';
import 'package:carfy/presentation/referral/state/referral_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> showUpdateCodeBottomSheet(BuildContext context) {
  final cubit = context.read<ReferralCubit>();
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: _UpdateCodeSheet(initialCode: cubit.state.info?.code ?? ''),
    ),
  );
}

class _UpdateCodeSheet extends StatefulWidget {
  final String initialCode;

  const _UpdateCodeSheet({required this.initialCode});

  @override
  State<_UpdateCodeSheet> createState() => _UpdateCodeSheetState();
}

class _UpdateCodeSheetState extends State<_UpdateCodeSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialCode);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isValid(String code) {
    return RegExp(r'^[A-Za-z0-9]{4,20}$').hasMatch(code);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReferralCubit, ReferralState>(
      listenWhen: (prev, curr) => prev.updateCodeStatus != curr.updateCodeStatus,
      listener: (context, state) {
        if (state.updateCodeStatus is StateStatusSuccessWithMessage) {
          CustomToast.showSuccess(context, context.localization.referralUpdateCodeSuccess);
          Navigator.of(context).pop();
        } else {
          showStateStatusToast(context, state.updateCodeStatus);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: const Color(0xFFD9D9D9), borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                context.localization.referralUpdateCode,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: context.theme.colors.black),
              ),
              const SizedBox(height: 8),
              Text(
                context.localization.referralUpdateCodeRules,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color(0xFF717171)),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _controller,
                hint: context.localization.referralUpdateCodeHint,
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                  LengthLimitingTextInputFormatter(20),
                ],
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 20),
              BlocBuilder<ReferralCubit, ReferralState>(
                buildWhen: (prev, curr) => prev.updateCodeStatus != curr.updateCodeStatus,
                builder: (context, state) => CustomButton(
                  text: context.localization.referralUpdateCodeSave,
                  loading: state.updateCodeStatus is StateStatusLoading,
                  onPressed:
                      _isValid(_controller.text) && _controller.text.toUpperCase() != widget.initialCode.toUpperCase()
                      ? () => context.read<ReferralCubit>().updateCode(_controller.text)
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
