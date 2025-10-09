import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:banking_app/features/transfer/models/transfer_model.dart';
import 'package:banking_app/features/transfer/repositories/transfer_repository.dart';
import 'package:banking_app/core/bloc/base_bloc.dart';
import 'package:banking_app/features/transactions/models/transaction_model.dart';
import 'package:banking_app/core/services/biometric_service.dart';
import 'package:banking_app/core/utils/beneficiary_utils.dart';
import 'package:banking_app/core/exceptions/transfer_exceptions.dart';
import 'transfer_event.dart';
import 'transfer_state.dart';

class TransferBloc extends BaseBloc<TransferEvt, TransferState> {
  final TransferRepository transferRepo;
  final BiometricService biometricService;

  TransferBloc({required this.transferRepo, required this.biometricService})
    : super(TransferState(status: TransferStatus.initial())) {
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

  /// Loads the initial data required for the transfer feature.
  Future<void> _onTransferInitialize(
    TransferInitializeEvt event,
    Emitter<TransferState> emit,
  ) async {
    emit(state.copyWith(status: TransferStatus.loading()));

    final result = await executeWithErrorHandling<Map<String, dynamic>>(
      () async {
        final beneficiaries = await transferRepo.fetchBeneficiaries();
        final banks = await transferRepo.fetchBanks();
        final branches = await transferRepo.fetchBranches();
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
          status: TransferStatus.initial(),
          beneficiaries: result['beneficiaries'],
          banks: result['banks'],
          branches: result['branches'],
          filteredBeneficiaries: result['beneficiaries'],
          accounts: result['accounts'],
          cards: result['cards'],
          biometricAvailable: result['biometricAvailable'],
          biometricEnabled: result['biometricEnabled'],
        ),
      );
      _filterBeneficiaries(emit);
    } else {
      emit(
        state.copyWith(
          status: TransferStatus.failure(),
          errorMessage: 'Failed to load initial data',
        ),
      );
    }
  }

  /// Initializes the beneficiaries from the event.
  void _onBeneficiariesInitialize(
    BeneficiariesInitializeEvt event,
    Emitter<TransferState> emit,
  ) {
    emit(
      state.copyWith(
        beneficiaries: event.beneficiaries,
        banks: event.banks,
        filteredBeneficiaries: event.beneficiaries,
      ),
    );
  }

  /// Handles the selection of a bank account.
  void _onSelectAccount(SelectAccountEvt event, Emitter<TransferState> emit) {
    emit(state.copyWith(selectedAccount: event.account, clearCard: true));
    _filterBeneficiaries(emit);
    _recalculateFeeIfNeeded();
  }

  void _filterBeneficiaries(Emitter<TransferState> emit) {
    final userAccount = state.selectedAccount;
    if (userAccount == null) return;

    final effectiveBeneficiaries = state.filteredBeneficiaries.isNotEmpty
        ? state.filteredBeneficiaries
        : state.beneficiaries;

    final viaCard = effectiveBeneficiaries
        .where(
          (b) => getTransferType(b, userAccount) == TransferType.cardNumber,
        )
        .toList();

    final sameBank = effectiveBeneficiaries
        .where((b) => getTransferType(b, userAccount) == TransferType.sameBank)
        .toList();

    final diffBank = effectiveBeneficiaries
        .where((b) => getTransferType(b, userAccount) == TransferType.otherBank)
        .toList();

    emit(
      state.copyWith(
        viaCardBeneficiaries: viaCard,
        sameBankBeneficiaries: sameBank,
        otherBankBeneficiaries: diffBank,
      ),
    );
  }

  /// Handles the selection of a bank card."
  void _onSelectCard(SelectCardEvt event, Emitter<TransferState> emit) {
    emit(state.copyWith(selectedCard: event.card, clearAccount: true));
    _recalculateFeeIfNeeded();
  }

  /// Handles the selection of a transfer type.
  void _onSelectTransferType(
    SelectTransferTypeEvt event,
    Emitter<TransferState> emit,
  ) {
    emit(state.copyWith(selectedTransferType: event.transferType));
    _recalculateFeeIfNeeded();
  }

  /// Handles the selection of a beneficiary.
  void _onSelectBeneficiary(
    SelectBeneficiaryEvt event,
    Emitter<TransferState> emit,
  ) {
    emit(state.copyWith(selectedBeneficiary: event.beneficiary));
    _recalculateFeeIfNeeded();
  }

  /// Handles the selection of a bank.
  void _onSelectBank(SelectBankEvt event, Emitter<TransferState> emit) {
    emit(state.copyWith(selectedBank: event.bank, selectedBranch: null));
  }

  /// Handles the selection of a branch.
  void _onSelectBranch(SelectBranchEvt event, Emitter<TransferState> emit) {
    emit(state.copyWith(selectedBranch: event.branch));
  }

  /// Handles the addition of a new beneficiary.
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

  /// Updates the transfer form with new details.
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

  /// Fills the transfer details from the event.
  void _onFillTransferDetails(
    FillTransferDetailsEvt event,
    Emitter<TransferState> emit,
  ) {
    emit(state.copyWith(amount: event.amount, content: event.content));
    _recalculateFeeIfNeeded();
  }

  /// Searches for beneficiaries based on a query.
  void _onSearchBeneficiaries(
    SearchBeneficiaryEvt event,
    Emitter<TransferState> emit,
  ) {
    final query = event.query.trim().toLowerCase();

    if (query.isEmpty) {
      emit(
        state.copyWith(
          searchQuery: '',
          filteredBeneficiaries: state.beneficiaries,
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
      state.copyWith(searchQuery: event.query, filteredBeneficiaries: filtered),
    );
  }

  /// Calculates the transaction fee for the transfer.
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

  /// Initiates the transfer process.
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

  /// Sends an OTP to the user's email.
  Future<void> _onSendOtp(SendOtpEvt event, Emitter<TransferState> emit) async {
    emit(state.copyWith(status: const TransferStatus.loading()));

    try {
      await executeWithErrorHandling(
        () async => await transferRepo.sendOtpEmail(event.transferId),
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
          errorMessage: 'Failed to send OTP',
        ),
      );
    }
  }

  /// Confirms the transfer with the provided OTP.
  Future<void> _onConfirmTransferWithOtp(
    ConfirmTransferWithOtpEvt event,
    Emitter<TransferState> emit,
  ) async {
    await _confirmTransfer(
      emit,
      () async {
        final isValid = await transferRepo.verifyOTP(
          state.transferId ?? '',
          event.otpCode,
        );

        if (isValid) {
          return await transferRepo.confirmTransfer(
            state.transferId ?? '',
            event.otpCode,
          );
        } else {
          throw Exception('Invalid OTP code');
        }
      },
      'confirm_transfer_with_otp',
      {'transfer_id': state.transferId, 'has_otp': event.otpCode.isNotEmpty},
    );
  }

  /// Confirms the transfer with biometric authentication.
  Future<void> _onConfirmWithBiometric(
    ConfirmWithBiometricEvt event,
    Emitter<TransferState> emit,
  ) async {
    await _confirmTransfer(
      emit,
      () async {
        final canAuth = await biometricService.authenticate();

        if (!canAuth) {
          throw Exception('Biometric authentication failed');
        }

        return await transferRepo.confirmTransfer(
          state.transferId ?? '',
          'BIOMETRIC_AUTH',
        );
      },
      'confirm_with_biometric',
      {'transfer_id': state.transferId, 'auth_method': 'biometric'},
    );
  }

  /// A helper method to confirm the transfer.
  Future<void> _confirmTransfer(
    Emitter<TransferState> emit,
    Future<bool> Function() confirmation,
    String operationName,
    Map<String, dynamic> context,
  ) async {
    emit(state.copyWith(status: const TransferStatus.loading()));

    final result = await executeWithErrorHandling(
      confirmation,
      operationName: operationName,
      isCritical: true,
      context: context,
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
      String mapTransferError(Object? error) => switch (error) {
        InvalidOtpException e => e.message,
        InsufficientFundsException e => e.message,
        InvalidTransferSourceException e => e.message,
        UserNotLoggedInException e => e.message,
        _ => 'Transfer confirmation failed',
      };

      emit(
        state.copyWith(
          status: const TransferStatus.failure(),
          errorMessage: mapTransferError(result),
        ),
      );
    }
  }

  /// Recalculates the transaction fee if needed.
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
