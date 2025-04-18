import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tradly_app/core/extensions/context_extensions.dart';
import 'package:tradly_app/core/routes/app_router.dart';

class TABottomNavigationBar extends StatefulWidget {
  const TABottomNavigationBar({
    super.key,
    required this.items,
    this.backgroundColor,
    this.selectedItemColor = const Color(0xFF007A70),
    this.unselectedItemColor = Colors.grey,
    this.margin = const EdgeInsets.all(8),
    this.currentIndex = 0,
    this.onTap,
  });

  final List<TASBottomNavigationBarItem> items;
  final Color? backgroundColor;
  final Color selectedItemColor;
  final Color unselectedItemColor;
  final EdgeInsets margin;
  final int currentIndex;
  final Function(int)? onTap;

  @override
  State<TABottomNavigationBar> createState() => _TABottomNavigationBarState();
}

class _TABottomNavigationBarState extends State<TABottomNavigationBar> {
  late int _selectedIndex;

  final Map<int, String> _tabRoutes = {
    0: TAPaths.home.name,
    // 1: TAPaths.beverages.name,
    2: TAPaths.store.name,
    // 3: TAPaths.order.name,
    4: TAPaths.profile.name, // Profile route
  };

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
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      widget.onTap?.call(index);

      final routeName = _tabRoutes[index];
      if (routeName != null) {
        context.goNamed(routeName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: double.infinity,
      color: widget.backgroundColor ?? context.colorScheme.onPrimary,
      child: SafeArea(
        minimum: widget.margin,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: widget.items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isSelected = index == _selectedIndex;
            final selectedColor = widget.selectedItemColor;
            final unselectedColor = widget.unselectedItemColor;

            return Expanded(
              child: GestureDetector(
                onTap: () => _onItemTapped(index),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isSelected ? item.activeIcon : item.icon,
                    const SizedBox(height: 4),
                    Text(
                      item.label,
                      style: TextStyle(
                        color: isSelected ? selectedColor : unselectedColor,
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.w500 : FontWeight.normal,
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

class TASBottomNavigationBarItem {
  final Widget icon;
  final Widget activeIcon;
  final String label;

  TASBottomNavigationBarItem({
    required this.icon,
    Widget? activeIcon,
    required this.label,
  }) : activeIcon = activeIcon ?? icon;
}
