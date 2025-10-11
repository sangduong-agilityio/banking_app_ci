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
import 'package:banking_app/features/bill_payment/models/bill_payment_model.dart';
import 'package:banking_app/features/bill_payment/models/company_model.dart';
import 'package:banking_app/features/bill_payment/blocs/bill_payment_bloc.dart';
import 'package:banking_app/features/bill_payment/blocs/bill_payment_event.dart';
import 'package:banking_app/features/bill_payment/blocs/bill_payment_state.dart';
import 'package:banking_app/features/bill_payment/views/bill_payment_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

/// A screen where the user can select a company and enter a bill code to check for a bill.
class PaymentOptionScreen extends StatefulWidget {
  const PaymentOptionScreen({super.key, required this.billType});
  final BillType billType;
  @override
  State<PaymentOptionScreen> createState() => _PaymentOptionScreenState();
}

class _PaymentOptionScreenState extends State<PaymentOptionScreen> {
  final _billCodeController = TextEditingController();

  @override
  void dispose() {
    _billCodeController.dispose();
    super.dispose();
  }

  /// Shows a dialog for the user to select a company.
  void _showCompanySelector(
    List<CompanyModel> companies,
    CompanyModel? selectedCompany,
  ) {
    showDialog(
      context: context,
      builder: (_) => BASelectorDialog<CompanyModel>(
        title: S.current.payBillChooseCompanyHint,
        items: companies,
        selectedValue: selectedCompany?.id,
        value: (value) => value.id,
        label: (value) => value.name,
        onSelected: (company) {
          context.read<BillPaymentBloc>().add(SelectCompanyEvt(company));
          Navigator.pop(context);
        },
      ),
    );
  }

  /// Handles the logic for checking a bill after the user enters a bill code.
  void _handleCheckBill(BillPaymentState state) {
    final selectedCompany = state.selectedCompany;
    if (selectedCompany == null || _billCodeController.text.isEmpty) {
      return;
    }

    final trimmedCode = _billCodeController.text.trim();

    final selectedBill = state.bills.firstWhere(
      (bill) =>
          bill.billType == widget.billType &&
          bill.company?.id == selectedCompany.id &&
          bill.billCode == trimmedCode,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<BillPaymentBloc>(),
          child: BillPaymentDetailsScreen(bill: selectedBill),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: BAScaffold(
        appBar: BAAppBar(
          title: S.current.payBillTitle,
          titleColor: context.colorScheme.scrim,
          alignment: BAAppBarAlignment.left,
          iconColor: context.colorScheme.scrim,
        ),
        body: BlocConsumer<BillPaymentBloc, BillPaymentState>(
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
            final availableCompanies = state.bills
                .where(
                  (b) => b.billType == widget.billType && b.company != null,
                )
                .map((b) => b.company!)
                .toSet()
                .toList();

            final selectedCompany = state.selectedCompany;
            return GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: context.colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => _showCompanySelector(
                            availableCompanies,
                            selectedCompany,
                          ),
                          child: AbsorbPointer(
                            child: BATextField(
                              controller:
                                  TextEditingController(
                                      text: selectedCompany?.name ?? '',
                                    )
                                    ..selection = TextSelection.collapsed(
                                      offset:
                                          (selectedCompany?.name ?? '').length,
                                    ),
                              hint: S.current.payBillChooseCompanyHint,
                              suffixIcon: const Icon(
                                Icons.keyboard_arrow_right,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          S.current.payBillTypeLabel(
                            widget.billType.displayName.toLowerCase(),
                          ),
                          style: context.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        BATextField(
                          controller: _billCodeController,
                          hint: S.current.payBillCodeHint,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: SecureInputValidator.validateBillCode,
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 24),
                        Text(
                          S.current.payBillDescription,
                          style: context.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 24),
                        BAElevatedButton(
                          padding: EdgeInsets.zero,
                          text: S.current.payBillCheckButton,
                          isDisabled:
                              selectedCompany == null ||
                              _billCodeController.text.isEmpty,
                          onPressed: () => _handleCheckBill(state),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
