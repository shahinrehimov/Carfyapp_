import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:carfy/presentation/app/state/basket_manager/basket_manager_cubit.dart';
import 'package:carfy/presentation/app/state/localization/localization_cubit.dart';
import 'package:carfy/presentation/app/state/wishlist_manager/wishlist_manager_cubit.dart';
import 'package:carfy/presentation/filter/state/filter_cubit.dart';

class MultiProviderWrap extends StatelessWidget {
  final Widget child;

  const MultiProviderWrap({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocalizationCubit>(create: (_) => LocalizationCubit()..init(), lazy: false),
        BlocProvider<BasketManagerCubit>(create: (_) => BasketManagerCubit(), lazy: false),
        BlocProvider<WishlistManagerCubit>(create: (_) => WishlistManagerCubit(), lazy: false),
        BlocProvider<FilterCubit>(create: (_) => FilterCubit()..loadFilters(), lazy: false),
      ],
      child: child,
    );
  }
}
