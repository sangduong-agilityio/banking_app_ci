import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/widgets/assets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum BAAppBarAlignment { center, left }

class BAAppBar extends StatelessWidget implements PreferredSizeWidget {
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 2),
      child: AppBar(
        actions: actions,
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: alignment == BAAppBarAlignment.center,
        titleSpacing:
            titleSpacing ?? (alignment == BAAppBarAlignment.left ? 0 : null),
        title: Text(
          title,
          style:
              style ??
              context.headlineSmall?.copyWith(
                color: titleColor ?? context.colorScheme.onSurface,
                fontSize: fontSize ?? 20,
              ),
        ),
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                color: iconColor ?? Colors.black,
                onPressed: onBack ?? () => context.pop(),
              )
            : BAProfileImage(url: profileImage, size: 32),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
