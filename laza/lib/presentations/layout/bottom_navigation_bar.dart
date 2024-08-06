import 'package:flutter/material.dart';
import 'package:laza/core/extensions/context_extensions.dart';

class LSBottomNavigationBar extends StatefulWidget {
  const LSBottomNavigationBar({
    super.key,
    required this.items,
    this.backgroundColor,
    this.currentIndex = 0,
    this.onTap,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.itemShape = const BorderDirectional(),
    this.margin = const EdgeInsets.all(8),
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeOutQuint,
    this.colorLabel,
  });

  /// A list of tabs to display, ie `Home`, `WishList`, etc
  final List<LSBottomNavigationBarItem> items;

  /// The tab to display.
  final int currentIndex;

  /// Returns the index of the tab that was tapped.
  final Function(int)? onTap;

  /// The background color of the bar.
  final Color? backgroundColor;

  /// The color of the icon and text when the item is selected.
  final Color? selectedItemColor;

  /// The color of the icon and text when the item is not selected.
  final Color? unselectedItemColor;

  /// The border shape of each item.
  final ShapeBorder itemShape;

  /// A convenience field for the margin surrounding the entire widget.
  final EdgeInsets margin;

  /// The transition duration
  final Duration duration;

  /// The transition curve
  final Curve curve;

  /// Color label
  final Color? colorLabel;

  @override
  State<LSBottomNavigationBar> createState() => _LSBottomNavigationBarState();
}

class _LSBottomNavigationBarState extends State<LSBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 80,
      width: double.infinity,
      color: context.colorScheme.onPrimary,
      child: SafeArea(
        minimum: widget.margin,
        child: Row(
          mainAxisAlignment: widget.items.length <= 2
              ? MainAxisAlignment.spaceEvenly
              : MainAxisAlignment.spaceBetween,
          children: [
            for (final item in widget.items)
              TweenAnimationBuilder<double>(
                tween: Tween(
                  end: widget.items.indexOf(item) == widget.currentIndex
                      ? 1.0
                      : 0.0,
                ),
                curve: widget.curve,
                duration: widget.duration,
                builder: (context, t, _) {
                  final selectedColor = item.selectedColor ??
                      widget.selectedItemColor ??
                      theme.primaryColor;

                  final unselectedColor = item.unselectedColor ??
                      widget.unselectedItemColor ??
                      theme.iconTheme.color;
                  return Material(
                    shape: widget.itemShape,
                    child: Container(
                      color: context.colorScheme.onPrimary,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            widget.onTap?.call(widget.items.indexOf(item));
                          });
                        },
                        customBorder: widget.itemShape,
                        focusColor: selectedColor.withOpacity(0.1),
                        highlightColor: selectedColor.withOpacity(0.1),
                        splashColor: selectedColor.withOpacity(0.1),
                        hoverColor: selectedColor.withOpacity(0.1),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                          ),
                          child: IconTheme(
                            data: IconThemeData(
                              color:
                                  Color.lerp(unselectedColor, selectedColor, t),
                            ),
                            child: widget.items.indexOf(item) ==
                                    widget.currentIndex
                                ? item.activeIcon ?? item.icon
                                : item.icon,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

/// A tab to display in a [LSBottomNavigationBar]
class LSBottomNavigationBarItem {
  final Widget icon;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Widget? activeIcon;

  LSBottomNavigationBarItem({
    required this.icon,
    this.activeIcon,
    this.selectedColor,
    this.unselectedColor,
  });
}
