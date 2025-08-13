import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/assets.dart';
import 'package:flutter/material.dart';

class BABottomNavigationBar extends StatelessWidget {
  const BABottomNavigationBar({
    super.key,
    required this.items,
    this.backgroundColor,
    this.selectedItemColor = Colors.white,
    this.unselectedItemColor = const Color(0xFF898989),
    required this.currentIndex,
    this.onTap,
  });

  final List<TABottomNavigationBarItem> items;
  final Color? backgroundColor;
  final Color selectedItemColor;
  final Color unselectedItemColor;
  final int currentIndex;
  final Function(int)? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final bool isSelected = index == currentIndex;

            return GestureDetector(
              onTap: () => onTap?.call(index),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(
                  horizontal: isSelected ? 14 : 0,
                  vertical: 8,
                ),
                decoration: isSelected
                    ? BoxDecoration(
                        color: context.colorScheme.secondary,
                        borderRadius: BorderRadius.circular(20),
                      )
                    : null,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconTheme(
                      data: IconThemeData(
                        size: 24,
                        color: isSelected
                            ? selectedItemColor
                            : unselectedItemColor,
                      ),
                      child: isSelected ? item.activeIcon : item.icon,
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 6),
                      Text(
                        item.label,
                        style: TextStyle(
                          color: selectedItemColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class TABottomNavigationBarItem {
  final Widget icon;
  final Widget activeIcon;
  final String label;

  TABottomNavigationBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

List<TABottomNavigationBarItem> bottomNavigationBarItems(BuildContext context) {
  return [
    TABottomNavigationBarItem(
      icon: BAAssets.home(),
      activeIcon: BAAssets.homeFilled(color: context.colorScheme.onPrimary),
      label: S.current.homeTitle,
    ),
    TABottomNavigationBarItem(
      icon: BAAssets.search(),
      activeIcon: BAAssets.search(color: context.colorScheme.onPrimary),
      label: S.current.searchTitle,
    ),
    TABottomNavigationBarItem(
      icon: BAAssets.message(),
      activeIcon: BAAssets.messageFilled(color: context.colorScheme.onPrimary),
      label: S.current.messageTitle,
    ),
    TABottomNavigationBarItem(
      icon: BAAssets.setting(),
      activeIcon: BAAssets.settingFilled(color: context.colorScheme.onPrimary),
      label: S.current.settingTitle,
    ),
  ];
}
