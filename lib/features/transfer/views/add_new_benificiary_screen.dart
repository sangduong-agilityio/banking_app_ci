import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/core/widgets/snackbar.dart';
import 'package:banking_app/features/transfer/states/transfer_bloc.dart';
import 'package:banking_app/features/transfer/states/transfer_event.dart';
import 'package:banking_app/features/transfer/states/transfer_state.dart';
import 'package:banking_app/features/transfer/models/transfer_model.dart';
import 'package:banking_app/features/transfer/widgets/transaction_card.dart';
import 'package:banking_app/features/transfer/widgets/transaction_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

class AddNewBeneficiaryScreen extends StatefulWidget {
  final List<Bank> banks;
  final Function(Beneficiary) onBeneficiaryAdded;

  const AddNewBeneficiaryScreen({
    super.key,
    required this.banks,
    required this.onBeneficiaryAdded,
  });

  @override
  State<AddNewBeneficiaryScreen> createState() =>
      _AddNewBeneficiaryScreenState();
}

class _AddNewBeneficiaryScreenState extends State<AddNewBeneficiaryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _accountNumberController = TextEditingController();

  Bank? _selectedBank;
  String? _selectedBranch;
  bool _isLoading = false;

  final List<String> _branches = [
    'New York',
    'Los Angeles',
    'Chicago',
    'Houston',
    'Miami',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactionTypes = [
      TransactionTypeItem(
        title: S.current.transferViaCardNumberTitle,
        icon: Icons.credit_card_rounded,
        type: TransferType.cardNumber,
      ),
      TransactionTypeItem(
        title: S.current.transferSameBankTitle,
        icon: Icons.account_balance_rounded,
        type: TransferType.sameBank,
      ),
      TransactionTypeItem(
        title: S.current.transferAnotherBankTitle,
        icon: Icons.account_balance_wallet_rounded,
        type: TransferType.otherBank,
      ),
    ];
    return BAScaffold(
      appBar: BAAppBar(
        title: "Add New",
        alignment: BAAppBarAlignment.left,
        titleColor: context.colorScheme.scrim,
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
              BASnackBar.buildErrorSnackbar(context, state.errorMessage ?? '');
            },
            orElse: () => context.loaderOverlay.hide(),
          );
        },
        builder: (context, state) => Column(
          children: [
            Center(child: _buildUserSection(context)),
            const SizedBox(height: 24),
            SizedBox(
              height: 110,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 2),
                itemCount: transactionTypes.length,
                itemBuilder: (context, index) {
                  final item = transactionTypes[index];
                  final isSelected = state.selectedTransferType == item.type;

                  return Padding(
                    padding: EdgeInsets.only(
                      right: index < transactionTypes.length - 1 ? 12 : 0,
                    ),
                    child: TransactionCard(
                      isSelected: isSelected,
                      onTap: () {
                        context.read<TransferBloc>().add(
                          SelectTransferTypeEvt(item.type),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            item.icon,
                            color: context.colorScheme.onPrimary,
                            size: 28,
                          ),
                          const SizedBox(height: 11),
                          Text(
                            item.title,
                            style: context.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: context.colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBankingDetailsSection(context),
                      const SizedBox(height: 24),
                      _buildConfirmButton(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserSection(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.colorScheme.primaryContainer,
            border: Border.all(color: context.colorScheme.primary, width: 2),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.person,
                size: 40,
                color: context.colorScheme.onPrimaryContainer,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.colorScheme.primary,
                  ),
                  child: Icon(
                    Icons.edit,
                    size: 12,
                    color: context.colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _nameController.text.isNotEmpty
              ? _nameController.text
              : 'Push Puttichai',
          style: context.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: context.colorScheme.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildBankingDetailsSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBankSelector(context),
          const SizedBox(height: 16),
          _buildBranchSelector(context),
          const SizedBox(height: 16),
          _buildTextField(
            context: context,
            label: 'Transaction name',
            controller: _nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter beneficiary name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            context: context,
            label: 'Card number',
            controller: _accountNumberController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter card/account number';
              }
              if (value.length < 10) {
                return 'Card number must be at least 10 digits';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBankSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose bank',
          style: context.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<Bank>(
          value: _selectedBank,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          hint: const Text('Select bank'),
          items: widget.banks.map((bank) {
            return DropdownMenuItem<Bank>(value: bank, child: Text(bank.name));
          }).toList(),
          onChanged: (Bank? bank) {
            setState(() {
              _selectedBank = bank;
              _selectedBranch = null;
            });
          },
          validator: (value) {
            if (value == null) {
              return 'Please select a bank';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildBranchSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose branch',
          style: context.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedBranch,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          hint: const Text('Select branch'),
          items: _branches.map((branch) {
            return DropdownMenuItem<String>(value: branch, child: Text(branch));
          }).toList(),
          onChanged: _selectedBank == null
              ? null
              : (String? branch) {
                  setState(() {
                    _selectedBranch = branch;
                  });
                },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a branch';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          validator: validator,
          onChanged: (value) {
            if (controller == _nameController) {
              setState(() {}); // Rebuild to update display name
            }
          },
        ),
      ],
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleConfirm,
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colorScheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Confirm',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
      ),
    );
  }

  void _handleConfirm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create new beneficiary
      final newBeneficiary = Beneficiary(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Temporary ID
        name: _nameController.text.trim(),
        accountNumber: _accountNumberController.text.trim(),
        bank: _selectedBank,
        branch: _selectedBranch,
        isFavorite: false,
      );

      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      widget.onBeneficiaryAdded(newBeneficiary);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${newBeneficiary.name} added successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add beneficiary: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
