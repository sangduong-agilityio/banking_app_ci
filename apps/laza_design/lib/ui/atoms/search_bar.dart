import 'package:flutter/material.dart';
import 'package:laza_design/ui/atoms/icons.dart';
import 'package:laza_design/ui/foundations/colors.dart';

class LSSearchBar extends StatelessWidget {
  const LSSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onTapIcon,
    this.onTap,
    this.focusNode,
    this.icon,
  });

  /// Controller of editing text
  final TextEditingController? controller;

  /// Function trigger when onChanged
  final Function(String)? onChanged;

  /// Function trigger when submit
  final Function(String)? onSubmitted;

  /// Function on Tap icon
  final Function()? onTapIcon;

  /// Function tap open view suggestion
  final VoidCallback? onTap;

  /// FocusNode of search bar
  final FocusNode? focusNode;

  /// Custom icon
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      onTap: onTap,
      focusNode: focusNode,
      elevation: WidgetStateProperty.all(0),
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      backgroundColor: WidgetStateProperty.all(LSColors.grey200),
      textCapitalization: TextCapitalization.words,
      leading: Padding(
        padding: const EdgeInsets.all(15),
        child: InkWell(
          onTap: onTapIcon,
          child: icon ?? LSIcons.icSearch,
        ),
      ),
    );
  }
}
