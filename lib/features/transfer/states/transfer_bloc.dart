import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:banking_app/features/transfer/models/transfer_model.dart';
import 'package:banking_app/features/transfer/models/beneficiary_model.dart';
import 'package:banking_app/features/transfer/models/bank_model.dart';
import 'package:banking_app/features/transfer/models/branch_model.dart';
import 'package:banking_app/features/transfer/repositories/transfer_repository.dart';
import 'package:banking_app/core/bloc/base_bloc.dart';
import 'package:banking_app/features/transactions/models/transaction_model.dart';
import 'package:banking_app/features/home/models/account_model.dart';
import 'package:banking_app/features/home/models/card_model.dart';
import 'package:banking_app/core/services/biometric_service.dart';

import 'transfer_event.dart';
import 'transfer_state.dart';

class TransferBloc extends BaseBloc<TransferEvt, TransferState> {
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

    final result = await executeWithErrorHandling(
      () async {
        final beneficiaries = await transferRepo.fetchBeneficiaries();
        final banks = await transferRepo.fetchBanks();
        final branches = await transferRepo.fetchBranchs();
        final accounts = await transferRepo.fetchAccounts();
        final cards = await transferRepo.fetchCards();
        final biometricAvailable = await biometricService.canCheckBiometrics();
        final biometricEnabled = await biometricService.isBiometricEnabled();

        return {
          'beneficiaries': beneficiaries,
          'banks': banks,
          'branches': branches,
          'accounts': accounts,
          'cards': cards,
          'biometricAvailable': biometricAvailable,
          'biometricEnabled': biometricEnabled,
        };
      },
      operationName: 'transfer_initialize',
      isCritical: true,
      context: {'event_type': 'TransferInitializeEvt'},
    );

    if (result != null) {
      emit(
        state.copyWith(
          status: const TransferStatus.initial(),
          beneficiaries: result['beneficiaries'] as List<BeneficiaryModel>,
          banks: result['banks'] as List<BankModel>,
          branches: result['branches'] as List<BranchModel>,
          beneficiariesFiltered:
              result['beneficiaries'] as List<BeneficiaryModel>,
          accounts: result['accounts'] as List<AccountModel>,
          cards: result['cards'] as List<CardModel>,
          biometricAvailable: result['biometricAvailable'] as bool,
          biometricEnabled: result['biometricEnabled'] as bool,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: const TransferStatus.failure(),
          errorMessage: 'Failed to load initial data',
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

    final result = await executeWithErrorHandling(
      () async => await transferRepo.addNewBeneficiary(event.beneficiary),
      operationName: 'add_new_beneficiary',
      isCritical: false,
      context: {
        'beneficiary_name': event.beneficiary.name,
        'account_number': event.beneficiary.accountNumber,
      },
    );

    if (result != null) {
      emit(
        state.copyWith(
          status: const TransferStatus.success(),
          newBeneficiary: result,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: const TransferStatus.failure(),
          errorMessage: 'Failed to add beneficiary',
        ),
      );
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

    final result = await executeWithErrorHandling(
      () async {
        final request = TransferModel(
          fromAccount: state.selectedAccount,
          fromCard: state.selectedCard,
          toBeneficiary: state.selectedBeneficiary,
          amount: state.amount,
          transactionFee: 0,
          content: state.content ?? '',
          transferType: state.selectedTransferType,
        );

        return await transferRepo.calculateFee(request);
      },
      operationName: 'calculate_transaction_fee',
      isCritical: false,
      context: {
        'amount': state.amount,
        'transfer_type': state.selectedTransferType.name,
        'has_account': state.selectedAccount != null,
        'has_card': state.selectedCard != null,
      },
    );

    if (result != null) {
      emit(
        state.copyWith(
          transactionFee: result.fee,
          status: const TransferStatus.initial(),
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: const TransferStatus.failure(),
          errorMessage: 'Failed to calculate transaction fee',
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

    final result = await executeWithErrorHandling(
      () async {
        final transferRequest = TransferModel(
          fromAccount: state.selectedAccount,
          fromCard: state.selectedCard,
          toBeneficiary: state.selectedBeneficiary,
          amount: state.amount ?? 0,
          transactionFee: state.transactionFee,
          content: state.content ?? '',
          transferType: state.selectedTransferType,
        );

        return await transferRepo.initiateTransfer(transferRequest);
      },
      operationName: 'confirm_transfer',
      isCritical: true,
      context: {
        'amount': state.amount,
        'transfer_type': state.selectedTransferType.name,
        'has_account': state.selectedAccount != null,
        'has_card': state.selectedCard != null,
      },
    );

    if (result != null) {
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
    } else {
      emit(
        state.copyWith(
          status: const TransferStatus.failure(),
          errorMessage: 'Transfer confirmation failed',
        ),
      );
    }
  }

  /// Send OTP
  Future<void> _onSendOtp(SendOtpEvt event, Emitter<TransferState> emit) async {
    emit(state.copyWith(status: const TransferStatus.loading()));

    try {
      await executeWithErrorHandling(
        () async => await transferRepo.sendOtpEmail(event.transferId),
        operationName: 'send_otp',
        isCritical: false,
        context: {'transfer_id': event.transferId},
      );

      // OTP sending doesn't return a value, so we assume success if no exception was thrown
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
          errorMessage: 'Failed to send OTP',
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

    final result = await executeWithErrorHandling(
      () async {
        final isValid = await transferRepo.verifyOTP(
          state.transferId ?? '',
          event.otpCode,
        );

        if (isValid) {
          // Complete the transfer after OTP verification
          return await transferRepo.confirmTransfer(
            state.transferId ?? '',
            event.otpCode,
          );
        } else {
          throw Exception('Invalid OTP code');
        }
      },
      operationName: 'confirm_transfer_with_otp',
      isCritical: true,
      context: {
        'transfer_id': state.transferId,
        'has_otp': event.otpCode.isNotEmpty,
      },
    );

    if (result != null && result == true) {
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
          errorMessage: result == false
              ? 'Transfer confirmation failed'
              : 'Invalid OTP code',
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

    final result = await executeWithErrorHandling(
      () async {
        final canAuth = await biometricService.authenticate();

        if (!canAuth) {
          throw Exception('Biometric authentication failed');
        }

        // Complete the transfer with biometric authentication
        return await transferRepo.confirmTransfer(
          state.transferId ?? '',
          'BIOMETRIC_AUTH',
        );
      },
      operationName: 'confirm_with_biometric',
      isCritical: true,
      context: {'transfer_id': state.transferId, 'auth_method': 'biometric'},
    );

    if (result != null && result == true) {
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
          errorMessage: result == false
              ? 'Transfer confirmation failed'
              : 'Biometric authentication failed',
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

  @override
  String? getCurrentUserId() {
    return state.selectedAccount?.userId ?? state.selectedCard?.userId;
  }
}
