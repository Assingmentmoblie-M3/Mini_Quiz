import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum DeviceType { mobile, tablet, desktop }

class R {
  const R._();

  static const double mobileBreakpoint = 600;
  static const double desktopBreakpoint = 1024;

  static double _clamp(double value, {double? min, double? max}) => value
      .clamp(min ?? double.negativeInfinity, max ?? double.infinity)
      .toDouble();

  static MediaQueryData mediaQuery(BuildContext context) =>
      MediaQuery.of(context);

  static Size size(BuildContext context) => mediaQuery(context).size;

  static Orientation orientation(BuildContext context) =>
      mediaQuery(context).orientation;

  static bool isLandscape(BuildContext context) =>
      orientation(context) == Orientation.landscape;

  static bool isPortrait(BuildContext context) =>
      orientation(context) == Orientation.portrait;

  static bool isMobile(BuildContext context) =>
      size(context).width < mobileBreakpoint;

  static bool isTablet(BuildContext context) =>
      size(context).width >= mobileBreakpoint &&
      size(context).width < desktopBreakpoint;

  static bool isDesktop(BuildContext context) =>
      size(context).width >= desktopBreakpoint;

  static DeviceType deviceType(BuildContext context) {
    if (isDesktop(context)) return DeviceType.desktop;
    if (isTablet(context)) return DeviceType.tablet;
    return DeviceType.mobile;
  }

  static double w(BuildContext context, double percent) =>
      widthPercent(context, percent);

  static double h(BuildContext context, double percent) =>
      heightPercent(context, percent);

  static double widthPercent(BuildContext context, double percent) =>
      size(context).width * percent;

  static double heightPercent(BuildContext context, double percent) =>
      size(context).height * percent;

  static double contentWidth(BuildContext context, {double max = 1200}) =>
      size(context).width.clamp(320.0, max).toDouble();

  static double wp(
    BuildContext context,
    double percent, {
    double? min,
    double? max,
  }) {
    final value = w(context, percent);
    if (min == null && max == null) return value;
    return _clamp(value, min: min, max: max);
  }

  static double hp(
    BuildContext context,
    double percent, {
    double? min,
    double? max,
  }) {
    final value = h(context, percent);
    if (min == null && max == null) return value;
    return _clamp(value, min: min, max: max);
  }

  static double adaptive(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    final type = deviceType(context);
    if (type == DeviceType.desktop) {
      return desktop ?? tablet ?? mobile;
    }
    if (type == DeviceType.tablet) {
      return tablet ?? mobile;
    }
    return mobile;
  }

  /// ScreenUtil: responsive width based on design size.
  static double scaleWidth(double width) => width.w;

  /// ScreenUtil: responsive height based on design size.
  static double scaleHeight(double height) => height.h;

  /// ScreenUtil: responsive font size.
  static double sp(double fontSize) => fontSize.sp;

  /// ScreenUtil: responsive radius.
  static double r(double radius) => radius.r;

  /// ScreenUtil: full screen width.
  static double get screenWidth => 1.sw;

  /// ScreenUtil: full screen height.
  static double get screenHeight => 1.sh;

  /// ScreenUtil: status bar height.
  static double get statusBarHeight => ScreenUtil().statusBarHeight;

  /// ScreenUtil: bottom inset height.
  static double get bottomBarHeight => ScreenUtil().bottomBarHeight;
}
