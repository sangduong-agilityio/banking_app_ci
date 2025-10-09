import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/assets.dart';
import 'package:banking_app/core/widgets/button.dart';
import 'package:banking_app/core/widgets/forms/text_field.dart';
import 'package:banking_app/core/widgets/snackbar.dart';
import 'package:banking_app/features/transfer/states/transfer_bloc.dart';
import 'package:banking_app/features/transfer/states/transfer_event.dart';
import 'package:banking_app/features/transfer/states/transfer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A widget for entering and confirming the OTP code for a transaction.
///
/// This widget displays a text field for entering the OTP code, a button to
/// resend the OTP code, and a button to confirm the transaction. If biometric
/// authentication is available and enabled, it will show a fingerprint icon
class OtpSection extends StatefulWidget {
  const OtpSection({super.key});

  @override
  State<OtpSection> createState() => _OtpSectionState();
}

class _OtpSectionState extends State<OtpSection> {
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransferBloc, TransferState>(
      builder: (context, state) {
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
                  ConfirmTransferWithOtpEvt(otpCode: otp, transferId: txId),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
