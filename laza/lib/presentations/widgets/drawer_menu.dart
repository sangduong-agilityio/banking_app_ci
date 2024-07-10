import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/core/gen_assets/assets.gen.dart';
import 'package:laza/core/l10n/l10n_generated/l10n.dart';
import 'package:laza/presentations/widgets/app_bar.dart';
import 'package:laza/presentations/widgets/icons.dart';

class LSDrawerMenu extends StatefulWidget {
  const LSDrawerMenu({super.key});

  @override
  State<LSDrawerMenu> createState() => _LSDrawerMenuState();
}

class _LSDrawerMenuState extends State<LSDrawerMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Drawer(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          backgroundColor: context.colorScheme.onPrimary,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 45,
                    ),
                    LSAppBar(
                      onTappedBackButton: () {
                        context.pop();
                      },
                      icon: LSIcons.icInvertedMenu,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage(
                            Assets.images.dataImage.path,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sang',
                              style: context.textTheme.headlineLarge,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              S.current.verifiedProfile,
                              style: context.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        const SizedBox(width: 30),
                        Container(
                          width: 66,
                          height: 32,
                          decoration: BoxDecoration(
                            color: context.colorScheme.outlineVariant,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              '3 Orders',
                              style: context.textTheme.bodyLarge,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
              // Dark mode switch
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    ListTile(
                      leading: LSIcons.icSun,
                      title: Text(
                        S.current.darkMode,
                        style: context.textTheme.headlineMedium!.copyWith(
                            color: context.colorScheme.primaryContainer),
                      ),
                      trailing: CupertinoSwitch(
                        value: false,
                        onChanged: (value) {},
                      ),
                    ),
                    // Account information
                    ListTile(
                      leading: LSIcons.icInformation,
                      title: Text(
                        S.current.accountInformation,
                        style: context.textTheme.headlineMedium!.copyWith(
                            color: context.colorScheme.primaryContainer),
                      ),
                      onTap: () {},
                    ),
                    // Orders
                    ListTile(
                      leading: LSIcons.icBag,
                      title: Text(
                        S.current.order,
                        style: context.textTheme.headlineMedium!.copyWith(
                            color: context.colorScheme.primaryContainer),
                      ),
                      onTap: () {},
                    ),
                    // My cards
                    SizedBox(
                      child: ListTile(
                        leading: LSIcons.icWallet,
                        title: Text(
                          S.current.myCards,
                          style: context.textTheme.headlineMedium!.copyWith(
                              color: context.colorScheme.primaryContainer),
                        ),
                        onTap: () {},
                      ),
                    ),

                    // Wishlist
                    ListTile(
                      leading: LSIcons.icHeart,
                      title: Text(
                        S.current.wishList,
                        style: context.textTheme.headlineMedium!.copyWith(
                            color: context.colorScheme.primaryContainer),
                      ),
                      onTap: () {},
                    ),
                    const SizedBox(height: 230),
                    // Logout
                    ListTile(
                      leading: LSIcons.icLogout,
                      title: Text(
                        S.current.logoutBtn,
                        style: context.textTheme.headlineMedium!
                            .copyWith(color: context.colorScheme.error),
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
