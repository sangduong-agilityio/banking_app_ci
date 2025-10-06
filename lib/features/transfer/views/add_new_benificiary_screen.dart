import 'dart:io';
import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/security/input_validator.dart';
import 'package:banking_app/core/widgets/button.dart';
import 'package:banking_app/core/widgets/dialog.dart';
import 'package:banking_app/core/widgets/forms/text_field.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/core/widgets/snackbar.dart';
import 'package:banking_app/features/transfer/models/bank_model.dart';
import 'package:banking_app/features/transfer/models/beneficiary_model.dart';
import 'package:banking_app/features/transfer/models/branch_model.dart';
import 'package:banking_app/features/transfer/states/transfer_bloc.dart';
import 'package:banking_app/features/transfer/states/transfer_event.dart';
import 'package:banking_app/features/transfer/states/transfer_state.dart';
import 'package:banking_app/features/transfer/widgets/transaction_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';

class AddNewBeneficiaryScreen extends StatelessWidget {
  final List<BankModel> banks;
  final Function(BeneficiaryModel) onBeneficiaryAdded;

  const AddNewBeneficiaryScreen({
    super.key,
    required this.banks,
    required this.onBeneficiaryAdded,
  });

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null && context.mounted) {
      context.read<TransferBloc>().add(
        UpdateTransferDetailsEvt(avatarUrl: pickedFile.path),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: BAScaffold(
        appBar: BAAppBar(
          title: S.current.transferAddNewBeneficiaryTitle,
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
                BASnackBar.buildErrorSnackbar(
                  context,
                  state.errorMessage ?? '',
                );
              },
              orElse: () => context.loaderOverlay.hide(),
            );
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Column(
                  children: [
                    BeneficiaryProfile(onPickImage: () => _pickImage(context)),
                    const SizedBox(height: 24),
                    const TransactionTypeSelection(),
                    const SizedBox(height: 24),
                    AddBeneficiaryForm(
                      banks: banks,
                      onSaved: (beneficiary) {
                        context.read<TransferBloc>().add(
                          AddNewBeneficiaryEvt(beneficiary),
                        );
                        onBeneficiaryAdded(beneficiary);
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class BeneficiaryProfile extends StatelessWidget {
  final VoidCallback onPickImage;

  const BeneficiaryProfile({super.key, required this.onPickImage});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransferBloc, TransferState>(
      builder: (context, state) {
        final hasAvatar = state.avatarUrl != null;

        return Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: context.colorScheme.outlineVariant,
                  backgroundImage: hasAvatar
                      ? FileImage(File(state.avatarUrl ?? ''))
                      : null,
                  child: !hasAvatar
                      ? Icon(
                          Icons.person,
                          size: 60,
                          color: context.colorScheme.onPrimary,
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 3,
                  child: GestureDetector(
                    onTap: onPickImage,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: context.colorScheme.secondary,
                      child: Icon(
                        hasAvatar ? Icons.edit : Icons.add,
                        size: 18,
                        color: context.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              state.name ?? S.current.transferAddNewBeneficiaryNameTitle,
              style: context.titleMedium?.copyWith(
                color: context.colorScheme.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      },
    );
  }
}

class AddBeneficiaryForm extends StatefulWidget {
  final List<BankModel> banks;
  final void Function(BeneficiaryModel) onSaved;

  const AddBeneficiaryForm({
    super.key,
    required this.banks,
    required this.onSaved,
  });

  @override
  State<AddBeneficiaryForm> createState() => _AddBeneficiaryFormState();
}

class _AddBeneficiaryFormState extends State<AddBeneficiaryForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cardController = TextEditingController();
  final _bankController = TextEditingController();
  final _branchController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _cardController.dispose();
    _bankController.dispose();
    _branchController.dispose();
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
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () =>
                      _showBankSelector(state.banks, state.selectedBank),
                  child: AbsorbPointer(
                    child: BATextField(
                      name: S.current.transferChooseBankLabel,
                      hint: S.current.transferChooseBankLabel,
                      controller: _bankController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      suffixIcon: const Icon(
                        Icons.keyboard_arrow_right,
                        size: 20,
                      ),
                      validator: (value) =>
                          SecureInputValidator.validateSecureInput(
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
                  onTap: state.selectedBank == null
                      ? null
                      : () {
                          final filteredBranches = state.branches
                              .where((b) => b.bankId == state.selectedBank?.id)
                              .toList();
                          _showBranchSelector(
                            filteredBranches,
                            state.selectedBranch,
                          );
                        },
                  child: AbsorbPointer(
                    child: BATextField(
                      name: S.current.transferChooseBranchLabel,
                      hint: S.current.transferChooseBranchLabel,
                      controller: _branchController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      suffixIcon: const Icon(Icons.keyboard_arrow_right),
                      validator: (value) =>
                          SecureInputValidator.validateSecureInput(
                            value,
                            fieldName: S.current.transferChooseBranchLabel,
                            minLength: 1,
                            maxLength: 50,
                            allowSpecialChars: false,
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                BATextField(
                  name: S.current.transferAddNewBeneficiaryLabel,
                  hint: S.current.transferAddNewBeneficiaryLabel,
                  controller: _nameController,
                  onChanged: (value) {
                    context.read<TransferBloc>().add(
                      UpdateTransferDetailsEvt(name: value),
                    );
                  },
                  validator: (value) =>
                      SecureInputValidator.validateSecureInput(
                        value,
                        fieldName: S.current.transferAddNewBeneficiaryLabel,
                        minLength: 2,
                        maxLength: 50,
                        allowSpecialChars: false,
                      ),
                ),
                const SizedBox(height: 16),
                BATextField(
                  name: S.current.transferCardNumberLabel,
                  hint: S.current.transferCardNumberLabel,
                  controller: _cardController,
                  validator: SecureInputValidator.validateAccountNumber,
                ),
                const SizedBox(height: 24),
                BAElevatedButton(
                  padding: EdgeInsets.zero,
                  text: S.current.transferSaveDirectoryButton,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final bloc = context.read<TransferBloc>();

                      final newBeneficiary = BeneficiaryModel(
                        id: '',
                        name: _nameController.text,
                        accountNumber: _cardController.text,
                        bankId: bloc.state.selectedBank?.id,
                        branch: bloc.state.selectedBranch?.name,
                        avatarUrl: bloc.state.avatarUrl,
                      );

                      bloc.add(AddNewBeneficiaryEvt(newBeneficiary));
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showBankSelector(List<BankModel> banks, BankModel? selectedBank) {
    showDialog(
      context: context,
      builder: (_) => BASelectorDialog<BankModel>(
        title: S.current.transferChooseBankLabel,
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
}
