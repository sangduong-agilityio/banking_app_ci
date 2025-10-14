import 'package:banking_app/core/common/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A custom scaffold widget that provides a consistent layout structure for the app.
///
/// This scaffold can be customized with different properties like app bar, background color, bottom navigation bar, and floating action button.
class BAScaffold extends StatelessWidget {
  /// Creates a [BAScaffold] widget.
  const BAScaffold({
    required this.body,
    this.canPop = true,
    this.extendBodyBehindAppBar,
    this.appBar,
    this.backgroundColor,
    this.persistentFooterButtons,
    this.bottomNavigationBar,
    this.resizeToAvoidBottomInset,
    this.brightness,
    this.onPopInvokedWithResult,
    this.floatingActionButton,
    super.key,
  });

  /// The body of the scaffold.
  final Widget body;

  /// The app bar to display at the top of the scaffold.
  final PreferredSizeWidget? appBar;

  /// The background color of the scaffold.
  final Color? backgroundColor;

  /// Whether the scaffold can be popped.
  final bool canPop;

  /// The persistent footer buttons to display at the bottom of the scaffold.
  final List<Widget>? persistentFooterButtons;

  /// Whether the body should extend behind the app bar.
  final bool? extendBodyBehindAppBar;

  /// The bottom navigation bar to display at the bottom of the scaffold.
  final Widget? bottomNavigationBar;

  /// Whether the body should resize to avoid the bottom inset.
  final bool? resizeToAvoidBottomInset;

  /// The brightness of the status bar.
  final Brightness? brightness;

  /// The callback that is called when the scaffold is popped.
  final PopInvokedWithResultCallback<dynamic>? onPopInvokedWithResult;

  /// The floating action button to display.
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final color = backgroundColor ?? context.colorScheme.onPrimary;
    final colorComputeLuminance = color.computeLuminance();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            brightness ??
            (colorComputeLuminance >= 0.5 ? Brightness.dark : Brightness.light),
        systemNavigationBarColor: color,
      ),
      child: PopScope(
        canPop: canPop,
        onPopInvokedWithResult: onPopInvokedWithResult,
        child: Scaffold(
          extendBodyBehindAppBar: extendBodyBehindAppBar ?? false,
          appBar: appBar,
          backgroundColor: backgroundColor ?? context.colorScheme.onPrimary,
          body: body,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset ?? true,
          persistentFooterButtons: persistentFooterButtons,
          bottomNavigationBar: bottomNavigationBar,
          floatingActionButton: floatingActionButton,
        ),
      ),
    );
  }
}
