import 'package:flutter/material.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/core/l10n/l10n_generated/l10n.dart';
import 'package:laza/core/themes/colors.dart';
import 'package:laza/presentations/widgets/icons.dart';

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
    final screenWithTablet = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: screenWithTablet > 600 ? 650.w : 280.w,
          height: 50.h,
          child: SearchBar(
            onTap: onTap,
            focusNode: focusNode,
            controller: controller,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            backgroundColor: WidgetStateProperty.all(LSColors.grey200),
            textCapitalization: TextCapitalization.words,
            hintText: S.current.searchInput,
            leading: Padding(
              padding: const EdgeInsets.all(10),
              child: InkWell(
                onTap: onTapIcon,
                child: icon ?? LSIcons.icSearch,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: screenWithTablet > 600 ? 60.w : 50.w,
          height: 50.h,
          decoration: ShapeDecoration(
            color: context.colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: IconButton(
            icon: LSIcons.icVoice,
            onPressed: () {},
          ),
        )
      ],
    );
  }
}
