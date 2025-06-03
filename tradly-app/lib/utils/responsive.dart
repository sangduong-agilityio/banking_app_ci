import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

enum TAResponsiveSizeType {
  mobile,
  tablet,
}

class TAResponsiveConfig {
  static const double defaultTabletScaleFactor = 1;
}

class TAResponsive {
  static double value(
    BuildContext context, {
    double? mobile,
    double? tablet,
    double? desktop,
    double? defaultValue,
  }) {
    if (ResponsiveBreakpoints.of(context).isTablet) {
      return tablet ?? 0;
    } else if (ResponsiveBreakpoints.of(context).isDesktop) {
      return desktop ?? 0;
    } else if (ResponsiveBreakpoints.of(context).isMobile) {
      return mobile ?? 0;
    }

    return defaultValue ?? 0;
  }

  static Widget layout(
    BuildContext context, {
    Widget? mobile,
    Widget? tablet,
    Widget? desktop,
  }) {
    if (ResponsiveBreakpoints.of(context).isTablet) {
      return tablet ?? const SizedBox.shrink();
    } else if (ResponsiveBreakpoints.of(context).isDesktop) {
      return desktop ?? const SizedBox.shrink();
    } else {
      return mobile ?? const SizedBox.shrink();
    }
  }

  static double scale(
    BuildContext context, {
    required double defaultValue,
    double? mobile,
    double? tablet = TAResponsiveConfig.defaultTabletScaleFactor,
    double? desktop,
  }) {
    if (ResponsiveBreakpoints.of(context).isTablet && tablet != null) {
      return defaultValue * tablet;
    }
    if (ResponsiveBreakpoints.of(context).isMobile && mobile != null) {
      return defaultValue * mobile;
    }
    if (ResponsiveBreakpoints.of(context).isDesktop && desktop != null) {
      return defaultValue * desktop;
    }
    return defaultValue;
  }

  static Widget visibility(
    BuildContext context, {
    required Widget child,
    bool? visible = false,
    List<TAResponsiveSizeType> visibleWhen = const [],
  }) {
    final visibleConditions = visibleWhen.map((platform) {
      String name;
      switch (platform) {
        case TAResponsiveSizeType.mobile:
          name = MOBILE;
          break;
        case TAResponsiveSizeType.tablet:
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

  static bool isTablet(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 600 && screenWidth <= 1024;
  }

  static double orientationSizeOf(
    BuildContext context, {
    double? landscape,
    double? portrait,
  }) {
    if (isTablet(context)) {
      return portrait ?? landscape ?? 1.3;
    } else if (ResponsiveBreakpoints.of(context).orientation ==
        Orientation.portrait) {
      return portrait ?? 0.8;
    } else {
      return landscape ?? 1.2;
    }
  }

  static bool isPortraitMode(
    BuildContext context,
  ) {
    return ResponsiveBreakpoints.of(context).orientation ==
        Orientation.portrait;
  }
}
