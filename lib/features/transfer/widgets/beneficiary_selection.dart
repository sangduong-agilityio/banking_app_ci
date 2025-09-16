import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/dialog.dart';
import 'package:banking_app/features/transfer/states/transfer_bloc.dart';
import 'package:banking_app/features/transfer/states/transfer_event.dart';
import 'package:banking_app/features/transfer/states/transfer_state.dart';
import 'package:banking_app/features/transfer/models/transfer_model.dart';
import 'package:banking_app/features/transfer/views/directory_beneficiary_screen.dart';
import 'package:banking_app/features/transfer/widgets/beneficiary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BeneficiarySelection extends StatelessWidget {
  final TransferState state;

  const BeneficiarySelection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.current.transferChooseBeneficiaryTitle,
              style: context.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colorScheme.inverseSurface,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DirectoryBeneficiaryScreen(
                      beneficiaries: state.beneficiaries,
                      banks: state.banks,
                      onBeneficiarySelected: (value) {
                        context.read<TransferBloc>().add(
                          SelectBeneficiaryEvt(value),
                        );
                      },
                    ),
                  ),
                );
              },
              child: Text(
                S.current.transferFindBeneficiaryTitle,
                style: context.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.colorScheme.secondary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: state.beneficiaries.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildAddCard(context, context.colorScheme);
              }
              final beneficiary = state.beneficiaries[index - 1];
              final isSelected =
                  state.selectedBeneficiary?.id == beneficiary.id;
              return _buildBeneficiaryCard(context, beneficiary, isSelected);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddCard(BuildContext context, ColorScheme colorScheme) {
    return BeneficiaryCard(
      onTap: () => _showBeneficiarySelector(
        context,
        state.banks,
        state.selectedBeneficiary?.bank,
      ),
      child: Center(
        child: CircleAvatar(
          radius: 28,
          backgroundColor: colorScheme.outlineVariant,
          child: Icon(Icons.add, color: colorScheme.onPrimary),
        ),
      ),
    );
  }

  Widget _buildBeneficiaryCard(
    BuildContext context,
    Beneficiary beneficiary,
    bool isSelected,
  ) {
    return BeneficiaryCard(
      isSelected: isSelected,
      onTap: () {
        context.read<TransferBloc>().add(SelectBeneficiaryEvt(beneficiary));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: beneficiary.avatarUrl != null
                ? NetworkImage(beneficiary.avatarUrl!)
                : null,
            backgroundColor: isSelected
                ? context.colorScheme.secondary
                : context.colorScheme.outlineVariant,
            child: beneficiary.avatarUrl == null
                ? Text(
                    beneficiary.name.isNotEmpty
                        ? beneficiary.name[0].toUpperCase()
                        : '',
                    style: TextStyle(
                      color: isSelected
                          ? context.colorScheme.onPrimary
                          : context.colorScheme.scrim,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            beneficiary.name,
            style: context.bodyMedium?.copyWith(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? context.colorScheme.secondary
                  : context.colorScheme.scrim,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showBeneficiarySelector(
    BuildContext context,
    List<Bank> banks,
    Bank? selectedBank,
  ) {
    showDialog(
      context: context,
      builder: (_) => BASelectorDialog<Bank>(
        title: S.current.transferSelectBeneficiary,
        items: banks,
        selectedValue: selectedBank != null ? selectedBank.id : '',
        value: (b) => b.id,
        label: (b) => "${b.name} ",
        onSelected: (id) {},
      ),
    );
  }
}
