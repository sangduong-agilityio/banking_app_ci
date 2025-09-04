import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/search/models/search_model.dart';
import 'package:flutter/material.dart';

class InterestRateScreen extends StatelessWidget {
  const InterestRateScreen({super.key, required this.rates});

  final List<InterestRate> rates;

  @override
  Widget build(BuildContext context) {
    return BAScaffold(
      appBar: BAAppBar(
        title: S.current.searchInterestRateTitle,
        titleColor: context.colorScheme.scrim,
        alignment: BAAppBarAlignment.left,
        iconColor: context.colorScheme.scrim,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InterestRateHeader(),
          Expanded(
            child: ListView.builder(
              itemCount: rates.length,
              itemBuilder: (context, index) {
                return InterestRateItem(rate: rates[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class InterestRateHeader extends StatelessWidget {
  const InterestRateHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              S.current.searchInterestKindTitle,
              style: context.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colorScheme.inverseSurface,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              S.current.searchDepositTitle,
              style: context.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colorScheme.inverseSurface,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              S.current.searchRateTitle,
              textAlign: TextAlign.right,
              style: context.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colorScheme.inverseSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InterestRateItem extends StatelessWidget {
  const InterestRateItem({super.key, required this.rate});

  final InterestRate rate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  rate.type,
                  style: context.titleMedium?.copyWith(
                    color: context.colorScheme.scrim,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  rate.period,
                  textAlign: TextAlign.center,
                  style: context.titleMedium?.copyWith(
                    color: context.colorScheme.scrim,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  rate.rate,
                  textAlign: TextAlign.right,
                  style: context.titleMedium?.copyWith(
                    color: context.colorScheme.secondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 0.5,
          thickness: 0.5,
          indent: 20,
          endIndent: 20,
          color: Colors.grey[300],
        ),
      ],
    );
  }
}
