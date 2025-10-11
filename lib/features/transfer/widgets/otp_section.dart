import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/assets.dart';
import 'package:banking_app/core/widgets/button.dart';
import 'package:banking_app/core/widgets/forms/text_field.dart';
import 'package:banking_app/features/transfer/blocs/transfer_bloc.dart';
import 'package:banking_app/features/transfer/blocs/transfer_event.dart';
import 'package:banking_app/features/transfer/blocs/transfer_state.dart';
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
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  bool _isOtpValid() {
    return _otpController.text.trim().length == 6;
  }

  bool _canConfirm(TransferState state) {
    // For biometric: can confirm if awaiting biometric and biometrics available
    if (state.status is TransferStatusAwaitingBiometric &&
        state.canUseBiometrics) {
      return true;
    }

    // For OTP: can confirm if OTP was sent and user entered 6 digits
    if (state.otpSent && _isOtpValid()) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransferBloc, TransferState>(
      buildWhen: (previous, current) =>
          previous.otpSent != current.otpSent ||
          previous.status != current.status,
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
                    child: ValueListenableBuilder(
                      valueListenable: _otpController,
                      builder: (context, value, _) {
                        return BATextField(
                          controller: _otpController,
                          hint: S.current.transferOtpLabel,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
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
            ValueListenableBuilder(
              valueListenable: _otpController,
              builder: (context, value, _) {
                final canConfirm = _canConfirm(state);

                return BAElevatedButton(
                  isDisabled: !canConfirm,
                  padding: EdgeInsets.zero,
                  text: S.current.transferConfirmButton,
                  onPressed: !canConfirm
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
                          final otp = _otpController.text.trim();
                          context.read<TransferBloc>().add(
                            ConfirmTransferWithOtpEvt(
                              otpCode: otp,
                              transferId: txId,
                            ),
                          );
                        },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
