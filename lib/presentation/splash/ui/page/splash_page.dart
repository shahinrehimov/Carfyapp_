import 'package:auto_route/annotations.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/presentation/splash/state/splash_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (_) => SplashCubit()..init(),
      child: Scaffold(backgroundColor: context.theme.colors.bg),
    );
  }
}
