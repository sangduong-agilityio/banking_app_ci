import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tradly_app/extensions/context_extensions.dart';

class TABottomNavigationBar extends StatefulWidget {
  const TABottomNavigationBar({
    super.key,
    required this.items,
    this.backgroundColor,
    this.selectedItemColor = const Color(0xFF33907C),
    this.unselectedItemColor = Colors.grey,
    this.currentIndex = 0,
    this.onTap,
  });

  final List<TABottomNavigationBarItem> items;
  final Color? backgroundColor;
  final Color selectedItemColor;
  final Color unselectedItemColor;
  final int currentIndex;
  final Function(int)? onTap;

  static TABottomNavigationBarState? of(BuildContext context) {
    return context.findAncestorStateOfType<TABottomNavigationBarState>();
  }

  @override
  State<TABottomNavigationBar> createState() => TABottomNavigationBarState();
}

class TABottomNavigationBarState extends State<TABottomNavigationBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
  }

  @override
  void didUpdateWidget(TABottomNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex) {
      _selectedIndex = widget.currentIndex;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onTap?.call(index);
  }

  void updateIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return isLandscape
        ? Container(
            width: 120,
            height: double.infinity,
            color: widget.backgroundColor ?? context.colorScheme.onPrimary,
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: widget.items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final isSelected = index == _selectedIndex;

                  return GestureDetector(
                    onTap: () {
                      _onItemTapped(index);
                      HapticFeedback.lightImpact();
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 8),
                        isSelected ? item.activeIcon : item.icon,
                        const SizedBox(height: 4),
                        Text(
                          item.label,
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            color: isSelected
                                ? widget.selectedItemColor
                                : widget.unselectedItemColor,
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          )
        : Container(
            height: 90,
            width: double.infinity,
            color: widget.backgroundColor ?? context.colorScheme.onPrimary,
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: widget.items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final isSelected = index == _selectedIndex;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _onItemTapped(index);
                        HapticFeedback.lightImpact();
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 8),
                          isSelected ? item.activeIcon : item.icon,
                          const SizedBox(height: 4),
                          Text(
                            textAlign: TextAlign.center,
                            item.label,
                            style: TextStyle(
                              color: isSelected
                                  ? widget.selectedItemColor
                                  : widget.unselectedItemColor,
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            ),
                          ),
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
