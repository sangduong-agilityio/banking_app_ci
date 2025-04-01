import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tradly_app/extensions/context_extensions.dart';
import 'package:tradly_app/utils/responsive.dart';

class TaAppBarSize {
  static const double small = kToolbarHeight;
  static const double minimum = 0;
  static const double medium = 76;
  static const double large = 120;
}

enum TaTitleAlignment {
  center,
  bottom,
  normal,
}

enum TaAppBarBottomType {
  none,
  line,
}

enum TaAppBarShape {
  normal,
  rounded,
}

class TaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TaAppBar({
    this.automaticallyImplyLeading = true,
    this.toolbarHeight = TaAppBarSize.large,
    this.alignmentTitle = TaTitleAlignment.normal,
    this.title = const SizedBox.shrink(),
    this.leading,
    this.backgroundColor,
    this.subTitle,
    this.trailing,
    this.bottomType = TaAppBarBottomType.none,
    this.shapeType,
    super.key,
  });

  /// The [leading] is the widget on the left side of the AppBar.
  final Widget? leading;

  /// The [title] is the widget in the center of the AppBar.
  final Widget? title;

  /// The [subTitle] is the widget below the [title].
  final Widget? subTitle;

  /// The [toolbarHeight] is the height of the AppBar.
  final double toolbarHeight;

  /// The [backgroundColor] is the background color of the AppBar.
  final Color? backgroundColor;

  /// The [alignmentTitle] is the title alignment, see [TaTitleAlignment].
  final TaTitleAlignment? alignmentTitle;

  /// The [trailing] is the widget on the right side of the AppBar.
  final Widget? trailing;

  /// The [automaticallyImplyLeading] is create back button
  final bool automaticallyImplyLeading;

  /// The bottom is the widget below the [title].
  final TaAppBarBottomType? bottomType;

  /// The shape is the shape of the AppBar.
  final TaAppBarShape? shapeType;

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(toolbarHeight),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: AppBar(
          automaticallyImplyLeading: automaticallyImplyLeading,
          elevation: 0,
          titleSpacing: 0,
          leadingWidth: 64,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          centerTitle: alignmentTitle == TaTitleAlignment.center,
          toolbarHeight: TaResponsive.scale(
            context,
            defaultValue: toolbarHeight,
          ),
          backgroundColor: backgroundColor,
          leading: leading,
          actions: [
            if (trailing != null) trailing!,
          ],
          title: switch (subTitle != null) {
            true => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title ?? const SizedBox.shrink(),
                  subTitle ?? const SizedBox.shrink(),
                ],
              ),
            false => title,
          },
          bottom: switch (bottomType) {
            TaAppBarBottomType.line => PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(
                  color: context.colorScheme.outline,
                  height: 1,
                ),
              ),
            TaAppBarBottomType.none => null,
            _ => null,
          },
          shape: switch (shapeType) {
            TaAppBarShape.rounded => const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
            TaAppBarShape.normal => null,
            _ => null,
          },
        ),
      ),
    );
  }
}
