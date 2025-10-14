import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/common/extensions/context_extensions.dart';
import 'package:banking_app/core/security/biometric_capability.dart';
import 'package:flutter/material.dart';

/// A button that triggers biometric authentication (Face ID, Touch ID, or fingerprint).
///
/// This button adapts its appearance based on the biometric capability and whether it's enabled.
class BABiometricButton extends StatelessWidget {
  /// Creates a [BABiometricButton] widget.
  const BABiometricButton({
    super.key,
    required this.capability,
    required this.onPressed,
    this.isEnabled = true,
    this.size = 56.0,
  });

  /// The biometric capability of the device.
  final BiometricCapability capability;

  /// The callback that is called when the button is tapped.
  final VoidCallback onPressed;

  /// Whether the button is enabled.
  final bool isEnabled;

  /// The size of the button.
  final double size;

  @override
  Widget build(BuildContext context) {
    if (!capability.isAvailable) {
      return const SizedBox.shrink();
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isEnabled
            ? context.colorScheme.secondary.withAlpha(25)
            : context.colorScheme.onSurface.withAlpha(25),
        border: Border.all(
          color: isEnabled
              ? context.colorScheme.secondary
              : context.colorScheme.onSurface.withAlpha(76),
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(size / 2),
          onTap: isEnabled ? onPressed : null,
          child: Center(
            child: Icon(
              _getIconForCapability(capability),
              size: size * 0.4,
              color: isEnabled
                  ? context.colorScheme.secondary
                  : context.colorScheme.onSurface.withAlpha(76),
            ),
          ),
        ),
      ),
    );
  }

  /// Returns the appropriate icon for the given biometric capability.
  IconData _getIconForCapability(BiometricCapability capability) {
    switch (capability) {
      case BiometricCapability.faceId:
        return Icons.face;
      case BiometricCapability.touchId:
      case BiometricCapability.fingerprint:
        return Icons.fingerprint;
      default:
        return Icons.security;
    }
  }
}

/// A widget that displays the status of biometric authentication.
///
/// This widget shows an icon and an optional label to indicate the biometric status.
class BiometricStatusIndicator extends StatelessWidget {
  /// Creates a [BiometricStatusIndicator] widget.
  const BiometricStatusIndicator({
    super.key,
    required this.capability,
    required this.isEnabled,
    this.showLabel = true,
  });

  /// The biometric capability of the device.
  final BiometricCapability capability;

  /// Whether biometric authentication is enabled.
  final bool isEnabled;

  /// Whether to show the label next to the icon.
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    if (!capability.isAvailable) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          _getIconForCapability(capability),
          size: 16,
          color: isEnabled
              ? context.colorScheme.secondary
              : context.colorScheme.onSurface.withAlpha(127),
        ),
        if (showLabel) ...[
          const SizedBox(width: 4),
          Text(
            capability.displayName,
            style: context.bodySmall?.copyWith(
              color: isEnabled
                  ? context.colorScheme.secondary
                  : context.colorScheme.onSurface.withAlpha(127),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  /// Returns the appropriate icon for the given biometric capability.
  IconData _getIconForCapability(BiometricCapability capability) {
    switch (capability) {
      case BiometricCapability.faceId:
        return Icons.face;
      case BiometricCapability.touchId:
      case BiometricCapability.fingerprint:
        return Icons.fingerprint;
      default:
        return Icons.security;
    }
  }
}
