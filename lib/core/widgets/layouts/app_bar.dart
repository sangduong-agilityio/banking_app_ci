import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/common/extensions/context_extensions.dart';
import 'package:banking_app/core/widgets/assets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum BAAppBarAlignment { center, left }

class BAAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BAAppBar({
    super.key,
    required this.title,
    this.alignment = BAAppBarAlignment.center,
    this.showBackButton = true,
    this.actions,
    this.backgroundColor = Colors.white,
    this.titleColor,
    this.fontSize,
    this.iconColor,
    this.onBack,
    this.padding,
    this.profileImage,
    this.style,
    this.titleSpacing,
  });

  final String title;
  final BAAppBarAlignment alignment;
  final bool showBackButton;
  final List<Widget>? actions;
  final Color backgroundColor;
  final Color? titleColor;
  final Color? iconColor;
  final VoidCallback? onBack;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final String? profileImage;
  final TextStyle? style;
  final double? titleSpacing;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            if (showBackButton)
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                color: iconColor ?? Colors.black,
                onPressed: onBack ?? () => context.pop(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              )
            else if (profileImage != null)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: BAProfileImage(url: profileImage, size: 50),
              ),
            if (showBackButton) const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style:
                    style ??
                    context.headlineSmall?.copyWith(
                      color: titleColor ?? context.colorScheme.onSurface,
                      fontSize: fontSize ?? 20,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            if (actions != null) ...actions!,
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
