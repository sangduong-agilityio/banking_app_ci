import 'package:flutter/material.dart';
import 'package:tradly_app/core/extensions/context_extensions.dart';
import 'package:tradly_app/core/resources/assets_generated/assets.gen.dart';
import 'package:tradly_app/core/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/presentations/layouts/app_bar.dart';
import 'package:tradly_app/presentations/layouts/bottom_navigation_bar.dart';
import 'package:tradly_app/presentations/widgets/assets.dart';
import 'package:tradly_app/presentations/widgets/images.dart';
import 'package:tradly_app/presentations/widgets/text.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: TaAppBar(
        toolbarHeight: TaAppBarSize.small,
        title: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: const TaDisplaySmallText(
            text: 'Profile',
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: context.colorScheme.primary,
        trailing: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite),
                onPressed: () {},
              ),
              IconButton(
                icon: TAAssets.cart(),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 251,
            color: context.colorScheme.primary,
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TAImageCircle(
                  radius: 32,
                  Assets.images.imgTradly.path,
                  boxFit: BoxFit.cover,
                ),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tradly Team',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '+1 (234) 5678776',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'info@tradly.co',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 110,
            child: Container(
              width: MediaQuery.of(context).size.width - 32,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMenuItem(
                    title: 'Edit Profile',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    title: 'Language & Currency',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    title: 'Feedback',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    title: 'Refer a Friend',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    title: 'Terms & Conditions',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    title: 'Logout',
                    textColor: const Color(0xFF2A8572),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: TABottomNavigationBar(
        items: [
          TASBottomNavigationBarItem(
            icon: TAAssets.home(),
            label: S.current.homeLabel,
            activeIcon: TAAssets.home(
              color: context.colorScheme.primary,
            ),
          ),
          TASBottomNavigationBarItem(
            icon: TAAssets.search(),
            label: S.current.homeBrowseLabel,
            activeIcon: TAAssets.search(
              color: context.colorScheme.primary,
            ),
          ),
          TASBottomNavigationBarItem(
            icon: TAAssets.store(),
            label: S.current.homeStoreLabel,
            activeIcon: TAAssets.store(
              color: context.colorScheme.primary,
            ),
          ),
          TASBottomNavigationBarItem(
            icon: TAAssets.order(),
            label: S.current.homeOrderHistoryLabel,
            activeIcon: TAAssets.order(
              color: context.colorScheme.primary,
            ),
          ),
          TASBottomNavigationBarItem(
            icon: TAAssets.profile(),
            label: S.current.homeProfileLabel,
            activeIcon: TAAssets.profile(
              color: context.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: TaTitleLargeText(
          text: title,
          fontWeight: FontWeight.w500,
          color: textColor ?? Colors.black87,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 16,
      endIndent: 16,
      color: Color(0xFFEEEEEE),
    );
  }
}
