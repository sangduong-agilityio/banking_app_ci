import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/utils/validators.dart';
import 'package:banking_app/core/widgets/button.dart';
import 'package:banking_app/core/widgets/dialog.dart';
import 'package:banking_app/core/widgets/forms/text_field.dart';
import 'package:banking_app/features/transfer/states/transfer_bloc.dart';
import 'package:banking_app/features/transfer/states/transfer_event.dart';
import 'package:banking_app/features/transfer/states/transfer_state.dart';
import 'package:banking_app/features/transfer/models/transfer_model.dart';
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
  final _cardController = TextEditingController();
  final _amountController = TextEditingController();
  final _contentController = TextEditingController();
  final _bankController = TextEditingController();

  Bank? _selectedBank;

  @override
  void dispose() {
    _nameController.dispose();
    _cardController.dispose();
    _amountController.dispose();
    _contentController.dispose();
    _bankController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransferBloc, TransferState>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: context.colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ..._buildFormFields(state),

                Row(
                  children: [
                    Checkbox(
                      value: state.saveToDirectory,
                      onChanged: (value) {
                        context.read<TransferBloc>().add(
                          UpdateTransferFormEvt(
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
                  padding: EdgeInsets.zero,
                  height: 44,
                  text: S.current.transferConfirmButton,
                  onPressed: _canProceed(state)
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

  List<Widget> _buildFormFields(TransferState state) {
    switch (state.selectedTransferType) {
      case TransferType.cardNumber:
      case TransferType.sameBank:
        return _buildCardTransferFields();
      case TransferType.otherBank:
        return _buildOtherBankFields(state);
    }
  }

  List<Widget> _buildCardTransferFields() {
    return [
      BATextField(
        name: 'recipient_name',
        label: S.current.transferNameLabel,
        hint: S.current.transferNameLabel,
        controller: _nameController,
        validator: (value) =>
            InputValidationMixin.validateRequired(value, 'Name is required'),
        onChanged: (value) {
          context.read<TransferBloc>().add(UpdateTransferFormEvt(name: value));
        },
      ),
      const SizedBox(height: 24),

      BATextField(
        name: 'card_number',
        label: S.current.transferCardNumberLabel,
        hint: S.current.transferCardNumberLabel,
        controller: _cardController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(16),
          _CardNumberFormatter(),
        ],
        validator: InputValidationMixin.validateCardNumber,
        onChanged: (value) {
          context.read<TransferBloc>().add(
            UpdateTransferFormEvt(cardNumber: value),
          );
        },
      ),
      const SizedBox(height: 24),

      BATextField(
        name: 'amount',
        label: S.current.transferAmountLabel,
        hint: S.current.transferAmountLabel,
        controller: _amountController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        ],
        validator: (value) => InputValidationMixin.validateAmount(
          value,
          context.read<TransferBloc>().state.selectedAccount?.availableBalance,
        ),
        onChanged: (value) {
          final amount = double.tryParse(value ?? '');
          if (amount != null) {
            context.read<TransferBloc>().add(
              UpdateTransferFormEvt(amount: amount),
            );
          }
        },
      ),
      const SizedBox(height: 24),

      BATextField(
        name: 'content',
        label: S.current.transferContentLabel,
        hint: S.current.transferContentLabel,
        controller: _contentController,
        textInputAction: TextInputAction.done,
        validator: (value) =>
            InputValidationMixin.validateRequired(value, 'Content is required'),
        onChanged: (value) {
          context.read<TransferBloc>().add(
            UpdateTransferFormEvt(content: value),
          );
        },
      ),
    ];
  }

  List<Widget> _buildOtherBankFields(TransferState state) {
    return [
      GestureDetector(
        onTap: () => _showBankSelector(state.banks, _selectedBank),
        child: AbsorbPointer(
          child: BATextField(
            name: 'choose_bank',
            label: 'Choose bank',
            hint: 'Choose bank',
            controller: _bankController,
            suffixIcon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey[600],
              size: 20,
            ),
            validator: (_) =>
                _selectedBank == null ? 'Please select a bank' : null,
          ),
        ),
      ),
      const SizedBox(height: 24),

      // Name
      BATextField(
        name: 'name',
        label: 'Name',
        hint: 'Enter name',
        controller: _nameController,
        validator: (value) =>
            InputValidationMixin.validateRequired(value, 'Name is required'),
        onChanged: (value) {
          context.read<TransferBloc>().add(UpdateTransferFormEvt(name: value));
        },
      ),
      const SizedBox(height: 24),

      // Card number
      BATextField(
        name: 'card_number',
        label: 'Card number',
        hint: 'Enter card number',
        controller: _cardController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(16),
        ],
        validator: (value) => InputValidationMixin.validateRequired(
          value,
          'Card number is required',
        ),
        onChanged: (value) {
          context.read<TransferBloc>().add(
            UpdateTransferFormEvt(cardNumber: value),
          );
        },
      ),
      const SizedBox(height: 24),

      // Amount
      BATextField(
        name: 'amount',
        label: 'Amount',
        hint: 'Enter amount',
        controller: _amountController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        ],
        validator: (value) => InputValidationMixin.validateAmount(
          value,
          context.read<TransferBloc>().state.selectedAccount?.availableBalance,
        ),
        onChanged: (value) {
          final amount = double.tryParse(value ?? '');
          if (amount != null) {
            context.read<TransferBloc>().add(
              UpdateTransferFormEvt(amount: amount),
            );
          }
        },
      ),
      const SizedBox(height: 24),

      // Note
      BATextField(
        name: 'note',
        label: 'Note',
        hint: 'Enter note',
        controller: _contentController,
        textInputAction: TextInputAction.done,
        validator: (value) =>
            InputValidationMixin.validateRequired(value, 'Note is required'),
        onChanged: (value) {
          context.read<TransferBloc>().add(
            UpdateTransferFormEvt(content: value),
          );
        },
      ),
    ];
  }

  void _showBankSelector(List<Bank> banks, Bank? selectedBank) {
    showDialog(
      context: context,
      builder: (_) => BASelectorDialog<Bank>(
        title: S.current.transferSelectBeneficiary,
        items: banks,
        selectedValue: selectedBank != null ? selectedBank.id : '',
        value: (b) => b.id,
        label: (b) => b.name,
        onSelected: (bank) {
          setState(() {
            _selectedBank = bank;
            _bankController.text = bank.name;
          });
          context.read<TransferBloc>().add(UpdateTransferFormEvt(bank: bank));
          Navigator.pop(context);
        },
      ),
    );
  }

  bool _canProceed(TransferState state) {
    switch (state.selectedTransferType) {
      case TransferType.cardNumber:
      case TransferType.sameBank:
        return state.selectedAccount != null &&
            state.selectedBeneficiary != null &&
            _nameController.text.trim().isNotEmpty &&
            _cardController.text.trim().isNotEmpty &&
            _amountController.text.trim().isNotEmpty &&
            _contentController.text.trim().isNotEmpty;

      case TransferType.otherBank:
        return state.selectedAccount != null &&
            _selectedBank != null &&
            _nameController.text.trim().isNotEmpty &&
            _cardController.text.trim().isNotEmpty &&
            _amountController.text.trim().isNotEmpty &&
            _contentController.text.trim().isNotEmpty;
    }
  }

  void _handleConfirm(BuildContext context, TransferState state) {
    if (!_formKey.currentState!.validate()) return;

    final amount =
        double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0;
    final content = _contentController.text.trim();

    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    if (state.selectedAccount != null &&
        amount > state.selectedAccount!.availableBalance) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Insufficient balance')));
      return;
    }

    if (state.selectedTransferType == TransferType.otherBank) {
      final beneficiary = Beneficiary(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        accountNumber: _cardController.text.trim(),
        bank: _selectedBank,
      );

      context.read<TransferBloc>().add(SelectBeneficiaryEvt(beneficiary));
    }

    context.read<TransferBloc>().add(
      FillTransferDetailsEvt(amount: amount, content: content),
    );

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

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(text[i]);
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
