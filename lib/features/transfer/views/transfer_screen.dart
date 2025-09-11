import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/utils/validators.dart';
import 'package:banking_app/core/widgets/bottom_sheet.dart';
import 'package:banking_app/core/widgets/button.dart';
import 'package:banking_app/core/widgets/forms/text_field.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/transfer/bloc/transfer_bloc.dart';
import 'package:banking_app/features/transfer/bloc/transfer_event.dart';
import 'package:banking_app/features/transfer/bloc/transfer_state.dart';
import 'package:banking_app/features/transfer/models/transfer_model.dart';
import 'package:banking_app/features/transfer/views/confirm_transfer_screen.dart';
import 'package:banking_app/features/transfer/widgets/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
      child: BAScaffold(
        appBar: BAAppBar(
          title: 'Transfer',
          titleColor: context.colorScheme.scrim,
          alignment: BAAppBarAlignment.left,
          iconColor: context.colorScheme.scrim,
        ),
        body: BlocBuilder<TransferBloc, TransferState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24),
                  AccountSection(
                    state: state,
                    onSelectAccount: () => _showAccountSelector(state.accounts),
                  ),
                  SizedBox(height: 32),
                  TransactionTypeSelection(state: state),
                  SizedBox(height: 32),
                  // Beneficiary Selection
                  BeneficiarySelection(
                    state: state,
                    showBeneficiaryDialog: _showBeneficiaryDialog,
                  ),
                  SizedBox(height: 32),
                  // Transfer Form Section
                  TransferFormSection(),
                  SizedBox(height: 20),
                  // Fee Display
                  if (state.transactionFee > 0) _buildFeeSection(state),
                  SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFeeSection(TransferState state) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue[600], size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Transaction Fee",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[800],
                  ),
                ),
                Text(
                  "Additional charges apply",
                  style: TextStyle(fontSize: 12, color: Colors.blue[600]),
                ),
              ],
            ),
          ),
          Text(
            "\$${NumberFormat('#,##0.00').format(state.transactionFee)}",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
        ],
      ),
    );
  }

  void _showAccountSelector(List<Account> accounts) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => BASelectionSheet<Account>(
        title: "Select Account",
        items: accounts,
        itemBuilder: (context, account) => ListTile(
          leading: Container(
            width: 48,
            height: 32,
            decoration: BoxDecoration(
              color: Color(0xFF4C4DDC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                account.type,
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
          title: Text(account.maskedNumber),
          subtitle: Text(
            "Available: ${NumberFormat('#,##0.00').format(account.availableBalance)}",
            style: TextStyle(color: Colors.green[600]),
          ),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
        ),
        onItemSelected: (account) {
          context.read<TransferBloc>().add(SelectAccountEvt(account));
        },
      ),
    );
  }

  void _showBeneficiaryDialog(List<Bank> banks) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => BASelectionSheet<Bank>(
        title: "Choose Beneficiary Bank",
        items: banks,
        enableSearch: true,
        searchFilter: (bank, query) =>
            bank.name.toLowerCase().contains(query.toLowerCase()),
        itemBuilder: (context, bank) => ListTile(
          leading: Icon(Icons.account_balance),
          title: Text(bank.name),
          subtitle: Text(bank.code),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
        ),
        onItemSelected: (bank) {},
      ),
    );
  }
}

// void _showAddBeneficiaryDialog(Bank selectedBank) {
//   showDialog(
//     context: context,
//     builder: (context) => AddBeneficiaryDialog(selectedBank: selectedBank),
//   );
// }

// =============================================================================
// ADD BENEFICIARY DIALOG
// =============================================================================

// class AddBeneficiaryDialog extends StatefulWidget {
//   final Bank selectedBank;

//   const AddBeneficiaryDialog({Key? key, required this.selectedBank})
//     : super(key: key);

//   @override
//   _AddBeneficiaryDialogState createState() => _AddBeneficiaryDialogState();
// }

// class _AddBeneficiaryDialogState extends State<AddBeneficiaryDialog>
//     with TickerProviderStateMixin {
//   final _formKey = GlobalKey<FormBuilderState>();
//   late AnimationController _animationController;
//   late Animation<double> _scaleAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
//     );
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.transparent,
//       child: ScaleTransition(
//         scale: _scaleAnimation,
//         child: Container(
//           padding: EdgeInsets.all(24),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: FormBuilder(
//             key: _formKey,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Header
//                 Row(
//                   children: [
//                     Container(
//                       width: 48,
//                       height: 48,
//                       decoration: BoxDecoration(
//                         color: Color(0xFF4C4DDC).withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(24),
//                       ),
//                       child: Icon(
//                         Icons.person_add,
//                         color: Color(0xFF4C4DDC),
//                         size: 24,
//                       ),
//                     ),
//                     SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Add New Beneficiary",
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Text(
//                             widget.selectedBank.name,
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),

//                 SizedBox(height: 24),

//                 SizedBox(height: 16),

//                 SizedBox(height: 24),

//                 // Action buttons
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextButton(
//                         onPressed: () {
//                           _animationController.reverse().then((_) {
//                             Navigator.pop(context);
//                           });
//                         },
//                         style: TextButton.styleFrom(
//                           padding: EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             side: BorderSide(color: Colors.grey[300]!),
//                           ),
//                         ),
//                         child: Text(
//                           "Cancel",
//                           style: TextStyle(
//                             color: Colors.grey[700],
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 16),
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () {
//                           if (_formKey.currentState!.saveAndValidate()) {
//                             final formData = _formKey.currentState!.value;
//                             final beneficiary = Beneficiary(
//                               id: '',
//                               name: formData['beneficiary_name'],
//                               accountNumber: formData['account_number'],
//                               bank: widget.selectedBank,
//                             );

//                             context.read<TransferBloc>().add(
//                               AddNewBeneficiaryEvt(beneficiary),
//                             );
//                             _animationController.reverse().then((_) {
//                               Navigator.pop(context);
//                             });
//                             HapticFeedback.mediumImpact();
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color(0xFF4C4DDC),
//                           padding: EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: Text(
//                           "Add Beneficiary",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

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

class AccountSection extends StatelessWidget {
  final TransferState state;
  final VoidCallback onSelectAccount;

  const AccountSection({
    super.key,
    required this.state,
    required this.onSelectAccount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onSelectAccount,
          child: AbsorbPointer(
            child: BATextField(
              hint: "Choose account / card ",
              suffixIcon: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey[600],
                size: 20,
              ),
              controller: TextEditingController(
                text: state.selectedAccount?.maskedNumber ?? "",
              ),
              validator: (value) {
                if (state.selectedAccount == null) {
                  return "Please select an account";
                }
                return null;
              },
            ),
          ),
        ),
        if (state.selectedAccount != null) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 14),
            child: Text(
              "Available balance: \$${NumberFormat('#,##0.00').format(state.selectedAccount!.availableBalance)}",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class TransactionTypeSelection extends StatelessWidget {
  final TransferState state;

  const TransactionTypeSelection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final transactionTypes = [
      {
        'title': 'Transfer via\ncard number',
        'icon': Icons.credit_card_rounded,
        'type': TransferType.cardNumber,
      },
      {
        'title': 'Transfer to\nthe same bank',
        'icon': Icons.account_balance_rounded,
        'type': TransferType.sameBank,
      },
      {
        'title': 'Transfer to\nanother bank',
        'icon': Icons.account_balance_wallet_rounded,
        'type': TransferType.otherBank,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Choose transaction",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.inverseSurface,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            itemCount: transactionTypes.length,
            itemBuilder: (context, index) {
              final item = transactionTypes[index];
              final isSelected = state.selectedTransferType == item['type'];

              return Padding(
                padding: EdgeInsets.only(
                  right: index < transactionTypes.length - 1 ? 12 : 0,
                ),
                child: TransactionCard(
                  isSelected: isSelected,
                  onTap: () {
                    context.read<TransferBloc>().add(
                      SelectTransferTypeEvt(item['type'] as TransferType),
                    );
                    HapticFeedback.lightImpact();
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        item['icon'] as IconData,
                        color: Colors.white,
                        size: 28,
                      ),
                      const SizedBox(height: 11),
                      Text(
                        item['title'] as String,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class BeneficiarySelection extends StatelessWidget {
  final TransferState state;
  final void Function(List<Bank> banks) showBeneficiaryDialog;

  const BeneficiarySelection({
    super.key,
    required this.state,
    required this.showBeneficiaryDialog,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Choose beneficiary",
              style: context.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colorScheme.inverseSurface,
              ),
            ),
            TextButton(
              onPressed: () => showBeneficiaryDialog(state.banks ?? []),
              child: Text(
                "Find beneficiary",
                style: context.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.colorScheme.secondary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: state.beneficiaries.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildAddBeneficiaryCard(context);
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

  Widget _buildBeneficiaryCard(
    BuildContext context,
    Beneficiary beneficiary,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        context.read<TransferBloc>().add(SelectBeneficiaryEvt(beneficiary));
        HapticFeedback.selectionClick();
      },
      child: Container(
        width: 100,
        height: 120,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF4C4DDC)
                      : Colors.grey[300]!,
                  width: isSelected ? 3 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF4C4DDC).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: ClipOval(
                child: beneficiary.avatarUrl != null
                    ? Image.network(
                        beneficiary.avatarUrl!,
                        fit: BoxFit.cover,
                        width: 64,
                        height: 64,
                        errorBuilder: (_, __, ___) =>
                            _buildAvatarInitial(beneficiary.name, isSelected),
                      )
                    : _buildAvatarInitial(beneficiary.name, isSelected),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              beneficiary.name,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? const Color(0xFF4C4DDC) : Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddBeneficiaryCard(BuildContext context) {
    return GestureDetector(
      onTap: () => showBeneficiaryDialog([]),
      child: Container(
        width: 100,
        height: 120,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: CircleAvatar(
            radius: 28,
            backgroundColor: context.colorScheme.outlineVariant,
            child: Icon(
              Icons.add,
              size: 24,
              color: context.colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarInitial(String name, bool isSelected) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: isSelected ? Colors.white : Colors.grey[600],
        ),
      ),
    );
  }
}

class TransferFormSection extends StatefulWidget {
  const TransferFormSection({super.key});

  @override
  State<TransferFormSection> createState() => _TransferFormSectionState();
}

class _TransferFormSectionState extends State<TransferFormSection>
    with InputValidationMixin {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransferBloc, TransferState>(
      builder: (context, state) {
        return Container(
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
              Text(
                "Transfer Details",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 24),
              BATextField(
                name: "name",
                hint: "Name",
                validator: (value) => InputValidationMixin.validateRequired(
                  value,
                  "Recipient name",
                ),
                onChanged: (value) {
                  context.read<TransferBloc>().add(
                    UpdateTransferFormEvt(recipientName: value),
                  );
                },
              ),
              SizedBox(height: 24),
              BATextField(
                name: "card_number",
                hint: "Card number",
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                  _CardNumberFormatter(),
                ],
                validator: InputValidationMixin.validateCardNumber,
                onChanged: (value) {
                  context.read<TransferBloc>().add(
                    UpdateTransferFormEvt(cardNumber: value),
                  );
                },
              ),
              SizedBox(height: 24),
              BATextField(
                name: "amount",
                hint: "Amount",
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                validator: (value) => InputValidationMixin.validateAmount(
                  value,
                  state.selectedAccount?.availableBalance,
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
              SizedBox(height: 24),
              BATextField(
                name: "content",
                hint: "Content",
                textInputAction: TextInputAction.done,
                validator: (value) => InputValidationMixin.validateRequired(
                  value,
                  "Transfer note",
                ),
                onChanged: (value) {
                  context.read<TransferBloc>().add(
                    UpdateTransferFormEvt(content: value),
                  );
                },
              ),

              Row(
                children: [
                  Checkbox(
                    value: state.saveToDirectory,
                    onChanged: (value) {
                      context.read<TransferBloc>().add(
                        UpdateTransferFormEvt(saveToDirectory: value ?? false),
                      );
                    },
                    activeColor: context.colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Text(
                    "Save to beneficiary directory",
                    style: context.titleSmall,
                  ),
                ],
              ),
              SizedBox(height: 32),
              BAElevatedButton(
                padding: EdgeInsets.zero,
                height: 44,
                text: 'Confirm',
                isDisabled:
                    state.selectedAccount != null &&
                    state.selectedBeneficiary != null &&
                    state.amount != null &&
                    state.amount! > 0 &&
                    state.content != null &&
                    state.content!.isNotEmpty,
                onPressed:
                    state.selectedAccount != null &&
                        state.selectedBeneficiary != null &&
                        state.amount != null &&
                        state.amount! > 0 &&
                        state.content != null &&
                        state.content!.isNotEmpty
                    ? () {
                        HapticFeedback.mediumImpact();
                        context.read<TransferBloc>().add(InitiateTransfer());
                      }
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }
}
