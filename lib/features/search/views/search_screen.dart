import 'package:banking_app/app/router/app_router.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/assets.dart';
import 'package:banking_app/core/widgets/card.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/core/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A screen that displays a list of search categories.
///
/// This screen shows a list of categories that the user can search for, such as
/// branches, interest rates, and exchange rates.
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BAScaffold(
      appBar: BAAppBar(
        title: S.current.searchTitle,
        titleColor: context.colorScheme.scrim,
        alignment: BAAppBarAlignment.left,
        iconColor: context.colorScheme.scrim,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CardCategorySelected(
              category: S.current.searchBranchSelectedTitle,
              categoryName: S.current.searchBranchDescription,
              imageUrl: BAAssets.branch(),
              onTap: () {
                BASnackBar.showNotSupported(
                  context,
                  S.current.pageNotSupportedYet,
                );
              },
            ),
            CardCategorySelected(
              category: S.current.searchInterestRateTitle,
              categoryName: S.current.searchInterestRateDescription,
              imageUrl: BAAssets.interest(),
              onTap: () {
                context.goNamed(BAPaths.interestRate.name);
              },
            ),
            CardCategorySelected(
              category: S.current.searchExchangeRateTitle,
              categoryName: S.current.searchExchangeRateDescription,
              imageUrl: BAAssets.exchangeRate(),
              onTap: () {
                context.goNamed(BAPaths.exchangeRate.name);
              },
            ),
            CardCategorySelected(
              category: S.current.searchExchangeTitle,
              categoryName: S.current.searchExchangeDescription,
              imageUrl: BAAssets.exchange(),
              onTap: () {
                context.goNamed(BAPaths.exchange.name);
              },
            ),
          ],
        ),
      ),
    );
  }
}
