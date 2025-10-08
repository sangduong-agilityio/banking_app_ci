import 'package:banking_app/features/home/models/account_model.dart';
import 'package:banking_app/features/transactions/models/transaction_model.dart';
import 'package:banking_app/features/transfer/models/beneficiary_model.dart';

/// A utility function that determines the type of transfer based on the beneficiary's and user's account details.
///
/// This function returns a [TransferType] which can be one of the following:
/// - [TransferType.sameBank]: If the beneficiary's bank is the same as the user's bank.
/// - [TransferType.cardNumber]: If the beneficiary's account number is a 16-digit card number.
/// - [TransferType.otherBank]: If the transfer is to a different bank.
TransferType getTransferType(BeneficiaryModel b, AccountModel userAccount) {
  if (b.bankId != null && b.bankId == userAccount.bankId) {
    return TransferType.sameBank;
  }

  if (b.accountNumber.length == 16) {
    return TransferType.cardNumber;
  }

  return TransferType.otherBank;
}
