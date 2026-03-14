import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_app_bar.dart';
import 'package:carfy/common/widgets/custom_button.dart';
import 'package:carfy/common/widgets/custom_dropdown.dart';
import 'package:carfy/common/widgets/custom_text_field.dart';
import 'package:carfy/common/widgets/state_status_toast.dart';
import 'package:carfy/domain/entities/car/user_car.dart';
import 'package:carfy/presentation/cars/state/car_form/car_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class CarFormPage extends StatefulWidget implements AutoRouteWrapper {
  final UserCar? car;

  const CarFormPage({super.key, this.car});

  @override
  Widget wrappedRoute(BuildContext context) =>
      BlocProvider(create: (_) => CarFormCubit()..init(car), child: this);

  @override
  State<CarFormPage> createState() => _CarFormPageState();
}

class _CarFormPageState extends State<CarFormPage> {
  final _yearController = TextEditingController();
  final _engineNumberController = TextEditingController();
  final _vinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final car = widget.car;
    if (car != null) {
      _yearController.text = car.year.toString();
      _engineNumberController.text = car.engineNumber ?? '';
      _vinController.text = car.vinNumber ?? '';
    }
  }

  @override
  void dispose() {
    _yearController.dispose();
    _engineNumberController.dispose();
    _vinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CarFormCubit>();
    final car = widget.car;
    final isEdit = car != null;
    final title = isEdit ? '${car.brand.title} ${car.brandModel.title}' : context.localization.carFormAddTitle;

    return BlocListener<CarFormCubit, CarFormState>(
      listenWhen: (prev, curr) =>
          prev.submitStatus != curr.submitStatus || prev.deleteStatus != curr.deleteStatus,
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
              // Brand
              BlocBuilder<CarFormCubit, CarFormState>(
                buildWhen: (prev, curr) =>
                    prev.brands != curr.brands ||
                    prev.brandsStatus != curr.brandsStatus ||
                    prev.selectedBrand != curr.selectedBrand,
                builder: (context, state) {
                  return CustomDropdownField(
                    items: state.brands,
                    value: state.selectedBrand,
                    hint: context.localization.carFormBrand,
                    isLoading: state.brandsStatus is StateStatusLoading,
                    searchable: true,
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
                    prev.selectedBrand != curr.selectedBrand,
                builder: (context, state) {
                  return CustomDropdownField(
                    items: state.models,
                    value: state.selectedModel,
                    hint: context.localization.carFormModel,
                    isLoading: state.modelsStatus is StateStatusLoading,
                    searchable: true,
                    enabled: state.selectedBrand != null,
                    itemLabelBuilder: (item) => item.title,
                    onChanged: (item) {
                      if (item != null) cubit.selectModel(item);
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              // Year
              CustomTextField(
                controller: _yearController,
                hint: context.localization.carFormYear,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                onChanged: (value) => cubit.setYear(value),
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
                    prev.selectedCarType != curr.selectedCarType,
                builder: (context, state) {
                  return CustomDropdownField(
                    items: state.carTypes,
                    value: state.selectedCarType,
                    hint: context.localization.carFormCarType,
                    isLoading: state.carTypesStatus is StateStatusLoading,
                    itemLabelBuilder: (item) => item.title,
                    onChanged: (item) {
                      if (item != null) cubit.selectCarType(item);
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              // Engine Number
              CustomTextField(
                controller: _engineNumberController,
                hint: context.localization.carFormEngineNumber,
                onChanged: (value) => cubit.setEngineNumber(value),
              ),
              const SizedBox(height: 16),
              // VIN Number
              CustomTextField(
                controller: _vinController,
                hint: context.localization.carFormVinNumber,
                onChanged: (value) => cubit.setVinNumber(value),
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
                      onPressed: () => cubit.deleteCar(car.id),
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
