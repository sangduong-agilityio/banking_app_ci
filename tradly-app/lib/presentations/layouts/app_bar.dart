import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tradly_app/core/extensions/context_extensions.dart';
import 'package:tradly_app/core/utils/responsive.dart';

class TaAppBarSize {
  static const double small = kToolbarHeight;
  static const double minimum = 72;
  static const double medium = 126;
  static const double large = 182;
}

enum TaTitleAlignment {
  center,
  bottom,
  normal,
}

enum TaAppBarBottomType {
  none,
  option,
  search,
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
    this.searchForm,
    this.optionList,
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

  final Widget? searchForm;

  final Widget? optionList;

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
            TaAppBarBottomType.search => PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: searchForm ?? const SizedBox.shrink(),
                    ),
                    const SizedBox.shrink(),
                  ],
                ),
              ),
            TaAppBarBottomType.option => PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          Icons.sort,
                          size: 16,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Sort by',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          // minimumSize: const Size(10, 32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(
                              color: context.colorScheme.onPrimary,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          size: 16,
                          Icons.location_on,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Location',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          // minimumSize: const Size(10, 32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(
                              color: context.colorScheme.onPrimary,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          size: 16,
                          Icons.category,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Category',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          // minimumSize: const Size(10, 32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(
                              color: context.colorScheme.onPrimary,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
