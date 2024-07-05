import 'package:flutter/material.dart';

class LSBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final int currentIndex;
  final List<LSBottomNavigationBarItem> items;
  final Function(int)? onTap;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final Duration duration;
  final Color? backgroundColor;

  const LSBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.items,
    required this.currentIndex,
    this.onTap,
    this.selectedItemColor,
    this.unselectedItemColor,
    required this.duration,
    this.backgroundColor,
  });

  @override
  State<LSBottomNavigationBar> createState() => _LSBottomNavigationBarState();
}

class _LSBottomNavigationBarState extends State<LSBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      child: const SafeArea(child: Row()),
    );
  }
}

/// A tab to display in a [LSBottomNavigationBarItem]
class LSBottomNavigationBarItem {
  /// An icon to display.
  final Widget icon;

  /// An icon to display when this tab bar is active.
  final Widget? activeIcon;

  /// A primary color to use for this tab.
  final Color? selectedColor;

  /// The color to display when this tab is not selected.
  final Color? unselectedColor;

  LSBottomNavigationBarItem({
    required this.icon,
    this.selectedColor,
    this.unselectedColor,
    this.activeIcon,
  });
}
