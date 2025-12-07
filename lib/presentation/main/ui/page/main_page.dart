import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/common/theme/theme.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../state/main_cubit.dart';
import '../enum/main_pages.dart';
import '../widgets/custom_bottom_nav.dart';

@RoutePage()
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MainCubit(),
      child: AutoTabsScaffold(
        lazyLoad: true,
        backgroundColor: context.theme.colors.bg,
        routes: const [HomeRoute(), MessagesRoute(), FavoritesRoute(), BasketRoute(), ProfileRoute()],
        bottomNavigationBuilder: (context, tabsRouter) {
          return BlocConsumer<MainCubit, MainPages>(
            listener: (context, state) {
              tabsRouter.setActiveIndex(state.value);
            },
            builder: (context, state) {
              return CustomBottomNav(
                onTap: (MainPages page) {
                  if (page.value == tabsRouter.activeIndex) {
                    tabsRouter.maybePopTop();
                  } else {
                    context.read<MainCubit>().changePage(page);
                  }
                },
                activePage: state,
              );
            },
          );
        },
      ),
    );
  }
}
