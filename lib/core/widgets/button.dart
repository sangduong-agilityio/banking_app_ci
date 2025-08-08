import 'package:banking_app/app/themes/app_colors.dart';
import 'package:banking_app/app/themes/typography.dart';
import 'package:flutter/material.dart';

enum ButtonType { primary, secondary, ghost, outline, danger, success }

enum ButtonSize { small, medium, large }

class CommonButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final ButtonSize size;
  final IconData? icon;
  final IconData? suffixIcon;
  final bool isLoading;
  final bool isExpanded;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final TextStyle? textStyle;

  const CommonButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.suffixIcon,
    this.isLoading = false,
    this.isExpanded = false,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonConfig = _getButtonConfig();
    final sizeConfig = _getSizeConfig();

    Widget button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? buttonConfig.backgroundColor,
        foregroundColor: textColor ?? buttonConfig.textColor,
        elevation: buttonConfig.elevation,
        shadowColor: buttonConfig.shadowColor,
        side: buttonConfig.borderSide != null
            ? BorderSide(
                color: borderColor ?? buttonConfig.borderSide!.color,
                width: buttonConfig.borderSide!.width,
              )
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderRadius ?? sizeConfig.borderRadius,
          ),
        ),
        padding: padding ?? sizeConfig.padding,
        minimumSize: Size(
          width ?? (isExpanded ? double.infinity : sizeConfig.minWidth),
          height ?? sizeConfig.height,
        ),
        textStyle: textStyle ?? sizeConfig.textStyle,
      ),
      child: _buildButtonContent(buttonConfig, sizeConfig),
    );

    if (isExpanded) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }

  Widget _buildButtonContent(ButtonConfig config, SizeConfig sizeConfig) {
    if (isLoading) {
      return SizedBox(
        width: sizeConfig.iconSize,
        height: sizeConfig.iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            textColor ?? config.textColor,
          ),
        ),
      );
    }

    List<Widget> children = [];

    if (icon != null) {
      children.add(
        Icon(
          icon,
          size: sizeConfig.iconSize,
          color: textColor ?? config.textColor,
        ),
      );
      children.add(SizedBox(width: sizeConfig.iconSpacing));
    }

    children.add(
      Text(
        text,
        style: (textStyle ?? sizeConfig.textStyle).copyWith(
          color: textColor ?? config.textColor,
        ),
      ),
    );

    if (suffixIcon != null) {
      children.add(SizedBox(width: sizeConfig.iconSpacing));
      children.add(
        Icon(
          suffixIcon,
          size: sizeConfig.iconSize,
          color: textColor ?? config.textColor,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  ButtonConfig _getButtonConfig() {
    switch (type) {
      case ButtonType.primary:
        return ButtonConfig(
          backgroundColor: AppColors.primary,
          textColor: AppColors.white,
          elevation: 2,
          shadowColor: AppColors.shadow,
        );
      case ButtonType.secondary:
        return ButtonConfig(
          backgroundColor: AppColors.grey100,
          textColor: AppColors.textPrimary,
          elevation: 0,
        );
      case ButtonType.ghost:
        return ButtonConfig(
          backgroundColor: Colors.transparent,
          textColor: AppColors.primary,
          elevation: 0,
        );
      case ButtonType.outline:
        return ButtonConfig(
          backgroundColor: Colors.transparent,
          textColor: AppColors.primary,
          elevation: 0,
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        );
      case ButtonType.danger:
        return ButtonConfig(
          backgroundColor: AppColors.error,
          textColor: AppColors.white,
          elevation: 2,
          shadowColor: AppColors.error.withOpacity(0.3),
        );
      case ButtonType.success:
        return ButtonConfig(
          backgroundColor: AppColors.success,
          textColor: AppColors.white,
          elevation: 2,
          shadowColor: AppColors.success.withOpacity(0.3),
        );
    }
  }

  SizeConfig _getSizeConfig() {
    switch (size) {
      case ButtonSize.small:
        return SizeConfig(
          height: 36,
          minWidth: 80,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          borderRadius: 8,
          textStyle: AppTypography.buttonSmall,
          iconSize: 16,
          iconSpacing: 6,
        );
      case ButtonSize.medium:
        return SizeConfig(
          height: 48,
          minWidth: 120,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          borderRadius: 12,
          textStyle: AppTypography.buttonMedium,
          iconSize: 18,
          iconSpacing: 8,
        );
      case ButtonSize.large:
        return SizeConfig(
          height: 56,
          minWidth: 140,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          borderRadius: 14,
          textStyle: AppTypography.buttonLarge,
          iconSize: 20,
          iconSpacing: 10,
        );
    }
  }
}

// Helper classes
class ButtonConfig {
  final Color backgroundColor;
  final Color textColor;
  final double elevation;
  final Color? shadowColor;
  final BorderSide? borderSide;

  ButtonConfig({
    required this.backgroundColor,
    required this.textColor,
    required this.elevation,
    this.shadowColor,
    this.borderSide,
  });
}

class SizeConfig {
  final double height;
  final double minWidth;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final TextStyle textStyle;
  final double iconSize;
  final double iconSpacing;

  SizeConfig({
    required this.height,
    required this.minWidth,
    required this.padding,
    required this.borderRadius,
    required this.textStyle,
    required this.iconSize,
    required this.iconSpacing,
  });
}

// Specialized Button Components
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isExpanded;
  final ButtonSize size;

  const PrimaryButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
    this.size = ButtonSize.medium,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonButton(
      text: text,
      onPressed: onPressed,
      type: ButtonType.primary,
      size: size,
      icon: icon,
      isLoading: isLoading,
      isExpanded: isExpanded,
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isExpanded;
  final ButtonSize size;

  const SecondaryButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
    this.size = ButtonSize.medium,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonButton(
      text: text,
      onPressed: onPressed,
      type: ButtonType.secondary,
      size: size,
      icon: icon,
      isLoading: isLoading,
      isExpanded: isExpanded,
    );
  }
}

class GhostButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final ButtonSize size;

  const GhostButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.size = ButtonSize.medium,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonButton(
      text: text,
      onPressed: onPressed,
      type: ButtonType.ghost,
      size: size,
      icon: icon,
      isLoading: isLoading,
    );
  }
}

class OutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isExpanded;
  final ButtonSize size;

  const OutlineButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
    this.size = ButtonSize.medium,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonButton(
      text: text,
      onPressed: onPressed,
      type: ButtonType.outline,
      size: size,
      icon: icon,
      isLoading: isLoading,
      isExpanded: isExpanded,
    );
  }
}

class FloatingButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final ButtonSize size;

  const FloatingButton({
    Key? key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.size = ButtonSize.medium,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sizeConfig = _getSizeConfig();

    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      backgroundColor: backgroundColor ?? AppColors.primary,
      foregroundColor: foregroundColor ?? AppColors.white,
      elevation: elevation ?? 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(sizeConfig.borderRadius),
      ),
      child: Icon(icon, size: sizeConfig.iconSize),
    );
  }

  _SizeFabConfig _getSizeConfig() {
    switch (size) {
      case ButtonSize.small:
        return _SizeFabConfig(borderRadius: 12, iconSize: 20);
      case ButtonSize.medium:
        return _SizeFabConfig(borderRadius: 16, iconSize: 24);
      case ButtonSize.large:
        return _SizeFabConfig(borderRadius: 20, iconSize: 28);
    }
  }
}

class _SizeFabConfig {
  final double borderRadius;
  final double iconSize;

  _SizeFabConfig({required this.borderRadius, required this.iconSize});
}

class IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? backgroundColor;
  final double? size;
  final String? tooltip;
  final EdgeInsetsGeometry? padding;

  const IconButton({
    Key? key,
    required this.icon,
    this.onPressed,
    this.color,
    this.backgroundColor,
    this.size,
    this.tooltip,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: padding ?? const EdgeInsets.all(8),
          child: Icon(
            icon,
            color: color ?? AppColors.textSecondary,
            size: size ?? 24,
          ),
        ),
      ),
    );
  }
}
