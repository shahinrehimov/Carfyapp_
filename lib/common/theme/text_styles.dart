import 'package:flutter/material.dart';

class CustomTextTheme extends TextTheme {
  final TextStyle headingBlackHeading1;

  final TextStyle headingBoldHeading1;

  final TextStyle headingSemiBoldHeading1;

  final TextStyle headingMediumHeading1;

  final TextStyle headingRegularHeading1;

  final TextStyle headingLightHeading1;

  final TextStyle headingUltraLightHeading1;

  final TextStyle headingBlackHeading2;

  final TextStyle headingBoldHeading2;

  final TextStyle headingSemiBoldHeading2;

  final TextStyle headingMediumHeading2;

  final TextStyle headingRegularHeading2;

  final TextStyle headingLightHeading2;

  final TextStyle headingUltraLightHeading2;

  final TextStyle headingBlackHeading3;

  final TextStyle headingBoldHeading3;

  final TextStyle headingSemiBoldHeading3;

  final TextStyle headingMediumHeading3;

  final TextStyle headingRegularHeading3;

  final TextStyle headingLightHeading3;

  final TextStyle headingUltraLightHeading3;

  final TextStyle headingBlackHeading4;

  final TextStyle headingBoldHeading4;

  final TextStyle headingSemiBoldHeading4;

  final TextStyle headingMediumHeading4;

  final TextStyle headingRegularHeading4;

  final TextStyle headingLightHeading4;

  final TextStyle headingUltraLightHeading4;

  final TextStyle headingBlackHeading5;

  final TextStyle headingBoldHeading5;

  final TextStyle headingSemiBoldHeading5;

  final TextStyle headingMediumHeading5;

  final TextStyle headingRegularHeading5;

  final TextStyle headingLightHeading5;

  final TextStyle headingUltraLightHeading5;

  final TextStyle headingBlackHeading6;

  final TextStyle headingBoldHeading6;

  final TextStyle headingSemiBoldHeading6;

  final TextStyle headingMediumHeading6;
  final TextStyle headingRegularHeading6;

  final TextStyle headingLightHeading6;

  final TextStyle headingUltraLightHeading6;

  // Subtitle Styles
  final TextStyle subtitleBlackSubtitle1;

  final TextStyle subtitleBoldSubtitle1;

  final TextStyle subtitleSemiBoldSubtitle1;

  final TextStyle subtitleMediumSubtitle1;

  final TextStyle subtitleRegularSubtitle1;

  final TextStyle subtitleLightSubtitle1;

  final TextStyle subtitleUltraLightSubtitle1;

  // Subtitle Styles
  final TextStyle subtitleBlackSubtitle2;

  final TextStyle subtitleBoldSubtitle2;

  final TextStyle subtitleSemiBoldSubtitle2;

  final TextStyle subtitleMediumSubtitle2;

  final TextStyle subtitleRegularSubtitle2;

  final TextStyle subtitleLightSubtitle2;

  final TextStyle subtitleUltraLightSubtitle2;

  // Body Styles
  final TextStyle bodyBlackBody1;

  final TextStyle bodyBoldBody1;

  final TextStyle bodySemiBoldBody1;

  final TextStyle bodyMediumBody1;

  final TextStyle bodyRegularBody1;

  final TextStyle bodyLightBody1;

  final TextStyle bodyUltraLightBody1;

  // Body Styles
  final TextStyle bodyBlackBody2;

  final TextStyle bodyBoldBody2;

  final TextStyle bodySemiBoldBody2;

  final TextStyle bodyMediumBody2;

  final TextStyle bodyRegularBody2;

  final TextStyle bodyLightBody2;

  final TextStyle bodyUltraLightBody2;

  // Body Styles
  final TextStyle bodyBlackBody3;

  final TextStyle bodyBoldBody3;

  final TextStyle bodySemiBoldBody3;

  final TextStyle bodyMediumBody3;

  final TextStyle bodyRegularBody3;

  final TextStyle bodyLightBody3;

  final TextStyle bodyUltraLightBody3;

  // Caption Styles
  final TextStyle captionBlack;

  final TextStyle captionBold;

  final TextStyle captionSemiBold;

  final TextStyle captionMedium;

  final TextStyle captionRegular;

  final TextStyle captionLight;

  final TextStyle captionUltraLight;

  // overLine Styles
  final TextStyle overLineBlack;

  final TextStyle overLineBold;

  final TextStyle overLineSemiBold;

  final TextStyle overLineMedium;

  final TextStyle overLineRegular;

  final TextStyle overLineLight;

  final TextStyle overLineUltraLight;

  // overLine Styles
  final TextStyle overLineNormalBlack;

  final TextStyle overLineNormalBold;

  final TextStyle overLineNormalSemiBold;

  final TextStyle overLineNormalMedium;

  final TextStyle overLineNormalRegular;
  final TextStyle overLineNormalLight;

  final TextStyle overLineNormalUltraLight;

  // Mini Styles
  final TextStyle miniBlack;

  final TextStyle miniBold;
  final TextStyle miniSemiBold;

  final TextStyle miniMedium;

  final TextStyle miniRegular;
  final TextStyle miniLight;
  final TextStyle miniUltraLight;

  const CustomTextTheme({
    required this.headingBlackHeading1,
    required this.headingBoldHeading1,
    required this.headingSemiBoldHeading1,
    required this.headingMediumHeading1,
    required this.headingRegularHeading1,
    required this.headingLightHeading1,
    required this.headingUltraLightHeading1,
    required this.headingBlackHeading2,
    required this.headingBoldHeading2,
    required this.headingSemiBoldHeading2,
    required this.headingMediumHeading2,
    required this.headingRegularHeading2,
    required this.headingLightHeading2,
    required this.headingUltraLightHeading2,
    required this.headingBlackHeading3,
    required this.headingBoldHeading3,
    required this.headingSemiBoldHeading3,
    required this.headingMediumHeading3,
    required this.headingRegularHeading3,
    required this.headingLightHeading3,
    required this.headingUltraLightHeading3,
    required this.headingBlackHeading4,
    required this.headingBoldHeading4,
    required this.headingSemiBoldHeading4,
    required this.headingMediumHeading4,
    required this.headingRegularHeading4,
    required this.headingLightHeading4,
    required this.headingUltraLightHeading4,
    required this.headingBlackHeading5,
    required this.headingBoldHeading5,
    required this.headingSemiBoldHeading5,
    required this.headingMediumHeading5,
    required this.headingRegularHeading5,
    required this.headingLightHeading5,
    required this.headingUltraLightHeading5,
    required this.headingBlackHeading6,
    required this.headingBoldHeading6,
    required this.headingSemiBoldHeading6,
    required this.headingMediumHeading6,
    required this.headingRegularHeading6,
    required this.headingLightHeading6,
    required this.headingUltraLightHeading6,
    required this.subtitleBlackSubtitle1,
    required this.subtitleBoldSubtitle1,
    required this.subtitleSemiBoldSubtitle1,
    required this.subtitleMediumSubtitle1,
    required this.subtitleRegularSubtitle1,
    required this.subtitleLightSubtitle1,
    required this.subtitleUltraLightSubtitle1,
    required this.subtitleBlackSubtitle2,
    required this.subtitleBoldSubtitle2,
    required this.subtitleSemiBoldSubtitle2,
    required this.subtitleMediumSubtitle2,
    required this.subtitleRegularSubtitle2,
    required this.subtitleLightSubtitle2,
    required this.subtitleUltraLightSubtitle2,
    required this.bodyBlackBody1,
    required this.bodyBoldBody1,
    required this.bodySemiBoldBody1,
    required this.bodyMediumBody1,
    required this.bodyRegularBody1,
    required this.bodyLightBody1,
    required this.bodyUltraLightBody1,
    required this.bodyBlackBody2,
    required this.bodyBoldBody2,
    required this.bodySemiBoldBody2,
    required this.bodyMediumBody2,
    required this.bodyRegularBody2,
    required this.bodyLightBody2,
    required this.bodyUltraLightBody2,
    required this.bodyBlackBody3,
    required this.bodyBoldBody3,
    required this.bodySemiBoldBody3,
    required this.bodyMediumBody3,
    required this.bodyRegularBody3,
    required this.bodyLightBody3,
    required this.bodyUltraLightBody3,
    required this.captionBlack,
    required this.captionBold,
    required this.captionSemiBold,
    required this.captionMedium,
    required this.captionRegular,
    required this.captionLight,
    required this.captionUltraLight,
    required this.overLineBlack,
    required this.overLineBold,
    required this.overLineSemiBold,
    required this.overLineMedium,
    required this.overLineRegular,
    required this.overLineLight,
    required this.overLineUltraLight,
    required this.overLineNormalBlack,
    required this.overLineNormalBold,
    required this.overLineNormalSemiBold,
    required this.overLineNormalMedium,
    required this.overLineNormalRegular,
    required this.overLineNormalLight,
    required this.overLineNormalUltraLight,
    required this.miniBlack,
    required this.miniBold,
    required this.miniSemiBold,
    required this.miniMedium,
    required this.miniRegular,
    required this.miniLight,
    required this.miniUltraLight,
  }) : super();
}

const String _fontFamilyInter = 'Gilroy';
const double _letterSpacing = 0.4;

TextStyle _baseStyle(FontWeight weight, double size) =>
    TextStyle(fontSize: size, fontFamily: _fontFamilyInter, fontWeight: weight, letterSpacing: _letterSpacing);

CustomTextTheme defaultTextTheme = CustomTextTheme(
  headingBlackHeading1: _baseStyle(FontWeight.w900, 96),
  headingBoldHeading1: _baseStyle(FontWeight.bold, 96),
  headingSemiBoldHeading1: _baseStyle(FontWeight.w600, 96),
  headingMediumHeading1: _baseStyle(FontWeight.w500, 96),
  headingRegularHeading1: _baseStyle(FontWeight.w400, 96),
  headingLightHeading1: _baseStyle(FontWeight.w300, 96),
  headingUltraLightHeading1: _baseStyle(FontWeight.w200, 96),
  headingBlackHeading2: _baseStyle(FontWeight.w900, 60),
  headingBoldHeading2: _baseStyle(FontWeight.bold, 60),
  headingSemiBoldHeading2: _baseStyle(FontWeight.w600, 60),
  headingMediumHeading2: _baseStyle(FontWeight.w500, 60),
  headingRegularHeading2: _baseStyle(FontWeight.w400, 60),
  headingLightHeading2: _baseStyle(FontWeight.w300, 60),
  headingUltraLightHeading2: _baseStyle(FontWeight.w200, 60),
  headingBlackHeading3: _baseStyle(FontWeight.w900, 48),
  headingBoldHeading3: _baseStyle(FontWeight.bold, 48),
  headingSemiBoldHeading3: _baseStyle(FontWeight.w600, 48),
  headingMediumHeading3: _baseStyle(FontWeight.w500, 48),
  headingRegularHeading3: _baseStyle(FontWeight.w400, 48),
  headingLightHeading3: _baseStyle(FontWeight.w300, 48),
  headingUltraLightHeading3: _baseStyle(FontWeight.w200, 48),
  headingBlackHeading4: _baseStyle(FontWeight.w900, 34),
  headingBoldHeading4: _baseStyle(FontWeight.bold, 34),
  headingSemiBoldHeading4: _baseStyle(FontWeight.w600, 34),
  headingMediumHeading4: _baseStyle(FontWeight.w500, 34),
  headingRegularHeading4: _baseStyle(FontWeight.w400, 34),
  headingLightHeading4: _baseStyle(FontWeight.w300, 34),
  headingUltraLightHeading4: _baseStyle(FontWeight.w200, 34),
  headingBlackHeading5: _baseStyle(FontWeight.w900, 24),
  headingBoldHeading5: _baseStyle(FontWeight.bold, 24),
  headingSemiBoldHeading5: _baseStyle(FontWeight.w600, 24),
  headingMediumHeading5: _baseStyle(FontWeight.w500, 24),
  headingRegularHeading5: _baseStyle(FontWeight.w400, 24),
  headingLightHeading5: _baseStyle(FontWeight.w300, 24),
  headingUltraLightHeading5: _baseStyle(FontWeight.w200, 24),
  headingBlackHeading6: _baseStyle(FontWeight.w900, 20),
  headingBoldHeading6: _baseStyle(FontWeight.bold, 20),
  headingSemiBoldHeading6: _baseStyle(FontWeight.w600, 20),
  headingMediumHeading6: _baseStyle(FontWeight.w500, 20),
  headingRegularHeading6: _baseStyle(FontWeight.w400, 20),
  headingLightHeading6: _baseStyle(FontWeight.w300, 20),
  headingUltraLightHeading6: _baseStyle(FontWeight.w200, 20),
  subtitleBlackSubtitle1: _baseStyle(FontWeight.w900, 16),
  subtitleBoldSubtitle1: _baseStyle(FontWeight.bold, 16),
  subtitleSemiBoldSubtitle1: _baseStyle(FontWeight.w600, 16),
  subtitleMediumSubtitle1: _baseStyle(FontWeight.w500, 16),
  subtitleRegularSubtitle1: _baseStyle(FontWeight.w400, 16),
  subtitleLightSubtitle1: _baseStyle(FontWeight.w300, 16),
  subtitleUltraLightSubtitle1: _baseStyle(FontWeight.w200, 16),
  subtitleBlackSubtitle2: _baseStyle(FontWeight.w900, 14),
  subtitleBoldSubtitle2: _baseStyle(FontWeight.bold, 14),
  subtitleSemiBoldSubtitle2: _baseStyle(FontWeight.w600, 14),
  subtitleMediumSubtitle2: _baseStyle(FontWeight.w500, 14),
  subtitleRegularSubtitle2: _baseStyle(FontWeight.w400, 14),
  subtitleLightSubtitle2: _baseStyle(FontWeight.w300, 14),
  subtitleUltraLightSubtitle2: _baseStyle(FontWeight.w200, 14),
  bodyBlackBody1: _baseStyle(FontWeight.w900, 16),
  bodyBoldBody1: _baseStyle(FontWeight.bold, 16),
  bodySemiBoldBody1: _baseStyle(FontWeight.w600, 16),
  bodyMediumBody1: _baseStyle(FontWeight.w500, 16),
  bodyRegularBody1: _baseStyle(FontWeight.w400, 16),
  bodyLightBody1: _baseStyle(FontWeight.w300, 16),
  bodyUltraLightBody1: _baseStyle(FontWeight.w200, 16),
  bodyBlackBody2: _baseStyle(FontWeight.w900, 14),
  bodyBoldBody2: _baseStyle(FontWeight.bold, 14),
  bodySemiBoldBody2: _baseStyle(FontWeight.w600, 14),
  bodyMediumBody2: _baseStyle(FontWeight.w500, 14),
  bodyRegularBody2: _baseStyle(FontWeight.w400, 14),
  bodyLightBody2: _baseStyle(FontWeight.w300, 14),
  bodyUltraLightBody2: _baseStyle(FontWeight.w200, 14),
  bodyBlackBody3: _baseStyle(FontWeight.w900, 14),
  bodyBoldBody3: _baseStyle(FontWeight.bold, 14),
  bodySemiBoldBody3: _baseStyle(FontWeight.w600, 14),
  bodyMediumBody3: _baseStyle(FontWeight.w500, 14),
  bodyRegularBody3: _baseStyle(FontWeight.w400, 14),
  bodyLightBody3: _baseStyle(FontWeight.w300, 14),
  bodyUltraLightBody3: _baseStyle(FontWeight.w200, 14),
  captionBlack: _baseStyle(FontWeight.w900, 12),
  captionBold: _baseStyle(FontWeight.bold, 12),
  captionSemiBold: _baseStyle(FontWeight.w600, 12),
  captionMedium: _baseStyle(FontWeight.w500, 12),
  captionRegular: _baseStyle(FontWeight.w400, 12),
  captionLight: _baseStyle(FontWeight.w300, 12),
  captionUltraLight: _baseStyle(FontWeight.w200, 12),
  overLineBlack: _baseStyle(FontWeight.w900, 10),
  overLineBold: _baseStyle(FontWeight.bold, 10),
  overLineSemiBold: _baseStyle(FontWeight.w600, 10),
  overLineMedium: _baseStyle(FontWeight.w500, 10),
  overLineRegular: _baseStyle(FontWeight.w400, 10),
  overLineLight: _baseStyle(FontWeight.w300, 10),
  overLineUltraLight: _baseStyle(FontWeight.w200, 10),
  overLineNormalBlack: _baseStyle(FontWeight.w900, 10),
  overLineNormalBold: _baseStyle(FontWeight.bold, 10),
  overLineNormalSemiBold: _baseStyle(FontWeight.w600, 10),
  overLineNormalMedium: _baseStyle(FontWeight.w500, 10),
  overLineNormalRegular: _baseStyle(FontWeight.w400, 10),
  overLineNormalLight: _baseStyle(FontWeight.w300, 10),
  overLineNormalUltraLight: _baseStyle(FontWeight.w200, 10),
  miniBlack: _baseStyle(FontWeight.w900, 8),
  miniBold: _baseStyle(FontWeight.bold, 8),
  miniSemiBold: _baseStyle(FontWeight.w600, 8),
  miniMedium: _baseStyle(FontWeight.w500, 8),
  miniRegular: _baseStyle(FontWeight.w400, 8),
  miniLight: _baseStyle(FontWeight.w300, 8),
  miniUltraLight: _baseStyle(FontWeight.w200, 8),
);
