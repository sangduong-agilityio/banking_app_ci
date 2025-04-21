import 'package:flutter/material.dart';
import 'package:tradly_app/core/extensions/context_extensions.dart';
import 'package:tradly_app/core/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/presentations/widgets/assets.dart';
import 'package:go_router/go_router.dart';
import 'package:tradly_app/core/routes/app_router.dart';

class TABottomNavigationBar extends StatefulWidget {
  const TABottomNavigationBar({
    super.key,
    this.backgroundColor,
    this.selectedItemColor = const Color(0xFF007A70),
    this.unselectedItemColor = Colors.grey,
    this.margin = const EdgeInsets.all(8),
    this.currentIndex = 0,
    this.onTap,
  });

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

      switch (index) {
        case 0:
          context.goNamed(TAPaths.home.name);
          break;
        case 1:
          context.goNamed(TAPaths.beverages.name);
          break;
        case 2:
          context.goNamed(TAPaths.store.name);
          break;
        case 3:
          context.goNamed(TAPaths.egg.name);
          break;
        case 4:
          context.goNamed(TAPaths.profile.name);
          break;
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
          children: _navigationItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isSelected = index == _selectedIndex;

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
                        color: isSelected
                            ? widget.selectedItemColor
                            : widget.unselectedItemColor,
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

  final List<_NavigationItem> _navigationItems = [
    _NavigationItem(
      icon: TAAssets.home(),
      activeIcon: TAAssets.home(color: const Color(0xFF007A70)),
      label: S.current.homeLabel,
    ),
    _NavigationItem(
      icon: TAAssets.search(),
      activeIcon: TAAssets.search(color: const Color(0xFF007A70)),
      label: S.current.homeBrowseLabel,
    ),
    _NavigationItem(
      icon: TAAssets.store(),
      activeIcon: TAAssets.store(color: const Color(0xFF007A70)),
      label: S.current.homeStoreLabel,
    ),
    _NavigationItem(
      icon: TAAssets.order(),
      activeIcon: TAAssets.order(color: const Color(0xFF007A70)),
      label: S.current.homeOrderHistoryLabel,
    ),
    _NavigationItem(
      icon: TAAssets.profile(),
      activeIcon: TAAssets.profile(color: const Color(0xFF007A70)),
      label: S.current.homeProfileLabel,
    ),
  ];
}

class _NavigationItem {
  final Widget icon;
  final Widget activeIcon;
  final String label;

  _NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
