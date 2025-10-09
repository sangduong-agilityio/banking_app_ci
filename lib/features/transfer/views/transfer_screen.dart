import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/core/widgets/snackbar.dart';
import 'package:banking_app/features/transfer/states/transfer_bloc.dart';
import 'package:banking_app/features/transfer/states/transfer_event.dart';
import 'package:banking_app/features/transfer/states/transfer_state.dart';
import 'package:banking_app/features/transfer/widgets/account_and_card_selection.dart';
import 'package:banking_app/features/transfer/widgets/beneficiary_selection.dart';
import 'package:banking_app/features/transfer/widgets/transaction_selection.dart';
import 'package:banking_app/features/transfer/widgets/transfer_form_section.dart';
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
            builder: (context, state) {
              return GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      _buildAccountOrCardSelector(context, state),
                      const SizedBox(height: 32),
                      const TransactionTypeSelection(),
                      const SizedBox(height: 32),
                      _buildBeneficiarySelection(context, state),
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
  Widget _buildAccountOrCardSelector(
    BuildContext context,
    TransferState state,
  ) {
    return AccountOrCardSelector(
      accounts: state.accounts,
      cards: state.cards,
      selectedAccount: state.selectedAccount,
      selectedCard: state.selectedCard,
      onSelected: (account, card) {
        if (account != null) {
          context.read<TransferBloc>().add(SelectAccountEvt(account));
        } else if (card != null) {
          context.read<TransferBloc>().add(SelectCardEvt(card));
        }
      },
    );
  }

  /// Builds the widget for selecting a beneficiary.
  Widget _buildBeneficiarySelection(BuildContext context, TransferState state) {
    return BeneficiarySelection(
      state: state,
      onBeneficiarySelected: (beneficiary) {
        context.read<TransferBloc>().add(SelectBeneficiaryEvt(beneficiary));
      },
    );
  }
}
