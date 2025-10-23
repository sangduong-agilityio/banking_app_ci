import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class ConfirmationDialog extends StatelessWidget {
  final String toolName;
  final Map<String, dynamic> params;
  final bool requiresBiometric;

  const ConfirmationDialog({
    Key? key,
    required this.toolName,
    required this.params,
    this.requiresBiometric = false,
  }) : super(key: key);

  Future<bool> _authenticateWithBiometrics(BuildContext context) async {
    final localAuth = LocalAuthentication();
    try {
      final canCheckBiometrics = await localAuth.canCheckBiometrics;
      if (!canCheckBiometrics) {
        return true; // Fallback if biometrics not available
      }

      return await localAuth.authenticate(
        localizedReason: 'Please authenticate to confirm this action',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }

  String _formatParamValue(dynamic value) {
    if (value == null) return 'Not specified';
    if (value is DateTime) {
      return value.toLocal().toString().split('.')[0];
    }
    if (value is double) {
      return value.toStringAsFixed(2);
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Confirm $toolName'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Please review the details:'),
          const SizedBox(height: 16.0),
          ...params.entries.map((entry) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${entry.key}:',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(_formatParamValue(entry.value)),
                ),
              ],
            ),
          )),
          if (requiresBiometric)
            const Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Row(
                children: [
                  Icon(Icons.fingerprint),
                  SizedBox(width: 8.0),
                  Text('Biometric authentication required'),
                ],
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (requiresBiometric) {
              final authenticated = await _authenticateWithBiometrics(context);
              if (!authenticated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Authentication failed'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
            }
            Navigator.of(context).pop(true);
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}