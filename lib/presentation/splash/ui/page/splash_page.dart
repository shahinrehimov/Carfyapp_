import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/widgets/custom_button.dart';
import 'package:carfy/localization/languages/languages.dart';
import 'package:carfy/presentation/splash/state/splash_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashCubit()..init(),
      child: Scaffold(
        backgroundColor: context.theme.colors.bg,
        body: BlocBuilder<SplashCubit, SplashState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: state.firstEnter ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
              children: [
                SizedBox(width: double.maxFinite),
                Image.asset('assets/images/splash-logo.png', width: 250),
                if (state.firstEnter)
                  CustomButton(
                    onPressed: () => context.router.pushAndPopUntil(MainRoute(), predicate: (_) => false),
                    text: Languages.of(context)!.$continue,
                    width: 268,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
