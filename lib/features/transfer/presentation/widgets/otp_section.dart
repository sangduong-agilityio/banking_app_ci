import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/assets.dart';
import 'package:banking_app/core/widgets/button.dart';
import 'package:banking_app/core/widgets/forms/text_field.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_bloc.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_event.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_state.dart';
import 'package:banking_app/core/security/input_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A widget for entering and confirming the OTP code for a transaction.
class OtpSection extends StatefulWidget {
  const OtpSection({super.key});

  @override
  State<OtpSection> createState() => _OtpSectionState();
}

class _OtpSectionState extends State<OtpSection> {
  bool _canConfirm(TransferState state) {
    // For biometric: can confirm if awaiting biometric and biometrics available
    if (state.status is TransferStatusAwaitingBiometric &&
        state.canUseBiometrics) {
      return true;
    }

    // For OTP: can confirm if OTP was sent and user entered 6 digits
    // Note: This allows confirming without the OTP being sent first.
    if (state.isOtpValid) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransferBloc, TransferState>(
      buildWhen: (previous, current) =>
          previous.otpSent != current.otpSent ||
          previous.status != current.status ||
          previous.otp != current.otp,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: BATextField(
                      hint: S.current.transferOtpLabel,
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      validator: SecureInputValidator.validateOTP,
                      onChanged: (value) {
                        context.read<TransferBloc>().add(
                          OtpChangedEvt(value ?? ''),
                        );
                      },
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

            /// Confirm Button - Only enabled when appropriate
            BAElevatedButton(
              isDisabled: !_canConfirm(state),
              padding: EdgeInsets.zero,
              text: S.current.transferConfirmButton,
              onPressed: !_canConfirm(state)
                  ? null
                  : () {
                      final txId = state.transferId ?? '';

                      // Handle biometric authentication
                      if (state.status is TransferStatusAwaitingBiometric &&
                          state.canUseBiometrics) {
                        context.read<TransferBloc>().add(
                          const ConfirmWithBiometricEvt(),
                        );
                        return;
                      }

                      // Handle OTP verification
                      final otp = state.otp ?? '';
                      context.read<TransferBloc>().add(
                        ConfirmTransferWithOtpEvt(
                          otpCode: otp,
                          transferId: txId,
                        ),
                      );
                    },
            ),
          ],
        );
      },
    );
  }
}
