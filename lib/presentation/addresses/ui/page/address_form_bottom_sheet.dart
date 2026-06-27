import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/common/state/field_validation_state.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_button.dart';
import 'package:carfy/common/widgets/custom_dropdown.dart';
import 'package:carfy/common/widgets/custom_phone_field.dart';
import 'package:carfy/common/widgets/custom_text_field.dart';
import 'package:carfy/common/widgets/confirmation_dialog.dart';
import 'package:carfy/common/widgets/state_status_toast.dart';
import 'package:carfy/domain/entities/address/address.dart';
import 'package:carfy/presentation/addresses/state/address_form/address_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

Future<bool> showAddressFormBottomSheet(BuildContext context, {Address? address}) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider(
      create: (_) => AddressFormCubit()..init(address),
      child: _AddressFormSheet(address: address),
    ),
  );
  return result == true;
}

class _AddressFormSheet extends StatefulWidget {
  final Address? address;

  const _AddressFormSheet({this.address});

  @override
  State<_AddressFormSheet> createState() => _AddressFormSheetState();
}

class _AddressFormSheetState extends State<_AddressFormSheet> {
  final _line1Controller = TextEditingController();
  final _line2Controller = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final addr = widget.address;
    if (addr != null) {
      _line1Controller.text = addr.addressLine1;
      _line2Controller.text = addr.addressLine2 ?? '';
      _phoneController.text = addr.phone;
    }
  }

  @override
  void dispose() {
    _line1Controller.dispose();
    _line2Controller.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddressFormCubit>();
    final isEdit = widget.address != null;

    return BlocListener<AddressFormCubit, AddressFormState>(
      listenWhen: (prev, curr) => prev.submitStatus != curr.submitStatus || prev.deleteStatus != curr.deleteStatus,
      listener: (context, state) {
        showStateStatusToast(context, state.submitStatus);
        showStateStatusToast(context, state.deleteStatus);
        if (state.submitStatus is StateStatusSuccess || state.deleteStatus is StateStatusSuccess) {
          Navigator.of(context).pop(true);
        }
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF8F8F8),
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Column(
              children: [
                // Drag handle
                Padding(
                  padding: const EdgeInsets.only(top: 11),
                  child: Container(
                    width: 54,
                    height: 3,
                    decoration: BoxDecoration(color: const Color(0xFFD9D9D9), borderRadius: BorderRadius.circular(100)),
                  ),
                ),
                // Title
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 24),
                  child: Text(
                    isEdit ? context.localization.addressFormEditTitle : context.localization.addressFormAddTitle,
                    style: const TextStyle(color: Color(0xFF242323), fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                ),
                // Form
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    child: Column(
                      children: [
                        // Address Type
                        BlocBuilder<AddressFormCubit, AddressFormState>(
                          buildWhen: (prev, curr) =>
                              prev.addressTypes != curr.addressTypes ||
                              prev.addressTypesStatus != curr.addressTypesStatus ||
                              prev.selectedAddressType != curr.selectedAddressType ||
                              prev.addressTypeError != curr.addressTypeError,
                          builder: (context, state) => CustomDropdownField(
                            items: state.addressTypes,
                            value: state.selectedAddressType,
                            hint: context.localization.addressFormAddressType,
                            sheetTitle: context.localization.addressFormAddressType,
                            isLoading: state.addressTypesStatus is StateStatusLoading,
                            hasError: state.addressTypesStatus is StateStatusFailure,
                            onRetry: cubit.retryAddressTypes,
                            borderRadius: 12,
                            errorText: switch (state.addressTypeError) {
                              AddressFormFieldError.required => context.localization.addressFormAddressTypeRequired,
                              null => null,
                            },
                            itemLabelBuilder: (item) => item.title,
                            onChanged: (item) {
                              if (item != null) cubit.selectAddressType(item);
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        // City
                        BlocBuilder<AddressFormCubit, AddressFormState>(
                          buildWhen: (prev, curr) =>
                              prev.flatCities != curr.flatCities ||
                              prev.citiesStatus != curr.citiesStatus ||
                              prev.selectedCity != curr.selectedCity ||
                              prev.cityError != curr.cityError,
                          builder: (context, state) => CustomDropdownField(
                            items: state.flatCities,
                            value: state.selectedCity,
                            hint: context.localization.addressFormCity,
                            sheetTitle: context.localization.addressFormCity,
                            isLoading: state.citiesStatus is StateStatusLoading,
                            hasError: state.citiesStatus is StateStatusFailure,
                            onRetry: cubit.retryCities,
                            searchable: true,
                            borderRadius: 12,
                            errorText: switch (state.cityError) {
                              AddressFormFieldError.required => context.localization.addressFormCityRequired,
                              null => null,
                            },
                            itemLabelBuilder: (item) => item.displayTitle,
                            onChanged: (item) {
                              if (item != null) cubit.selectCity(item);
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Address Line 1
                        BlocBuilder<AddressFormCubit, AddressFormState>(
                          buildWhen: (prev, curr) =>
                              prev.addressLine1Error != curr.addressLine1Error ||
                              prev.addressLine1ValidationState != curr.addressLine1ValidationState,
                          builder: (context, state) => CustomTextField(
                            controller: _line1Controller,
                            hint: context.localization.addressFormLine1,
                            borderRadius: 12,
                            errorText: switch (state.addressLine1Error) {
                              AddressFormFieldError.required => context.localization.addressFormLine1Required,
                              null => state.addressLine1ValidationState.message,
                            },
                            onChanged: cubit.setAddressLine1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Address Line 2
                        BlocBuilder<AddressFormCubit, AddressFormState>(
                          buildWhen: (prev, curr) =>
                              prev.addressLine2ValidationState != curr.addressLine2ValidationState,
                          builder: (context, state) => CustomTextField(
                            controller: _line2Controller,
                            hint: context.localization.addressFormLine2,
                            borderRadius: 12,
                            errorText: state.addressLine2ValidationState.message,
                            onChanged: cubit.setAddressLine2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Phone
                        BlocBuilder<AddressFormCubit, AddressFormState>(
                          buildWhen: (prev, curr) =>
                              prev.phoneError != curr.phoneError ||
                              prev.phoneValidationState != curr.phoneValidationState,
                          builder: (context, state) => CustomPhoneField(
                            controller: _phoneController,
                            borderRadius: 12,
                            errorText: switch (state.phoneError) {
                              AddressFormFieldError.required => context.localization.addressFormPhoneRequired,
                              null => state.phoneValidationState.message,
                            },
                            onChanged: cubit.setPhone,
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Map location picker
                        BlocBuilder<AddressFormCubit, AddressFormState>(
                          buildWhen: (prev, curr) =>
                              prev.latitude != curr.latitude ||
                              prev.longitude != curr.longitude ||
                              prev.locationError != curr.locationError,
                          builder: (context, state) {
                            final hasLocation = state.latitude != null && state.longitude != null;
                            final hasError = state.locationError != null;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    final initLat = double.tryParse(state.latitude ?? '');
                                    final initLng = double.tryParse(state.longitude ?? '');
                                    final result = await context.pushRoute<LatLng>(
                                      MapPickerRoute(initialLatitude: initLat, initialLongitude: initLng),
                                    );
                                    if (result != null) {
                                      cubit.setLocation(
                                        result.latitude.toStringAsFixed(6),
                                        result.longitude.toStringAsFixed(6),
                                      );
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: hasError ? context.theme.colors.error : const Color(0xFFF0F0F0),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          size: 20,
                                          color: hasLocation
                                              ? context.theme.colors.primary
                                              : context.theme.colors.textLight,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            hasLocation
                                                ? '${state.latitude}, ${state.longitude}'
                                                : context.localization.addressFormPickLocation,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: hasLocation
                                                  ? context.theme.colors.textDark
                                                  : context.theme.colors.textLight,
                                            ),
                                          ),
                                        ),
                                        Icon(Icons.chevron_right, color: context.theme.colors.textLight),
                                      ],
                                    ),
                                  ),
                                ),
                                if (hasError)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4, left: 16),
                                    child: Text(switch (state.locationError) {
                                      AddressFormFieldError.required =>
                                        context.localization.addressFormLocationRequired,
                                      null => '',
                                    }, style: TextStyle(color: context.theme.colors.error, fontSize: 12)),
                                  ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        // Save button
                        BlocBuilder<AddressFormCubit, AddressFormState>(
                          buildWhen: (prev, curr) => prev.submitStatus != curr.submitStatus,
                          builder: (context, state) => CustomButton(
                            text: context.localization.addressFormSave,
                            loading: state.submitStatus is StateStatusLoading,
                            onPressed: () => cubit.save(address: widget.address),
                          ),
                        ),
                        if (isEdit) ...[
                          const SizedBox(height: 12),
                          BlocBuilder<AddressFormCubit, AddressFormState>(
                            buildWhen: (prev, curr) => prev.deleteStatus != curr.deleteStatus,
                            builder: (context, state) => CustomButton(
                              text: context.localization.addressFormDelete,
                              loading: state.deleteStatus is StateStatusLoading,
                              backgroundColor: Colors.transparent,
                              outlineColor: context.theme.colors.error,
                              color: context.theme.colors.error,
                              onPressed: () => showConfirmationDialog(
                                context: context,
                                title: context.localization.addressDeleteConfirmTitle,
                                description: context.localization.addressDeleteConfirmDescription,
                                confirmText: context.localization.delete,
                                cancelText: context.localization.cancel,
                                onConfirm: () => cubit.deleteAddress(widget.address!.id),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
