import 'package:banking_app/features/bill_payment/data/models/bill_payment_model.dart';
import 'package:banking_app/features/home/data/models/account_model.dart';
import 'package:banking_app/features/home/data/models/card_model.dart';
import 'package:banking_app/features/bill_payment/data/models/company_model.dart';
import 'package:equatable/equatable.dart';

/// Base class for all bill payment events.
abstract class BillPaymentEvt extends Equatable {
  const BillPaymentEvt();

  @override
  List<Object?> get props => [];
}

/// Event to initialize the bill payment feature with a specific bill type.
class BillPaymentInitializeEvt extends BillPaymentEvt {
  const BillPaymentInitializeEvt(this.type);

  final BillType type;

  @override
  List<Object> get props => [type];
}

/// Event to select a specific bill to pay.
class SelectBillEvt extends BillPaymentEvt {
  const SelectBillEvt(this.bill);
  final BillPaymentModel bill;
  @override
  List<Object> get props => [bill];
}

/// Event to select a company for the bill payment.
class SelectCompanyEvt extends BillPaymentEvt {
  const SelectCompanyEvt(this.company);

  final CompanyModel company;

  @override
  List<Object> get props => [company];
}

/// Event to select a bank account as the payment method.
class SelectAccountEvt extends BillPaymentEvt {
  const SelectAccountEvt(this.account);

  final AccountModel account;

  @override
  List<Object> get props => [account];
}

/// Event to select a card as the payment method.
class SelectCardEvt extends BillPaymentEvt {
  const SelectCardEvt(this.card);

  final CardModel card;

  @override
  List<Object> get props => [card];
}

/// Event to update the details of the bill being paid.
class UpdateBillDetailsEvt extends BillPaymentEvt {
  const UpdateBillDetailsEvt({
    this.amount,
    this.fee,
    this.billCode,
    this.phoneNumber,
  });

  final double? amount;
  final double? fee;
  final String? billCode;
  final String? phoneNumber;

  @override
  List<Object?> get props => [amount, fee, billCode, phoneNumber];
}

/// Event to initiate the payment of a bill.
class PayBillEvt extends BillPaymentEvt {
  const PayBillEvt({required this.bill, required this.paymentMethodId});

  final String paymentMethodId;
  final BillPaymentModel bill;

  @override
  List<Object> get props => [bill, paymentMethodId];
}

/// Event to send an OTP to the user's email for verification.
class SendOtpEvt extends BillPaymentEvt {
  const SendOtpEvt({required this.billId});

  final String billId;
  @override
  List<Object> get props => [billId];
}

/// Event to confirm the bill payment with an OTP.
class ConfirmBillPaymentWithOtpEvt extends BillPaymentEvt {
  const ConfirmBillPaymentWithOtpEvt({
    required this.billId,
    required this.otpCode,
  });

  final String billId;
  final String otpCode;

  @override
  List<Object> get props => [billId, otpCode];
}

class OtpChangedEvt extends BillPaymentEvt {
  const OtpChangedEvt(this.otpCode);

  final String otpCode;

  @override
  List<Object> get props => [otpCode];
}
