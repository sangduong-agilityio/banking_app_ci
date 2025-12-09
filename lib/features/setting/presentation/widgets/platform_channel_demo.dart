import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:banking_app/core/data/services/platform_channel_service.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/common/extensions/context_extensions.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/core/widgets/button.dart';

/// Example widget demonstrating Platform Channel usage
class PlatformChannelDemo extends StatefulWidget {
  const PlatformChannelDemo({super.key});

  @override
  State<PlatformChannelDemo> createState() => _PlatformChannelDemoState();
}

class _PlatformChannelDemoState extends State<PlatformChannelDemo> {
  final PlatformChannelService _platformService = PlatformChannelService();
  int _batteryLevel = 0;
  String _helloWorldResponse = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getSystemVersion();
  }

  Future<void> _getSystemVersion() async {
    setState(() => _isLoading = true);


    setState(() {
     
      _isLoading = false;
    });
  }

  Future<void> _getBatteryLevel() async {
    setState(() => _isLoading = true);
    try {
      final level = await _platformService.getBatteryLevel();
      setState(() {
        _batteryLevel = level;
        _isLoading = false;
      });

      if (mounted) {
        BASnackBar.buildSuccessSnackbar(
          context,
          S.current.platformChannelBatteryLevelSnackbar(level),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        BASnackBar.buildErrorSnackbar(
          context,
          S.current.platformChannelErrorMessage(e.toString()),
        );
      }
    }
  }

  Future<void> _sendHelloWorld() async {
    setState(() => _isLoading = true);
    try {
      final response = await _platformService.sendHelloWorld();
      setState(() {
        _helloWorldResponse = response;
        _isLoading = false;
      });
      if (mounted) {
        BASnackBar.buildSuccessSnackbar(
          context,
          'Native response: $response',
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        BASnackBar.buildErrorSnackbar(
          context,
          'Error: $e',
        );
      }
    }
  }

 


  @override
  Widget build(BuildContext context) {
    return BAScaffold(
      appBar: BAAppBar(
        title: S.current.platformChannelTitle,
        titleColor: context.colorScheme.scrim,
        alignment: BAAppBarAlignment.left,
        iconColor: context.colorScheme.scrim,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
             

              const SizedBox(height: 16),

              // Battery Level Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.current.platformChannelBatteryInfoTitle,
                        style: context.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: context.colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(
                            _batteryLevel > 20
                                ? Icons.battery_full
                                : Icons.battery_alert,
                            size: 24,
                            color: _batteryLevel > 20
                                ? context.colorScheme.secondary
                                : context.colorScheme.error,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  S.current.platformChannelBatteryLevelLabel,
                                  style: context.bodySmall?.copyWith(
                                    color: context.colorScheme.scrim.withAlpha(
                                      0x99,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _batteryLevel > 0
                                      ? '$_batteryLevel%'
                                      : S.current.platformChannelNotChecked,
                                  style: context.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: context.colorScheme.scrim,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Hello World Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello World Demo',
                        style: context.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: context.colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(
                            Icons.message_outlined,
                            size: 24,
                            color: context.colorScheme.secondary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Native Response',
                                  style: context.bodySmall?.copyWith(
                                    color: context.colorScheme.scrim.withAlpha(
                                      0x99,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _helloWorldResponse.isEmpty
                                      ? 'Not sent yet'
                                      : _helloWorldResponse,
                                  style: context.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: context.colorScheme.scrim,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

           
              // Action Buttons
            
              const SizedBox(height: 12),
              BAElevatedButton(
                padding: EdgeInsets.zero,
                height: 50,
                text: S.current.platformChannelGetBatteryButton,
                onPressed: _isLoading ? null : _getBatteryLevel,
              ),
              const SizedBox(height: 12),
              BAElevatedButton(
                padding: EdgeInsets.zero,
                height: 50,
                text: 'Send Hello World',
                onPressed: _isLoading ? null : _sendHelloWorld,
              ),
              const SizedBox(height: 12),
              

            ],
          ),
        ),
      ),
    );
  }
}
