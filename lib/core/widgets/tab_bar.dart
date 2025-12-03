import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/common/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

/// A custom tab bar widget with a specific design.
///
/// This tab bar can be customized with different properties like height, border radius, and padding.
class BATabBar extends StatelessWidget {
  /// Creates a [BATabBar] widget.
  const BATabBar({
    super.key,
    this.controller,
    required this.tabs,
    this.height = 50,
    this.borderRadius = 16,
    this.padding,
    this.containerPadding = const EdgeInsets.all(20),
  });

  /// The controller for the tab bar.
  final TabController? controller;

  /// The list of tab names.
  final List<String> tabs;

  /// The height of the tab bar.
  final double? height;

  /// The border radius of the tab bar.
  final double? borderRadius;

  /// The padding of the tab bar.
  final EdgeInsets? padding;

  /// The padding of the container that holds the tab bar.
  final EdgeInsets? containerPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: containerPadding,
      child: Container(
        height: height,
        padding: padding ?? const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular((borderRadius ?? 16)),
        ),
        child: TabBar(
          controller: controller,
          indicator: BoxDecoration(
            color: context.colorScheme.secondary,
            borderRadius: BorderRadius.circular(borderRadius ?? 16),
          ),
          indicatorColor: context.colorScheme.error,
          labelColor: context.colorScheme.onPrimary,
          unselectedLabelColor: context.colorScheme.scrim,
          labelStyle: context.titleMedium,
          unselectedLabelStyle: context.titleMedium,
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          splashFactory: NoSplash.splashFactory,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          tabs: tabs.asMap().entries.map((entry) {
            final tabName = entry.value;

            return AnimatedBuilder(
              animation: controller?.animation ?? kAlwaysCompleteAnimation,
              builder: (context, child) {
                return Tab(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.center,
                    // decoration: !isSelected
                    //     ? BoxDecoration(
                    //         color: context.colorScheme.surfaceContainerHighest,
                    //         borderRadius: BorderRadius.circular(
                    //           borderRadius ?? 16,
                    //         ),
                    //       )
                    //     : null,
                    child: Text(tabName),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
