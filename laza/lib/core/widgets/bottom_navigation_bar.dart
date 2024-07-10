import 'package:flutter/material.dart';
import 'package:laza/core/extenssions/context_extenssions.dart';

class LSBottomNavigationBar extends StatefulWidget {
  const LSBottomNavigationBar({
    super.key,
    required this.items,
    this.backgroundColor,
    this.currentIndex = 0,
    this.onTap,
    this.itemShape = const BorderDirectional(),
    this.margin = const EdgeInsets.all(8),
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeOutQuint,
    this.colorLabel,
  });

  /// A list of tabs to display, ie `Home`, `Likes`, etc
  final List<LSBottomNavigationBarItem> items;

  /// The tab to display.
  final int currentIndex;

  /// Returns the index of the tab that was tapped.
  final Function(int)? onTap;

  /// The background color of the bar.
  final Color? backgroundColor;

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
    return Container(
      height: 80,
      width: double.infinity,
      color: context.colorScheme.onPrimary,
      child: SafeArea(
        minimum: widget.margin,
        child: Row(
          /// Using a different alignment when there are 2 items or less
          /// so it behaves the same as BottomNavigationBar.
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                          ),
                          child: IconTheme(
                            data: const IconThemeData(),
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
  /// An icon to display.
  final Widget icon;

  /// An icon to display when this tab bar is active.
  final Widget? activeIcon;

  LSBottomNavigationBarItem({
    required this.icon,
    this.activeIcon,
  });
}
