import 'package:banking_app/features/bill_payment/models/bill_payment_model.dart';
import 'package:banking_app/features/home/models/account_model.dart';
import 'package:banking_app/features/home/models/card_model.dart';
import 'package:banking_app/features/bill_payment/models/company_model.dart';
import 'package:equatable/equatable.dart';

abstract class BillPaymentEvt extends Equatable {
  const BillPaymentEvt();

  @override
  List<Object?> get props => [];
}

class BillPaymentInitializeEvt extends BillPaymentEvt {
  const BillPaymentInitializeEvt(this.type);

  final BillType type;

  @override
  List<Object> get props => [type];
}

class SelectBillEvt extends BillPaymentEvt {
  const SelectBillEvt(this.bill);
  final BillPaymentModel bill;
  @override
  List<Object> get props => [bill];
}

class SelectCompanyEvt extends BillPaymentEvt {
  const SelectCompanyEvt(this.company);

  final CompanyModel company;

  @override
  List<Object> get props => [company];
}

class SelectAccountEvt extends BillPaymentEvt {
  const SelectAccountEvt(this.account);

  final AccountModel account;

  @override
  List<Object> get props => [account];
}

class SelectCardEvt extends BillPaymentEvt {
  const SelectCardEvt(this.card);

  final CardModel card;

  @override
  List<Object> get props => [card];
}

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

class PayBillEvt extends BillPaymentEvt {
  const PayBillEvt({required this.bill, required this.paymentMethodId});

  final String paymentMethodId;
  final BillPaymentModel bill;

  @override
  List<Object> get props => [bill, paymentMethodId];
}

class SendOtpEvt extends BillPaymentEvt {
  const SendOtpEvt({required this.billId});

  final String billId;
  @override
  List<Object> get props => [billId];
}

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
