import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:banking_app/features/transfer/models/transfer_model.dart';
import 'package:banking_app/features/transfer/repositories/transfer_repository.dart';
import 'package:banking_app/core/security/error_sanitizer.dart';
import 'package:banking_app/features/transactions/models/transaction_model.dart';
import 'package:banking_app/core/services/biometric_service.dart';

import 'transfer_event.dart';
import 'transfer_state.dart';

class TransferBloc extends Bloc<TransferEvt, TransferState> {
  final TransferRepository transferRepo;
  final BiometricService biometricService;

  TransferBloc({required this.transferRepo, required this.biometricService})
    : super(const TransferState(status: TransferStatus.initial())) {
    on<TransferInitializeEvt>(_onTransferInitialize);
    on<BeneficiariesInitializeEvt>(_onBeneficiariesInitialize);
    on<SelectAccountEvt>(_onSelectAccount);
    on<SelectCardEvt>(_onSelectCard);
    on<SelectTransferTypeEvt>(_onSelectTransferType);
    on<SelectBeneficiaryEvt>(_onSelectBeneficiary);
    on<SelectBankEvt>(_onSelectBank);
    on<SelectBranchEvt>(_onSelectBranch);
    on<AddNewBeneficiaryEvt>(_onAddNewBeneficiary);
    on<UpdateTransferDetailsEvt>(_onUpdateTransferForm);
    on<FillTransferDetailsEvt>(_onFillTransferDetails);
    on<SearchBeneficiaryEvt>(_onSearchBeneficiaries);
    on<CalculateTransactionFeeEvt>(_onCalculateTransactionFee);
    on<ConfirmTransferEvt>(_onConfirmTransfer);
    on<SendOtpEvt>(_onSendOtp);
    on<ConfirmTransferWithOtpEvt>(_onConfirmTransferWithOtp);
    on<ConfirmWithBiometricEvt>(_onConfirmWithBiometric);
  }

  /// Load initial data: beneficiaries, banks, branches, accounts, cards
  /// Also checks biometric availability
  Future<void> _onTransferInitialize(
    TransferInitializeEvt event,
    Emitter<TransferState> emit,
  ) async {
    emit(state.copyWith(status: const TransferStatus.loading()));
    try {
      final beneficiaries = await transferRepo.fetchBeneficiaries();
      final banks = await transferRepo.fetchBanks();
      final branches = await transferRepo.fetchBranchs();
      final accounts = await transferRepo.fetchAccounts();
      final cards = await transferRepo.fetchCards();
      final biometricAvailable = await biometricService.canCheckBiometrics();
      final biometricEnabled = await biometricService.isBiometricEnabled();

      /// Emit loaded data
      emit(
        state.copyWith(
          status: const TransferStatus.initial(),
          beneficiaries: beneficiaries,
          banks: banks,
          branches: branches,
          beneficiariesFiltered: beneficiaries,
          accounts: accounts,
          cards: cards,
          biometricAvailable: biometricAvailable,
          biometricEnabled: biometricEnabled,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const TransferStatus.initial(),
          errorMessage: 'Failed to load initial data: ${e.toString()}',
        ),
      );
    }
  }

  /// Initialize beneficiaries from event
  Future<void> _onBeneficiariesInitialize(
    BeneficiariesInitializeEvt event,
    Emitter<TransferState> emit,
  ) async {
    emit(
      state.copyWith(
        beneficiaries: event.beneficiaries,
        banks: event.banks,
        beneficiariesFiltered: event.beneficiaries,
      ),
    );
  }

  /// Select account
  void _onSelectAccount(SelectAccountEvt event, Emitter<TransferState> emit) {
    emit(state.copyWith(selectedAccount: event.account, clearCard: true));
    _recalculateFeeIfNeeded();
  }

  /// Select card
  void _onSelectCard(SelectCardEvt event, Emitter<TransferState> emit) {
    emit(state.copyWith(selectedCard: event.card, clearAccount: true));
    _recalculateFeeIfNeeded();
  }

  /// Select transfer type
  void _onSelectTransferType(
    SelectTransferTypeEvt event,
    Emitter<TransferState> emit,
  ) {
    emit(state.copyWith(selectedTransferType: event.transferType));
    _recalculateFeeIfNeeded();
  }

  /// Select beneficiary
  void _onSelectBeneficiary(
    SelectBeneficiaryEvt event,
    Emitter<TransferState> emit,
  ) {
    emit(state.copyWith(selectedBeneficiary: event.beneficiary));
    _recalculateFeeIfNeeded();
  }

  /// Select bank
  void _onSelectBank(SelectBankEvt event, Emitter<TransferState> emit) {
    emit(state.copyWith(selectedBank: event.bank, selectedBranch: null));
  }

  /// Select branch
  void _onSelectBranch(SelectBranchEvt event, Emitter<TransferState> emit) {
    emit(state.copyWith(selectedBranch: event.branch));
  }

  /// Add new beneficiary
  Future<void> _onAddNewBeneficiary(
    AddNewBeneficiaryEvt event,
    Emitter<TransferState> emit,
  ) async {
    emit(state.copyWith(status: const TransferStatus.loading()));
    try {
      final result = await transferRepo.addNewBeneficiary(event.beneficiary);
      emit(
        state.copyWith(
          status: const TransferStatus.success(),
          newBeneficiary: result,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: const TransferStatus.failure()));
    }
  }

  /// Update transfer form
  void _onUpdateTransferForm(
    UpdateTransferDetailsEvt event,
    Emitter<TransferState> emit,
  ) {
    emit(
      state.copyWith(
        amount: event.amount ?? state.amount,
        content: event.content ?? state.content,
        saveToDirectory: event.saveToDirectory ?? state.saveToDirectory,
        selectedBank: event.bank ?? state.selectedBank,
        selectedBranch: event.branch ?? state.selectedBranch,
        name: event.name ?? state.name,
        avatarUrl: event.avatarUrl ?? state.avatarUrl,
      ),
    );
    if (event.amount != null) _recalculateFeeIfNeeded();
  }

  /// Fill transfer details
  void _onFillTransferDetails(
    FillTransferDetailsEvt event,
    Emitter<TransferState> emit,
  ) {
    emit(state.copyWith(amount: event.amount, content: event.content));
    _recalculateFeeIfNeeded();
  }

  /// Search beneficiaries
  void _onSearchBeneficiaries(
    SearchBeneficiaryEvt event,
    Emitter<TransferState> emit,
  ) {
    final query = event.query.trim().toLowerCase();

    if (query.isEmpty) {
      emit(
        state.copyWith(
          searchQuery: '',
          beneficiariesFiltered: state.beneficiaries,
        ),
      );
      return;
    }

    final filtered = state.beneficiaries.where((b) {
      final name = b.name.toLowerCase();
      final account = b.accountNumber.toLowerCase();
      final bankName = b.bankName?.toLowerCase() ?? '';
      final branch = b.branch?.toLowerCase() ?? '';
      return name.contains(query) ||
          account.contains(query) ||
          bankName.contains(query) ||
          branch.contains(query);
    }).toList();

    emit(
      state.copyWith(searchQuery: event.query, beneficiariesFiltered: filtered),
    );
  }

  /// Calculate transaction fee
  Future<void> _onCalculateTransactionFee(
    CalculateTransactionFeeEvt event,
    Emitter<TransferState> emit,
  ) async {
    emit(state.copyWith(status: const TransferStatus.loading()));
    try {
      final request = TransferModel(
        fromAccount: state.selectedAccount,
        fromCard: state.selectedCard,
        toBeneficiary: state.selectedBeneficiary,
        amount: state.amount,
        transactionFee: 0,
        content: state.content ?? '',
        transferType: state.selectedTransferType,
      );

      final fee = await transferRepo.calculateFee(request);
      emit(
        state.copyWith(
          transactionFee: fee.fee,
          status: const TransferStatus.initial(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const TransferStatus.failure(),
          errorMessage: ErrorSanitizer.sanitize(e),
        ),
      );
    }
  }

  /// Confirm transfer
  Future<void> _onConfirmTransfer(
    ConfirmTransferEvt event,
    Emitter<TransferState> emit,
  ) async {
    emit(state.copyWith(status: const TransferStatus.loading()));

    try {
      final transferRequest = TransferModel(
        fromAccount: state.selectedAccount,
        fromCard: state.selectedCard,
        toBeneficiary: state.selectedBeneficiary,
        amount: state.amount ?? 0,
        transactionFee: state.transactionFee,
        content: state.content ?? '',
        transferType: state.selectedTransferType,
      );

      final result = await transferRepo.initiateTransfer(transferRequest);

      /// Check null & transferId
      if (result.transferId.isEmpty) {
        emit(
          state.copyWith(
            status: const TransferStatus.failure(),
            errorMessage:
                'Transfer initiation failed: invalid response from server.',
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
                state.selectedAccount?.userId ??
                state.selectedCard?.userId ??
                '',
            amount: state.amount ?? 0,
            type: state.selectedTransferType,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const TransferStatusFailure(),
          errorMessage: ErrorSanitizer.sanitize(e),
        ),
      );
    }
  }

  /// Send OTP
  Future<void> _onSendOtp(SendOtpEvt event, Emitter<TransferState> emit) async {
    emit(state.copyWith(status: const TransferStatus.loading()));
    try {
      await transferRepo.sendOtpEmail(event.transferId);
      emit(
        state.copyWith(
          otpSent: true,
          status: const TransferStatus.awaitingOtp(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const TransferStatus.failure(),
          errorMessage: ErrorSanitizer.sanitize(e),
        ),
      );
    }
  }

  /// Confirm transfer with OTP
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

      if (isValid) {
        // Complete the transfer after OTP verification
        final result = await transferRepo.confirmTransfer(
          state.transferId ?? '',
          event.otpCode,
        );

        if (result) {
          emit(
            state.copyWith(
              status: const TransferStatus.success(),
              otpSent: false,
              errorMessage: null,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: const TransferStatus.failure(),
              errorMessage: 'Transfer confirmation failed.',
            ),
          );
        }
      } else {
        emit(
          state.copyWith(
            status: const TransferStatus.failure(),
            errorMessage: 'Invalid OTP code.',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: const TransferStatus.failure(),
          errorMessage: 'OTP verification failed: ${e.toString()}',
        ),
      );
    }
  }

  /// Confirm with biometric
  Future<void> _onConfirmWithBiometric(
    ConfirmWithBiometricEvt event,
    Emitter<TransferState> emit,
  ) async {
    emit(state.copyWith(status: const TransferStatus.loading()));

    try {
      final canAuth = await biometricService.authenticate();

      if (!canAuth) {
        emit(
          state.copyWith(
            status: const TransferStatus.failure(),
            errorMessage: 'Biometric authentication failed.',
          ),
        );
        return;
      }

      // Complete the transfer with biometric authentication
      final result = await transferRepo.confirmTransfer(
        state.transferId ?? '',
        'BIOMETRIC_AUTH',
      );

      if (result) {
        emit(
          state.copyWith(
            status: const TransferStatus.success(),
            errorMessage: null,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: const TransferStatus.failure(),
            errorMessage: 'Transfer confirmation failed.',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: const TransferStatus.failure(),
          errorMessage: 'Biometric confirm error: ${e.toString()}',
        ),
      );
    }
  }

  /// Recalculate fee
  void _recalculateFeeIfNeeded() {
    if ((state.selectedAccount != null || state.selectedCard != null) &&
        state.selectedBeneficiary != null &&
        state.amount != null &&
        state.amount! > 0) {
      add(CalculateTransactionFeeEvt());
    }
  }
}
