import 'package:flutter/material.dart';
import 'package:wilde_buren/config/theme/custom_colors.dart';
import 'package:wilde_buren/config/theme/size_setter.dart';

class CustomTheme {
  BuildContext context;

  static const fontFamily = 'TitilliumWeb';

  CustomTheme(this.context);

  ThemeData get themeData {
    SizeSetter.construct(context);

    return ThemeData(
      useMaterial3: true,
      textTheme: TextTheme(
        // Display
        displayLarge: TextStyle(
          fontSize: SizeSetter.getDisplayLargeSize(),
          fontFamily: fontFamily,
          fontWeight: FontWeight.w700,
          height: 1,
          color: CustomColors.dark,
        ),
        displayMedium: TextStyle(
          fontSize: SizeSetter.getDisplayMediumSize(),
          fontFamily: fontFamily,
          fontWeight: FontWeight.w700,
          height: 1,
          color: CustomColors.dark,
        ),
        displaySmall: TextStyle(
          fontSize: SizeSetter.getDisplaySmallSize(),
          fontFamily: fontFamily,
          fontWeight: FontWeight.w700,
          height: 1,
          color: CustomColors.dark,
        ),

        // Headline -- 700
        headlineLarge: TextStyle(
          fontSize: SizeSetter.getHeadlineLargeSize(),
          fontFamily: fontFamily,
          fontWeight: FontWeight.w700,
          height: 1,
          color: CustomColors.primary,
        ),
        headlineMedium: TextStyle(
          fontSize: SizeSetter.getHeadlineMediumSize(),
          fontFamily: fontFamily,
          fontWeight: FontWeight.w600,
          height: 1,
          color: CustomColors.primary,
        ),
        headlineSmall: TextStyle(
          fontSize: SizeSetter.getHeadlineSmallSize(),
          fontFamily: fontFamily,
          fontWeight: FontWeight.w600,
          height: 1,
          color: CustomColors.primary,
        ),

        // Title -- 500
        titleLarge: TextStyle(
          fontSize: SizeSetter.getTitleLargeSize(),
          fontFamily: fontFamily,
          fontWeight: FontWeight.w700,
          height: 1,
          color: CustomColors.primary,
        ),
        titleMedium: TextStyle(
          fontSize: SizeSetter.getTitleMediumSize(),
          fontFamily: fontFamily,
          fontWeight: FontWeight.w600,
          height: 1,
          color: CustomColors.primary,
        ),
        titleSmall: TextStyle(
          fontSize: SizeSetter.getTitleSmallSize(),
          fontFamily: fontFamily,
          fontWeight: FontWeight.w500,
          height: 1,
          color: CustomColors.dark,
        ),

        // Label -- 900
        labelSmall: TextStyle(
          fontSize: SizeSetter.getLabelSmallSize(),
          fontFamily: fontFamily,
          fontWeight: FontWeight.w500,
          height: 1,
          color: CustomColors.dark,
        ),
        labelMedium: TextStyle(
          fontSize: SizeSetter.getLabelMediumSize(),
          fontFamily: fontFamily,
          fontWeight: FontWeight.w500,
          height: 1,
          color: CustomColors.dark,
        ),
        labelLarge: TextStyle(
          fontSize: SizeSetter.getLabelLargeSize(),
          fontFamily: fontFamily,
          fontWeight: FontWeight.w700,
          height: 1,
          color: CustomColors.dark,
        ),

        // Body -- 400
        bodyLarge: TextStyle(
          fontSize: SizeSetter.getBodyLargeSize(),
          fontFamily: fontFamily,
          fontWeight: FontWeight.w400,
          color: CustomColors.dark,
        ),
        bodyMedium: TextStyle(
          fontSize: SizeSetter.getBodyMediumSize(),
          fontFamily: fontFamily,
          fontWeight: FontWeight.w400,
          color: CustomColors.dark,
        ),
        bodySmall: TextStyle(
          fontSize: SizeSetter.getBodySmallSize(),
          fontFamily: fontFamily,
          fontWeight: FontWeight.w400,
          color: CustomColors.dark,
        ),
      ),
    );
  }
}
