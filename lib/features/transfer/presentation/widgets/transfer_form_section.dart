import 'package:banking_app/core/common/utils/currency_input_formatter.dart';
import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/common/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/common/utils/currency.dart';
import 'package:banking_app/core/security/input_validator.dart';
import 'package:banking_app/core/widgets/button.dart';
import 'package:banking_app/core/widgets/dialog.dart';
import 'package:banking_app/core/widgets/forms/text_field.dart';
import 'package:banking_app/features/transactions/data/models/transaction_model.dart';
import 'package:banking_app/features/transfer/data/models/bank_model.dart';
import 'package:banking_app/features/transfer/data/models/beneficiary_model.dart';
import 'package:banking_app/features/transfer/data/models/branch_model.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_bloc.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_event.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_state.dart';
import 'package:banking_app/features/transfer/presentation/views/confirm_transfer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A widget that displays the form for a transfer.
///
/// This widget is a stateful widget that manages the form controllers and the
/// logic for filling and clearing the form. It also builds the form fields
/// based on the selected transfer type.
class TransferFormSection extends StatefulWidget {
  const TransferFormSection({super.key});

  @override
  State<TransferFormSection> createState() => _TransferFormSectionState();
}

class _TransferFormSectionState extends State<TransferFormSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _amountController = TextEditingController();
  final _contentController = TextEditingController();
  final _bankController = TextEditingController();
  final _branchController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _cardNumberController.dispose();
    _amountController.dispose();
    _contentController.dispose();
    _bankController.dispose();
    _branchController.dispose();
    super.dispose();
  }

  /// Fills the form with the data from the selected beneficiary.
  void _fillFromBeneficiary(BeneficiaryModel beneficiary, TransferState state) {
    _nameController.text = beneficiary.name;
    _cardNumberController.text = beneficiary.accountNumber;
  }

  /// Clears the form fields.
  void _clearForm() {
    _nameController.clear();
    _cardNumberController.clear();
    _amountController.clear();
    _contentController.clear();
    _bankController.clear();
    _branchController.clear();
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransferBloc, TransferState>(
      listenWhen: (prev, curr) =>
          prev.selectedBeneficiary != curr.selectedBeneficiary,
      listener: (context, state) {
        if (state.selectedBeneficiary != null) {
          _fillFromBeneficiary(state.selectedBeneficiary!, state);
          if (state.selectedBank != null) {
            _bankController.text = state.selectedBank?.name ?? '';
          }
          if (state.selectedBranch != null) {
            _branchController.text = state.selectedBranch?.name ?? '';
          }
        } else {
          _clearForm();
        }
      },
      buildWhen: (prev, curr) =>
          prev.selectedTransferType != curr.selectedTransferType ||
          prev.selectedAccount != curr.selectedAccount ||
          prev.selectedBank != curr.selectedBank ||
          prev.selectedBranch != curr.selectedBranch ||
          prev.saveToDirectory != curr.saveToDirectory ||
          prev.amount != curr.amount,
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: context.colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ..._buildTransferForm(state),
                _buildSaveToDirectory(state),
                const SizedBox(height: 22),
                BAElevatedButton(
                  isDisabled: !state.canConfirmTransfer,
                  padding: EdgeInsets.zero,
                  text: S.current.transferConfirmButton,
                  onPressed: state.canConfirmTransfer
                      ? () => _handleConfirm(context, state)
                      : null,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Builds the widget for the "Save to directory" checkbox.
  Widget _buildSaveToDirectory(TransferState state) {
    return Row(
      children: [
        Checkbox(
          value: state.saveToDirectory,
          onChanged: (value) {
            context.read<TransferBloc>().add(
              UpdateTransferDetailsEvt(saveToDirectory: value ?? false),
            );
          },
          activeColor: context.colorScheme.secondary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        Expanded(
          child: Text(
            S.current.transferSaveBeneficiaryTitle,
            style: context.titleSmall,
          ),
        ),
      ],
    );
  }

  /// Builds the transfer form based on the selected transfer type.
  List<Widget> _buildTransferForm(TransferState state) {
    switch (state.selectedTransferType) {
      case TransferType.cardNumber:
      case TransferType.sameBank:
        return [
          _buildBankOrCardForm(),
          const SizedBox(height: 24),
          ..._buildAmountAndContentForm(state),
        ];
      case TransferType.otherBank:
        return [
          _buildOtherBankForm(state),
          const SizedBox(height: 24),
          _buildBankOrCardForm(),
          const SizedBox(height: 24),
          ..._buildAmountAndContentForm(state),
        ];
    }
  }

  /// Builds the form for selecting a bank and a branch for transfers to other banks.
  Widget _buildOtherBankForm(TransferState state) {
    final isBeneficiarySelected = state.selectedBeneficiary != null;
    return Column(
      children: [
        GestureDetector(
          onTap: isBeneficiarySelected
              ? null
              : () => _showBankSelector(state.banks, state.selectedBank),
          child: AbsorbPointer(
            absorbing: isBeneficiarySelected,
            child: BATextField(
              name: S.current.transferChooseBankLabel,
              hint: S.current.transferChooseBankLabel,
              controller: _bankController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              suffixIcon: const Icon(Icons.keyboard_arrow_right, size: 20),
              validator: (value) => SecureInputValidator.validateSecureInput(
                value,
                fieldName: S.current.transferChooseBankLabel,
                minLength: 1,
                maxLength: 50,
                allowSpecialChars: false,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: isBeneficiarySelected || state.selectedBank == null
              ? null
              : () {
                  final filteredBranches = state.branches
                      .where((b) => b.bankId == state.selectedBank?.id)
                      .toList();
                  _showBranchSelector(filteredBranches, state.selectedBranch);
                },
          child: AbsorbPointer(
            absorbing: isBeneficiarySelected,
            child: BATextField(
              name: S.current.transferChooseBranchLabel,
              hint: S.current.transferChooseBranchLabel,
              controller: _branchController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              suffixIcon: const Icon(Icons.keyboard_arrow_right),
              validator: (value) => SecureInputValidator.validateSecureInput(
                value,
                fieldName: S.current.transferChooseBranchLabel,
                minLength: 1,
                maxLength: 50,
                allowSpecialChars: false,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the form for the beneficiary's name and card number.
  Widget _buildBankOrCardForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BATextField(
          name: S.current.transferNameLabel,
          hint: S.current.transferNameLabel,
          controller: _nameController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) => SecureInputValidator.validateSecureInput(
            value,
            fieldName: S.current.transferNameLabel,
            minLength: 2,
            maxLength: 50,
            allowSpecialChars: false,
          ),
          onChanged: (value) => context.read<TransferBloc>().add(
            UpdateTransferDetailsEvt(name: value),
          ),
        ),
        const SizedBox(height: 24),
        BATextField(
          name: S.current.transferCardNumberLabel,
          hint: S.current.transferCardNumberLabel,
          controller: _cardNumberController,
          keyboardType: TextInputType.number,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(16),
          ],
          validator: SecureInputValidator.validateAccountNumber,
          onChanged: (value) => context.read<TransferBloc>().add(
            UpdateTransferDetailsEvt(cardNumber: value),
          ),
        ),
      ],
    );
  }

  /// Builds the form for the amount and content of the transfer.
  List<Widget> _buildAmountAndContentForm(TransferState state) {
    return [
      BATextField(
        name: S.current.transferAmountLabel,
        hint: S.current.transferAmountLabel,
        controller: _amountController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          CurrencyInputFormatter(
            locale: 'en_US',
            symbol: state.selectedCard?.currency == 'VND' ? '' : 'USD',
          ),
        ],
        validator: (v) {
          final double? maxBalance;
          if (state.selectedAccount != null) {
            maxBalance = state.selectedAccount?.availableBalance;
          } else if (state.selectedCard != null) {
            maxBalance = state.selectedCard!.availableBalance;
          } else {
            maxBalance = 0;
          }

          return SecureInputValidator.validateTransferAmount(
            v,
            maxBalance: maxBalance,
            transactionLimit: state.transactionLimit,
          );
        },
        onChanged: (v) {
          final amount = double.tryParse(
            v?.replaceAll(RegExp(r'[^\d\.]'), '') ?? '',
          );
          if (amount != null) {
            context.read<TransferBloc>().add(
              UpdateTransferDetailsEvt(
                amount: CurrencyUtils.roundTo2Decimal(amount),
              ),
            );
          }
        },
      ),

      const SizedBox(height: 24),
      BATextField(
        name: S.current.transferContentLabel,
        hint: S.current.transferContentLabel,
        controller: _contentController,
        textInputAction: TextInputAction.done,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => SecureInputValidator.validateSecureInput(
          value,
          fieldName: S.current.transferContentLabel,
          minLength: 3,
          maxLength: 100,
          allowSpecialChars: true,
        ),
        onChanged: (value) => context.read<TransferBloc>().add(
          UpdateTransferDetailsEvt(content: value),
        ),
      ),
      if (state.amount != null && state.amount! > 0)
        Padding(
          padding: const EdgeInsets.only(left: 14, top: 8),
          child: Text(
            CurrencyUtils.convertAmountToWords(state.amount!.toString()),
            style: context.bodySmall?.copyWith(
              color: context.colorScheme.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
    ];
  }

  /// Shows a dialog for selecting a bank.
  void _showBankSelector(List<BankModel> banks, BankModel? selectedBank) {
    showDialog(
      context: context,
      builder: (_) => BASelectorDialog<BankModel>(
        title: S.current.transferSelectBeneficiary,
        items: banks,
        selectedValue: selectedBank?.id ?? '',
        value: (b) => b.id,
        label: (b) => b.name,
        onSelected: (bank) {
          _bankController.text = bank.name;
          _branchController.clear();
          context.read<TransferBloc>().add(SelectBankEvt(bank));
          Navigator.pop(context);
        },
      ),
    );
  }

  /// Shows a dialog for selecting a branch.
  void _showBranchSelector(
    List<BranchModel> branches,
    BranchModel? selectedBranch,
  ) {
    showDialog(
      context: context,
      builder: (_) => BASelectorDialog<BranchModel>(
        title: S.current.transferChooseBranchLabel,
        items: branches,
        selectedValue: selectedBranch?.id ?? '',
        value: (b) => b.id,
        label: (b) => b.name,
        onSelected: (branch) {
          _branchController.text = branch.name;
          context.read<TransferBloc>().add(SelectBranchEvt(branch));
          Navigator.pop(context);
        },
      ),
    );
  }

  /// Handles the confirmation of the transfer.
  void _handleConfirm(BuildContext context, TransferState state) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<TransferBloc>().add(ConfirmTransferEvt());

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<TransferBloc>(),
          child: const ConfirmTransferScreen(),
        ),
      ),
    );
  }
}
