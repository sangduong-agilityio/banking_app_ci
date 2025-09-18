import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class BATabBar extends StatelessWidget {
  final TabController controller;
  final List<String> tabs;
  final double? height;
  final double? borderRadius;
  final EdgeInsets? padding;
  final EdgeInsets? containerPadding;

  const BATabBar({
    super.key,
    required this.controller,
    required this.tabs,
    this.height = 50,
    this.borderRadius = 16,
    this.padding,
    this.containerPadding = const EdgeInsets.all(20),
  });

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
            final index = entry.key;
            final tabName = entry.value;

            return AnimatedBuilder(
              animation: controller.animation!,
              builder: (context, child) {
                final isSelected = controller.index == index;

                return Tab(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.center,
                    decoration: !isSelected
                        ? BoxDecoration(
                            color: context.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(
                              borderRadius ?? 16,
                            ),
                          )
                        : null,
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
