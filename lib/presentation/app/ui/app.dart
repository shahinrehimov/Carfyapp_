import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/presentation/app/ui/widget/multi_provider_wrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../../common/theme/theme.dart';
import '../../../common/translations/delegate.dart';
import '../state/localization/localization_cubit.dart';

class CarfyApp extends StatelessWidget {
  const CarfyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final MediaQueryData data = MediaQuery.of(context);
    return MediaQuery(
      data: data.copyWith(textScaler: TextScaler.noScaling),
      child: AppTheme(
        themeMode: ThemeMode.light,
        child: MultiProviderWrap(
          child: BlocBuilder<LocalizationCubit, LocalizationState>(
            builder: (context, localizationState) {
              return MaterialApp.router(
                theme: AppTheme.of(context).getTheme(),
                debugShowCheckedModeBanner: false,
                locale: localizationState.appLanguage.locale,
                supportedLocales: const [Locale('az', ''), Locale('en', ''), Locale('ru', '')],
                localizationsDelegates: [
                  AppLocalizationsDelegate(context: context),
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                localeResolutionCallback: (locale, supportedLocales) {
                  for (var supportedLocale in supportedLocales) {
                    if (supportedLocale.languageCode == locale?.languageCode &&
                        supportedLocale.countryCode == locale?.countryCode) {
                      return supportedLocale;
                    }
                  }
                  return supportedLocales.first;
                },
                routerConfig: getIt<AppRouter>().config(),
              );
            },
          ),
        ),
      ),
    );
  }
}
