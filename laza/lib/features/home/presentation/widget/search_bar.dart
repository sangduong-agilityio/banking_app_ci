import 'package:flutter/material.dart';
import 'package:laza/core/extenssions/context_extenssions.dart';
import 'package:laza/core/l10n/l10n_generated/l10n.dart';
import 'package:laza/core/util/themes/colors.dart';
import 'package:laza/core/widgets/icons.dart';

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
    return Row(
      children: [
        SizedBox(
          width: 310,
          height: 50,
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
        const SizedBox(
          width: 10,
        ),
        Container(
          height: 50,
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
