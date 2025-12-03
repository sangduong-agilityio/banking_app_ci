import 'package:banking_app/features/transfer/data/models/bank_model.dart';
import 'package:banking_app/features/transfer/data/models/beneficiary_model.dart';
import 'package:banking_app/features/transfer/data/models/branch_model.dart';
import 'package:banking_app/features/transfer/data/models/transfer_model.dart';
import 'package:banking_app/features/transfer/data/repositories/transfer_repository.dart';
import 'package:banking_app/features/transfer/domain/services/beneficiary_filter_service.dart';
import 'package:banking_app/features/transfer/domain/services/transfer_fee_service.dart';
import 'package:banking_app/features/transfer/domain/services/transfer_validation_service.dart';
import 'package:banking_app/core/common/bloc/base_bloc.dart';
import 'package:banking_app/features/transactions/data/models/transaction_model.dart';
import 'package:banking_app/core/data/services/biometric_service.dart';
import 'package:banking_app/core/error_handling/transfer_exceptions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'transfer_event.dart';
import 'transfer_state.dart';

class TransferBloc extends BaseBloc<TransferEvt, TransferState> {
  TransferBloc({
    required this.transferRepo,
    required this.biometricService,
    BeneficiaryFilterService? filterService,
    TransferFeeService? feeService,
    TransferValidationService? validationService,
  }) : _filterService = filterService ?? const BeneficiaryFilterService(),
       _feeService = feeService ?? TransferFeeService(transferRepo),
       _validationService =
           validationService ?? const TransferValidationService(),
       super(const TransferState()) {
    on<TransferInitializeEvt>(_onTransferInitialize);
    on<BeneficiariesInitializeEvt>(_onBeneficiariesInitialize);
    on<SelectAccountEvt>(_onSelectAccount);
    on<SelectCardEvt>(_onSelectCard);
    on<SelectTransferTypeEvt>(_onSelectTransferType);
    on<SelectBeneficiaryEvt>(_onSelectBeneficiary);
    on<SelectBankEvt>(_onSelectBank);
    on<SelectBranchEvt>(_onSelectBranch);
    on<AddNewBeneficiaryEvt>(_onAddNewBeneficiary);
    on<UpdateTransferDetailsEvt>(_onUpdateTransferDetails);
    on<FillTransferDetailsEvt>(_onFillTransferDetails);
    on<SearchBeneficiaryEvt>(_onSearchBeneficiaries);
    on<CalculateTransactionFeeEvt>(_onCalculateTransactionFee);
    on<ConfirmTransferEvt>(_onConfirmTransfer);
    on<SendOtpEvt>(_onSendOtp);
    on<ConfirmTransferWithOtpEvt>(_onConfirmTransferWithOtp);
    on<ConfirmWithBiometricEvt>(_onConfirmWithBiometric);
    on<OtpChangedEvt>(_onOtpChanged);
    on<BiometricErrorMessageEvt>(_onClearErrorMessage);
    on<ReorderBeneficiaryEvt>(_onReorderBeneficiary);
  }

  final TransferRepository transferRepo;
  final BiometricService biometricService;
  final BeneficiaryFilterService _filterService;
  final TransferFeeService _feeService;
  final TransferValidationService _validationService;

  // ==================== INITIALIZATION ====================

  Future<void> _onTransferInitialize(
    TransferInitializeEvt event,
    Emitter<TransferState> emit,
  ) async {
    emit(state.copyWith(status: const TransferStatus.loading()));

    final criticalResult = await executeWithErrorHandling<Map<String, dynamic>>(
      () async {
        final (accounts, cards, beneficiaries) = await (
          transferRepo.fetchAccounts(),
          transferRepo.fetchCards(),
          transferRepo.fetchBeneficiaries(),
        ).wait;

        return {
          'accounts': accounts,
          'cards': cards,
          'beneficiaries': beneficiaries,
        };
      },
      operationName: 'transfer_initialize_phase1',
      isCritical: true,
      context: {'phase': 'critical'},
    );

    if (criticalResult == null) {
      emit(
        state.copyWith(
          status: const TransferStatus.failure(),
          errorMessage: S.current.transferErrorLoadInitialData,
        ),
      );
      return;
    }

    // Emit partial state - UI renders immediately
    final beneficiaries =
        criticalResult['beneficiaries'] as List<BeneficiaryModel>;
    final filterResult = _filterService.filterBeneficiaries(
      allBeneficiaries: beneficiaries,
      selectedTransferType: state.selectedTransferType,
    );

    emit(
      state.copyWith(
        status: const TransferStatus.initial(),
        accounts: criticalResult['accounts'],
        cards: criticalResult['cards'],
        beneficiaries: beneficiaries,
        filteredBeneficiaries: filterResult.filtered,
        viaCardBeneficiaries: filterResult.viaCard,
        sameBankBeneficiaries: filterResult.sameBank,
        otherBankBeneficiaries: filterResult.otherBank,
        disabledBeneficiaries: filterResult.disabled,
      ),
    );

    // Load secondary data in background (banks, branches, biometric)
    // These are only needed for specific transfer types
    final secondaryResult =
        await executeWithErrorHandling<Map<String, dynamic>>(
          () async {
            final (
              banks,
              branches,
              biometricAvailable,
              biometricEnabled,
            ) = await (
              transferRepo.fetchBanks(),
              transferRepo.fetchBranches(),
              biometricService.canCheckBiometrics(),
              biometricService.isBiometricEnabled(),
            ).wait;

            return {
              'banks': banks,
              'branches': branches,
              'biometricAvailable': biometricAvailable,
              'biometricEnabled': biometricEnabled,
            };
          },
          operationName: 'transfer_initialize_phase2',
          isCritical: false,
          context: {'phase': 'secondary'},
        );

    // Update with secondary data (if successful)
    if (secondaryResult != null) {
      emit(
        state.copyWith(
          banks: secondaryResult['banks'] as List<BankModel>,
          branches: secondaryResult['branches'] as List<BranchModel>,
          biometricAvailable: secondaryResult['biometricAvailable'] as bool,
          biometricEnabled: secondaryResult['biometricEnabled'] as bool,
        ),
      );
    }
  }

  void _onBeneficiariesInitialize(
    BeneficiariesInitializeEvt event,
    Emitter<TransferState> emit,
  ) {
    final filterResult = _filterService.filterBeneficiaries(
      allBeneficiaries: event.beneficiaries,
      selectedTransferType: state.selectedTransferType,
      selectedAccount: state.selectedAccount,
      selectedCard: state.selectedCard,
    );

    emit(
      state.copyWith(
        beneficiaries: event.beneficiaries,
        banks: event.banks,
        filteredBeneficiaries: filterResult.filtered,
        viaCardBeneficiaries: filterResult.viaCard,
        sameBankBeneficiaries: filterResult.sameBank,
        otherBankBeneficiaries: filterResult.otherBank,
        disabledBeneficiaries: filterResult.disabled,
      ),
    );
  }

  // ==================== SELECTION HANDLERS ====================

  Future<void> _onSelectAccount(
    SelectAccountEvt event,
    Emitter<TransferState> emit,
  ) async {
    final limit = await _feeService.fetchTransactionLimit(
      account: event.account,
    );
    final filterResult = _filterService.filterBeneficiaries(
      allBeneficiaries: state.beneficiaries,
      selectedTransferType: state.selectedTransferType,
      selectedAccount: event.account,
    );

    emit(
      state.copyWith(
        selectedAccount: event.account,
        clearCard: true,
        transactionLimit: limit,
        filteredBeneficiaries: filterResult.filtered,
        viaCardBeneficiaries: filterResult.viaCard,
        sameBankBeneficiaries: filterResult.sameBank,
        otherBankBeneficiaries: filterResult.otherBank,
        disabledBeneficiaries: filterResult.disabled,
      ),
    );

    // Calculate fee if needed
    if (_shouldCalculateFee()) {
      await _calculateFeeDirectly(emit);
    }
  }

  Future<void> _onSelectCard(
    SelectCardEvt event,
    Emitter<TransferState> emit,
  ) async {
    final limit = await _feeService.fetchTransactionLimit(card: event.card);
    final filterResult = _filterService.filterBeneficiaries(
      allBeneficiaries: state.beneficiaries,
      selectedTransferType: TransferType.cardNumber,
      selectedCard: event.card,
    );

    final needsTypeChange =
        state.selectedTransferType == TransferType.sameBank ||
        state.selectedTransferType == TransferType.otherBank;

    emit(
      state.copyWith(
        selectedCard: event.card,
        clearAccount: true,
        selectedTransferType: needsTypeChange ? TransferType.cardNumber : null,
        transactionLimit: limit,
        filteredBeneficiaries: filterResult.filtered,
        viaCardBeneficiaries: filterResult.viaCard,
        sameBankBeneficiaries: filterResult.sameBank,
        otherBankBeneficiaries: filterResult.otherBank,
        disabledBeneficiaries: filterResult.disabled,
      ),
    );

    // Calculate fee if needed
    if (_shouldCalculateFee()) {
      await _calculateFeeDirectly(emit);
    }
  }

  Future<void> _onSelectTransferType(
    SelectTransferTypeEvt event,
    Emitter<TransferState> emit,
  ) async {
    final filterResult = _filterService.filterBeneficiaries(
      allBeneficiaries: state.beneficiaries,
      selectedTransferType: event.transferType,
      selectedAccount: state.selectedAccount,
      selectedCard: state.selectedCard,
    );

    emit(
      state.copyWith(
        selectedTransferType: event.transferType,
        filteredBeneficiaries: filterResult.filtered,
        viaCardBeneficiaries: filterResult.viaCard,
        sameBankBeneficiaries: filterResult.sameBank,
        otherBankBeneficiaries: filterResult.otherBank,
        disabledBeneficiaries: filterResult.disabled,
      ),
    );

    // Calculate fee if needed
    if (_shouldCalculateFee()) {
      await _calculateFeeDirectly(emit);
    }
  }

  Future<void> _onSelectBeneficiary(
    SelectBeneficiaryEvt event,
    Emitter<TransferState> emit,
  ) async {
    emit(state.copyWith(selectedBeneficiary: event.beneficiary));
    // Calculate fee if needed
    if (_shouldCalculateFee()) {
      await _calculateFeeDirectly(emit);
    }
  }

  void _onSelectBank(SelectBankEvt event, Emitter<TransferState> emit) {
    emit(state.copyWith(selectedBank: event.bank));
  }

  void _onSelectBranch(SelectBranchEvt event, Emitter<TransferState> emit) {
    emit(state.copyWith(selectedBranch: event.branch));
  }

  // ==================== BENEFICIARY MANAGEMENT ====================

  Future<void> _onAddNewBeneficiary(
    AddNewBeneficiaryEvt event,
    Emitter<TransferState> emit,
  ) async {
    emit(state.copyWith(status: const TransferStatus.loading()));

    final result = await executeWithErrorHandling(
      () => transferRepo.addNewBeneficiary(event.beneficiary),
      operationName: 'add_new_beneficiary',
      isCritical: false,
      context: {'beneficiary_id': event.beneficiary.id},
    );

    if (result != null) {
      final updatedList = [...state.beneficiaries, result];
      final filterResult = _filterService.filterBeneficiaries(
        allBeneficiaries: updatedList,
        selectedTransferType: state.selectedTransferType,
        selectedAccount: state.selectedAccount,
        selectedCard: state.selectedCard,
      );

      emit(
        state.copyWith(
          status: const TransferStatus.initial(),
          beneficiaries: updatedList,
          filteredBeneficiaries: filterResult.filtered,
          viaCardBeneficiaries: filterResult.viaCard,
          sameBankBeneficiaries: filterResult.sameBank,
          otherBankBeneficiaries: filterResult.otherBank,
          disabledBeneficiaries: filterResult.disabled,
          newBeneficiary: result,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: const TransferStatus.failure(),
          errorMessage: S.current.transferErrorAddBeneficiary,
        ),
      );
    }
  }

  void _onSearchBeneficiaries(
    SearchBeneficiaryEvt event,
    Emitter<TransferState> emit,
  ) {
    final filtered = _filterService.searchBeneficiaries(
      state.beneficiaries,
      event.query,
    );

    emit(
      state.copyWith(searchQuery: event.query, filteredBeneficiaries: filtered),
    );
  }

  Future<void> _onReorderBeneficiary(
    ReorderBeneficiaryEvt event,
    Emitter<TransferState> emit,
  ) async {
    // Validate indices
    if (event.oldIndex < 0 ||
        event.oldIndex >= state.beneficiaries.length ||
        event.newIndex < 0 ||
        event.newIndex >= state.beneficiaries.length) {
      return;
    }

    // Store original state for rollback on failure
    final originalBeneficiaries = state.beneficiaries;
    final originalFiltered = state.filteredBeneficiaries;
    final originalViaCard = state.viaCardBeneficiaries;
    final originalSameBank = state.sameBankBeneficiaries;
    final originalOtherBank = state.otherBankBeneficiaries;
    final originalDisabled = state.disabledBeneficiaries;

    // Optimistic update: apply reorder immediately for responsive UI
    final reordered = List<BeneficiaryModel>.from(state.beneficiaries);
    final item = reordered.removeAt(event.oldIndex);
    reordered.insert(event.newIndex, item);

    // Re-filter after reordering to keep UI consistent
    final filterResult = _filterService.filterBeneficiaries(
      allBeneficiaries: reordered,
      selectedTransferType: state.selectedTransferType,
      selectedAccount: state.selectedAccount,
      selectedCard: state.selectedCard,
    );

    // Emit optimistic state
    emit(
      state.copyWith(
        beneficiaries: reordered,
        filteredBeneficiaries: filterResult.filtered,
        viaCardBeneficiaries: filterResult.viaCard,
        sameBankBeneficiaries: filterResult.sameBank,
        otherBankBeneficiaries: filterResult.otherBank,
        disabledBeneficiaries: filterResult.disabled,
      ),
    );

    // Persist to repository with rollback on failure
    try {
      await executeWithErrorHandling(
        () => transferRepo.saveBeneficiaryOrder(reordered),
        operationName: 'reorder_beneficiary',
        isCritical: false,
        context: {'old_index': event.oldIndex, 'new_index': event.newIndex},
      );
    } catch (e) {
      // Rollback to original state on persistence failure
      emit(
        state.copyWith(
          beneficiaries: originalBeneficiaries,
          filteredBeneficiaries: originalFiltered,
          viaCardBeneficiaries: originalViaCard,
          sameBankBeneficiaries: originalSameBank,
          otherBankBeneficiaries: originalOtherBank,
          disabledBeneficiaries: originalDisabled,
        ),
      );
    }
  }

  // ==================== FORM UPDATES ====================

  Future<void> _onUpdateTransferDetails(
    UpdateTransferDetailsEvt event,
    Emitter<TransferState> emit,
  ) async {
    emit(
      state.copyWith(
        amount: event.amount ?? state.amount,
        content: event.content ?? state.content,
        saveToDirectory: event.saveToDirectory ?? state.saveToDirectory,
        selectedBank: event.bank ?? state.selectedBank,
        selectedBranch: event.branch ?? state.selectedBranch,
        name: event.name ?? state.name,
        cardNumber: event.cardNumber ?? state.cardNumber,
        avatarUrl: event.avatarUrl ?? state.avatarUrl,
        clearForm: event.clearForm ?? state.clearForm,
      ),
    );

    //Calculate fee directly if amount changed (instead of triggering event)
    if (event.amount != null && _shouldCalculateFee()) {
      await _calculateFeeDirectly(emit);
    }
  }

  Future<void> _onFillTransferDetails(
    FillTransferDetailsEvt event,
    Emitter<TransferState> emit,
  ) async {
    emit(state.copyWith(amount: event.amount, content: event.content));
    // Calculate fee directly
    if (_shouldCalculateFee()) {
      await _calculateFeeDirectly(emit);
    }
  }

  // Helper: Check if fee calculation is needed
  bool _shouldCalculateFee() {
    return _feeService.shouldRecalculateFee(
      hasSource: state.selectedAccount != null || state.selectedCard != null,
      hasBeneficiary: state.selectedBeneficiary != null,
      amount: state.amount,
    );
  }

  // Helper: Calculate fee and emit state
  Future<void> _calculateFeeDirectly(Emitter<TransferState> emit) async {
    final transferRequest = TransferModel(
      fromAccount: state.selectedAccount,
      fromCard: state.selectedCard,
      toBeneficiary: state.selectedBeneficiary,
      amount: state.amount ?? 0,
      transactionFee: 0,
      content: state.content ?? '',
      transferType: state.selectedTransferType,
    );

    final fee = await executeWithErrorHandling(
      () => _feeService.calculateFee(transferRequest),
      operationName: 'calculate_fee_inline',
      isCritical: false,
      context: {'amount': state.amount},
    );

    if (fee != null) {
      emit(state.copyWith(transactionFee: fee));
    }
  }

  // ==================== FEE CALCULATION ====================

  Future<void> _onCalculateTransactionFee(
    CalculateTransactionFeeEvt event,
    Emitter<TransferState> emit,
  ) async {
    emit(state.copyWith(status: const TransferStatus.loading()));

    final transferRequest = TransferModel(
      fromAccount: state.selectedAccount,
      fromCard: state.selectedCard,
      toBeneficiary: state.selectedBeneficiary,
      amount: state.amount ?? 0,
      transactionFee: 0,
      content: state.content ?? '',
      transferType: state.selectedTransferType,
    );

    final fee = await executeWithErrorHandling(
      () => _feeService.calculateFee(transferRequest),
      operationName: 'calculate_transaction_fee',
      isCritical: false,
      context: {
        'amount': state.amount,
        'transfer_type': state.selectedTransferType.name,
      },
    );

    if (fee != null) {
      emit(
        state.copyWith(
          transactionFee: fee,
          status: const TransferStatus.initial(),
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: const TransferStatus.failure(),
          errorMessage: S.current.transferErrorCalculateFee,
        ),
      );
    }
  }

  // ==================== TRANSFER CONFIRMATION ====================

  Future<void> _onConfirmTransfer(
    ConfirmTransferEvt event,
    Emitter<TransferState> emit,
  ) async {
    final validation = _validationService.validateForConfirmation(
      selectedAccount: state.selectedAccount,
      selectedCard: state.selectedCard,
      selectedBeneficiary: state.selectedBeneficiary,
      amount: state.amount,
      transactionLimit: state.transactionLimit,
    );

    if (!validation.isValid) {
      emit(
        state.copyWith(
          status: const TransferStatus.failure(),
          errorMessage: validation.errorMessage,
        ),
      );
      return;
    }

    emit(state.copyWith(status: const TransferStatus.loading()));

    final transferRequest = TransferModel(
      fromAccount: state.selectedAccount,
      fromCard: state.selectedCard,
      toBeneficiary: state.selectedBeneficiary,
      amount: state.amount ?? 0,
      transactionFee: state.transactionFee,
      content: state.content ?? '',
      transferType: state.selectedTransferType,
    );

    final result = await executeWithErrorHandling(
      () => transferRepo.initiateTransfer(transferRequest),
      operationName: 'confirm_transfer',
      isCritical: true,
      context: {
        'amount': state.amount,
        'transfer_type': state.selectedTransferType.name,
      },
    );

    if (result == null || result.transferId.isEmpty) {
      emit(
        state.copyWith(
          status: const TransferStatus.failure(),
          errorMessage: S.current.transferErrorNoPendingTransaction,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: const TransferStatus.initial(),
        transferId: result.transferId,
        otpSent: false,
        transaction: TransactionModel(
          id: result.transferId,
          userId:
              state.selectedAccount?.userId ?? state.selectedCard?.userId ?? '',
          amount: state.amount ?? 0,
          type: state.selectedTransferType,
        ),
      ),
    );
  }

  // ==================== AUTHENTICATION ====================

  Future<void> _onSendOtp(SendOtpEvt event, Emitter<TransferState> emit) async {
    emit(state.copyWith(status: const TransferStatus.loading()));

    try {
      await executeWithErrorHandling(
        () => transferRepo.sendOtpEmail(event.transferId),
        operationName: 'send_otp',
        isCritical: false,
        context: {'transfer_id': event.transferId},
      );

      emit(
        state.copyWith(
          otpSent: true,
          status: const TransferStatus.awaitingOtp(),
        ),
      );
    } on OtpSendFailedException catch (e) {
      emit(
        state.copyWith(
          status: const TransferStatus.failure(),
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const TransferStatus.failure(),
          errorMessage: S.current.transferErrorSendOtp,
        ),
      );
    }
  }

  Future<void> _onConfirmTransferWithOtp(
    ConfirmTransferWithOtpEvt event,
    Emitter<TransferState> emit,
  ) async {
    emit(state.copyWith(status: const TransferStatus.loading()));

    try {
      final isValid = await transferRepo.verifyOTP(
        state.transferId ?? '',
        event.otpCode,
      );

      if (!isValid) {
        throw const InvalidOtpException();
      }

      final canUseBiometric = _validationService.canUseBiometric(
        biometricAvailable: state.biometricAvailable,
        biometricEnabled: state.biometricEnabled,
      );

      if (canUseBiometric) {
        emit(state.copyWith(status: const TransferStatus.awaitingBiometric()));
      } else {
        await _completeTransfer(emit, event.otpCode);
      }
    } on InvalidOtpException catch (e) {
      emit(
        state.copyWith(
          status: const TransferStatus.failure(),
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const TransferStatus.failure(),
          errorMessage: S.current.transferErrorUnexpected,
        ),
      );
    }
  }

  Future<void> _onConfirmWithBiometric(
    ConfirmWithBiometricEvt event,
    Emitter<TransferState> emit,
  ) async {
    emit(state.copyWith(status: const TransferStatus.loading()));

    try {
      final canAuth = await biometricService.authenticate();

      if (canAuth) {
        await _completeTransfer(emit, 'BIOMETRIC_AUTH');
      } else {
        emit(
          state.copyWith(
            status: const TransferStatus.awaitingBiometric(),
            errorMessage: S.current.transferErrorBiometricFailed,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: const TransferStatus.failure(),
          errorMessage: S.current.transferErrorBiometricAuthFailed,
        ),
      );
    }
  }

  Future<void> _completeTransfer(
    Emitter<TransferState> emit,
    String authCode,
  ) async {
    final success = await executeWithErrorHandling(
      () => transferRepo.confirmTransfer(state.transferId ?? '', authCode),
      operationName: 'complete_transfer',
      isCritical: true,
      context: {'transfer_id': state.transferId},
    );

    if (success == true) {
      emit(state.copyWith(status: const TransferStatus.success()));
    } else {
      emit(
        state.copyWith(
          status: const TransferStatus.failure(),
          errorMessage: S.current.transferErrorTransferFailed,
        ),
      );
    }
  }

  // ==================== UTILITY ====================

  void _onOtpChanged(OtpChangedEvt event, Emitter<TransferState> emit) {
    emit(state.copyWith(otp: event.otp));
  }

  void _onClearErrorMessage(
    BiometricErrorMessageEvt event,
    Emitter<TransferState> emit,
  ) {
    emit(state.copyWith(errorMessage: null));
  }

  @override
  String? getCurrentUserId() {
    return state.selectedAccount?.userId ?? state.selectedCard?.userId;
  }
}
