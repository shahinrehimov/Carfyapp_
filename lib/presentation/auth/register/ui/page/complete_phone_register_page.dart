import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/state/field_validation_state.dart';
import 'package:carfy/common/util/input_formatters.dart';
import 'package:carfy/common/widgets/custom_date_picker.dart';
import 'package:carfy/common/widgets/custom_dropdown.dart';
import 'package:carfy/common/widgets/custom_text_field.dart';
import 'package:carfy/presentation/auth/register/state/complete_phone_register/complete_phone_register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../common/state/state_status.dart';
import '../../../../../common/theme/theme.dart';
import '../../../../../common/translations/translation_context_extension.dart';
import '../../../../../common/translations/translation_keys.dart';
import '../../../../../common/widgets/custom_button.dart';
import '../../../../../domain/enums/gender.dart';
import '../../../../../gen/assets.gen.dart';

@RoutePage()
class CompletePhoneRegisterPage extends StatelessWidget implements AutoRouteWrapper {
  final String phone;
  final String confirmationToken;
  final int otp;

  const CompletePhoneRegisterPage({super.key, required this.phone, required this.confirmationToken, required this.otp});

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(create: (_) => CompletePhoneRegisterCubit(), child: this);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CompletePhoneRegisterCubit>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () => context.maybePop(),
          child: UnconstrainedBox(child: SvgPicture.asset(Assets.icons.arrowNarrowLeft, width: 24, height: 24)),
        ),
      ),
      backgroundColor: context.theme.colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                context.localization.signUp,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: context.theme.colors.primary),
              ),
              SizedBox(height: 32),
              BlocBuilder<CompletePhoneRegisterCubit, CompletePhoneRegisterState>(
                buildWhen: (oldState, newState) => oldState.nameValidationState != newState.nameValidationState,
                builder: (context, state) {
                  return CustomTextField(
                    controller: cubit.nameController,
                    hint: context.localization.name,
                    errorText: state.nameValidationState.message,
                    inputFormatters: [InputFormatter.getPersonNameFormatter()],
                  );
                },
              ),
              SizedBox(height: 16),
              BlocBuilder<CompletePhoneRegisterCubit, CompletePhoneRegisterState>(
                buildWhen: (oldState, newState) => oldState.surnameValidationState != newState.surnameValidationState,
                builder: (context, state) {
                  return CustomTextField(
                    controller: cubit.surnameController,
                    hint: context.localization.surname,
                    errorText: state.surnameValidationState.message,
                    inputFormatters: [InputFormatter.getPersonNameFormatter()],
                  );
                },
              ),
              SizedBox(height: 16),
              CustomDropdownField<Gender>(
                items: [Gender.male, Gender.female],
                hint: context.localization.gender,
                required: true,
                onChanged: (value) {
                  if (value != null) {
                    cubit.selectGender(value);
                  }
                },
                itemLabelBuilder: (item) => switch (item) {
                  Gender.male => context.localization.male,
                  Gender.female => context.localization.female,
                },
              ),
              SizedBox(height: 16),
              CustomDatePickerField(
                hint: context.localization.birthDate,
                onChanged: (date) {
                  if (date != null) {
                    cubit.selectBirthDate(date);
                  }
                },
              ),
              SizedBox(height: 16),
              BlocBuilder<CompletePhoneRegisterCubit, CompletePhoneRegisterState>(
                buildWhen: (oldState, newState) => oldState.emailValidationState != newState.emailValidationState,
                builder: (context, state) {
                  return CustomTextField(
                    controller: cubit.emailController,
                    hint: context.localization.email,
                    errorText: state.emailValidationState.message,
                    inputFormatters: [InputFormatter.getEmailFormatter()],
                  );
                },
              ),
              SizedBox(height: 24),
              BlocBuilder<CompletePhoneRegisterCubit, CompletePhoneRegisterState>(
                buildWhen: (oldState, newState) => oldState.registerState != newState.registerState,
                builder: (context, state) {
                  return CustomButton(
                    onPressed: () => cubit.register(phone: phone, phoneConfirmationToken: confirmationToken, otp: otp),
                    loading: state.registerState is StateStatusLoading,
                    text: context.localization.confirm,
                  );
                },
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
