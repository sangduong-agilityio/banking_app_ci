import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/common/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/assets.dart';
import 'package:banking_app/core/widgets/dialog.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/transfer/data/models/bank_model.dart';
import 'package:banking_app/features/transfer/data/models/beneficiary_model.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_bloc.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_event.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_state.dart';
import 'package:banking_app/features/transfer/presentation/views/add_new_benificiary_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

/// A screen that displays a directory of beneficiaries.
///
/// The screen allows users to view, search, and select beneficiaries for transfers.
class DirectoryBeneficiaryScreen extends StatelessWidget {
  final List<BankModel> banks;

  const DirectoryBeneficiaryScreen({super.key, required this.banks});

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: BAScaffold(
        appBar: BAAppBar(
          title: S.current.transferBeneficiaryTitle,
          alignment: BAAppBarAlignment.left,
          titleColor: context.colorScheme.scrim,
          iconColor: context.colorScheme.scrim,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: IconButton(
                onPressed: () {
                  final state = context.read<TransferBloc>().state;
                  _showBeneficiarySelector(context, state.selectedBeneficiary, (
                    b,
                  ) {
                    context.read<TransferBloc>().add(SelectBeneficiaryEvt(b));
                    Navigator.pop(context);
                  });
                },
                icon: const Icon(Icons.search),
                color: context.colorScheme.scrim,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: BlocBuilder<TransferBloc, TransferState>(
            buildWhen: (previous, current) =>
                previous.selectedAccount != current.selectedAccount ||
                previous.viaCardBeneficiaries != current.viaCardBeneficiaries ||
                previous.sameBankBeneficiaries !=
                    current.sameBankBeneficiaries ||
                previous.otherBankBeneficiaries !=
                    current.otherBankBeneficiaries,
            builder: (context, state) {
              final userAccount = state.selectedAccount;
              if (userAccount == null) {
                return Center(child: BAAssets.empty(width: 300, height: 300));
              }

              final viaCard = state.viaCardBeneficiaries;
              final sameBank = state.sameBankBeneficiaries;
              final diffBank = state.otherBankBeneficiaries;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (viaCard.isNotEmpty)
                      _listTransferSection(
                        context,
                        S.current.transferViaCardNumberTitle,
                        viaCard,
                      ),
                    if (sameBank.isNotEmpty) const SizedBox(height: 24),
                    if (sameBank.isNotEmpty)
                      _listTransferSection(
                        context,
                        S.current.transferSameBankTitle,
                        sameBank,
                      ),
                    if (diffBank.isNotEmpty) const SizedBox(height: 24),
                    if (diffBank.isNotEmpty)
                      _listTransferSection(
                        context,
                        S.current.transferAnotherBankTitle,
                        diffBank,
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<TransferBloc>(),
                  child: AddNewBeneficiaryScreen(
                    banks: banks,
                    onBeneficiaryAdded: (b) {
                      context.read<TransferBloc>().add(AddNewBeneficiaryEvt(b));
                    },
                  ),
                ),
              ),
            );
          },
          shape: const CircleBorder(),
          backgroundColor: context.colorScheme.secondary,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showBeneficiarySelector(
    BuildContext context,
    BeneficiaryModel? selectedBeneficiary,
    void Function(BeneficiaryModel) onSelected,
  ) {
    final transferBloc = context.read<TransferBloc>();

    showDialog(
      context: context,
      builder: (_) => BlocBuilder<TransferBloc, TransferState>(
        bloc: transferBloc,
        buildWhen: (previous, current) =>
            previous.filteredBeneficiaries != current.filteredBeneficiaries ||
            previous.beneficiaries != current.beneficiaries,
        builder: (context, state) {
          final items = state.filteredBeneficiaries.isNotEmpty
              ? state.filteredBeneficiaries
              : state.beneficiaries;

          return BASelectorDialog<BeneficiaryModel>(
            title: S.current.transferSelectBeneficiary,
            items: items,
            selectedValue: selectedBeneficiary?.id,
            value: (b) => b.id ?? '',
            label: (b) => '${b.name} • ${b.accountNumber}',
            onSelected: (b) {
              onSelected(b);
              Navigator.of(context, rootNavigator: true).pop();
            },
            onSearchChanged: (query) {
              transferBloc.add(SearchBeneficiaryEvt(query));
            },
          );
        },
      ),
    );
  }

  Widget _listTransferSection(
    BuildContext context,
    String title,
    List<BeneficiaryModel> beneficiaries,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.bodySmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: context.colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: beneficiaries
                .asMap()
                .entries
                .map(
                  (e) => BeneficiaryTile(
                    beneficiary: e.value,
                    onTap: (b) {
                      context.read<TransferBloc>().add(SelectBeneficiaryEvt(b));
                      Navigator.pop(context);
                    },
                    showDivider: e.key < beneficiaries.length - 1,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class BeneficiaryTile extends StatelessWidget {
  final BeneficiaryModel beneficiary;
  final void Function(BeneficiaryModel) onTap;
  final bool showDivider;

  const BeneficiaryTile({
    super.key,
    required this.beneficiary,
    required this.onTap,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: BAProfileImage(
            url: beneficiary.avatarUrl,
            size: 60,
            backgroundColor: context.colorScheme.outlineVariant,
            iconColor: context.colorScheme.onPrimary,
          ),
          title: Text(
            beneficiary.name,
            style: context.titleMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            beneficiary.accountNumber,
            style: context.bodySmall?.copyWith(
              color: context.colorScheme.inverseSurface,
            ),
          ),
          onTap: () => onTap(beneficiary),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(height: 1, color: context.colorScheme.outline),
          ),
      ],
    );
  }
}
