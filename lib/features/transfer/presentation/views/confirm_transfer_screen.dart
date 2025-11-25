import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/common/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/common/utils/formatters.dart';
import 'package:banking_app/core/widgets/forms/text_field.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/core/widgets/snackbar.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_bloc.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_event.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_state.dart';
import 'package:banking_app/features/transfer/presentation/views/transfer_success_screen.dart';
import 'package:banking_app/features/transfer/presentation/widgets/otp_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ConfirmTransferScreen extends StatefulWidget {
  const ConfirmTransferScreen({super.key});

  @override
  State<ConfirmTransferScreen> createState() => _ConfirmTransferScreenState();
}

class _ConfirmTransferScreenState extends State<ConfirmTransferScreen> {
  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: BAScaffold(
        appBar: BAAppBar(
          title: S.current.transferConfirmTitle,
          titleColor: context.colorScheme.scrim,
          alignment: BAAppBarAlignment.left,
          iconColor: context.colorScheme.scrim,
        ),
        body: BlocConsumer<TransferBloc, TransferState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            state.status.map(
              loading: (_) => context.loaderOverlay.show(),
              failure: (_) {
                context.loaderOverlay.hide();
                BASnackBar.buildErrorSnackbar(
                  context,
                  state.errorMessage ?? '',
                );
              },
              awaitingOtp: (_) {
                context.loaderOverlay.hide();
                BASnackBar.buildSuccessSnackbar(
                  context,
                  S.current.transferSendOtpToEmailTitle,
                );
              },
              awaitingBiometric: (_) {
                context.loaderOverlay.hide();
                if (state.errorMessage != null) {
                  BASnackBar.buildErrorSnackbar(
                    context,
                    state.errorMessage ?? '',
                  );
                  context.read<TransferBloc>().add(
                    const BiometricErrorMessageEvt(),
                  );
                }
              },
              success: (_) {
                context.loaderOverlay.hide();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TransferSuccessScreen(
                      amount: state.amount ?? 0,
                      beneficiaryName: state.selectedBeneficiary?.name ?? '',
                    ),
                  ),
                );
              },
              initial: (_) => context.loaderOverlay.hide(),
            );
          },
          buildWhen: (previous, current) =>
              previous.selectedAccount != current.selectedAccount ||
              previous.selectedCard != current.selectedCard ||
              previous.selectedBeneficiary != current.selectedBeneficiary ||
              previous.amount != current.amount ||
              previous.transactionFee != current.transactionFee ||
              previous.content != current.content ||
              previous.otpSent != current.otpSent ||
              previous.otp != current.otp ||
              previous.biometricAvailable != current.biometricAvailable ||
              previous.biometricEnabled != current.biometricEnabled,
          builder: (context, state) {
            return GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Confirmation Title
                    Text(
                      S.current.transferConfirmTransaction,
                      style: context.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),

                    /// Transaction Details
                    ConfirmTransactionDetail(state: state),
                    const SizedBox(height: 24),

                    /// OTP or Biometric Authentication Section
                    const OtpSection(),

                    const SizedBox(height: 40),
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

class ConfirmTransactionDetail extends StatelessWidget {
  final TransferState state;

  const ConfirmTransactionDetail({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    const sizeBox = SizedBox(height: 24);

    final bankName =
        state.selectedBank?.name ?? state.selectedBeneficiary?.bankName ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // From Account/Card
        BATextField(
          name: S.current.transferFormLabel,
          label: S.current.transferFormLabel,
          controller: TextEditingController(text: _getFromSourceNumber()),
          readOnly: true,
        ),

        sizeBox,
        // To Beneficiary
        BATextField(
          name: S.current.transferToLabel,
          label: S.current.transferToLabel,
          controller: TextEditingController(
            text: state.selectedBeneficiary?.name ?? '',
          ),
          readOnly: true,
        ),
        sizeBox,

        // Beneficiary Account Number
        BATextField(
          name: S.current.transferCardNumberLabel,
          label: S.current.transferCardNumberLabel,
          controller: TextEditingController(
            text: state.selectedBeneficiary?.accountNumber != null
                ? FormatterUtils.maskCardNumber(
                    state.selectedBeneficiary!.accountNumber,
                  )
                : '',
          ),
          readOnly: true,
        ),
        sizeBox,

        // Beneficiary Bank
        if (bankName.isNotEmpty)
          BATextField(
            name: S.current.transferBeneficiaryBank,
            label: S.current.transferBeneficiaryBank,
            controller: TextEditingController(text: bankName),
            readOnly: true,
          ),
        if (bankName.isNotEmpty) sizeBox,

        // Transaction Fee
        BATextField(
          name: S.current.transferTransactionFeeLabel,
          label: S.current.transferTransactionFeeLabel,
          controller: TextEditingController(
            text: '${FormatterUtils.formatAmount(state.transactionFee)}\$',
          ),
          readOnly: true,
        ),
        sizeBox,

        // Transfer Content
        BATextField(
          name: S.current.transferContentLabel,
          label: S.current.transferContentLabel,
          controller: TextEditingController(text: state.content ?? ''),
          readOnly: true,
        ),
        sizeBox,

        // Transfer Amount
        BATextField(
          name: S.current.transferAmountLabel,
          label: S.current.transferAmountLabel,
          controller: TextEditingController(
            text: '\$${FormatterUtils.formatAmount(state.amount ?? 0)}',
          ),
          readOnly: true,
        ),
      ],
    );
  }

  /// Gets the masked number of the selected account or card.
  String _getFromSourceNumber() {
    if (state.selectedAccount != null) {
      return FormatterUtils.maskCardNumber(
        state.selectedAccount!.accountNumber,
      );
    } else if (state.selectedCard != null) {
      return FormatterUtils.maskCardNumber(state.selectedCard!.cardNumber);
    }
    return '';
  }
}
