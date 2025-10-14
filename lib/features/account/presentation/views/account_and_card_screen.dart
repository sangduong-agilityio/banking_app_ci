import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/assets.dart';
import 'package:banking_app/core/widgets/card.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/core/widgets/shimmer.dart';
import 'package:banking_app/core/widgets/tab_bar.dart';
import 'package:banking_app/features/account/presentation/blocs/account_and_card_cubit.dart';
import 'package:banking_app/features/account/presentation/blocs/account_and_card_state.dart';
import 'package:banking_app/features/account/presentation/views/account_management_screen.dart';
import 'package:banking_app/features/account/presentation/views/bank_card_detail_screen.dart';
import 'package:banking_app/features/account/presentation/widgets/account_card.dart';
import 'package:flutter/material.dart';
import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/common/extensions/context_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A screen that displays the user's accounts and bank cards.
///
/// This screen has two tabs: one for accounts and one for bank cards.
/// It uses a [AccountAndCardCubit] to manage the state.
class AccountAndCardScreen extends StatefulWidget {
  /// Creates an [AccountAndCardScreen] object.
  const AccountAndCardScreen({super.key});

  @override
  State<AccountAndCardScreen> createState() => _AccountAndCardScreenState();
}

class _AccountAndCardScreenState extends State<AccountAndCardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // The listener is used to rebuild the widget when the tab changes.
    // This is to ensure that the correct tab is highlighted.
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<AccountAndCardCubit>()..accountAndCardInitialize(),
      child: BAScaffold(
        appBar: BAAppBar(
          title: S.current.accountAndCardTitle,
          titleColor: context.colorScheme.scrim,
          alignment: BAAppBarAlignment.left,
          iconColor: context.colorScheme.scrim,
        ),
        body: Column(
          children: [
            const SizedBox(height: 16),
            BATabBar(
              controller: _tabController,
              tabs: [S.current.accountTitle, S.current.accountCardTitle],
              containerPadding: const EdgeInsets.symmetric(horizontal: 24),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [AccountListSection(), BankCardListSection()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A widget that displays a list of bank cards.
class BankCardListSection extends StatelessWidget {
  /// Creates a [BankCardListSection] object.
  const BankCardListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountAndCardCubit, AccountAndCardState>(
      // Rebuild the widget only when the list of cards changes.
      buildWhen: (previous, current) => previous.cards != current.cards,
      builder: (context, state) {
        final cards = state.cards;
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 30,
                ),
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  final card = cards[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to the bank card detail screen with the selected card.
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<AccountAndCardCubit>(),
                              child: BankCardDetailScreen(card: card),
                            ),
                          ),
                        );
                      },
                      child: SwipeableCreditCard(
                        key: ValueKey(card.id),
                        data: card,
                        isActive: index == 0,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

/// A widget that displays a list of bank accounts.
class AccountListSection extends StatelessWidget {
  /// Creates an [AccountListSection] object.
  const AccountListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountAndCardCubit, AccountAndCardState>(
      // Rebuild the widget only when the user or the list of accounts changes.
      buildWhen: (previous, current) =>
          previous.user != current.user ||
          previous.accounts != current.accounts,
      builder: (context, state) {
        // Show a skeleton loading indicator while the data is being fetched.
        if (state.status is AccountAndCardStatusLoading) {
          return const AccountListSkeleton();
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  BAProfileImage(url: state.user?.profileImage, size: 100),
                  const SizedBox(height: 12),
                  Text(
                    state.user?.username ?? '',
                    style: context.titleMedium?.copyWith(
                      color: context.colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: state.accounts.length,
                itemBuilder: (context, index) {
                  final account = state.accounts[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to the account management screen with the selected account.
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<AccountAndCardCubit>(),
                            child: AccountManagementScreen(account: account),
                          ),
                        ),
                      );
                    },
                    child: AccountCard(
                      account: account,
                      mode: AccountCardMode.overview,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
