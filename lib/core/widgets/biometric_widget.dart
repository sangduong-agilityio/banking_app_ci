import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/services/biometric_capability.dart';
import 'package:flutter/material.dart';

class BABiometricButton extends StatelessWidget {
  const BABiometricButton({
    super.key,
    required this.capability,
    required this.onPressed,
    this.isEnabled = true,
    this.size = 56.0,
  });

  final BiometricCapability capability;
  final VoidCallback onPressed;
  final bool isEnabled;
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
            ? context.colorScheme.secondary.withOpacity(0.1)
            : context.colorScheme.onSurface.withOpacity(0.1),
        border: Border.all(
          color: isEnabled
              ? context.colorScheme.secondary
              : context.colorScheme.onSurface.withOpacity(0.3),
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
                  : context.colorScheme.onSurface.withOpacity(0.3),
            ),
          ),
        ),
      ),
    );
  }

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

class BiometricStatusIndicator extends StatelessWidget {
  const BiometricStatusIndicator({
    super.key,
    required this.capability,
    required this.isEnabled,
    this.showLabel = true,
  });

  final BiometricCapability capability;
  final bool isEnabled;
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
              : context.colorScheme.onSurface.withOpacity(0.5),
        ),
        if (showLabel) ...[
          const SizedBox(width: 4),
          Text(
            capability.displayName,
            style: context.bodySmall?.copyWith(
              color: isEnabled
                  ? context.colorScheme.secondary
                  : context.colorScheme.onSurface.withOpacity(0.5),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

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
