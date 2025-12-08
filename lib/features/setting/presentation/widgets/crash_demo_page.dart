import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/core/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:banking_app/core/common/extensions/context_extensions.dart';

class CrashDemoPage extends StatefulWidget {
  const CrashDemoPage({super.key});

  @override
  State<CrashDemoPage> createState() => _CrashDemoPageState();
}

class _CrashDemoPageState extends State<CrashDemoPage> {
  static const platform = MethodChannel('com.example.banking_app/crash');
  final List<String> _logs = [];

  @override
  void initState() {
    super.initState();
    _addLog('Crash Demo initialized');
  }

  void _addLog(String message) {
    setState(() {
      final timestamp = DateTime.now().toString().split('.')[0];
      _logs.add('[$timestamp] $message');
    });
  }

  void _triggerDartCrash() {
    _addLog('⚠️ Dart crash triggered');
    if (mounted) {
      BASnackBar.buildSuccessSnackbar(
        context,
        'Dart exception sent to Firebase',
      );
    }
    throw Exception('Test Dart exception');
  }

  void _triggerAsyncCrash() {
    _addLog('⚠️ Async crash triggered');
    if (mounted) {
      BASnackBar.buildSuccessSnackbar(
        context,
        'Async exception sent to Firebase',
      );
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      throw Exception('Test async exception');
    });
  }

  void _triggerNullPointerCrash() {
    _addLog('⚠️ Null pointer crash triggered');
    if (mounted) {
      BASnackBar.buildSuccessSnackbar(
        context,
        'Null pointer exception sent to Firebase',
      );
    }
    dynamic obj;
    // ignore: unnecessary_statements
    obj.toString();
  }

  void _logNonFatalError() {
    _addLog('📝 Recording non-fatal error');
    try {
      throw Exception('Test non-fatal error');
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        fatal: false,
      );
      _addLog('✓ Non-fatal error recorded');
      if (mounted) {
        BASnackBar.buildSuccessSnackbar(
          context,
          'Non-fatal error sent to Firebase',
        );
      }
    }
  }

  void _addCustomLogsAndKeys() {
    _addLog('🔑 Adding custom data');
    try {
      FirebaseCrashlytics.instance.setCustomKey(
        'session_id',
        'demo_${DateTime.now().millisecondsSinceEpoch}',
      );
      FirebaseCrashlytics.instance.setCustomKey('action', 'crash_demo');
      FirebaseCrashlytics.instance.log('Crash demo started');
      _addLog('✓ Custom data added');
      if (mounted) {
        BASnackBar.buildSuccessSnackbar(
          context,
          'Custom logs & keys sent to Firebase',
        );
      }
    } catch (e) {
      _addLog('✗ Error: $e');
    }
  }

  void _triggerNativeCrash() async {
    _addLog('⚠️ Native crash triggered');
    try {
      await platform.invokeMethod('triggerNativeCrash');
      if (mounted) {
        BASnackBar.buildSuccessSnackbar(
          context,
          'Native crash sent to Firebase',
        );
      }
    } catch (e) {
      _addLog('ℹ️ Android only feature');
      if (mounted) {
        BASnackBar.buildSuccessSnackbar(
          context,
          'Native crash (Android only)',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BAScaffold(
       appBar: BAAppBar(
        title: 'Crash Test Demo',
        titleColor: context.colorScheme.onPrimary,
        alignment: BAAppBarAlignment.left,
        iconColor: context.colorScheme.onPrimary,
        backgroundColor: context.colorScheme.secondary,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildCrashItem(
                    'Dart Crash',
                    'throw Exception()',
                    _triggerDartCrash,
                  ),
                  _buildCrashItem(
                    'Async Crash',
                    'Future error',
                    _triggerAsyncCrash,
                  ),
                  _buildCrashItem(
                    'Null Pointer Crash',
                    'null.toString()',
                    _triggerNullPointerCrash,
                  ),
                  _buildCrashItem(
                    'Non-Fatal Error',
                    'Caught & logged',
                    _logNonFatalError,
                  ),
                  _buildCrashItem(
                    'Custom Logs & Keys',
                    'Add metadata',
                    _addCustomLogsAndKeys,
                  ),
                  _buildCrashItem(
                    'Native Crash',
                    'Android only',
                    _triggerNativeCrash,
                  ),
                ],
              ),
            ),
          ),
         
        ],
      ),
    );
  }

  Widget _buildCrashItem(
    String title,
    String description,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: context.colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: context.colorScheme.secondary.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: context.colorScheme.inverseSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.inverseSurface
                            .withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: context.colorScheme.secondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
