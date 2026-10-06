import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_button.dart';
import 'package:carfy/common/widgets/custom_dropdown.dart';
import 'package:carfy/domain/entities/products/fitment_selection_options.dart';
import 'package:carfy/domain/params/product/product_show_params.dart';
import 'package:carfy/domain/use_cases/car/get_brand_models_use_case.dart';
import 'package:carfy/domain/use_cases/car/get_brands_use_case.dart';
import 'package:carfy/domain/use_cases/product/get_product_show_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ─── State ───────────────────────────────────────────────────────────────────

class FitmentSelectionState extends Equatable {
  final StateStatus status;
  final FitmentSelectionOptions? options;
  final List<FitmentBrandOption> availableBrands;
  final FitmentBrandOption? selectedBrand;
  final List<FitmentModelOption> availableModels;
  final StateStatus modelsStatus;
  final FitmentModelOption? selectedModel;

  const FitmentSelectionState({
    required this.status,
    this.options,
    this.availableBrands = const [],
    this.selectedBrand,
    this.availableModels = const [],
    this.modelsStatus = const StateStatus(),
    this.selectedModel,
  });

  factory FitmentSelectionState.initial() =>
      FitmentSelectionState(status: StateStatus.initial());

  bool get canConfirm {
    if (selectedBrand == null) return false;
    if (selectedBrand!.anyModel && availableModels.isEmpty) return true;
    return selectedModel != null;
  }

  FitmentSelectionState copyWith({
    StateStatus? status,
    FitmentSelectionOptions? options,
    List<FitmentBrandOption>? availableBrands,
    FitmentBrandOption? selectedBrand,
    bool clearBrand = false,
    List<FitmentModelOption>? availableModels,
    StateStatus? modelsStatus,
    FitmentModelOption? selectedModel,
    bool clearModel = false,
  }) {
    return FitmentSelectionState(
      status: status ?? this.status,
      options: options ?? this.options,
      availableBrands: availableBrands ?? this.availableBrands,
      selectedBrand: clearBrand ? null : selectedBrand ?? this.selectedBrand,
      availableModels: availableModels ?? this.availableModels,
      modelsStatus: modelsStatus ?? this.modelsStatus,
      selectedModel: clearModel ? null : selectedModel ?? this.selectedModel,
    );
  }

  @override
  List<Object?> get props => [status, options, availableBrands, selectedBrand, availableModels, modelsStatus, selectedModel];
}

// ─── Cubit ────────────────────────────────────────────────────────────────────

class FitmentSelectionCubit extends Cubit<FitmentSelectionState> with StateMapHelper {
  final GetProductShowUseCase _getProductShowUseCase;
  final GetBrandsUseCase _getBrandsUseCase;
  final GetBrandModelsUseCase _getBrandModelsUseCase;

  FitmentSelectionCubit({
    GetProductShowUseCase? getProductShowUseCase,
    GetBrandsUseCase? getBrandsUseCase,
    GetBrandModelsUseCase? getBrandModelsUseCase,
  })  : _getProductShowUseCase = getProductShowUseCase ?? getIt<GetProductShowUseCase>(),
        _getBrandsUseCase = getBrandsUseCase ?? getIt<GetBrandsUseCase>(),
        _getBrandModelsUseCase = getBrandModelsUseCase ?? getIt<GetBrandModelsUseCase>(),
        super(FitmentSelectionState.initial());

  Future<void> init(String cpvUuid, {FitmentSelectionOptions? options}) async {
    if (options != null) {
      await _applyOptions(options);
      return;
    }
    emit(state.copyWith(status: StateStatus.loading()));
    final result = await _getProductShowUseCase(ProductShowParams(cpvUuid: cpvUuid));
    result.fold(
      (failure) => emit(state.copyWith(status: mapFailure(failure))),
      (show) async {
        if (show.fitmentSelectionOptions != null) {
          await _applyOptions(show.fitmentSelectionOptions!);
        } else {
          emit(state.copyWith(status: StateStatus.success()));
        }
      },
    );
  }

  Future<void> _applyOptions(FitmentSelectionOptions options) async {
    if (options.anyBrand) {
      emit(state.copyWith(status: StateStatus.loading(), options: options));
      final result = await _getBrandsUseCase();
      result.fold(
        (failure) => emit(state.copyWith(status: mapFailure(failure))),
        (brands) {
          final brandOptions = brands
              .map((b) => FitmentBrandOption(id: b.id, title: b.title, anyModel: true, models: []))
              .toList();
          emit(state.copyWith(status: StateStatus.success(), options: options, availableBrands: brandOptions));
        },
      );
    } else {
      emit(state.copyWith(
        status: StateStatus.success(),
        options: options,
        availableBrands: options.brands,
      ));
    }
  }

  Future<void> selectBrand(FitmentBrandOption brand) async {
    emit(state.copyWith(selectedBrand: brand, availableModels: [], clearModel: true, modelsStatus: StateStatus.initial()));

    if (brand.anyModel) {
      emit(state.copyWith(modelsStatus: StateStatus.loading()));
      final result = await _getBrandModelsUseCase(brand.id);
      result.fold(
        (failure) => emit(state.copyWith(modelsStatus: mapFailure(failure))),
        (models) {
          final modelOptions = models.map((m) => FitmentModelOption(id: m.id, title: m.title)).toList();
          emit(state.copyWith(availableModels: modelOptions, modelsStatus: StateStatus.success()));
        },
      );
    } else {
      emit(state.copyWith(availableModels: brand.models, modelsStatus: StateStatus.success()));
    }
  }

  void selectModel(FitmentModelOption model) {
    emit(state.copyWith(selectedModel: model));
  }
}

// ─── Bottom Sheet ─────────────────────────────────────────────────────────────

class FitmentSelectionBottomSheet extends StatelessWidget {
  final String cpvUuid;
  final FitmentSelectionOptions? preloadedOptions;
  final void Function(int brandId, int? brandModelId) onConfirm;

  const FitmentSelectionBottomSheet({
    super.key,
    required this.cpvUuid,
    this.preloadedOptions,
    required this.onConfirm,
  });

  static Future<void> show(
    BuildContext context, {
    required String cpvUuid,
    FitmentSelectionOptions? preloadedOptions,
    required void Function(int brandId, int? brandModelId) onConfirm,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider(
        create: (ctx) => FitmentSelectionCubit()..init(cpvUuid, options: preloadedOptions),
        child: FitmentSelectionBottomSheet(
          cpvUuid: cpvUuid,
          preloadedOptions: preloadedOptions,
          onConfirm: onConfirm,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom + 16,
      ),
      child: BlocBuilder<FitmentSelectionCubit, FitmentSelectionState>(
        builder: (context, state) {
          final isLoading = state.status.maybeWhen(loading: () => true, orElse: () => false);

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDDDDD),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                context.localization.addToBasket,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: context.theme.colors.black),
              ),
              const SizedBox(height: 4),
              Text(
                context.localization.carFormBrand,
                style: TextStyle(fontSize: 12, color: context.theme.colors.black.withValues(alpha: 0.5)),
              ),
              const SizedBox(height: 16),
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else ...[
                // Brand dropdown
                CustomDropdownField<FitmentBrandOption>(
                  items: state.availableBrands,
                  value: state.selectedBrand,
                  hint: context.localization.carFormBrand,
                  searchable: true,
                  itemLabelBuilder: (b) => b.title,
                  onChanged: (b) {
                    if (b != null) context.read<FitmentSelectionCubit>().selectBrand(b);
                  },
                ),
                const SizedBox(height: 12),
                // Model dropdown
                BlocBuilder<FitmentSelectionCubit, FitmentSelectionState>(
                  buildWhen: (p, c) => p.selectedBrand != c.selectedBrand || p.availableModels != c.availableModels || p.modelsStatus != c.modelsStatus || p.selectedModel != c.selectedModel,
                  builder: (context, state) {
                    final modelsLoading = state.modelsStatus.maybeWhen(loading: () => true, orElse: () => false);
                    return CustomDropdownField<FitmentModelOption>(
                      items: state.availableModels,
                      value: state.selectedModel,
                      hint: context.localization.carFormModel,
                      searchable: true,
                      enabled: state.selectedBrand != null && !modelsLoading,
                      isLoading: modelsLoading,
                      itemLabelBuilder: (m) => m.title,
                      onChanged: (m) {
                        if (m != null) context.read<FitmentSelectionCubit>().selectModel(m);
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
                BlocBuilder<FitmentSelectionCubit, FitmentSelectionState>(
                  buildWhen: (p, c) => p.canConfirm != c.canConfirm,
                  builder: (context, state) {
                    return CustomButton(
                      onPressed: state.canConfirm
                          ? () {
                              final brandId = state.selectedBrand!.id;
                              final brandModelId = state.selectedModel?.id;
                              Navigator.of(context).pop();
                              onConfirm(brandId, brandModelId);
                            }
                          : null,
                      text: context.localization.addToBasket,
                    );
                  },
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
