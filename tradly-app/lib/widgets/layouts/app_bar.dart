import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tradly_app/extensions/context_extensions.dart';
import 'package:tradly_app/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/utils/responsive.dart';
import 'package:tradly_app/widgets/assets.dart';
import 'package:tradly_app/widgets/text.dart';

enum TAAppBarType {
  home,
  productList,
  productDetail,
  checkout,
}

enum TAAppBarBottomType {
  none,
  options,
  search,
  imageBackground,
  custom,
}

class TAAppBarSize {
  static const double small = kToolbarHeight;
  static const double minimum = 72;
  static const double medium = 126;
  static const double large = 182;
}

class TAAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TAAppBar({
    this.appBarType = TAAppBarType.home,
    this.automaticallyImplyLeading = true,
    this.toolbarHeight = TAAppBarSize.medium,
    this.title,
    this.leading,
    this.backgroundColor,
    this.subTitle,
    this.trailing,
    this.bottomType = TAAppBarBottomType.none,
    this.searchForm,
    this.filterOptions,
    this.background,
    this.onBackPressed,
    this.onSortPressed,
    this.onLocationPressed,
    this.elevation = 0,
    this.onPressed,
    this.actions,
    this.centerTitle = true,
    super.key,
  });

  final TAAppBarType appBarType;
  final Widget? leading;
  final Widget? title;
  final Widget? subTitle;
  final double toolbarHeight;
  final Color? backgroundColor;
  final Widget? trailing;
  final bool automaticallyImplyLeading;
  final TAAppBarBottomType bottomType;
  final Widget? searchForm;
  final Widget? filterOptions;
  final Widget? background;
  final VoidCallback? onBackPressed;
  final double elevation;
  final VoidCallback? onPressed;
  final List<Widget>? actions;
  final bool centerTitle;
  final VoidCallback? onSortPressed;
  final VoidCallback? onLocationPressed;

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);

  /// Factory constructor for home screen app bar
  factory TAAppBar.home({
    required Widget title,
    required Widget searchForm,
    List<Widget>? actions,
    Color? backgroundColor,
    Widget? trailing,
    bool? centerTitle,
    bool? automaticallyImplyLeading,
  }) {
    return TAAppBar(
      appBarType: TAAppBarType.home,
      title: title,
      backgroundColor: backgroundColor,
      bottomType: TAAppBarBottomType.search,
      searchForm: searchForm,
      trailing: trailing,
      automaticallyImplyLeading: automaticallyImplyLeading ?? true,
      centerTitle: centerTitle ?? true,
    );
  }

  /// Factory constructor for product list screen app bar
  factory TAAppBar.productList({
    required String title,
    VoidCallback? onBackPressed,
    Color? backgroundColor,
    TAAppBarBottomType bottomType = TAAppBarBottomType.options,
    Widget? filterOptions,
    VoidCallback? onPressed,
  }) {
    return TAAppBar(
      appBarType: TAAppBarType.productList,
      title: TADisplaySmallText(
        text: title,
        fontWeight: FontWeight.w700,
      ),
      backgroundColor: backgroundColor ?? Colors.teal,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: onBackPressed,
      ),
      bottomType: bottomType,
      filterOptions: filterOptions,
      onPressed: onPressed,
    );
  }

  /// Factory constructor for product details screen app bar
  factory TAAppBar.productDetail({
    required Widget background,
    VoidCallback? onBackPressed,
    VoidCallback? onPressed,
    Color? backgroundColor,
    List<Widget>? actions,
    TAAppBarBottomType bottomType = TAAppBarBottomType.imageBackground,
  }) {
    return TAAppBar(
      appBarType: TAAppBarType.productDetail,
      toolbarHeight: TAAppBarSize.large,
      background: background,
      backgroundColor: Colors.teal,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withAlpha(50),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: onBackPressed,
        ),
      ),
      bottomType: bottomType,
      trailing: Row(
        children: (actions ?? []),
      ),
    );
  }

  /// Factory constructor for checkout screen app bar
  factory TAAppBar.checkout({
    required String title,
    VoidCallback? onBackPressed,
    Color? backgroundColor,
    TAAppBarBottomType bottomType = TAAppBarBottomType.none,
  }) {
    return TAAppBar(
      appBarType: TAAppBarType.checkout,
      title: TADisplaySmallText(
        text: title,
        fontWeight: FontWeight.w700,
      ),
      backgroundColor: backgroundColor ?? Colors.teal,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: onBackPressed,
      ),
      bottomType: bottomType,
      toolbarHeight: TAAppBarSize.small,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(toolbarHeight),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: AppBar(
          flexibleSpace: background,
          automaticallyImplyLeading: automaticallyImplyLeading,
          elevation: elevation,
          titleSpacing: 0,
          leadingWidth: 56,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          centerTitle: centerTitle,
          toolbarHeight: TAResponsive.scale(
            context,
            defaultValue: toolbarHeight,
          ),
          backgroundColor: backgroundColor ?? context.colorScheme.primary,
          leading: leading ??
              (automaticallyImplyLeading && Navigator.canPop(context)
                  ? IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: context.colorScheme.onPrimary,
                      ),
                      onPressed:
                          onBackPressed ?? () => Navigator.of(context).pop(),
                    )
                  : null),
          actions: [
            if (trailing != null)
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: trailing!,
              ),
          ],
          title: subTitle != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title ?? const SizedBox.shrink(),
                    const SizedBox(height: 4),
                    subTitle!,
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: title,
                ),
          bottom: _buildBottom(context),
        ),
      ),
    );
  }

  PreferredSizeWidget? _buildBottom(BuildContext context) {
    switch (bottomType) {
      case TAAppBarBottomType.search:
        return PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: searchForm ?? const SizedBox.shrink(),
          ),
        );

      case TAAppBarBottomType.options:
        return PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: filterOptions ?? _filterOptions(context),
          ),
        );

      case TAAppBarBottomType.imageBackground:
        return PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(height: 120),
        );

      case TAAppBarBottomType.custom:
        return PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: searchForm ?? const SizedBox.shrink(),
              ),
              filterOptions ?? _filterOptions(context),
            ],
          ),
        );

      case TAAppBarBottomType.none:
        return PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(height: 20),
        );
    }
  }

  Widget _filterOptions(BuildContext context) {
    return filterOptions ??
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _filterButton(
              context,
              icon: TAAssets.sortList(),
              label: S.current.productDetailSortByButton,
              onPressed: onSortPressed ?? () {},
            ),
            _filterButton(
              context,
              icon: Icon(
                Icons.location_on,
                size: 16,
              ),
              label: S.current.productDetailLocationButton,
              onPressed: onLocationPressed ?? () {},
            ),
            _filterButton(
              context,
              icon: TAAssets.category(),
              label: S.current.productDetailCategoryButton,
              onPressed: () {},
            ),
          ],
        );
  }

  Widget _filterButton(
    BuildContext context, {
    required Widget icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: TATitleLargeText(
        text: label,
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(
            color: context.colorScheme.onPrimary,
            width: 1,
          ),
        ),
      ),
    );
  }
}
