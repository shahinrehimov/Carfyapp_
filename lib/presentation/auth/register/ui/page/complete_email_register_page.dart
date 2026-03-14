import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/state/field_validation_state.dart';
import 'package:carfy/common/util/input_formatters.dart';
import 'package:carfy/common/widgets/custom_date_picker.dart';
import 'package:carfy/common/widgets/custom_dropdown.dart';
import 'package:carfy/common/widgets/custom_phone_field.dart';
import 'package:carfy/common/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_button.dart';
import 'package:carfy/domain/enums/gender.dart';
import 'package:carfy/gen/assets.gen.dart';
import 'package:carfy/presentation/auth/register/state/complete_email_register/complete_email_register_cubit.dart';

@RoutePage()
class CompleteEmailRegisterPage extends StatelessWidget implements AutoRouteWrapper {
  final String email;

  const CompleteEmailRegisterPage({super.key, required this.email});

  @override
  Widget wrappedRoute(BuildContext context) =>
      BlocProvider(create: (_) => CompleteEmailRegisterCubit()..init(email), child: this);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CompleteEmailRegisterCubit>();
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
              const SizedBox(height: 32),
              BlocBuilder<CompleteEmailRegisterCubit, CompleteEmailRegisterState>(
                buildWhen: (oldState, newState) => oldState.nameValidationState != newState.nameValidationState,
                builder: (context, state) {
                  return CustomTextField(
                    controller: cubit.nameController,
                    hint: context.localization.name,
                    errorText: state.nameValidationState.message,
                    inputFormatters: [InputFormatter.getPersonNameFormatter()],
                    prefix: UnconstrainedBox(child: SvgPicture.asset(Assets.icons.profile)),
                  );
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<CompleteEmailRegisterCubit, CompleteEmailRegisterState>(
                buildWhen: (oldState, newState) => oldState.surnameValidationState != newState.surnameValidationState,
                builder: (context, state) {
                  return CustomTextField(
                    controller: cubit.surnameController,
                    hint: context.localization.surname,
                    errorText: state.surnameValidationState.message,
                    inputFormatters: [InputFormatter.getPersonNameFormatter()],
                    prefix: UnconstrainedBox(child: SvgPicture.asset(Assets.icons.profile)),
                  );
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<CompleteEmailRegisterCubit, CompleteEmailRegisterState>(
                buildWhen: (oldState, newState) => oldState.phoneValidationState != newState.phoneValidationState,
                builder: (context, state) {
                  return CustomPhoneField(
                    controller: cubit.phoneController,
                    errorText: state.phoneValidationState.message,
                  );
                },
              ),
              const SizedBox(height: 16),
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
                prefix: UnconstrainedBox(child: SvgPicture.asset(Assets.icons.gender)),
              ),
              const SizedBox(height: 16),
              CustomDatePickerField(
                hint: context.localization.birthDate,
                onChanged: (date) {
                  if (date != null) {
                    cubit.selectBirthDate(date);
                  }
                },
                prefix: UnconstrainedBox(child: SvgPicture.asset(Assets.icons.calendar)),
              ),
              const SizedBox(height: 16),
              BlocBuilder<CompleteEmailRegisterCubit, CompleteEmailRegisterState>(
                buildWhen: (oldState, newState) => oldState.emailValidationState != newState.emailValidationState,
                builder: (context, state) {
                  return CustomTextField(
                    controller: cubit.emailController,
                    hint: context.localization.email,
                    errorText: state.emailValidationState.message,
                    inputFormatters: [InputFormatter.getEmailFormatter()],
                    prefix: UnconstrainedBox(child: SvgPicture.asset(Assets.icons.message)),
                  );
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<CompleteEmailRegisterCubit, CompleteEmailRegisterState>(
                buildWhen: (oldState, newState) =>
                    oldState.obscurePassword != newState.obscurePassword ||
                    oldState.passwordValidationState != newState.passwordValidationState,
                builder: (context, state) {
                  return CustomTextField(
                    controller: cubit.passwordController,
                    hint: context.localization.password,
                    errorText: state.passwordValidationState.message,
                    obscureText: state.obscurePassword,
                    maxLines: 1,
                    prefix: UnconstrainedBox(child: SvgPicture.asset(Assets.icons.password)),
                    suffix: GestureDetector(
                      onTap: () => cubit.toggleObscurePassword(),
                      child: UnconstrainedBox(child: SvgPicture.asset(Assets.icons.eyeOff, width: 24, height: 24)),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<CompleteEmailRegisterCubit, CompleteEmailRegisterState>(
                buildWhen: (oldState, newState) =>
                    oldState.obscureRepeatPassword != newState.obscureRepeatPassword ||
                    oldState.repeatPasswordValidationState != newState.repeatPasswordValidationState,
                builder: (context, state) {
                  return CustomTextField(
                    controller: cubit.repeatPasswordController,
                    hint: context.localization.enterRepeatPassword,
                    errorText: state.repeatPasswordValidationState.message,
                    obscureText: state.obscureRepeatPassword,
                    maxLines: 1,
                    prefix: UnconstrainedBox(child: SvgPicture.asset(Assets.icons.password)),
                    suffix: GestureDetector(
                      onTap: () => cubit.toggleObscureRepeatPassword(),
                      child: UnconstrainedBox(child: SvgPicture.asset(Assets.icons.eyeOff, width: 24, height: 24)),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              BlocBuilder<CompleteEmailRegisterCubit, CompleteEmailRegisterState>(
                buildWhen: (oldState, newState) => oldState.registerState != newState.registerState,
                builder: (context, state) {
                  return CustomButton(
                    onPressed: () => cubit.register(),
                    loading: state.registerState is StateStatusLoading,
                    text: context.localization.confirm,
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
