import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/assets.dart';
import 'package:banking_app/core/widgets/card.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/core/widgets/tab_bar.dart';
import 'package:banking_app/features/account/states/account_and_card_cubit.dart';
import 'package:banking_app/features/account/states/account_and_card_state.dart';
import 'package:banking_app/features/account/views/account_management_screen.dart';
import 'package:banking_app/features/account/views/bank_card_detail_screen.dart';
import 'package:banking_app/features/account/widgets/account_card.dart';
import 'package:flutter/material.dart';
import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountAndCardScreen extends StatefulWidget {
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
            SizedBox(height: 16),
            BATabBar(
              controller: _tabController,
              tabs: [S.current.accountTitle, S.current.accountCardTitle],
              containerPadding: EdgeInsets.symmetric(horizontal: 24),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [AccountListSection(), BankCardListSection()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bank Card List Section
class BankCardListSection extends StatelessWidget {
  const BankCardListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountAndCardCubit, AccountAndCardState>(
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<AccountAndCardCubit>(),
                              child: BankCardDetailScreen(
                                cards: state.cards[0],
                              ),
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

/// Account List Section
class AccountListSection extends StatelessWidget {
  const AccountListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountAndCardCubit, AccountAndCardState>(
      buildWhen: (previous, current) =>
          previous.user != current.user ||
          previous.accounts != current.accounts,
      builder: (context, state) {
        return Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  BAProfileImage(url: state.user?.profileImage, size: 100),
                  SizedBox(height: 12),
                  Text(
                    state.user?.username ?? '',
                    style: context.titleMedium?.copyWith(
                      color: context.colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 32),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<AccountAndCardCubit>(),
                            child: AccountManagementScreen(
                              account: state.accounts[0],
                            ),
                          ),
                        ),
                      );
                    },
                    child: SizedBox(
                      height: 300,
                      child: ListView.builder(
                        itemCount: state.accounts.length,
                        itemBuilder: (context, index) => AccountCard(
                          account: state.accounts[index],
                          mode: AccountCardMode.overview,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
