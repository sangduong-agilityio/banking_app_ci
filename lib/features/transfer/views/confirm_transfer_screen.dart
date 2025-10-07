import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/utils/formatters.dart';
import 'package:banking_app/core/widgets/assets.dart';
import 'package:banking_app/core/widgets/button.dart';
import 'package:banking_app/core/widgets/forms/text_field.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/core/widgets/snackbar.dart';
import 'package:banking_app/features/transfer/states/transfer_bloc.dart';
import 'package:banking_app/features/transfer/states/transfer_event.dart';
import 'package:banking_app/features/transfer/states/transfer_state.dart';
import 'package:banking_app/features/transfer/views/transfer_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ConfirmTransferScreen extends StatefulWidget {
  const ConfirmTransferScreen({super.key});

  @override
  State<ConfirmTransferScreen> createState() => _ConfirmTransferScreenState();
}

class _ConfirmTransferScreenState extends State<ConfirmTransferScreen> {
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

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
                _otpController.clear();
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

          builder: (context, state) {
            return SingleChildScrollView(
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
                  _buildOtpSection(context, state),

                  const SizedBox(height: 24),

                  /// Confirm Button
                  BAElevatedButton(
                    padding: EdgeInsets.zero,
                    text: S.current.transferConfirmButton,
                    onPressed: () {
                      final txId = state.transferId ?? '';

                      // Handle biometric authentication (Touch ID/Face ID)
                      if (state.status is TransferStatusAwaitingBiometric &&
                          state.canUseBiometrics) {
                        context.read<TransferBloc>().add(
                          const ConfirmWithBiometricEvt(),
                        );
                        return;
                      }

                      // Handle OTP verification
                      final otp = _otpController.text.trim();
                      if (otp.isEmpty) {
                        BASnackBar.buildErrorSnackbar(
                          context,
                          S.current.transferEnterOtpCodeTitle,
                        );
                        return;
                      }

                      context.read<TransferBloc>().add(
                        ConfirmTransferWithOtpEvt(
                          otpCode: otp,
                          transferId: txId,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOtpSection(BuildContext context, TransferState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.current.transferGetOtpTransactionTitle,
          style: context.bodySmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),

        if (state.status is TransferStatusAwaitingBiometric &&
            state.canUseBiometrics)
          Center(
            child: GestureDetector(
              onTap: () {
                context.read<TransferBloc>().add(
                  const ConfirmWithBiometricEvt(),
                );
              },
              child: BAAssets.fingerprint(),
            ),
          )
        else
          Row(
            children: [
              Expanded(
                flex: 3,
                child: BATextField(
                  controller: _otpController,
                  hint: S.current.transferOtpLabel,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                flex: 2,
                child: BAElevatedButton(
                  padding: const EdgeInsets.only(left: 15),
                  text: state.otpSent
                      ? S.current.transferResendButton
                      : S.current.transferGetOtpButton,
                  onPressed: () {
                    final transactionId = state.transferId;
                    context.read<TransferBloc>().add(
                      SendOtpEvt(transferId: transactionId ?? ''),
                    );
                  },
                  height: 48,
                ),
              ),
            ],
          ),
      ],
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
        // From Account
        BATextField(
          name: S.current.transferFormLabel,
          label: S.current.transferFormLabel,
          controller: TextEditingController(
            text: FormatterUtils.maskCardNumber(
              state.selectedAccount?.accountNumber ?? '',
            ),
          ),
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
            text: "${FormatterUtils.formatAmount(state.transactionFee)}\$",
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
            text: "\$${FormatterUtils.formatAmount(state.amount ?? 0)}",
          ),
          readOnly: true,
        ),
      ],
    );
  }
}
