import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/assets.dart';
import 'package:banking_app/core/widgets/card.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/search/models/search_model.dart';
import 'package:banking_app/features/search/views/exchange_rate_screen.dart';
import 'package:banking_app/features/search/views/exchange_screen.dart';
import 'package:banking_app/features/search/views/interest_rate_screen.dart';
import 'package:flutter/material.dart';

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
      body: Column(
        children: [
          CardCategorySelected(
            category: S.current.searchBranchSelectedTitle,
            categoryName: S.current.searchBranchDescription,
            imageUrl: BAAssets.branch(),
            onTap: () {},
          ),
          CardCategorySelected(
            category: S.current.searchInterestRateTitle,
            categoryName: S.current.searchInterestRateDescription,
            imageUrl: BAAssets.interest(),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InterestRateScreen(
                    rates: [
                      InterestRate(
                        type: "Individual customers",
                        period: "1m",
                        rate: "4.50%",
                      ),
                      InterestRate(
                        type: "Individual customers",
                        period: "2m",
                        rate: "4.75%",
                      ),
                      InterestRate(
                        type: "Individual customers",
                        period: "12m",
                        rate: "5.00%",
                      ),
                      InterestRate(
                        type: "Corporate customers",
                        period: "1m",
                        rate: "3.50%",
                      ),
                      InterestRate(
                        type: "Corporate customers",
                        period: "2m",
                        rate: "3.75%",
                      ),
                      InterestRate(
                        type: "Corporate customers",
                        period: "12m",
                        rate: "4.00%",
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          CardCategorySelected(
            category: S.current.searchExchangeRateTitle,
            categoryName: S.current.searchExchangeRateDescription,
            imageUrl: BAAssets.exchangeRate(),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExchangeRateScreen()),
              );
            },
          ),
          CardCategorySelected(
            category: S.current.searchExchangeTitle,
            categoryName: S.current.searchExchangeDescription,
            imageUrl: BAAssets.exchange(),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExchangeScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
