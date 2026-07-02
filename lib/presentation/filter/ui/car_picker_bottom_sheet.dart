import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_button.dart';
import 'package:carfy/common/widgets/shimmer_wrapper.dart';
import 'package:carfy/domain/entities/car/user_car.dart';
import 'package:carfy/presentation/filter/state/car_picker/car_picker_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarPickerBottomSheet extends StatelessWidget {
  const CarPickerBottomSheet({super.key});

  static Future<UserCar?> show(BuildContext context) {
    return showModalBottomSheet<UserCar>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider(
        create: (_) => CarPickerCubit()..load(),
        child: const CarPickerBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 11, bottom: 8),
                child: Container(
                  width: 54,
                  height: 3,
                  decoration: BoxDecoration(color: const Color(0xFFD9D9D9), borderRadius: BorderRadius.circular(100)),
                ),
              ),
              Text(
                context.localization.selectCarModel,
                style: TextStyle(color: context.theme.colors.textDark, fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<CarPickerCubit, CarPickerState>(
                  builder: (context, state) {
                    if (state.status is StateStatusLoading || state.status is StateStatusInitial) {
                      return const _CarPickerLoading();
                    }
                    if (state.cars.isEmpty) return const _CarPickerEmpty();
                    return _CarPickerList(cars: state.cars, scrollController: scrollController);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 28,
                  right: 28,
                  bottom: MediaQuery.of(context).padding.bottom + 16,
                  top: 8,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: context.theme.colors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                    ),
                    child: Text(
                      context.localization.carPickerCancel,
                      style: TextStyle(color: context.theme.colors.primary, fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CarPickerList extends StatelessWidget {
  final List<UserCar> cars;
  final ScrollController scrollController;

  const _CarPickerList({required this.cars, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: cars.length,
      separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFEDEDED)),
      itemBuilder: (context, index) {
        final car = cars[index];
        return InkWell(
          onTap: () => Navigator.pop(context, car),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                '${car.brand.title} ${car.brandModel.title}',
                style: TextStyle(color: context.theme.colors.textDark, fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CarPickerEmpty extends StatelessWidget {
  const _CarPickerEmpty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.localization.profileMyCarsEmpty,
              style: TextStyle(fontSize: 18, color: context.theme.colors.black),
            ),
            const SizedBox(height: 16),
            CustomButton(
              onPressed: () {
                Navigator.pop(context);
                context.pushRoute(CarFormRoute());
              },
              text: context.localization.profileMyCarsAddBtn,
              height: 48,
            ),
          ],
        ),
      ),
    );
  }
}

class _CarPickerLoading extends StatelessWidget {
  const _CarPickerLoading();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 4,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: ShimmerWrapper(
          child: Container(
            height: 20,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
    );
  }
}
