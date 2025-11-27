import 'package:banking_app/features/home/data/models/account_model.dart';
import 'package:banking_app/features/home/data/models/card_model.dart';
import 'package:banking_app/features/transfer/data/models/beneficiary_model.dart';
import 'package:banking_app/features/transactions/data/models/transaction_model.dart';
import 'package:banking_app/core/common/utils/beneficiary_utils.dart';

/// Service handling beneficiary filtering by account/card and transfer type
class BeneficiaryFilterService {
  const BeneficiaryFilterService();

  /// Filter beneficiaries based on selected source and transfer type
  BeneficiaryFilterResult filterBeneficiaries({
    required List<BeneficiaryModel> allBeneficiaries,
    required TransferType selectedTransferType,
    AccountModel? selectedAccount,
    CardModel? selectedCard,
  }) {
    // Case 1: No account/card selected → Show all
    if (selectedAccount == null && selectedCard == null) {
      return BeneficiaryFilterResult(
        filtered: allBeneficiaries,
        viaCard: _filterByType(allBeneficiaries, TransferType.cardNumber),
        sameBank: const [],
        otherBank: const [],
        disabled: {},
      );
    }

    // Case 2: Account selected → Filter by account compatibility
    if (selectedAccount != null) {
      return _filterByAccount(
        allBeneficiaries,
        selectedAccount,
        selectedTransferType,
      );
    }

    // Case 3: Card selected → Only card transfers allowed
    return _filterByCard(allBeneficiaries);
  }

  /// Filter beneficiaries when user selects an account
  BeneficiaryFilterResult _filterByAccount(
    List<BeneficiaryModel> beneficiaries,
    AccountModel account,
    TransferType selectedType,
  ) {
    final filtered = <BeneficiaryModel>[];
    final sameBank = <BeneficiaryModel>[];
    final otherBank = <BeneficiaryModel>[];
    final disabled = <String, String>{};

    for (final beneficiary in beneficiaries) {
      final type = getTransferType(beneficiary, account);

      // Add to appropriate category
      if (type == TransferType.sameBank) {
        sameBank.add(beneficiary);
      } else if (type == TransferType.otherBank) {
        otherBank.add(beneficiary);
      } else {
        disabled[beneficiary.id ?? ''] =
            'This beneficiary does not support the selected transfer type.';
      }

      // Add to filtered if matches selected type
      if (type == selectedType) {
        filtered.add(beneficiary);
      }
    }

    return BeneficiaryFilterResult(
      filtered: _sortBeneficiaries(filtered),
      viaCard: const [],
      sameBank: _sortBeneficiaries(sameBank),
      otherBank: _sortBeneficiaries(otherBank),
      disabled: disabled,
    );
  }

  /// Filter beneficiaries when user selects a card
  BeneficiaryFilterResult _filterByCard(List<BeneficiaryModel> beneficiaries) {
    final filtered = <BeneficiaryModel>[];
    final disabled = <String, String>{};

    for (final beneficiary in beneficiaries) {
      if (beneficiary.transferType == TransferType.cardNumber) {
        filtered.add(beneficiary);
      } else {
        disabled[beneficiary.id ?? ''] =
            'This beneficiary does not support card transfers.';
      }
    }

    return BeneficiaryFilterResult(
      filtered: _sortBeneficiaries(filtered),
      viaCard: _sortBeneficiaries(filtered),
      sameBank: const [],
      otherBank: const [],
      disabled: disabled,
    );
  }

  /// Helper: Filter by transfer type
  List<BeneficiaryModel> _filterByType(
    List<BeneficiaryModel> beneficiaries,
    TransferType type,
  ) {
    return beneficiaries.where((b) => b.transferType == type).toList();
  }

  /// Helper: Sort beneficiaries alphabetically by name
  List<BeneficiaryModel> _sortBeneficiaries(List<BeneficiaryModel> list) {
    final sorted = List<BeneficiaryModel>.from(list);
    sorted.sort((a, b) => a.name.compareTo(b.name));
    return sorted;
  }

  /// Search beneficiaries by query
  List<BeneficiaryModel> searchBeneficiaries(
    List<BeneficiaryModel> beneficiaries,
    String query,
  ) {
    final normalizedQuery = query.trim().toLowerCase();

    if (normalizedQuery.isEmpty) {
      return beneficiaries;
    }

    return beneficiaries.where((b) {
      final name = b.name.toLowerCase();
      final account = b.accountNumber.toLowerCase();
      final bankName = b.bankName?.toLowerCase() ?? '';
      final branch = b.branch?.toLowerCase() ?? '';

      return name.contains(normalizedQuery) ||
          account.contains(normalizedQuery) ||
          bankName.contains(normalizedQuery) ||
          branch.contains(normalizedQuery);
    }).toList();
  }
}

/// Result of beneficiary filtering
class BeneficiaryFilterResult {
  const BeneficiaryFilterResult({
    required this.filtered,
    required this.viaCard,
    required this.sameBank,
    required this.otherBank,
    required this.disabled,
  });

  final List<BeneficiaryModel> filtered;
  final List<BeneficiaryModel> viaCard;
  final List<BeneficiaryModel> sameBank;
  final List<BeneficiaryModel> otherBank;
  final Map<String, String> disabled;
}
