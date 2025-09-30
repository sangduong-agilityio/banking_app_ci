import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'package:banking_app/core/resources/l10n_generated/l10n.dart';

class BAWidgetTestApp extends StatelessWidget {
  final Widget child;
  final Size surfaceSize;

  const BAWidgetTestApp({
    super.key,
    required this.child,
    this.surfaceSize = const Size(800, 1400),
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBreakpoints.builder(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [S.delegate],
        supportedLocales: [
          ...S.delegate.supportedLocales,
          const Locale('en', ''),
        ],
        builder: (context, innerChild) => LoaderOverlay(child: innerChild!),
        home: MediaQuery(
          data: MediaQueryData(
            size: surfaceSize,
            padding: EdgeInsets.zero,
            devicePixelRatio: 1.0,
          ),
          child: child,
        ),
      ),
      breakpoints: const [
        Breakpoint(start: 0, end: 450, name: MOBILE),
        Breakpoint(start: 451, end: 800, name: TABLET),
        Breakpoint(start: 801, end: 1920, name: DESKTOP),
        Breakpoint(start: 1921, end: double.infinity, name: '4K'),
      ],
    );
  }
}
