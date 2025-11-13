import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/core/common/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/core/widgets/snackbar.dart';
import 'package:banking_app/features/home/data/models/account_model.dart';
import 'package:banking_app/features/home/data/models/card_model.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_bloc.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_event.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_state.dart';
import 'package:banking_app/features/transfer/presentation/widgets/account_and_card_selection.dart';
import 'package:banking_app/features/transfer/presentation/widgets/beneficiary_selection.dart';
import 'package:banking_app/features/transfer/presentation/widgets/transaction_selection.dart';
import 'package:banking_app/features/transfer/presentation/widgets/transfer_form_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

/// The main screen for the transfer feature.
///
/// This screen allows the user to select an account or a card to transfer from,
/// select a beneficiary, and fill in the transfer details.
class TransferScreen extends StatefulWidget {
  /// Creates a [TransferScreen] object.
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          locator<TransferBloc>()..add(TransferInitializeEvt()),
      child: LoaderOverlay(
        child: BAScaffold(
          appBar: BAAppBar(
            title: S.current.transferTitle,
            titleColor: context.colorScheme.scrim,
            alignment: BAAppBarAlignment.left,
            iconColor: context.colorScheme.scrim,
          ),
          body: BlocConsumer<TransferBloc, TransferState>(
            listenWhen: (previous, current) => previous.status != current.status,
            listener: (context, state) {
              state.status.maybeWhen(
                loading: () => context.loaderOverlay.show(),
                success: () {
                  if (context.mounted) context.loaderOverlay.hide();
                },
                failure: () {
                  context.loaderOverlay.hide();
                  BASnackBar.buildErrorSnackbar(
                    context,
                    state.errorMessage ?? '',
                  );
                },
                orElse: () => context.loaderOverlay.hide(),
              );
            },
            buildWhen: (previous, current) =>
                previous.accounts != current.accounts ||
                previous.cards != current.cards,
            builder: (context, state) {
              return GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      _buildAccountOrCardSelector(context),
                      const SizedBox(height: 32),
                      const TransactionTypeSelection(),
                      const SizedBox(height: 32),
                      const _BeneficiarySelectionWrapper(),
                      const SizedBox(height: 32),
                      const TransferFormSection(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// Builds the widget for selecting an account or a card.
  Widget _buildAccountOrCardSelector(BuildContext context) {
    return BlocSelector<TransferBloc, TransferState,
        (List<AccountModel>, List<CardModel>, AccountModel?, CardModel?)>(
      selector: (state) => (
        state.accounts,
        state.cards,
        state.selectedAccount,
        state.selectedCard,
      ),
      builder: (context, data) {
        final (accounts, cards, selectedAccount, selectedCard) = data;
        return AccountOrCardSelector(
          accounts: accounts,
          cards: cards,
          selectedAccount: selectedAccount,
          selectedCard: selectedCard,
          onSelected: (account, card) {
            if (account != null) {
              context.read<TransferBloc>().add(SelectAccountEvt(account));
            } else if (card != null) {
              context.read<TransferBloc>().add(SelectCardEvt(card));
            }
          },
        );
      },
    );
  }
}

/// Wrapper for beneficiary selection with BlocSelector
class _BeneficiarySelectionWrapper extends StatelessWidget {
  const _BeneficiarySelectionWrapper();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<TransferBloc, TransferState, TransferState>(
      selector: (state) => state,
      builder: (context, state) {
        return BeneficiarySelection(
          state: state,
          onBeneficiarySelected: (beneficiary) {
            context.read<TransferBloc>().add(SelectBeneficiaryEvt(beneficiary));
          },
        );
      },
    );
  }
}
