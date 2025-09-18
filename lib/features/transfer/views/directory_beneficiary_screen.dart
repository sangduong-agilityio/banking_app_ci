import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/widgets/forms/text_field.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/core/widgets/snackbar.dart';
import 'package:banking_app/features/transfer/states/transfer_bloc.dart';
import 'package:banking_app/features/transfer/states/transfer_event.dart';
import 'package:banking_app/features/transfer/states/transfer_state.dart';
import 'package:banking_app/features/transfer/models/transfer_model.dart';
import 'package:banking_app/features/transfer/views/add_new_benificiary_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

class DirectoryBeneficiaryScreen extends StatelessWidget {
  final List<Beneficiary> beneficiaries;
  final List<Bank> banks;
  final Function(Beneficiary) onBeneficiarySelected;

  const DirectoryBeneficiaryScreen({
    super.key,
    required this.beneficiaries,
    required this.banks,
    required this.onBeneficiarySelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<TransferBloc>()
        ..add(
          BeneficiariesInitializeEvt(
            beneficiaries: beneficiaries,
            banks: banks,
          ),
        ),
      child: LoaderOverlay(
        child: BAScaffold(
          appBar: BAAppBar(
            title: "Beneficiary",
            alignment: BAAppBarAlignment.left,
            titleColor: context.colorScheme.scrim,
            iconColor: context.colorScheme.scrim,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: IconButton(
                  onPressed: () => _buildSearchField(context),
                  icon: const Icon(Icons.search),
                  color: context.colorScheme.scrim,
                ),
              ),
            ],
          ),
          body: BlocListener<TransferBloc, TransferState>(
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
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Expanded(
                    child: BlocBuilder<TransferBloc, TransferState>(
                      builder: (context, state) {
                        final viaCard = state.filteredBeneficiaries
                            .take(2)
                            .toList();
                        final sameBank = state.filteredBeneficiaries
                            .where((b) => b.bank?.id == banks.first.id)
                            .toList();
                        final diffBank = state.filteredBeneficiaries
                            .where((b) => b.bank?.id != banks.first.id)
                            .toList();

                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _listTransferSection(
                                context,
                                "Transfer via card number",
                                viaCard,
                              ),
                              const SizedBox(height: 24),
                              _listTransferSection(
                                context,
                                "Transfer to the same bank",
                                sameBank,
                              ),
                              const SizedBox(height: 24),
                              _listTransferSection(
                                context,
                                "Transfer to another bank",
                                diffBank,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddNewBeneficiaryScreen(
                    banks: banks,
                    onBeneficiaryAdded: (b) {
                      onBeneficiarySelected(b);
                      Navigator.pop(context);
                    },
                  ),
                ),
              );
            },
            shape: const CircleBorder(),
            backgroundColor: context.colorScheme.secondary,
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return BATextField(
      hint: 'Search by name or card number',
      onChanged: (query) {
        context.read<TransferBloc>().add(SearchBeneficiaryEvt(query ?? ''));
      },
    );
  }

  Widget _listTransferSection(
    BuildContext context,
    String title,
    List<Beneficiary> beneficiaries,
  ) {
    if (beneficiaries.isEmpty) return const SizedBox.shrink();

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
                color: Colors.black.withOpacity(0.08),
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
                      onBeneficiarySelected(b);
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
  final Beneficiary beneficiary;
  final void Function(Beneficiary) onTap;
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
          leading: CircleAvatar(
            radius: 24,
            backgroundImage: beneficiary.avatarUrl != null
                ? NetworkImage(beneficiary.avatarUrl ?? '')
                : null,
          ),
          title: Text(
            beneficiary.name,
            style: context.titleMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                beneficiary.accountNumber,
                style: context.bodySmall?.copyWith(
                  color: context.colorScheme.inverseSurface,
                ),
              ),
              if (beneficiary.bank != null)
                Text(
                  beneficiary.bank?.name ?? '',
                  style: context.bodySmall?.copyWith(
                    color: context.colorScheme.inverseSurface,
                  ),
                ),
            ],
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
