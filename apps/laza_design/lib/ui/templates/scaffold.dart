// import 'package:flutter/material.dart';
// import 'package:teppi_design/core/extensions/context_extensions.dart';

// /// A custom scaffold for online learning app.
// class OnlineLearningScaffold extends StatelessWidget {
//   /// Constructs an [OnlineLearningScaffold].
//   const OnlineLearningScaffold({
//     super.key,
//     this.appBar,
//     required this.body,
//     this.bottomNavigationBar,
//     this.drawer,
//     this.endDrawer,
//     this.hasScrollView = true,
//     this.scrollController,
//     this.isCanPop = false,
//     this.floatingActionButton,
//     this.paddingScaffold = 0,
//     this.reverse,
//   });

//   // App bar of the scaffold
//   final PreferredSizeWidget? appBar;

//   // Body of the scaffold
//   final Widget body;

//   // Bottom navigation bar of the scaffold
//   final Widget? bottomNavigationBar;

//   // Drawer of the scaffold
//   final Widget? drawer;

//   // End drawer of the scaffold
//   final Widget? endDrawer;

//   // Whether the scaffold has a scroll view or not (default: true)
//   final bool hasScrollView;

//   // Scroll controller for the scaffold's scroll view
//   final ScrollController? scrollController;

//   // Whether the scaffold can be popped or not (default: false)
//   final bool isCanPop;

//   final bool? reverse;

//   /// A button displayed floating above [body], in the bottom right corner.
//   ///
//   /// Typically a [FloatingActionButton].
//   final Widget? floatingActionButton;
//   // Padding horizontal scaffold
//   final double paddingScaffold;

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: isCanPop,
//       child: Scaffold(
//         resizeToAvoidBottomInset: true,
//         backgroundColor: context.colorScheme.onPrimary,
//         appBar: appBar,
//         bottomNavigationBar: bottomNavigationBar,
//         body: Padding(
//           padding: EdgeInsets.symmetric(horizontal: paddingScaffold.w),
//           child: SafeArea(
//             bottom: false,
//             child: hasScrollView
//                 ? SingleChildScrollView(
//                     controller: scrollController,
//                     reverse: reverse ?? context.isOpenKeyboard,
//                     child: body,
//                   )
//                 : body,
//           ),
//         ),
//         drawer: drawer,
//         endDrawer: endDrawer,
//         floatingActionButton: floatingActionButton,
//       ),
//     );
//   }
// }
