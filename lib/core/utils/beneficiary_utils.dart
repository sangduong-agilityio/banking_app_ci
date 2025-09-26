import 'package:banking_app/features/home/models/account_model.dart';
import 'package:banking_app/features/transactions/models/transaction_model.dart';
import 'package:banking_app/features/transfer/models/beneficiary_model.dart';

TransferType getTransferType(BeneficiaryModel b, AccountModel userAccount) {
  if (b.bankId != null && b.bankId == userAccount.bankId) {
    return TransferType.sameBank;
  }

  if (b.accountNumber.length == 16) {
    return TransferType.cardNumber;
  }

  return TransferType.otherBank;
}
