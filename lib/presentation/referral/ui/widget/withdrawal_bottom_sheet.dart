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

Future<void> showWithdrawalBottomSheet(BuildContext context) {
  final cubit = context.read<ReferralCubit>();
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: _WithdrawalSheet(availableBalance: cubit.state.info?.availableBalance ?? 0),
    ),
  );
}

class _WithdrawalSheet extends StatefulWidget {
  final double availableBalance;

  const _WithdrawalSheet({required this.availableBalance});

  @override
  State<_WithdrawalSheet> createState() => _WithdrawalSheetState();
}

class _WithdrawalSheetState extends State<_WithdrawalSheet> {
  final _amountController = TextEditingController();
  final _cardLast4Controller = TextEditingController();
  final _cardHolderController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _cardLast4Controller.dispose();
    _cardHolderController.dispose();
    super.dispose();
  }

  bool get _isValid {
    final amount = double.tryParse(_amountController.text) ?? 0;
    return amount >= 50 &&
        amount <= widget.availableBalance &&
        _cardLast4Controller.text.length == 4 &&
        _cardHolderController.text.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReferralCubit, ReferralState>(
      listenWhen: (prev, curr) => prev.withdrawalCreateStatus != curr.withdrawalCreateStatus,
      listener: (context, state) {
        if (state.withdrawalCreateStatus is StateStatusSuccessWithMessage) {
          CustomToast.showSuccess(context, context.localization.referralWithdrawSuccess);
          Navigator.of(context).pop();
        } else {
          showStateStatusToast(context, state.withdrawalCreateStatus);
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
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                context.localization.referralWithdrawTitle,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: context.theme.colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${context.localization.referralAvailableBalance}: ${widget.availableBalance.toStringAsFixed(2)} ₼',
                style: const TextStyle(fontSize: 13, color: Color(0xFF717171)),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _amountController,
                hint: context.localization.referralWithdrawAmount,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                ],
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _cardLast4Controller,
                hint: context.localization.referralWithdrawCardLast4,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _cardHolderController,
                hint: context.localization.referralWithdrawCardHolder,
                textCapitalization: TextCapitalization.characters,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 20),
              BlocBuilder<ReferralCubit, ReferralState>(
                buildWhen: (prev, curr) => prev.withdrawalCreateStatus != curr.withdrawalCreateStatus,
                builder: (context, state) => CustomButton(
                  text: context.localization.referralWithdrawSubmit,
                  loading: state.withdrawalCreateStatus is StateStatusLoading,
                  onPressed: _isValid
                      ? () => context.read<ReferralCubit>().createWithdrawal(
                            amount: double.parse(_amountController.text),
                            cardLast4: _cardLast4Controller.text,
                            cardHolderName: _cardHolderController.text.trim(),
                          )
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
