import 'package:flutter/material.dart';
import 'package:laza/core/extensions/context_extensions.dart';

class LazaShopScaffold extends StatelessWidget {
  const LazaShopScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.hasScrollView = true,
    this.scrollController,
    this.isCanPop = false,
    this.floatingActionButton,
    this.paddingScaffold = 0,
    this.reverse,
  });

  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final bool hasScrollView;
  final ScrollController? scrollController;
  final bool isCanPop;
  final bool? reverse;
  final Widget? floatingActionButton;
  final double paddingScaffold;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: isCanPop,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: context.colorScheme.onPrimary,
        appBar: appBar,
        bottomNavigationBar: bottomNavigationBar,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingScaffold),
          child: SafeArea(
            bottom: false,
            child: hasScrollView
                ? SingleChildScrollView(
                    controller: scrollController,
                    reverse: reverse ?? context.isOpenKeyboard,
                    child: body,
                  )
                : body,
          ),
        ),
        drawer: drawer,
        endDrawer: endDrawer,
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
