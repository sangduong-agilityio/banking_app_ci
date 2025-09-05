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

class InterestRateScreen extends StatelessWidget {
  const InterestRateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<SearchBloc>()..add(InterestRateInitializeEvt()),
      child: BAScaffold(
        appBar: BAAppBar(
          title: S.current.searchInterestRateTitle,
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
                final rates = state.interestRates;
                if (rates == null || rates.isEmpty) {
                  return Center(child: Text('', style: context.titleMedium));
                }
                return BADataTable(
                  columns: [
                    TableColumn(
                      title: S.current.searchInterestKindTitle,
                      flex: 3,
                      alignment: TextAlign.left,
                    ),
                    TableColumn(
                      title: S.current.searchDepositTitle,
                      flex: 1,
                      alignment: TextAlign.center,
                    ),
                    TableColumn(
                      title: S.current.searchRateTitle,
                      flex: 1,
                      alignment: TextAlign.right,
                    ),
                  ],
                  data: rates,
                  itemBuilder: (context, rate, columns) {
                    return BATableRow(
                      values: [rate.type, rate.period, rate.rate],
                      columns: columns,
                      valueStyles: [
                        context.titleMedium?.copyWith(
                          color: context.colorScheme.scrim,
                        ),
                        context.titleMedium?.copyWith(
                          color: context.colorScheme.scrim,
                        ),
                        context.titleMedium?.copyWith(
                          color: context.colorScheme.secondary,
                        ),
                      ],
                    );
                  },
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
