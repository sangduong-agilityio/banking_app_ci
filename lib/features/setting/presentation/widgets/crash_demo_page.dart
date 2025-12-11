import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/core/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:banking_app/core/common/extensions/context_extensions.dart';

class CrashDemoPage extends StatefulWidget {
  const CrashDemoPage({super.key});

  @override
  State<CrashDemoPage> createState() => _CrashDemoPageState();
}

class _CrashDemoPageState extends State<CrashDemoPage> {
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

  void _triggerFatalCrash() {
    _addLog('Triggering fatal crash');
    FirebaseCrashlytics.instance.log('fatal demo button pressed');
    throw StateError('Fatal demo crash');
  }

  Future<void> _recordNonFatal() async {
    _addLog('Recording non-fatal error');
    try {
      throw Exception('Non-fatal: simulated network timeout');
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.log('non-fatal demo tap');
      await FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        fatal: false,
        reason: 'Manual non-fatal demo',
      );
      _addLog('Non-fatal sent to Crashlytics');
      if (mounted) {
        BASnackBar.buildSuccessSnackbar(
          context,
          'Non-fatal sent to Crashlytics',
        );
      }
    }
  }

  Future<void> _setUserAndKeys() async {
    _addLog('Setting user + keys');
    await FirebaseCrashlytics.instance.setUserIdentifier('demo-user-123');
    await FirebaseCrashlytics.instance.setCustomKey('feature', 'crash_demo');
    await FirebaseCrashlytics.instance.setCustomKey('flow_step', 'tap_set_user');
    FirebaseCrashlytics.instance.log('user + keys set for demo');
    if (mounted) {
      BASnackBar.buildSuccessSnackbar(
        context,
        'UserId and custom keys set',
      );
    }
  }

  Future<void> _sendUnsentReports() async {
    _addLog('Forcing sendUnsentReports');
    await FirebaseCrashlytics.instance.sendUnsentReports();
    if (mounted) {
      BASnackBar.buildSuccessSnackbar(
        context,
        'Queued reports sent',
      );
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Firebase Crashlytics Demo',
                      style: context.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCrashItem(
                    'Fatal crash',
                    'throw StateError → app exits, sent on next launch',
                    _triggerFatalCrash,
                    context.colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  _buildCrashItem(
                    'Non-fatal error',
                    'try-catch + recordError(fatal: false)',
                    _recordNonFatal,
                    context.colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  _buildCrashItem(
                    'Set user + keys + log',
                    'setUserIdentifier + setCustomKey + log',
                    _setUserAndKeys,
                    context.colorScheme.tertiary,
                  ),
                  const SizedBox(height: 12),
                  _buildCrashItem(
                    'Send queued reports',
                    'sendUnsentReports() after reopening',
                    _sendUnsentReports,
                    context.colorScheme.secondary,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Logs (local view)',
                        style: context.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: context.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: context.colorScheme.outlineVariant,
                        ),
                      ),
                      child: _logs.isEmpty
                          ? Text(
                              'No logs yet',
                              style: context.textTheme.bodySmall,
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _logs
                                  .map(
                                    (e) => Padding(
                                      padding: const EdgeInsets.only(bottom: 6),
                                      child: Text(
                                        e,
                                        style: context.textTheme.bodySmall,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
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
    Color accentColor,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: context.colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: accentColor.withOpacity(0.3), width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 60,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.textTheme.labelMedium?.copyWith(
                        color: context.colorScheme.inverseSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.inverseSurface.withOpacity(
                          0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: accentColor),
            ],
          ),
        ),
      ),
    );
  }
}
