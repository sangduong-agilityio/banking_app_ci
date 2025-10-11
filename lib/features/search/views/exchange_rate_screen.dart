import 'dart:async';
import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/utils/formatters.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/core/widgets/snackbar.dart';
import 'package:banking_app/core/widgets/table.dart';
import 'package:banking_app/features/search/blocs/search_bloc.dart';
import 'package:banking_app/features/search/blocs/search_event.dart';
import 'package:banking_app/features/search/blocs/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ExchangeRateScreen extends StatelessWidget {
  const ExchangeRateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<SearchBloc>()..add(ExchangeRateInitializeEvt()),
      child: LoaderOverlay(
        child: BAScaffold(
          appBar: BAAppBar(
            title: S.current.searchExchangeRateTitle,
            titleColor: context.colorScheme.scrim,
            alignment: BAAppBarAlignment.left,
            iconColor: context.colorScheme.scrim,
            actions: [
              BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  return IconButton(
                    icon: Icon(Icons.refresh, color: context.colorScheme.scrim),
                    onPressed: () {
                      context.read<SearchBloc>().add(
                        const ExchangeRateRefreshEvt(forceRefresh: true),
                      );
                    },
                  );
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              context.read<SearchBloc>().add(
                const ExchangeRateRefreshEvt(forceRefresh: true),
              );
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: BlocConsumer<SearchBloc, SearchState>(
              listener: (context, state) {
                state.status.maybeWhen(
                  loading: () => context.loaderOverlay.show(),
                  success: () {
                    if (context.mounted) context.loaderOverlay.hide();
                  },
                  failure: () {
                    context.loaderOverlay.hide();
                    BASnackBar.buildErrorSnackbar(context, '');
                  },
                  orElse: () => context.loaderOverlay.hide(),
                );
              },
              builder: (context, state) {
                final rates = state.exchangeRates ?? [];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (state.lastUpdated != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        color: state.isFromCache
                            ? context.colorScheme.onErrorContainer
                            : context.colorScheme.surfaceTint,
                        child: Row(
                          children: [
                            Icon(
                              state.isFromCache
                                  ? Icons.offline_bolt
                                  : Icons.cloud_done,
                              size: 16,
                              color: context.colorScheme.onPrimary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              state.isFromCache
                                  ? S.current.searchCachedDataTitle(
                                      FormatterUtils.formatLastUpdated(
                                        state.lastUpdated ?? DateTime.now(),
                                      ),
                                    )
                                  : S.current.searchFreshDataTitle(
                                      FormatterUtils.formatLastUpdated(
                                        state.lastUpdated ?? DateTime.now(),
                                      ),
                                    ),
                              style: context.bodySmall?.copyWith(
                                color: context.colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: BADataTable(
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
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
