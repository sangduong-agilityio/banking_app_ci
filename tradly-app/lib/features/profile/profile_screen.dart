import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradly_app/features/profile/states/profile_state.dart';
import 'package:tradly_app/utils/locator.dart';
import 'package:tradly_app/widgets/layouts/scaffold.dart';
import 'package:tradly_app/features/profile/states/profile_cubit.dart';
import 'package:tradly_app/extensions/context_extensions.dart';
import 'package:tradly_app/resources/assets_generated/assets.gen.dart';
import 'package:tradly_app/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/configs/app_router.dart';
import 'package:tradly_app/features/auth/repositories/auth_repo.dart';
import 'package:tradly_app/widgets/layouts/app_bar.dart';
import 'package:tradly_app/widgets/assets.dart';
import 'package:tradly_app/widgets/images.dart';
import 'package:tradly_app/widgets/not_found.dart';
import 'package:tradly_app/widgets/text.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(
        repo: locator.get<AuthRepository>(),
      )..fetchProfile(),
      child: TAScaffold(
        appBar: TAAppBar(
          centerTitle: false,
          toolbarHeight: TAAppBarSize.small,
          title: TADisplaySmallText(
            text: S.current.profileTitle,
            fontWeight: FontWeight.w700,
          ),
          trailing: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite),
                onPressed: () {},
              ),
              TAAssets.cart(),
            ],
          ),
        ),
        body:
            BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
          if (state.status is ProfileStatusLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status is ProfileStatusSuccess) {
            final user = state.user;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 251,
                    width: double.infinity,
                    color: context.colorScheme.primary,
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
                    child: SafeArea(
                      bottom: false,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TAImageCircle(
                            radius: 32,
                            Assets.images.imgTradly.path,
                            boxFit: BoxFit.cover,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TATitleLargeText(
                                  text: user?.userName ?? '',
                                  color: context.colorScheme.onPrimary,
                                ),
                                const SizedBox(height: 4),
                                TATitleLargeText(
                                  text: user?.email ?? '',
                                  color: context.colorScheme.onPrimary,
                                ),
                                const SizedBox(height: 2),
                                TATitleLargeText(
                                  text: user?.phoneNumber ?? '',
                                  color: context.colorScheme.onPrimary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -150),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: context.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _buildMenuItem(
                            context: context,
                            title: S.current.profileEditTitle,
                            onTap: () {},
                          ),
                          _buildDivider(),
                          _buildMenuItem(
                            context: context,
                            title: S.current.profileLanguageCurrencyTitle,
                            onTap: () {},
                          ),
                          _buildDivider(),
                          _buildMenuItem(
                            context: context,
                            title: S.current.profileFeedbackTitle,
                            onTap: () {},
                          ),
                          _buildDivider(),
                          _buildMenuItem(
                            context: context,
                            title: S.current.profileReferFriendTitle,
                            onTap: () {},
                          ),
                          _buildDivider(),
                          _buildMenuItem(
                            context: context,
                            title: S.current.profileTermsAndConditionsTitle,
                            onTap: () {},
                          ),
                          _buildDivider(),
                          _buildMenuItem(
                              context: context,
                              title: S.current.profileLogoutTitle,
                              textColor: context.colorScheme.primary,
                              onTap: () async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.remove('session_token');
                                if (context.mounted) {
                                  context.go(TAPaths.onboarding.path);
                                }
                              }),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            );
          } else if (state.status is ProfileStatusFailure) {
            return NotFoundScreen();
          }
          return const SizedBox.shrink();
        }),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 16),
          child: Row(
            children: [
              const SizedBox(width: 12),
              Expanded(
                child: TATitleLargeText(
                  text: title,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? context.colorScheme.onSurface,
                ),
              ),
            ],
          ),
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
