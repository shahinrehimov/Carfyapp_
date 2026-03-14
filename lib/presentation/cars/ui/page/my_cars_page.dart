import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_app_bar.dart';
import 'package:carfy/common/widgets/custom_button.dart';
import 'package:carfy/common/widgets/shimmer_wrapper.dart';
import 'package:carfy/common/widgets/state_status_toast.dart';
import 'package:carfy/domain/entities/car/user_car.dart';
import 'package:carfy/gen/assets.gen.dart';
import 'package:carfy/presentation/cars/state/my_cars_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

part '../widget/car_item.dart';

@RoutePage()
class MyCarsPage extends StatelessWidget implements AutoRouteWrapper {
  const MyCarsPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(create: (_) => MyCarsCubit()..init(), child: this);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MyCarsCubit>();
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: CustomAppBarWhite(title: context.localization.profileMyCars),
      body: BlocListener<MyCarsCubit, MyCarsState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) => showStateStatusToast(context, state.status),
        child: BlocBuilder<MyCarsCubit, MyCarsState>(
          builder: (context, state) {
            return state.status.maybeWhen(
              loading: () => const _CarListShimmer(),
              orElse: () => state.cars.isEmpty ? const _EmptyCarsView() : _CarList(cars: state.cars, cubit: cubit),
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(67, 8, 67, 16),
          child: CustomButton(
            onPressed: () {},
            backgroundColor: Colors.transparent,
            outlineColor: context.theme.colors.primary,
            color: context.theme.colors.primary,
            prefix: SvgPicture.asset(
              Assets.icons.plus,
              height: 23,
              colorFilter: ColorFilter.mode(context.theme.colors.primary, BlendMode.srcIn),
            ),
            text: context.localization.profileMyCarsAddBtn,
          ),
        ),
      ),
    );
  }
}

class _CarList extends StatelessWidget {
  final List<UserCar> cars;
  final MyCarsCubit cubit;

  const _CarList({required this.cars, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: cars.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) => BlocBuilder<MyCarsCubit, MyCarsState>(
        buildWhen: (prev, curr) => prev.deleteStatus[cars[index].id] != curr.deleteStatus[cars[index].id],
        builder: (context, state) => CarItem(
          car: cars[index],
          isDeleting: state.deleteStatus[cars[index].id] is StateStatusLoading,
          onDelete: () => cubit.deleteCar(cars[index].id),
          onEdit: () {},
          onSearch: () {},
        ),
      ),
    );
  }
}

class _EmptyCarsView extends StatelessWidget {
  const _EmptyCarsView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        context.localization.profileMyCarsEmpty,
        style: TextStyle(color: context.theme.colors.darkGray, fontSize: 14),
      ),
    );
  }
}

class _CarListShimmer extends StatelessWidget {
  const _CarListShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, __) => ShimmerWrapper(
        child: Container(
          height: 225,
          decoration: BoxDecoration(color: context.theme.colors.white, borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }
}
