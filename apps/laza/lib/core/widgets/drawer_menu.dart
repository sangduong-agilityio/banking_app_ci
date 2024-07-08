import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laza/core/extenssions/context_extenssions.dart';
import 'package:laza/core/l10n/l10n_generated/l10n.dart';
import 'package:laza/core/widgets/app_bar.dart';
import 'package:laza/core/widgets/icons.dart';

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
      body: Drawer(
        backgroundColor: context.colorScheme.onPrimary,
        child: ListView(
          children: [
            // Header section
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LSAppBar(
                    onTappedBackButton: () {},
                    icon: LSIcons.icInvertedMenu,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                            'https://picsum.photos/id/237/200/300'),
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
                      Text(
                        '3 Orders',
                        style: context.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 42),
            // Dark mode switch
            ListTile(
              leading: LSIcons.icSun,
              title: Text(
                S.current.darkMode,
                style: context.textTheme.headlineMedium!
                    .copyWith(color: context.colorScheme.primaryContainer),
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
                style: context.textTheme.headlineMedium!
                    .copyWith(color: context.colorScheme.primaryContainer),
              ),
              onTap: () {},
            ),
            // Orders
            ListTile(
              leading: LSIcons.icBag,
              title: Text(
                S.current.order,
                style: context.textTheme.headlineMedium!
                    .copyWith(color: context.colorScheme.primaryContainer),
              ),
              onTap: () {},
            ),
            // My cards
            SizedBox(
              child: ListTile(
                leading: LSIcons.icWallet,
                title: Text(
                  S.current.myCards,
                  style: context.textTheme.headlineMedium!
                      .copyWith(color: context.colorScheme.primaryContainer),
                ),
                onTap: () {},
              ),
            ),

            // Wishlist
            ListTile(
              leading: LSIcons.icHeart,
              title: Text(
                S.current.wishList,
                style: context.textTheme.headlineMedium!
                    .copyWith(color: context.colorScheme.primaryContainer),
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
              onTap: () {
                // Logout logic here
              },
            ),
          ],
        ),
      ),
    );
  }
}
