import 'package:flutter/material.dart';
import 'package:tradly_app/core/extensions/context_extensions.dart';

class TABottomNavigationBar extends StatefulWidget {
  const TABottomNavigationBar({
    super.key,
    required this.items,
    this.backgroundColor,
    this.selectedItemColor = const Color(0xFF007A70),
    this.unselectedItemColor = Colors.grey,
    this.margin = const EdgeInsets.all(8),
  });

  final List<TASBottomNavigationBarItem> items;
  final Color? backgroundColor;
  final Color selectedItemColor;
  final Color unselectedItemColor;
  final EdgeInsets margin;

  @override
  State<TABottomNavigationBar> createState() => _TABottomNavigationBarState();
}

class _TABottomNavigationBarState extends State<TABottomNavigationBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);

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

            return GestureDetector(
              onTap: () => _onItemTapped(index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconTheme(
                    data: IconThemeData(
                      color: isSelected ? selectedColor : unselectedColor,
                    ),
                    child: item.icon,
                  ),
                  Text(
                    item.label,
                    style: TextStyle(
                      color: isSelected ? selectedColor : unselectedColor,
                      fontSize: 12,
                    ),
                  ),
                ],
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
  final String label;

  TASBottomNavigationBarItem({
    required this.icon,
    required this.label,
  });
}
