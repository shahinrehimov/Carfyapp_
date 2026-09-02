import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_app_bar.dart';
import 'package:carfy/common/widgets/custom_button.dart';
import 'package:carfy/common/widgets/custom_date_picker.dart';
import 'package:carfy/common/widgets/custom_dropdown.dart';
import 'package:carfy/common/widgets/custom_text_field.dart';
import 'package:carfy/common/widgets/confirmation_dialog.dart';
import 'package:carfy/common/widgets/custom_toast.dart';
import 'package:carfy/common/widgets/state_status_toast.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/domain/entities/auth/auth_user.dart';
import 'package:carfy/presentation/profile/state/change_contact/change_contact_cubit.dart';
import 'package:carfy/presentation/profile/state/profile_update/profile_update_cubit.dart';
import 'package:carfy/presentation/profile/ui/widget/change_contact_bottom_sheet.dart';
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
          prev.deleteStatus != curr.deleteStatus ||
          prev.imageStatus != curr.imageStatus,
      listener: (context, state) {
        showStateStatusToast(context, state.submitStatus);
        showStateStatusToast(context, state.logoutStatus);
        showStateStatusToast(context, state.deleteStatus);
        showStateStatusToast(context, state.imageStatus);
        if (state.submitStatus is StateStatusSuccess) {
          CustomToast.showSuccess(context, context.localization.profileUpdateSuccess);
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
              const SizedBox(height: 16),
              _ProfileImagePicker(cubit: cubit),
              const SizedBox(height: 24),
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
              const SizedBox(height: 16),
              // Email field
              BlocBuilder<ProfileUpdateCubit, ProfileUpdateState>(
                buildWhen: (prev, curr) => prev.email != curr.email || prev.registerType != curr.registerType,
                builder: (context, state) => _ContactField(
                  label: context.localization.email,
                  value: state.email,
                  canEdit: state.registerType != 'google' && state.registerType != 'apple',
                  onEdit: () async {
                    final user = await showChangeContactBottomSheet(
                      context,
                      ChangeContactType.email,
                      currentValue: state.email,
                    );
                    if (user != null && context.mounted) {
                      cubit.updateContact(user);
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Phone field
              BlocBuilder<ProfileUpdateCubit, ProfileUpdateState>(
                buildWhen: (prev, curr) => prev.phone != curr.phone,
                builder: (context, state) => _ContactField(
                  label: context.localization.phone,
                  value: state.phone,
                  canEdit: true,
                  onEdit: () async {
                    final user = await showChangeContactBottomSheet(
                      context,
                      ChangeContactType.phone,
                      currentValue: state.phone,
                    );
                    if (user != null && context.mounted) {
                      cubit.updateContact(user);
                    }
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
              // Delete button
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
              SizedBox(height: 24 + MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileImagePicker extends StatelessWidget {
  final ProfileUpdateCubit cubit;

  const _ProfileImagePicker({required this.cubit});

  Future<void> _pickImage(BuildContext context) async {
    final hasImage = context.read<ProfileUpdateCubit>().state.currentImageUrl != null;

    final action = await showModalBottomSheet<_ImageAction>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(context, _ImageAction.pick),
            ),
            if (hasImage)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text('Remove photo', style: TextStyle(color: Colors.red)),
                onTap: () => Navigator.pop(context, _ImageAction.delete),
              ),
          ],
        ),
      ),
    );

    if (action == null) return;

    if (action == _ImageAction.delete) {
      cubit.deleteProfileImage();
      return;
    }

    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked == null) return;
    cubit.updateProfileImage(File(picked.path));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileUpdateCubit, ProfileUpdateState>(
      buildWhen: (prev, curr) => prev.currentImageUrl != curr.currentImageUrl || prev.imageStatus != curr.imageStatus,
      builder: (context, state) {
        final isLoading = state.imageStatus is StateStatusLoading;
        return Center(
          child: GestureDetector(
            onTap: isLoading ? null : () => _pickImage(context),
            child: Stack(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFEEEEEE)),
                  child: ClipOval(
                    child: state.currentImageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: state.currentImageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => const ColoredBox(color: Color(0xFFEEEEEE)),
                            errorWidget: (_, __, ___) => const Icon(Icons.person, size: 40, color: Colors.grey),
                          )
                        : const Icon(Icons.person, size: 40, color: Colors.grey),
                  ),
                ),
                if (isLoading)
                  const Positioned.fill(
                    child: ClipOval(
                      child: ColoredBox(
                        color: Colors.black26,
                        child: Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00569C),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.edit, size: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

enum _ImageAction { pick, delete }

class _ContactField extends StatelessWidget {
  final String label;
  final String value;
  final bool canEdit;
  final VoidCallback onEdit;

  const _ContactField({required this.label, required this.value, required this.canEdit, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(label, style: TextStyle(color: context.theme.colors.textLight, fontSize: 14)),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: context.theme.colors.border),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value.isEmpty ? '—' : value,
                  style: TextStyle(fontSize: 14, color: context.theme.colors.textDark),
                ),
              ),
              if (canEdit)
                GestureDetector(
                  onTap: onEdit,
                  child: Icon(Icons.edit_outlined, size: 20, color: context.theme.colors.primary),
                ),
            ],
          ),
        ),
      ],
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
