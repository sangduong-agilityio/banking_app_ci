import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:banking_app/features/transfer/models/transfer_model.dart';
import 'package:banking_app/features/transfer/services/transfer_repository.dart';

import 'transfer_event.dart';
import 'transfer_state.dart';

class TransferBloc extends Bloc<TransferEvt, TransferState> {
  final TransferRepository repo;

  TransferBloc({required this.repo}) : super(const TransferState()) {
    on<TransferInitializeEvt>(_onLoadInitialData);
    on<SelectAccountEvt>(_onSelectAccount);
    on<SelectTransferTypeEvt>(_onSelectTransferType);
    on<SelectBeneficiaryEvt>(_onSelectBeneficiary);
    on<AddNewBeneficiaryEvt>(_onAddNewBeneficiary);
    on<UpdateTransferFormEvt>(_onUpdateTransferForm);
    on<CalculateTransactionFeeEvt>(_onCalculateTransactionFee);
    on<InitiateTransfer>(_onInitiateTransfer);
    on<VerifyOTPEvt>(_onVerifyOTP);
    on<AuthenticateWithBiometricsEvt>(_onAuthenticateWithBiometrics);
    on<AuthenticateWithFaceIdEvt>(_onAuthenticateWithFaceId);
    on<ConfirmTransferEvt>(_onConfirmTransfer);
    on<ResetTransferEvt>(_onResetTransfer);
  }

  Future<void> _onLoadInitialData(
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
          selectedAccount: accounts.isNotEmpty ? accounts.first : null,
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

  void _onSelectAccount(SelectAccountEvt event, Emitter<TransferState> emit) {
    emit(state.copyWith(selectedAccount: event.account));
  }

  void _onSelectTransferType(
    SelectTransferTypeEvt event,
    Emitter<TransferState> emit,
  ) {
    emit(state.copyWith(selectedTransferType: event.transferType));

    if (state.amount != null &&
        state.selectedAccount != null &&
        state.selectedBeneficiary != null) {
      add(CalculateTransactionFeeEvt());
    }
  }

  void _onSelectBeneficiary(
    SelectBeneficiaryEvt event,
    Emitter<TransferState> emit,
  ) {
    emit(state.copyWith(selectedBeneficiary: event.beneficiary));
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
        saveToDirectory: event.saveToDirectory ?? state.saveToDirectory,
      ),
    );

    if (event.amount != null &&
        state.selectedAccount != null &&
        state.selectedBeneficiary != null) {
      add(CalculateTransactionFeeEvt());
    }
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
    if (state.selectedAccount == null ||
        state.selectedBeneficiary == null ||
        state.amount == null ||
        state.content == null) {
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
      final isVerified = await repo.verifyOTP("transactionId", event.otpCode);

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
        selectedAccount: null,
        selectedTransferType: TransferType.cardNumber,
        selectedBeneficiary: null,
        amount: null,
        content: null,
        transactionFee: 0.0,
        saveToDirectory: false,
        errorMessage: null,
        transactionId: null,
      ),
    );
  }
}
