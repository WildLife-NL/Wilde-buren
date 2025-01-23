import 'package:flutter/material.dart';
import 'package:wilde_buren/models/enums/horizontal_screen_padding.dart';
import 'package:wilde_buren/models/enums/screen_size.dart';

class SizeSetter {
  // Define screen size limits here
  static const int _xsMaxSize =
      1000; // XS - Small phones (iPhone SE, 13 mini || Google Pixel 2, Pixel 3)
  static const int _smMaxSize =
      1500; // SM - Normal phones (iPhone 14 / Pro Max, most Android phones)
  static const int _mdMaxSize =
      1800; // MD - Large phones or small tablets (Galaxy Fold, iPad mini)
  static ScreenSize screenSize = ScreenSize.sm;
  static double viewWidth = 0.0;
  // XL will be mdMaxSize and bigger - Tablets and larger

  static void construct(BuildContext buildContext) {
    viewWidth = View.of(buildContext).physicalSize.width;
    screenSize = _getScreenSize(viewWidth);
  }

  /// Returns a __String__ containing the sceen size based on the __width__ of the __[context]__
  static ScreenSize _getScreenSize(double screenWidth) {
    if (screenWidth >= 0 && screenWidth <= _xsMaxSize) {
      return ScreenSize.xs;
    } else if (screenWidth >= _xsMaxSize + 1 && screenWidth <= _smMaxSize) {
      return ScreenSize.sm;
    } else if (screenWidth >= _smMaxSize + 1 && screenWidth <= _mdMaxSize) {
      return ScreenSize.md;
    } else {
      return ScreenSize.xl;
    }
  }

  /// Returns the number that corresponds to the given __[screenSize]__
  static double _getValueByScreenSize(
      {required double xs,
      required double sm,
      required double md,
      required double xl}) {
    // get screen size with same value as key
    switch (screenSize) {
      case ScreenSize.xs:
        return xs;
      case ScreenSize.sm:
        return sm;
      case ScreenSize.md:
        return md;
      case ScreenSize.xl:
        return xl;
      default:
        return sm;
    }
  }

  // === FONTS SIZES ===

  /// Sets the fonts size of a small display based on the width of the screen
  static double getDisplayLargeSize() {
    return _getValueByScreenSize(xs: 55, sm: 57, md: 57, xl: 60);
  }

  static double getDisplayMediumSize() {
    return _getValueByScreenSize(xs: 43, sm: 45, md: 45, xl: 48);
  }

  static double getDisplaySmallSize() {
    return _getValueByScreenSize(xs: 34, sm: 36, md: 36, xl: 39);
  }

  /// Sets the fonts size of a large headline based on the width of the screen
  static double getHeadlineLargeSize() {
    return _getValueByScreenSize(xs: 30, sm: 32, md: 32, xl: 34);
  }

  /// Sets the fonts size of a medium headline based on the width of the screen
  static double getHeadlineMediumSize() {
    return _getValueByScreenSize(xs: 26, sm: 28, md: 28, xl: 30);
  }

  //fix: changed
  static double getHeadlineSmallSize() {
    return _getValueByScreenSize(xs: 22, sm: 24, md: 24, xl: 26);
  }

  /// Sets the fonts size of a large title based on the width of the screen
  static double getTitleLargeSize() {
    return _getValueByScreenSize(xs: 18, sm: 22, md: 22, xl: 24);
  }

  /// Sets the fonts size of a medium title based on the width of the screen
  static double getTitleMediumSize() {
    return _getValueByScreenSize(xs: 18, sm: 20, md: 20, xl: 22);
  }

  /// Sets the fonts size of a small title based on the width of the screen
  static double getTitleSmallSize() {
    return _getValueByScreenSize(xs: 14, sm: 16, md: 16, xl: 18);
  }

  /// Gets the body medium size based on screen width
  static double getBodyLargeSize() {
    return _getValueByScreenSize(xs: 14, sm: 16, md: 16, xl: 18);
  }

  /// Gets the body medium size based on screen width
  static double getBodyMediumSize() {
    return _getValueByScreenSize(xs: 12, sm: 14, md: 14, xl: 16);
  }

  /// Gets the body medium size based on screen width
  static double getBodySmallSize() {
    return _getValueByScreenSize(xs: 10, sm: 12, md: 12, xl: 14);
  }

  /// Sets the fonts size of a large label based on the width of the screen
  static double getLabelLargeSize() {
    return _getValueByScreenSize(xs: 12, sm: 15, md: 14, xl: 15);
  }

  /// Sets the fonts size of a medium label based on the width of the screen
  static double getLabelMediumSize() {
    return _getValueByScreenSize(xs: 10, sm: 12, md: 12, xl: 14);
  }

  static double getLabelSmallSize() {
    return _getValueByScreenSize(xs: 10, sm: 11, md: 11, xl: 12);
  }

  static double getBottomNavigationBarHeight() {
    return _getValueByScreenSize(xs: 65, sm: 95, md: 95, xl: 95);
  }

  static double getOnboardingTopSpacing() {
    return _getValueByScreenSize(xs: 75, sm: 125, md: 200, xl: 275);
  }

  // Sets horizontal padding based on screen size
  static double getHorizontalScreenPadding(
      {size = HorizontalScreenPadding.regular}) {
    // switch type
    switch (size) {
      case HorizontalScreenPadding.regular:
        return _getValueByScreenSize(xs: 15, sm: 25, md: 25, xl: 35);
      case HorizontalScreenPadding.small:
        return _getValueByScreenSize(xs: 10, sm: 15, md: 20, xl: 25);
      case HorizontalScreenPadding.large:
        return _getValueByScreenSize(xs: 20, sm: 35, md: 35, xl: 40);
      default:
        return 0;
    }
  }
}
