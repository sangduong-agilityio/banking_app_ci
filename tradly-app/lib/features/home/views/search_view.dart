import 'package:flutter/material.dart';
import 'package:tradly_app/extensions/context_extensions.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:go_router/go_router.dart';
import 'package:tradly_app/configs/app_router.dart';
import 'package:tradly_app/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/widgets/assets.dart';
import 'package:tradly_app/widgets/layouts/bottom_navigation_bar.dart';
import 'package:tradly_app/widgets/text.dart';

class TASearchView extends StatelessWidget {
  const TASearchView({
    super.key,
    required this.placeholder,
    this.onChanged,
    this.controller,
    this.textStyle,
    this.hintStyle,
  });

  final String placeholder;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: context.colorScheme.onSurface,
      onChanged: (value) {
        if (onChanged != null) {
          onChanged!(value);
        }
      },
      style: textStyle ?? TextStyle(color: context.colorScheme.onSurface),
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: hintStyle ??
            TextStyle(
              color: context.colorScheme.outline.withAlpha(150),
              fontSize: 14,
            ),
        prefixIcon: Icon(
          Icons.search,
          size: 24,
          color: context.colorScheme.primary,
        ),
        isDense: true,
        filled: true,
        fillColor: context.colorScheme.onPrimary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
            color: context.colorScheme.onPrimary,
            width: 2.0,
          ),
        ),
      ),
    );
  }
}

class SearchSpotlight extends StatelessWidget {
  const SearchSpotlight({
    super.key,
    this.placeholder,
    this.onNavigate,
  });

  final String? placeholder;
  final VoidCallback? onNavigate;

  List<NavigationItem> _getSuggestions(String pattern) {
    if (pattern.isEmpty || pattern.length < 3 || pattern.length > 20) {
      return [];
    }
    return navigationItems
        .where((item) => item.matchesSearch(pattern))
        .toList();
  }

  void _onItemSelected(BuildContext context, NavigationItem item) {
    onNavigate?.call();
    final bottomNavIndex = navigationItems
        .indexWhere((navItem) => navItem.routeName == item.routeName);
    context.goNamed(item.routeName);
    TABottomNavigationBar.of(context)?.updateIndex(bottomNavIndex);
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<NavigationItem>(
      suggestionsCallback: (pattern) async => _getSuggestions(pattern),
      itemBuilder: (context, suggestion) => NavigationItemWidget(
        item: suggestion,
        onTap: () => _onItemSelected(context, suggestion),
      ),
      onSelected: (suggestion) => _onItemSelected(context, suggestion),
      decorationBuilder: (context, child) {
        return Container(
          constraints: const BoxConstraints(maxHeight: 500),
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: child,
        );
      },
      emptyBuilder: (context) => const SizedBox.shrink(),
      loadingBuilder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
      hideOnEmpty: true,
      builder: (context, controller, focusNode) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          cursorColor: context.colorScheme.onSurface,
          decoration: InputDecoration(
            hintText: S.current.homeSearchSpotlightLabel,
            hintStyle: TextStyle(
              color: context.colorScheme.outline.withAlpha(150),
              fontSize: 14,
            ),
            prefixIcon: Icon(
              Icons.search,
              size: 24,
              color: context.colorScheme.primary,
            ),
            isDense: true,
            filled: true,
            fillColor: context.colorScheme.onPrimary,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(
                color: context.colorScheme.onPrimary,
                width: 2.0,
              ),
            ),
          ),
          style: TextStyle(
            fontSize: 14,
            color: context.colorScheme.onSurface,
          ),
        );
      },
    );
  }
}

class NavigationItemWidget extends StatelessWidget {
  const NavigationItemWidget({
    super.key,
    required this.item,
    required this.onTap,
  });

  final NavigationItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: context.colorScheme.primary.withAlpha(10),
                borderRadius: BorderRadius.circular(8),
              ),
              child: item.icon,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TAHeadlineSmallText(
                    text: item.title,
                    color: context.colorScheme.onSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 2),
                  TATitleMediumText(
                    text: item.subtitle,
                    color: context.colorScheme.onSecondary,
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavigationItem {
  final String title;
  final String subtitle;
  final Widget icon;
  final String routeName;
  final Object? extra;

  NavigationItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.routeName,
    this.extra,
  });

  bool matchesSearch(String query) {
    return title.toLowerCase().contains(query.toLowerCase()) ||
        subtitle.toLowerCase().contains(query.toLowerCase());
  }
}

final List<NavigationItem> navigationItems = [
  NavigationItem(
    title: S.current.homeLabel,
    subtitle: S.current.homeSubTitle,
    icon: TAAssets.home(
      color: const Color(0xFF33907C),
    ),
    routeName: TAPaths.home.name,
  ),
  NavigationItem(
    title: S.current.homeProfileLabel,
    subtitle: S.current.homeProfileSubTitle,
    icon: TAAssets.profile(
      color: const Color(0xFF33907C),
    ),
    routeName: TAPaths.profile.name,
  ),
  NavigationItem(
    title: S.current.homeBrowseLabel,
    subtitle: S.current.homeBrowseSubTitle,
    icon: TAAssets.search(
      color: const Color(0xFF33907C),
    ),
    routeName: TAPaths.browse.name,
  ),
  NavigationItem(
    title: S.current.homeStoreLabel,
    subtitle: S.current.homeStoreSubTitle,
    icon: TAAssets.store(
      color: const Color(0xFF33907C),
    ),
    routeName: TAPaths.store.name,
  ),
  NavigationItem(
    title: S.current.homeOrderHistoryLabel,
    subtitle: S.current.homeOrderHistorySubTitle,
    icon: TAAssets.order(
      color: const Color(0xFF33907C),
    ),
    routeName: TAPaths.orderHistory.name,
  ),
];
