import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/core/common/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/core/widgets/snackbar.dart';
import 'package:banking_app/core/widgets/table.dart';
import 'package:banking_app/features/search/presentation/blocs/search_bloc.dart';
import 'package:banking_app/features/search/presentation/blocs/search_event.dart';
import 'package:banking_app/features/search/presentation/blocs/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

/// A screen that displays a list of interest rates.
///
/// This screen fetches and displays a list of interest rates in a table format.
class InterestRateScreen extends StatelessWidget {
  const InterestRateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<SearchBloc>()..add(InterestRateInitializeEvt()),
      child: LoaderOverlay(
        child: BAScaffold(
          appBar: BAAppBar(
            title: S.current.searchInterestRateTitle,
            titleColor: context.colorScheme.scrim,
            alignment: BAAppBarAlignment.left,
            iconColor: context.colorScheme.scrim,
          ),
          body: BlocConsumer<SearchBloc, SearchState>(
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
              final interestRates = state.interestRates;

              // Display the interest rates in a data table.
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
                data: interestRates ?? [],
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
          ),
        ),
      ),
    );
  }
}
