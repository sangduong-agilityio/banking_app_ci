import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:banking_app/features/transfer/models/transfer_model.dart';
import 'package:banking_app/features/transfer/repositories/transfer_repository.dart';

import 'transfer_event.dart';
import 'transfer_state.dart';

class TransferBloc extends Bloc<TransferEvt, TransferState> {
  final TransferRepository repo;

  TransferBloc({required this.repo}) : super(const TransferState()) {
    on<TransferInitializeEvt>(_onTransferInitilize);
    on<SelectAccountEvt>(_onSelectAccount);
    on<SelectTransferTypeEvt>(_onSelectTransferType);
    on<SelectBeneficiaryEvt>(_onSelectBeneficiary);
    on<AddNewBeneficiaryEvt>(_onAddNewBeneficiary);
    on<UpdateTransferFormEvt>(_onUpdateTransferForm);
    on<FillTransferDetailsEvt>(_onFillTransferDetails);
    on<CalculateTransactionFeeEvt>(_onCalculateTransactionFee);
    on<InitiateTransfer>(_onInitiateTransfer);
    on<VerifyOTPEvt>(_onVerifyOTP);
    on<AuthenticateWithBiometricsEvt>(_onAuthenticateWithBiometrics);
    on<AuthenticateWithFaceIdEvt>(_onAuthenticateWithFaceId);
    on<ConfirmTransferEvt>(_onConfirmTransfer);
    on<ResetTransferEvt>(_onResetTransfer);
    on<BeneficiariesInitializeEvt>(_onBeneficiaresInitialize);
    on<SearchBeneficiaryEvt>(_onSearchBeneficiaries);
  }

  Future<void> _onTransferInitilize(
    TransferInitializeEvt event,
    Emitter<TransferState> emit,
  ) async {
    emit(state.copyWith(status: const TransferStatus.loading()));

    try {
      final accounts = await repo.getUserAccounts();
      final beneficiaries = await repo.getBeneficiaries();
      final banks = await repo.getBanks();

      emit(
        state.copyWith(
          status: const TransferStatus.success(),
          accounts: accounts,
          beneficiaries: beneficiaries,
          banks: banks,
          selectedAccount: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const TransferStatus.failure(),
          errorMessage: 'Failed to load initial data: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onBeneficiaresInitialize(
    BeneficiariesInitializeEvt event,
    Emitter<TransferState> emit,
  ) async {
    emit(state.copyWith(status: const TransferStatus.loading()));

    try {
      final beneficiaries = await repo.getBeneficiaries();
      final banks = await repo.getBanks();

      emit(
        state.copyWith(
          status: const TransferStatus.success(),
          beneficiaries: beneficiaries,
          banks: banks,
          filteredBeneficiaries: beneficiaries,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const TransferStatus.failure(),
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onSelectAccount(SelectAccountEvt event, Emitter<TransferState> emit) {
    emit(state.copyWith(selectedAccount: event.account));
  }

  void _onSelectTransferType(
    SelectTransferTypeEvt event,
    Emitter<TransferState> emit,
  ) {
    emit(state.copyWith(selectedTransferType: event.transferType));
    _recalculateFeeIfNeeded();
  }

  void _onSelectBeneficiary(
    SelectBeneficiaryEvt event,
    Emitter<TransferState> emit,
  ) {
    emit(state.copyWith(selectedBeneficiary: event.beneficiary));
    _recalculateFeeIfNeeded();
  }

  Future<void> _onAddNewBeneficiary(
    AddNewBeneficiaryEvt event,
    Emitter<TransferState> emit,
  ) async {
    try {
      final newBeneficiary = await repo.addBeneficiary(event.beneficiary);
      final updated = [...state.beneficiaries, newBeneficiary];

      emit(
        state.copyWith(
          beneficiaries: updated,
          selectedBeneficiary: newBeneficiary,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const TransferStatus.failure(),
          errorMessage: 'Failed to add beneficiary: ${e.toString()}',
        ),
      );
    }
  }

  void _onUpdateTransferForm(
    UpdateTransferFormEvt event,
    Emitter<TransferState> emit,
  ) {
    emit(
      state.copyWith(
        amount: event.amount ?? state.amount,
        content: event.content ?? state.content,
        banks: event.bank != null && !state.banks.contains(event.bank)
            ? [...state.banks, event.bank!]
            : state.banks,
        saveToDirectory: event.saveToDirectory ?? state.saveToDirectory,
      ),
    );

    if (event.amount != null) {
      _recalculateFeeIfNeeded();
    }
  }

  // Add the missing handler for FillTransferDetailsEvent
  void _onFillTransferDetails(
    FillTransferDetailsEvt event,
    Emitter<TransferState> emit,
  ) {
    emit(state.copyWith(amount: event.amount, content: event.content));

    // Calculate fee immediately
    add(CalculateTransactionFeeEvt());
  }

  Future<void> _onCalculateTransactionFee(
    CalculateTransactionFeeEvt event,
    Emitter<TransferState> emit,
  ) async {
    try {
      if (state.selectedAccount != null &&
          state.selectedBeneficiary != null &&
          state.amount != null) {
        final request = TransferRequest(
          fromAccount: state.selectedAccount!,
          toBeneficiary: state.selectedBeneficiary!,
          amount: state.amount!,
          transactionFee: 0.0,
          content: state.content ?? '',
          transferType: state.selectedTransferType,
        );

        final fee = await repo.calculateTransactionFee(request);
        emit(state.copyWith(transactionFee: fee));
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: const TransferStatus.failure(),
          errorMessage: 'Failed to calculate fee: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onInitiateTransfer(
    InitiateTransfer event,
    Emitter<TransferState> emit,
  ) async {
    if (!_validateTransferData()) {
      emit(state.copyWith(errorMessage: 'Please fill all required fields'));
      return;
    }

    emit(state.copyWith(status: const TransferStatus.loading()));

    try {
      final request = TransferRequest(
        fromAccount: state.selectedAccount!,
        toBeneficiary: state.selectedBeneficiary!,
        amount: state.amount!,
        transactionFee: state.transactionFee,
        content: state.content!,
        transferType: state.selectedTransferType,
        saveToDirectory: state.saveToDirectory,
      );

      final transactionId = await repo.initiateTransfer(request);

      emit(
        state.copyWith(
          status: const TransferStatus.success(),
          transactionId: transactionId,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const TransferStatus.failure(),
          errorMessage: 'Failed to initiate transfer: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onVerifyOTP(
    VerifyOTPEvt event,
    Emitter<TransferState> emit,
  ) async {
    try {
      final isVerified = await repo.verifyOTP(
        state.transactionId ?? "",
        event.otpCode,
      );

      if (isVerified) {
        add(ConfirmTransferEvt());
      } else {
        emit(
          state.copyWith(errorMessage: 'Invalid OTP code. Please try again.'),
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

  Future<void> _onAuthenticateWithBiometrics(
    AuthenticateWithBiometricsEvt event,
    Emitter<TransferState> emit,
  ) async {
    try {
      final isAuth = await repo.authenticateWithBiometrics();
      if (isAuth) {
        add(ConfirmTransferEvt());
      } else {
        emit(state.copyWith(errorMessage: 'Biometric authentication failed'));
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: const TransferStatus.failure(),
          errorMessage: 'Biometric authentication error: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onAuthenticateWithFaceId(
    AuthenticateWithFaceIdEvt event,
    Emitter<TransferState> emit,
  ) async {
    try {
      final isAuth = await repo.authenticateWithFaceId();
      if (isAuth) {
        add(ConfirmTransferEvt());
      } else {
        emit(state.copyWith(errorMessage: 'Face ID authentication failed'));
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: const TransferStatus.failure(),
          errorMessage: 'Face ID authentication error: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onConfirmTransfer(
    ConfirmTransferEvt event,
    Emitter<TransferState> emit,
  ) async {
    emit(state.copyWith(status: const TransferStatus.loading()));

    try {
      final transaction = await repo.confirmTransfer(state.transactionId!);

      emit(
        state.copyWith(
          status: const TransferStatus.success(),
          transaction: transaction,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const TransferStatus.failure(),
          errorMessage: 'Failed to confirm transfer: ${e.toString()}',
        ),
      );
    }
  }

  void _onResetTransfer(ResetTransferEvt event, Emitter<TransferState> emit) {
    emit(
      state.copyWith(
        status: const TransferStatus.initial(),
        selectedAccount: state.accounts.isNotEmpty
            ? state.accounts.first
            : null,
        selectedTransferType: TransferType.cardNumber,
        selectedBeneficiary: null,
        amount: null,
        content: null,
        transactionFee: 0.0,
        saveToDirectory: false,
        errorMessage: null,
        transactionId: null,
        transaction: null,
      ),
    );
  }

  // Helper methods
  bool _validateTransferData() {
    return state.selectedAccount != null &&
        state.selectedBeneficiary != null &&
        state.amount != null &&
        state.amount! > 0 &&
        state.content != null &&
        state.content!.isNotEmpty &&
        state.amount! <= state.selectedAccount!.availableBalance;
  }

  void _recalculateFeeIfNeeded() {
    if (state.selectedAccount != null &&
        state.selectedBeneficiary != null &&
        state.amount != null &&
        state.amount! > 0) {
      add(CalculateTransactionFeeEvt());
    }
  }

  void _onSearchBeneficiaries(
    SearchBeneficiaryEvt event,
    Emitter<TransferState> emit,
  ) {
    final query = event.query.trim().toLowerCase();
    final filtered = query.isEmpty
        ? state.beneficiaries
        : state.beneficiaries
              .where(
                (b) =>
                    b.name.toLowerCase().contains(query) ||
                    b.accountNumber.contains(query),
              )
              .toList();

    emit(
      state.copyWith(searchQuery: event.query, filteredBeneficiaries: filtered),
    );
  }
}
