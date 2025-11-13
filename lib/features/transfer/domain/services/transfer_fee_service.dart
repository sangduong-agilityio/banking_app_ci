import 'package:banking_app/features/home/data/models/account_model.dart';
import 'package:banking_app/features/home/data/models/card_model.dart';
import 'package:banking_app/features/transfer/data/models/transfer_model.dart';
import 'package:banking_app/features/transfer/data/repositories/transfer_repository.dart';

/// Service handling fee calculation and transaction limits
class TransferFeeService {
  const TransferFeeService(this._repository);

  final TransferRepository _repository;

  /// Fetch transaction limit for account or card
  Future<double?> fetchTransactionLimit({
    AccountModel? account,
    CardModel? card,
  }) async {
    if (account != null) {
      return await _repository.fetchAccountTransactionLimit(account);
    } else if (card != null) {
      return await _repository.fetchCardTransactionLimit(card);
    }
    return null;
  }

  /// Calculate transaction fee
  Future<double> calculateFee(TransferModel request) async {
    final feeResult = await _repository.calculateFee(request);
    return feeResult.fee;
  }

  /// Check if fee recalculation is needed
  bool shouldRecalculateFee({
    required bool hasSource,
    required bool hasBeneficiary,
    required double? amount,
  }) {
    return hasSource && hasBeneficiary && amount != null && amount > 0;
  }
}
