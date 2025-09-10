import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/core/widgets/table.dart';
import 'package:banking_app/features/search/bloc/search_bloc.dart';
import 'package:banking_app/features/search/bloc/search_event.dart';
import 'package:banking_app/features/search/bloc/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExchangeRateScreen extends StatelessWidget {
  const ExchangeRateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<SearchBloc>()..add(ExchangeRateInitializeEvt()),
      child: BAScaffold(
        appBar: BAAppBar(
          title: S.current.searchExchangeRateTitle,
          titleColor: context.colorScheme.scrim,
          alignment: BAAppBarAlignment.left,
          iconColor: context.colorScheme.scrim,
        ),
        body: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            return state.status.maybeWhen(
              loading: () => const Center(child: CircularProgressIndicator()),
              failure: () =>
                  Center(child: Text('', style: context.titleMedium)),
              success: () {
                final rates = state.exchangeRates;
                if (rates == null || rates.isEmpty) {
                  return Center(child: Text('', style: context.titleMedium));
                }
                return BADataTable(
                  columns: [
                    TableColumn(
                      title: S.current.searchCountryTitle,
                      flex: 2,
                      alignment: TextAlign.left,
                    ),
                    TableColumn(
                      title: S.current.searchBuyTitle,
                      flex: 1,
                      alignment: TextAlign.center,
                    ),
                    TableColumn(
                      title: S.current.searchSellTitle,
                      flex: 1,
                      alignment: TextAlign.right,
                    ),
                  ],
                  data: rates,
                  itemBuilder: (context, rate, columns) {
                    return Row(
                      children: [
                        Expanded(
                          flex: columns[0].flex,
                          child: Row(
                            children: [
                              Image.network(
                                rate.flag,
                                width: 40,
                                height: 30,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.flag),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                rate.country,
                                style: context.titleMedium?.copyWith(
                                  color: context.colorScheme.scrim,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Buy
                        Expanded(
                          flex: columns[1].flex,
                          child: Text(
                            rate.buy,
                            textAlign: columns[1].alignment,
                            style: context.titleMedium?.copyWith(
                              color: context.colorScheme.secondary,
                            ),
                          ),
                        ),

                        // Sell
                        Expanded(
                          flex: columns[2].flex,
                          child: Text(
                            rate.sell,
                            textAlign: columns[2].alignment,
                            style: context.titleMedium?.copyWith(
                              color: context.colorScheme.error,
                            ),
                          ),
                        ),
                      ],
                    );
                  },

                  onItemTap: (rate, index) {},
                );
              },
              orElse: () => const SizedBox.shrink(),
            );
          },
        ),
      ),
    );
  }
}
