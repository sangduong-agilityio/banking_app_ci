import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/core/widgets/snackbar.dart';
import 'package:banking_app/features/transfer/bloc/transfer_bloc.dart';
import 'package:banking_app/features/transfer/bloc/transfer_event.dart';
import 'package:banking_app/features/transfer/bloc/transfer_state.dart';
import 'package:banking_app/features/transfer/widgets/account_section.dart';
import 'package:banking_app/features/transfer/widgets/beneficiary_selection.dart';
import 'package:banking_app/features/transfer/widgets/transaction_selection.dart';
import 'package:banking_app/features/transfer/widgets/transfer_form_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

class TransferScreen extends StatefulWidget {
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
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24),
                      // Account Selection
                      AccountSection(accounts: state.accounts),
                      SizedBox(height: 32),
                      // Transaction Type Selection
                      TransactionTypeSelection(state: state),
                      SizedBox(height: 32),
                      // Beneficiary Selection
                      BeneficiarySelection(state: state),
                      SizedBox(height: 32),
                      // Transfer Form Section
                      TransferFormSection(),
                      SizedBox(height: 20),
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
}
