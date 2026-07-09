import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_app_bar.dart';
import 'package:carfy/common/widgets/custom_button.dart';
import 'package:carfy/common/widgets/custom_date_picker.dart';
import 'package:carfy/common/widgets/custom_dropdown.dart';
import 'package:carfy/common/widgets/custom_text_field.dart';
import 'package:carfy/common/widgets/confirmation_dialog.dart';
import 'package:carfy/common/widgets/state_status_toast.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/domain/entities/auth/auth_user.dart';
import 'package:carfy/presentation/profile/state/profile_update/profile_update_cubit.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ProfileUpdatePage extends StatefulWidget implements AutoRouteWrapper {
  final AuthUser user;

  const ProfileUpdatePage({super.key, required this.user});

  @override
  Widget wrappedRoute(BuildContext context) =>
      BlocProvider(create: (_) => ProfileUpdateCubit()..init(user), child: this);

  @override
  State<ProfileUpdatePage> createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name;
    _surnameController.text = widget.user.surname;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    super.dispose();
  }

  // Parses dd.MM.yyyy or yyyy-MM-dd into DateTime
  DateTime? _parseDate(String? raw) {
    if (raw == null) return null;
    if (raw.contains('.')) {
      final p = raw.split('.');
      if (p.length == 3) return DateTime.tryParse('${p[2]}-${p[1]}-${p[0]}');
    } else if (raw.contains('-')) {
      return DateTime.tryParse(raw);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileUpdateCubit>();

    return BlocListener<ProfileUpdateCubit, ProfileUpdateState>(
      listenWhen: (prev, curr) =>
          prev.submitStatus != curr.submitStatus ||
          prev.logoutStatus != curr.logoutStatus ||
          prev.deleteStatus != curr.deleteStatus,
      listener: (context, state) {
        showStateStatusToast(context, state.submitStatus);
        showStateStatusToast(context, state.logoutStatus);
        showStateStatusToast(context, state.deleteStatus);
        if (state.submitStatus is StateStatusSuccess) {
          context.maybePop(state.updatedUser);
        }
        if (state.logoutStatus is StateStatusSuccess || state.deleteStatus is StateStatusSuccess) {
          context.router.replaceAll([const LoginRoute()]);
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(title: context.localization.profileUpdateTitle),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 8),
              // Name
              BlocBuilder<ProfileUpdateCubit, ProfileUpdateState>(
                buildWhen: (prev, curr) =>
                    prev.nameError != curr.nameError || prev.nameValidationError != curr.nameValidationError,
                builder: (context, state) => CustomTextField(
                  controller: _nameController,
                  hint: context.localization.name,
                  title: context.localization.name,
                  errorText: switch (state.nameError) {
                    ProfileUpdateFieldError.required => context.localization.profileUpdateNameRequired,
                    null => state.nameValidationError,
                  },
                  onChanged: cubit.setName,
                ),
              ),
              const SizedBox(height: 16),
              // Surname
              BlocBuilder<ProfileUpdateCubit, ProfileUpdateState>(
                buildWhen: (prev, curr) =>
                    prev.surnameError != curr.surnameError ||
                    prev.surnameValidationError != curr.surnameValidationError,
                builder: (context, state) => CustomTextField(
                  controller: _surnameController,
                  hint: context.localization.surname,
                  title: context.localization.surname,
                  errorText: switch (state.surnameError) {
                    ProfileUpdateFieldError.required => context.localization.profileUpdateSurnameRequired,
                    null => state.surnameValidationError,
                  },
                  onChanged: cubit.setSurname,
                ),
              ),
              const SizedBox(height: 16),
              // Gender
              BlocBuilder<ProfileUpdateCubit, ProfileUpdateState>(
                buildWhen: (prev, curr) =>
                    prev.selectedGender != curr.selectedGender ||
                    prev.genderValidationError != curr.genderValidationError,
                builder: (context, state) {
                  final genders = [
                    _GenderOption('male', context.localization.male),
                    _GenderOption('female', context.localization.female),
                  ];
                  final selected = state.selectedGender != null
                      ? genders.where((g) => g.value == state.selectedGender).firstOrNull
                      : null;
                  return CustomDropdownField<_GenderOption>(
                    items: genders,
                    value: selected,
                    hint: context.localization.profileUpdateSelectGender,
                    title: context.localization.profileUpdateSelectGender,
                    sheetTitle: context.localization.gender,
                    itemLabelBuilder: (item) => item.label,
                    errorText: state.genderValidationError,
                    onChanged: (item) {
                      if (item != null) cubit.selectGender(item.value);
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              // Birth date
              BlocBuilder<ProfileUpdateCubit, ProfileUpdateState>(
                buildWhen: (prev, curr) =>
                    prev.birthDate != curr.birthDate || prev.birthDateValidationError != curr.birthDateValidationError,
                builder: (context, state) => CustomDatePickerField(
                  title: context.localization.birthDate,
                  hint: context.localization.profileUpdateSelectBirthDate,
                  value: _parseDate(state.birthDate),
                  lastDate: DateTime.now(),
                  firstDate: DateTime(1930),
                  errorText: state.birthDateValidationError,
                  hasError: state.birthDateValidationError != null,
                  onChanged: (date) {
                    if (date == null) return;
                    final formatted =
                        '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
                    cubit.setBirthDate(formatted);
                  },
                ),
              ),
              const SizedBox(height: 32),
              // Save button
              BlocBuilder<ProfileUpdateCubit, ProfileUpdateState>(
                buildWhen: (prev, curr) => prev.submitStatus != curr.submitStatus || prev.hasChanges != curr.hasChanges,
                builder: (context, state) => CustomButton(
                  text: context.localization.profileUpdateSave,
                  loading: state.submitStatus is StateStatusLoading,
                  onPressed: state.hasChanges ? cubit.save : null,
                ),
              ),
              const SizedBox(height: 12),
              // Logout button
              BlocBuilder<ProfileUpdateCubit, ProfileUpdateState>(
                buildWhen: (prev, curr) => prev.logoutStatus != curr.logoutStatus,
                builder: (context, state) => CustomButton(
                  text: context.localization.profileLogout,
                  loading: state.logoutStatus is StateStatusLoading,
                  backgroundColor: Colors.transparent,
                  outlineColor: context.theme.colors.error,
                  color: context.theme.colors.error,
                  onPressed: () => showConfirmationDialog(
                    context: context,
                    title: context.localization.logoutConfirmTitle,
                    description: context.localization.logoutConfirmDescription,
                    confirmText: context.localization.profileLogout,
                    cancelText: context.localization.cancel,
                    onConfirm: cubit.logout,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: () => showConfirmationDialog(
                  context: context,
                  title: context.localization.deleteAccountConfirmTitle,
                  description: context.localization.deleteAccountConfirmDescription,
                  confirmText: context.localization.profileDeleteAccount,
                  cancelText: context.localization.cancel,
                  onConfirm: cubit.deleteAccount,
                ),
                child: Text(
                  context.localization.profileDeleteAccount,
                  style: TextStyle(
                    color: context.theme.colors.error,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline,
                    decorationColor: context.theme.colors.error,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _GenderOption {
  final String value;
  final String label;

  const _GenderOption(this.value, this.label);

  @override
  bool operator ==(Object other) => other is _GenderOption && other.value == value;

  @override
  int get hashCode => value.hashCode;
}
