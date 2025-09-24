import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/utils/currency.dart';
import 'package:banking_app/core/utils/validators.dart';
import 'package:banking_app/core/widgets/button.dart';
import 'package:banking_app/core/widgets/dialog.dart';
import 'package:banking_app/core/widgets/forms/text_field.dart';
import 'package:banking_app/features/transfer/models/bank_model.dart';
import 'package:banking_app/features/transfer/models/beneficiary_model.dart';
import 'package:banking_app/features/transfer/models/branch_model.dart';
import 'package:banking_app/features/transfer/models/transfer_model.dart';
import 'package:banking_app/features/transfer/states/transfer_bloc.dart';
import 'package:banking_app/features/transfer/states/transfer_event.dart';
import 'package:banking_app/features/transfer/states/transfer_state.dart';
import 'package:banking_app/features/transfer/views/confirm_transfer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransferFormSection extends StatefulWidget {
  const TransferFormSection({super.key});

  @override
  State<TransferFormSection> createState() => _TransferFormSectionState();
}

class _TransferFormSectionState extends State<TransferFormSection>
    with InputValidationMixin {
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

  void _fillFromBeneficiary(BeneficiaryModel beneficiary, TransferState state) {
    _nameController.text = beneficiary.name;
    _cardNumberController.text = beneficiary.accountNumber;

    if (state.selectedTransferType == TransferType.otherBank) {
      final matchedBank = state.banks.firstWhere(
        (bank) => bank.id == beneficiary.bankId,
        orElse: () => state.banks.first,
      );
      _bankController.text = beneficiary.bankName ?? '';
      context.read<TransferBloc>().add(SelectBankEvt(matchedBank));
    }
  }

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
    return BlocListener<TransferBloc, TransferState>(
      listenWhen: (prev, curr) =>
          prev.selectedBeneficiary != curr.selectedBeneficiary,
      listener: (context, state) {
        if (state.selectedBeneficiary != null) {
          _fillFromBeneficiary(state.selectedBeneficiary!, state);
        } else {
          _clearForm();
        }
      },
      child: TransferFormSectionBody(
        formKey: _formKey,
        nameController: _nameController,
        cardNumberController: _cardNumberController,
        amountController: _amountController,
        contentController: _contentController,
        bankController: _bankController,
        branchController: _branchController,
        handleConfirm: _handleConfirm,
        transferForm: _transferForm,
        buildFormFields: _buildFormFields,
      ),
    );
  }

  /// Form for bank account or card number
  Widget _transferBankOrCardForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BATextField(
          name: S.current.transferNameLabel,
          hint: S.current.transferNameLabel,
          controller: _nameController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) => InputValidationMixin.validateRequired(
            value,
            S.current.transferNameLabel,
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
          validator: InputValidationMixin.validateCardNumber,
          onChanged: (value) => context.read<TransferBloc>().add(
            UpdateTransferDetailsEvt(cardNumber: value),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildFormFields(TransferState state) {
    return [
      BATextField(
        name: S.current.transferAmountLabel,
        hint: S.current.transferAmountLabel,
        controller: _amountController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        ],
        validator: (v) => CurrencyUtils.validateAmount(
          amount: double.tryParse(v ?? ''),
          balance: state.selectedAccount?.availableBalance ?? 0,
        ),
        onChanged: (v) {
          final amount = double.tryParse(v ?? '');
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
        validator: (value) => InputValidationMixin.validateRequired(
          value,
          S.current.transferContentLabel,
        ),
        onChanged: (value) => context.read<TransferBloc>().add(
          UpdateTransferDetailsEvt(content: value),
        ),
      ),
      if (_amountController.text.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(left: 14, top: 8),
          child: Text(
            CurrencyUtils.convertAmountToWords(_amountController.text),
            style: context.bodySmall?.copyWith(
              color: context.colorScheme.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
    ];
  }

  List<Widget> _transferForm(TransferState state) {
    switch (state.selectedTransferType) {
      case TransferType.cardNumber:
      case TransferType.sameBank:
        return [
          _transferBankOrCardForm(),
          const SizedBox(height: 24),
          ..._buildFormFields(state),
        ];
      case TransferType.otherBank:
        return [
          GestureDetector(
            onTap: () => _showBankSelector(state.banks, state.selectedBank),
            child: AbsorbPointer(
              child: BATextField(
                name: S.current.transferChooseBankLabel,
                hint: S.current.transferChooseBankLabel,
                controller: _bankController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                suffixIcon: const Icon(Icons.keyboard_arrow_right, size: 20),
                validator: (value) => InputValidationMixin.validateRequired(
                  value,
                  S.current.transferChooseBankLabel,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: state.selectedBank == null
                ? null
                : () {
                    final filteredBranches = state.branches
                        .where((b) => b.bankId == state.selectedBank?.id)
                        .toList();
                    _showBranchSelector(filteredBranches, state.selectedBranch);
                  },
            child: AbsorbPointer(
              child: BATextField(
                name: S.current.transferChooseBranchLabel,
                hint: S.current.transferChooseBranchLabel,
                controller: _branchController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                suffixIcon: const Icon(Icons.keyboard_arrow_right),
                validator: (value) => InputValidationMixin.validateRequired(
                  value,
                  S.current.transferChooseBranchLabel,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _transferBankOrCardForm(),
          const SizedBox(height: 24),
          ..._buildFormFields(state),
        ];
    }
  }

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

  void _handleConfirm(BuildContext context, TransferState state) async {
    if (!_formKey.currentState!.validate()) return;

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

class TransferFormSectionBody extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController cardNumberController;
  final TextEditingController amountController;
  final TextEditingController contentController;
  final TextEditingController bankController;
  final TextEditingController branchController;
  final void Function(BuildContext, TransferState) handleConfirm;
  final List<Widget> Function(TransferState) transferForm;
  final List<Widget> Function(TransferState) buildFormFields;

  const TransferFormSectionBody({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.cardNumberController,
    required this.amountController,
    required this.contentController,
    required this.bankController,
    required this.branchController,
    required this.handleConfirm,
    required this.transferForm,
    required this.buildFormFields,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransferBloc, TransferState>(
      buildWhen: (prev, curr) =>
          prev.selectedTransferType != curr.selectedTransferType ||
          prev.selectedAccount != curr.selectedAccount ||
          prev.selectedBank != curr.selectedBank ||
          prev.selectedBranch != curr.selectedBranch ||
          prev.saveToDirectory != curr.saveToDirectory,
      builder: (context, state) {
        return Form(
          key: formKey,
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
                ...transferForm(state),
                Row(
                  children: [
                    Checkbox(
                      value: state.saveToDirectory,
                      onChanged: (value) {
                        context.read<TransferBloc>().add(
                          UpdateTransferDetailsEvt(
                            saveToDirectory: value ?? false,
                          ),
                        );
                      },
                      activeColor: context.colorScheme.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        S.current.transferSaveBeneficiaryTitle,
                        style: context.titleSmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                BAElevatedButton(
                  isDisabled: state.selectedAccount == null,
                  padding: EdgeInsets.zero,
                  text: S.current.transferConfirmButton,
                  onPressed: () => handleConfirm(context, state),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
