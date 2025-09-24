import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/features/transfer/models/bank_model.dart';
import 'package:banking_app/features/transfer/models/beneficiary_model.dart';
import 'package:banking_app/features/transfer/states/transfer_bloc.dart';
import 'package:banking_app/features/transfer/states/transfer_event.dart';
import 'package:banking_app/features/transfer/states/transfer_state.dart';
import 'package:banking_app/features/transfer/views/add_new_benificiary_screen.dart';
import 'package:banking_app/features/transfer/views/directory_beneficiary_screen.dart';
import 'package:banking_app/features/transfer/widgets/beneficiary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BeneficiarySelection extends StatelessWidget {
  final TransferState state;
  final Function(String)? onNameChanged;
  final Function(String)? onCardNumberChanged;

  const BeneficiarySelection({
    super.key,
    required this.state,
    this.onNameChanged,
    this.onCardNumberChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BeneficiarySelectionHeader(banks: state.banks),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: state.beneficiaries.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              if (index == 0) {
                return _AddBeneficiaryCard(banks: state.banks);
              }
              final beneficiary = state.beneficiaries[index - 1];
              final isSelected =
                  state.selectedBeneficiary?.id == beneficiary.id;
              return _BeneficiaryCardItem(
                beneficiary: beneficiary,
                isSelected: isSelected,
                onNameChanged: onNameChanged,
                onCardNumberChanged: onCardNumberChanged,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _BeneficiarySelectionHeader extends StatelessWidget {
  final List<BankModel> banks;

  const _BeneficiarySelectionHeader({required this.banks});

  @override
  Widget build(BuildContext context) {
    return Row(
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
                builder: (_) => BlocProvider.value(
                  value: context.read<TransferBloc>(),
                  child: DirectoryBeneficiaryScreen(banks: banks),
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
    );
  }
}

class _AddBeneficiaryCard extends StatelessWidget {
  final List<BankModel> banks;

  const _AddBeneficiaryCard({required this.banks});

  @override
  Widget build(BuildContext context) {
    return BeneficiaryCard(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<TransferBloc>(),
              child: AddNewBeneficiaryScreen(
                banks: banks,
                onBeneficiaryAdded: (b) {
                  context.read<TransferBloc>().add(AddNewBeneficiaryEvt(b));
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        );
      },
      child: Center(
        child: CircleAvatar(
          radius: 28,
          backgroundColor: context.colorScheme.outlineVariant,
          child: Icon(Icons.add, color: context.colorScheme.onPrimary),
        ),
      ),
    );
  }
}

class _BeneficiaryCardItem extends StatelessWidget {
  final BeneficiaryModel beneficiary;
  final bool isSelected;
  final Function(String)? onNameChanged;
  final Function(String)? onCardNumberChanged;

  const _BeneficiaryCardItem({
    required this.beneficiary,
    required this.isSelected,
    this.onNameChanged,
    this.onCardNumberChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BeneficiaryCard(
      isSelected: isSelected,
      onTap: () {
        context.read<TransferBloc>().add(SelectBeneficiaryEvt(beneficiary));
        onNameChanged?.call(beneficiary.name);
        onCardNumberChanged?.call(beneficiary.accountNumber);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BeneficiaryAvatar(avatarUrl: beneficiary.avatarUrl),
          const SizedBox(height: 8),
          Text(
            beneficiary.name,
            style: context.bodyMedium?.copyWith(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? context.colorScheme.onPrimary
                  : context.colorScheme.scrim,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class BeneficiaryAvatar extends StatelessWidget {
  final String? avatarUrl;

  const BeneficiaryAvatar({super.key, this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 30,
      backgroundImage: (avatarUrl?.isNotEmpty ?? false)
          ? NetworkImage(avatarUrl ?? '')
          : null,
      child: (avatarUrl?.isEmpty ?? true)
          ? Icon(Icons.person, color: context.colorScheme.onPrimary)
          : null,
    );
  }
}
