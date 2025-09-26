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
import 'package:banking_app/features/bill_payment/models/bill_payment_model.dart';
import 'package:banking_app/features/bill_payment/states/bill_payment_bloc.dart';
import 'package:banking_app/features/bill_payment/states/bill_payment_event.dart';
import 'package:banking_app/features/bill_payment/states/bill_payment_state.dart';
import 'package:banking_app/features/bill_payment/views/bill_payment_success_screen.dart';
import 'package:banking_app/features/bill_payment/widgets/bill_detail_card.dart';
import 'package:banking_app/features/transfer/widgets/account_and_card_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

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

  @override
  Widget build(BuildContext context) {
    return BAScaffold(
      appBar: BAAppBar(
        title: widget.bill.billType?.displayName ?? '',
        titleColor: context.colorScheme.scrim,
        alignment: BAAppBarAlignment.left,
        iconColor: context.colorScheme.scrim,
      ),
      body: BlocConsumer<BillPaymentBloc, BillPaymentState>(
        listener: (context, state) {
          state.status.map(
            loaded: (_) => context.loaderOverlay.hide(),
            loading: (_) => context.loaderOverlay.show(),
            failure: (_) {
              context.loaderOverlay.hide();
              BASnackBar.buildErrorSnackbar(context, state.errorMessage ?? '');
            },
            awaitingOtp: (_) {
              context.loaderOverlay.hide();
              BASnackBar.buildSuccessSnackbar(
                context,
                S.current.transferSendOtpToEmailTitle,
              );
            },
            success: (_) {
              context.loaderOverlay.hide();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<BillPaymentBloc>(),
                    child: PaymentSuccessScreen(bill: widget.bill),
                  ),
                ),
              );
            },
            initial: (_) => context.loaderOverlay.hide(),
          );
        },
        builder: (context, state) {
          return SingleChildScrollView(
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
                  BillDetailCard(bills: widget.bill),
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

                  /// Pay button
                  BAElevatedButton(
                    padding: EdgeInsets.zero,
                    height: 44,
                    text: S.current.payBillButton,
                    onPressed: () {
                      final billId = widget.bill.id ?? '';
                      final otp = _otpController.text.trim();

                      if (otp.isEmpty) {
                        BASnackBar.buildErrorSnackbar(
                          context,
                          S.current.transferEnterOtpCodeTitle,
                        );
                        return;
                      }

                      context.read<BillPaymentBloc>().add(
                        ConfirmBillPaymentWithOtpEvt(
                          billId: billId,
                          otpCode: otp,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

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
                  final billId = widget.bill.id ?? '';
                  context.read<BillPaymentBloc>().add(
                    SendOtpEvt(billId: billId),
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
