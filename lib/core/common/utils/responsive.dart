import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// An enum that defines the different responsive size types.
enum BAResponsiveSizeType { mobile, tablet }

/// A class that contains constants for device types.
class BAResponsiveConfig {
  /// The default scale factor for tablets.
  static const double defaultTabletScaleFactor = 1;
}

/// A utility class for handling responsive design.
class BAResponsive {
  /// Returns a value based on the current device type.
  static double value(
    BuildContext context, {
    double? mobile,
    double? tablet,
    double? defaultValue,
  }) {
    if (ResponsiveBreakpoints.of(context).isTablet) {
      return tablet ?? 0;
    } else if (ResponsiveBreakpoints.of(context).isMobile) {
      return mobile ?? 0;
    }

    return defaultValue ?? 0;
  }

  /// Returns a widget based on the current device type.
  static Widget layout(
    BuildContext context, {
    Widget? mobile,
    Widget? tablet,
    Widget? desktop,
  }) {
    if (ResponsiveBreakpoints.of(context).isTablet) {
      return tablet ?? const SizedBox.shrink();
    } else {
      return mobile ?? const SizedBox.shrink();
    }
  }

  /// Scales a value based on the current device type.
  static double scale(
    BuildContext context, {
    required double defaultValue,
    double? mobile,
    double? tablet = BAResponsiveConfig.defaultTabletScaleFactor,
    double? desktop,
  }) {
    if (ResponsiveBreakpoints.of(context).isTablet && tablet != null) {
      return defaultValue * tablet;
    }
    if (ResponsiveBreakpoints.of(context).isMobile && mobile != null) {
      return defaultValue * mobile;
    }
    return defaultValue;
  }

  /// Controls the visibility of a widget based on the current device type.
  static Widget visibility(
    BuildContext context, {
    required Widget child,
    bool? visible = false,
    List<BAResponsiveSizeType> visibleWhen = const [],
  }) {
    final visibleConditions = visibleWhen.map((platform) {
      String name;
      switch (platform) {
        case BAResponsiveSizeType.mobile:
          name = MOBILE;
          break;
        case BAResponsiveSizeType.tablet:
          name = TABLET;
      }

      return Condition<bool>.equals(name: name);
    }).toList();

    return ResponsiveVisibility(
      visible: visible ?? false,
      visibleConditions: visibleConditions,
      child: child,
    );
  }

  /// Returns a widget based on the current orientation.
  static Widget orientation(
    BuildContext context, {
    Widget? landscape,
    Widget? portrait,
  }) {
    if (ResponsiveBreakpoints.of(context).orientation == Orientation.portrait) {
      return portrait ?? const SizedBox.shrink();
    } else {
      return landscape ?? const SizedBox.shrink();
    }
  }

  /// Checks if the device is a tablet.
  static bool isTablet(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 600 && screenWidth <= 1024;
  }

  /// Returns a size based on the orientation and device type.
  static int orientationSizeOf(
    BuildContext context, {
    int? landscape,
    int? portrait,
  }) {
    if (isTablet(context)) {
      return portrait ?? landscape ?? 1;
    } else if (ResponsiveBreakpoints.of(context).orientation ==
        Orientation.portrait) {
      return portrait ?? 0;
    } else {
      return landscape ?? 0;
    }
  }

  /// Checks if the device is in portrait mode.
  static bool isPortraitMode(BuildContext context) {
    return ResponsiveBreakpoints.of(context).orientation ==
        Orientation.portrait;
  }
}
