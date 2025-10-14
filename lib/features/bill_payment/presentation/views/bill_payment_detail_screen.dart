import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/common/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/common/utils/formatters.dart';
import 'package:banking_app/core/security/input_validator.dart';
import 'package:banking_app/core/widgets/assets.dart';
import 'package:banking_app/core/widgets/button.dart';
import 'package:banking_app/core/widgets/forms/text_field.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/core/widgets/snackbar.dart';
import 'package:banking_app/features/bill_payment/data/models/bill_payment_model.dart';
import 'package:banking_app/features/bill_payment/presentation/blocs/bill_payment_bloc.dart';
import 'package:banking_app/features/bill_payment/presentation/blocs/bill_payment_event.dart';
import 'package:banking_app/features/bill_payment/presentation/blocs/bill_payment_state.dart';
import 'package:banking_app/features/bill_payment/presentation/views/bill_payment_success_screen.dart';
import 'package:banking_app/features/bill_payment/presentation/widgets/bill_detail_card.dart';
import 'package:banking_app/features/transfer/presentation/widgets/account_and_card_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

/// A screen that displays the details of a specific bill and allows the user to pay it.
class BillPaymentDetailsScreen extends StatefulWidget {
  const BillPaymentDetailsScreen({super.key, required this.bill});

  final BillPaymentModel bill;

  @override
  State<BillPaymentDetailsScreen> createState() =>
      _BillPaymentDetailsScreenState();
}

class _BillPaymentDetailsScreenState extends State<BillPaymentDetailsScreen> {
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  /// Handles the confirmation of the bill payment.
  void _confirmPayment() {
    final state = context.read<BillPaymentBloc>().state;
    final billId = state.billId ?? state.selectedBill?.id;
    context.read<BillPaymentBloc>().add(
      ConfirmBillPaymentWithOtpEvt(
        billId: billId ?? '',
        otpCode: _otpController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: BAScaffold(
        appBar: BAAppBar(
          title: widget.bill.billType?.displayName ?? '',
          titleColor: context.colorScheme.scrim,
          alignment: BAAppBarAlignment.left,
          iconColor: context.colorScheme.scrim,
        ),
        body: BlocConsumer<BillPaymentBloc, BillPaymentState>(
          listener: (context, state) {
            state.status.maybeWhen(
              loading: () => context.loaderOverlay.show(),
              success: () {
                context.loaderOverlay.hide();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PaymentSuccessScreen(bill: widget.bill),
                  ),
                );
              },
              failure: () {
                context.loaderOverlay.hide();
                BASnackBar.buildErrorSnackbar(
                  context,
                  state.errorMessage ?? '',
                );
              },
              awaitingOtp: () {
                context.loaderOverlay.hide();
                BASnackBar.buildSuccessSnackbar(
                  context,
                  S.current.transferSendOtpToEmailTitle,
                );
              },
              orElse: () {},
            );
          },
          builder: (context, state) {
            return GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),
                      BAAssets.transferSuccess(),
                      const SizedBox(height: 16),
                      Text(
                        '${FormatterUtils.formatDate(widget.bill.startDate)} - ${FormatterUtils.formatDate(widget.bill.endDate)}',
                        style: context.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 24),

                      /// Bill details
                      BillDetailCard(bill: widget.bill),
                      const SizedBox(height: 34),

                      /// Account or Card selector
                      AccountOrCardSelector(
                        accounts: state.accounts,
                        cards: state.cards,
                        selectedAccount: state.selectedAccount,
                        selectedCard: state.selectedCard,
                        onSelected: (account, card) {
                          if (account != null) {
                            context.read<BillPaymentBloc>().add(
                              SelectAccountEvt(account),
                            );
                          } else if (card != null) {
                            context.read<BillPaymentBloc>().add(
                              SelectCardEvt(card),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 24),

                      /// OTP section
                      _buildOtpSection(context, state),

                      const SizedBox(height: 40),

                      BAElevatedButton(
                        padding: EdgeInsets.zero,
                        height: 44,
                        text: S.current.payBillButton,
                        isDisabled: !state.isOtpValid,
                        onPressed: _confirmPayment,
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Builds the OTP input section, including the 'Get OTP' button.
  Widget _buildOtpSection(BuildContext context, BillPaymentState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.current.transferGetOtpTransactionTitle,
          style: context.bodySmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: BATextField(
                controller: _otpController,
                hint: S.current.transferOtpLabel,
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                validator: SecureInputValidator.validateOTP,
                onChanged: (value) {
                  context.read<BillPaymentBloc>().add(
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
                isDisabled:
                    state.selectedAccount == null && state.selectedCard == null,
                onPressed: () {
                  // Check if transaction already created
                  if (state.billId != null && state.billId!.isNotEmpty) {
                    // Already created transaction, just resend OTP
                    context.read<BillPaymentBloc>().add(
                      SendOtpEvt(billId: state.billId ?? ''),
                    );
                  } else {
                    // Create transaction first
                    context.read<BillPaymentBloc>().add(
                      PayBillEvt(
                        bill: widget.bill,
                        paymentMethodId:
                            state.selectedAccount?.id ??
                            state.selectedCard?.id ??
                            '',
                      ),
                    );
                  }
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
