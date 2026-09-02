import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_button.dart';
import 'package:carfy/common/widgets/custom_text_field.dart';
import 'package:carfy/common/widgets/state_status_toast.dart';
import 'package:carfy/domain/entities/auth/auth_user.dart';
import 'package:carfy/presentation/profile/state/change_contact/change_contact_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

Future<AuthUser?> showChangeContactBottomSheet(
  BuildContext context,
  ChangeContactType type, {
  String? currentValue,
}) {
  return showModalBottomSheet<AuthUser?>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (_) => BlocProvider(
      create: (_) => ChangeContactCubit(type: type),
      child: _ChangeContactSheet(type: type, currentValue: currentValue),
    ),
  );
}

class _ChangeContactSheet extends StatefulWidget {
  final ChangeContactType type;
  final String? currentValue;

  const _ChangeContactSheet({required this.type, this.currentValue});

  @override
  State<_ChangeContactSheet> createState() => _ChangeContactSheetState();
}

class _ChangeContactSheetState extends State<_ChangeContactSheet> {
  final _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  String _formatTimer(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String _buildPhoneValue(String digits) => '994$digits';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangeContactCubit, ChangeContactState>(
      listenWhen: (prev, curr) =>
          prev.sendOtpStatus != curr.sendOtpStatus || prev.verifyStatus != curr.verifyStatus,
      listener: (context, state) {
        showStateStatusToast(context, state.sendOtpStatus);
        showStateStatusToast(context, state.verifyStatus);
        if (state.verifyStatus is StateStatusSuccess) {
          Navigator.of(context).pop(state.updatedUser);
        }
      },
      builder: (context, state) {
        return Padding(
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
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (state.step == ChangeContactStep.input) ...[
                  _buildInputStep(context, state),
                ] else ...[
                  _buildOtpStep(context, state),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputStep(BuildContext context, ChangeContactState state) {
    final cubit = context.read<ChangeContactCubit>();
    final isEmail = widget.type == ChangeContactType.email;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          isEmail ? context.localization.changeEmailTitle : context.localization.changePhoneTitle,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: context.theme.colors.black),
        ),
        if (widget.currentValue != null && widget.currentValue!.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            widget.currentValue!,
            style: const TextStyle(fontSize: 13, color: Color(0xFF717171)),
          ),
        ],
        const SizedBox(height: 20),
        if (isEmail)
          CustomTextField(
            controller: _inputController,
            hint: context.localization.changeEmailNewHint,
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) => setState(() {}),
          )
        else
          _PhoneInput(controller: _inputController, onChanged: (_) => setState(() {})),
        const SizedBox(height: 20),
        CustomButton(
          text: context.localization.sendOtp,
          loading: state.sendOtpStatus is StateStatusLoading,
          onPressed: _inputController.text.trim().isNotEmpty
              ? () {
                  final value = isEmail
                      ? _inputController.text.trim()
                      : _buildPhoneValue(_inputController.text.trim());
                  cubit.sendOtp(value);
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildOtpStep(BuildContext context, ChangeContactState state) {
    final cubit = context.read<ChangeContactCubit>();
    final isEmail = widget.type == ChangeContactType.email;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          isEmail ? context.localization.changeEmailTitle : context.localization.changePhoneTitle,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: context.theme.colors.black),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                isEmail
                    ? context.localization.changeEmailOtpDesc(state.value)
                    : context.localization.changePhoneOtpDesc(state.value),
                style: const TextStyle(fontSize: 13, color: Color(0xFF717171)),
              ),
            ),
            GestureDetector(
              onTap: cubit.goBackToInput,
              child: Text(
                context.localization.changeEmailNewHint,
                style: TextStyle(
                  fontSize: 13,
                  color: context.theme.colors.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: context.theme.colors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Center(
          child: Pinput(
            length: 4,
            keyboardType: TextInputType.number,
            autofocus: true,
            onCompleted: (otp) => cubit.verify(otp),
            defaultPinTheme: PinTheme(
              width: 56,
              height: 56,
              textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: context.theme.colors.black),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFD9D9D9)),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            focusedPinTheme: PinTheme(
              width: 56,
              height: 56,
              textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: context.theme.colors.black),
              decoration: BoxDecoration(
                border: Border.all(color: context.theme.colors.primary, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (state.verifyStatus is StateStatusLoading)
          const Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)))
        else
          Center(
            child: state.isTimerActive
                ? Text(
                    context.localization.otpExpiresIn(_formatTimer(state.timeRemaining)),
                    style: const TextStyle(fontSize: 13, color: Color(0xFF717171)),
                  )
                : const SizedBox.shrink(),
          ),
        const SizedBox(height: 12),
        Center(
          child: state.canResend
              ? GestureDetector(
                  onTap: () => cubit.resendOtp(),
                  child: Text(
                    context.localization.resendOtp,
                    style: TextStyle(
                      fontSize: 14,
                      color: context.theme.colors.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: context.theme.colors.primary,
                    ),
                  ),
                )
              : Text(
                  state.resendCooldown > 0
                      ? context.localization.resendOtpIn(_formatTimer(state.resendCooldown))
                      : '',
                  style: const TextStyle(fontSize: 13, color: Color(0xFF717171)),
                ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _PhoneInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const _PhoneInput({required this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              border: Border.all(color: context.theme.colors.border),
              borderRadius: BorderRadius.circular(40),
            ),
            alignment: Alignment.center,
            child: Text(
              '+994',
              style: TextStyle(fontSize: 14, color: context.theme.colors.textDark),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: CustomTextField(
              controller: controller,
              hint: '501234567',
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(9),
              ],
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
