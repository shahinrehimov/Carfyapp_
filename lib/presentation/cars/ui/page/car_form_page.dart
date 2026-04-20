import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carfy/common/state/field_validation_state.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/car_color_picker.dart';
import 'package:carfy/common/widgets/custom_app_bar.dart';
import 'package:carfy/common/widgets/custom_button.dart';
import 'package:carfy/common/widgets/custom_dropdown.dart';
import 'package:carfy/common/widgets/custom_text_field.dart';
import 'package:carfy/common/widgets/confirmation_dialog.dart';
import 'package:carfy/common/widgets/state_status_toast.dart';
import 'package:carfy/domain/entities/car/user_car.dart';
import 'package:carfy/gen/assets.gen.dart';
import 'package:carfy/presentation/cars/state/car_form/car_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class CarFormPage extends StatefulWidget implements AutoRouteWrapper {
  final UserCar? car;

  const CarFormPage({super.key, this.car});

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(create: (_) => CarFormCubit()..init(car), child: this);

  @override
  State<CarFormPage> createState() => _CarFormPageState();
}

class _CarFormPageState extends State<CarFormPage> {
  final _yearController = TextEditingController();
  final _engineNumberController = TextEditingController();
  final _vinController = TextEditingController();
  final _seatCountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final car = widget.car;
    if (car != null) {
      _yearController.text = car.year.toString();
      _engineNumberController.text = car.engineNumber ?? '';
      _vinController.text = car.vinNumber ?? '';
      _seatCountController.text = car.seatCount?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _yearController.dispose();
    _engineNumberController.dispose();
    _vinController.dispose();
    _seatCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CarFormCubit>();
    final car = widget.car;
    final isEdit = car != null;
    final title = isEdit ? '${car.brand.title} ${car.brandModel.title}' : context.localization.carFormAddTitle;

    return BlocListener<CarFormCubit, CarFormState>(
      listenWhen: (prev, curr) => prev.submitStatus != curr.submitStatus || prev.deleteStatus != curr.deleteStatus,
      listener: (context, state) {
        showStateStatusToast(context, state.submitStatus);
        showStateStatusToast(context, state.deleteStatus);
        if (state.submitStatus is StateStatusSuccess || state.deleteStatus is StateStatusSuccess) {
          context.maybePop(true);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        appBar: CustomAppBarWhite(title: title),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Photo
              BlocBuilder<CarFormCubit, CarFormState>(
                buildWhen: (prev, curr) =>
                    prev.selectedPhotoPath != curr.selectedPhotoPath ||
                    prev.deleteExistingPhoto != curr.deleteExistingPhoto,
                builder: (context, state) {
                  final existingPhoto = (!state.deleteExistingPhoto) ? car?.photo : null;
                  final localPath = state.selectedPhotoPath;
                  final hasPhoto = localPath != null || existingPhoto != null;
                  return Center(
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: cubit.pickPhoto,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: context.theme.colors.bg,
                              shape: BoxShape.circle,
                              border: Border.all(color: context.theme.colors.border),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: hasPhoto
                                ? (localPath != null
                                      ? Image.file(File(localPath), fit: BoxFit.cover)
                                      : CachedNetworkImage(imageUrl: existingPhoto!, fit: BoxFit.cover))
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(Assets.icons.carHatchback, width: 36, height: 36),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Şəkil',
                                        style: TextStyle(fontSize: 11, color: context.theme.colors.textLight),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: hasPhoto ? cubit.removePhoto : cubit.pickPhoto,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: hasPhoto ? context.theme.colors.error : context.theme.colors.primary,
                              ),
                              child: Icon(hasPhoto ? Icons.close : Icons.add, size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              // Brand
              BlocBuilder<CarFormCubit, CarFormState>(
                buildWhen: (prev, curr) =>
                    prev.brands != curr.brands ||
                    prev.brandsStatus != curr.brandsStatus ||
                    prev.selectedBrand != curr.selectedBrand ||
                    prev.brandError != curr.brandError,
                builder: (context, state) {
                  return CustomDropdownField(
                    items: state.brands,
                    value: state.selectedBrand,
                    hint: context.localization.carFormBrand,
                    isLoading: state.brandsStatus is StateStatusLoading,
                    hasError: state.brandsStatus is StateStatusFailure,
                    onRetry: cubit.retryBrands,
                    searchable: true,
                    errorText: switch (state.brandError) {
                      CarFormFieldError.required => context.localization.carFormBrandRequired,
                      null => null,
                    },
                    itemLabelBuilder: (item) => item.title,
                    onChanged: (item) {
                      if (item != null) cubit.selectBrand(item);
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              // Model
              BlocBuilder<CarFormCubit, CarFormState>(
                buildWhen: (prev, curr) =>
                    prev.models != curr.models ||
                    prev.modelsStatus != curr.modelsStatus ||
                    prev.selectedModel != curr.selectedModel ||
                    prev.selectedBrand != curr.selectedBrand ||
                    prev.modelError != curr.modelError ||
                    prev.brandModelValidationState != curr.brandModelValidationState,
                builder: (context, state) {
                  return CustomDropdownField(
                    items: state.models,
                    value: state.selectedModel,
                    hint: context.localization.carFormModel,
                    isLoading: state.modelsStatus is StateStatusLoading,
                    hasError: state.modelsStatus is StateStatusFailure,
                    onRetry: cubit.retryModels,
                    searchable: true,
                    enabled: state.selectedBrand != null,
                    errorText: switch (state.modelError) {
                      CarFormFieldError.required => context.localization.carFormModelRequired,
                      null => state.brandModelValidationState.message,
                    },
                    itemLabelBuilder: (item) => item.title,
                    onChanged: (item) {
                      if (item != null) cubit.selectModel(item);
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              // Year
              BlocBuilder<CarFormCubit, CarFormState>(
                buildWhen: (prev, curr) =>
                    prev.yearError != curr.yearError || prev.yearValidationState != curr.yearValidationState,
                builder: (context, state) {
                  return CustomTextField(
                    controller: _yearController,
                    hint: context.localization.carFormYear,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                    errorText: switch (state.yearError) {
                      CarFormFieldError.required => context.localization.carFormYearRequired,
                      null => state.yearValidationState.message,
                    },
                    onChanged: (value) => cubit.setYear(value),
                  );
                },
              ),
              const SizedBox(height: 16),
              // Engine Volume
              BlocBuilder<CarFormCubit, CarFormState>(
                buildWhen: (prev, curr) =>
                    prev.engineVolumes != curr.engineVolumes ||
                    prev.engineVolumesStatus != curr.engineVolumesStatus ||
                    prev.selectedEngineVolume != curr.selectedEngineVolume,
                builder: (context, state) {
                  return CustomDropdownField(
                    items: state.engineVolumes,
                    value: state.selectedEngineVolume,
                    hint: context.localization.carFormEngineVolume,
                    isLoading: state.engineVolumesStatus is StateStatusLoading,
                    hasError: state.engineVolumesStatus is StateStatusFailure,
                    onRetry: cubit.retryEngineVolumes,
                    itemLabelBuilder: (item) => item.title,
                    onChanged: (item) {
                      if (item != null) cubit.selectEngineVolume(item);
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              // Fuel Type
              BlocBuilder<CarFormCubit, CarFormState>(
                buildWhen: (prev, curr) =>
                    prev.fuelTypes != curr.fuelTypes ||
                    prev.fuelTypesStatus != curr.fuelTypesStatus ||
                    prev.selectedFuelType != curr.selectedFuelType,
                builder: (context, state) {
                  return CustomDropdownField(
                    items: state.fuelTypes,
                    value: state.selectedFuelType,
                    hint: context.localization.carFormFuelType,
                    isLoading: state.fuelTypesStatus is StateStatusLoading,
                    hasError: state.fuelTypesStatus is StateStatusFailure,
                    onRetry: cubit.retryFuelTypes,
                    itemLabelBuilder: (item) => item.title,
                    onChanged: (item) {
                      if (item != null) cubit.selectFuelType(item);
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              // Transmission Type
              BlocBuilder<CarFormCubit, CarFormState>(
                buildWhen: (prev, curr) =>
                    prev.transmissionTypes != curr.transmissionTypes ||
                    prev.transmissionTypesStatus != curr.transmissionTypesStatus ||
                    prev.selectedTransmissionType != curr.selectedTransmissionType,
                builder: (context, state) {
                  return CustomDropdownField(
                    items: state.transmissionTypes,
                    value: state.selectedTransmissionType,
                    hint: context.localization.carFormTransmissionType,
                    isLoading: state.transmissionTypesStatus is StateStatusLoading,
                    hasError: state.transmissionTypesStatus is StateStatusFailure,
                    onRetry: cubit.retryTransmissionTypes,
                    itemLabelBuilder: (item) => item.title,
                    onChanged: (item) {
                      if (item != null) cubit.selectTransmissionType(item);
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              // Car Type
              BlocBuilder<CarFormCubit, CarFormState>(
                buildWhen: (prev, curr) =>
                    prev.carTypes != curr.carTypes ||
                    prev.carTypesStatus != curr.carTypesStatus ||
                    prev.selectedCarType != curr.selectedCarType ||
                    prev.carTypeError != curr.carTypeError ||
                    prev.carTypeValidationState != curr.carTypeValidationState,
                builder: (context, state) {
                  return CustomDropdownField(
                    items: state.carTypes,
                    value: state.selectedCarType,
                    hint: context.localization.carFormCarType,
                    isLoading: state.carTypesStatus is StateStatusLoading,
                    hasError: state.carTypesStatus is StateStatusFailure,
                    onRetry: cubit.retryCarTypes,
                    errorText: switch (state.carTypeError) {
                      CarFormFieldError.required => context.localization.carFormCarTypeRequired,
                      null => state.carTypeValidationState.message,
                    },
                    itemLabelBuilder: (item) => item.title,
                    onChanged: (item) {
                      if (item != null) cubit.selectCarType(item);
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              // Engine Number
              BlocBuilder<CarFormCubit, CarFormState>(
                buildWhen: (prev, curr) => prev.engineNumberValidationState != curr.engineNumberValidationState,
                builder: (context, state) {
                  return CustomTextField(
                    controller: _engineNumberController,
                    hint: context.localization.carFormEngineNumber,
                    errorText: state.engineNumberValidationState.message,
                    onChanged: (value) => cubit.setEngineNumber(value),
                  );
                },
              ),
              const SizedBox(height: 16),
              // VIN Number
              BlocBuilder<CarFormCubit, CarFormState>(
                buildWhen: (prev, curr) => prev.vinNumberValidationState != curr.vinNumberValidationState,
                builder: (context, state) {
                  return CustomTextField(
                    controller: _vinController,
                    hint: context.localization.carFormVinNumber,
                    errorText: state.vinNumberValidationState.message,
                    onChanged: (value) => cubit.setVinNumber(value),
                  );
                },
              ),
              const SizedBox(height: 16),
              // Car Color
              BlocBuilder<CarFormCubit, CarFormState>(
                buildWhen: (prev, curr) =>
                    prev.carColors != curr.carColors ||
                    prev.carColorsStatus != curr.carColorsStatus ||
                    prev.selectedCarColor != curr.selectedCarColor ||
                    prev.carColorValidationState != curr.carColorValidationState,
                builder: (context, state) {
                  return CarColorPickerField(
                    colors: state.carColors,
                    selected: state.selectedCarColor,
                    hint: context.localization.carFormColor,
                    sheetTitle: context.localization.carFormColor,
                    isLoading: state.carColorsStatus is StateStatusLoading,
                    hasLoadError: state.carColorsStatus is StateStatusFailure,
                    onRetry: cubit.retryCarColors,
                    errorText: state.carColorValidationState.message,
                    onSelected: cubit.selectCarColor,
                  );
                },
              ),
              const SizedBox(height: 16),
              // Seat Count
              BlocBuilder<CarFormCubit, CarFormState>(
                buildWhen: (prev, curr) => prev.seatCountValidationState != curr.seatCountValidationState,
                builder: (context, state) {
                  return CustomTextField(
                    controller: _seatCountController,
                    hint: context.localization.carFormSeatCount,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    errorText: state.seatCountValidationState.message,
                    onChanged: (value) => cubit.setSeatCount(value),
                  );
                },
              ),
              const SizedBox(height: 32),
              // Save button
              BlocBuilder<CarFormCubit, CarFormState>(
                buildWhen: (prev, curr) => prev.submitStatus != curr.submitStatus,
                builder: (context, state) {
                  return CustomButton(
                    onPressed: () => cubit.save(car: car),
                    loading: state.submitStatus is StateStatusLoading,
                    text: context.localization.carFormSave,
                  );
                },
              ),
              if (isEdit) ...[
                const SizedBox(height: 12),
                BlocBuilder<CarFormCubit, CarFormState>(
                  buildWhen: (prev, curr) => prev.deleteStatus != curr.deleteStatus,
                  builder: (context, state) {
                    return CustomButton(
                      onPressed: () => showConfirmationDialog(
                        context: context,
                        title: context.localization.carDeleteConfirmTitle,
                        description: context.localization.carDeleteConfirmDescription,
                        confirmText: context.localization.delete,
                        cancelText: context.localization.cancel,
                        onConfirm: () => cubit.deleteCar(car.id),
                      ),
                      loading: state.deleteStatus is StateStatusLoading,
                      backgroundColor: Colors.transparent,
                      outlineColor: context.theme.colors.error,
                      color: context.theme.colors.error,
                      text: context.localization.carFormDelete,
                    );
                  },
                ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
