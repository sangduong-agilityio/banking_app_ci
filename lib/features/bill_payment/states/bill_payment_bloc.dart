import 'package:flutter_bloc/flutter_bloc.dart';
import 'bill_payment_event.dart';
import 'bill_payment_state.dart';
import 'package:banking_app/features/bill_payment/repositories/bill_payment_repository.dart';

class BillPaymentBloc extends Bloc<BillPaymentEvt, BillPaymentState> {
  BillPaymentBloc({required this.repository})
    : super(const BillPaymentState(status: BillPaymentStatus.initial())) {
    on<BillPaymentInitializeEvt>(_onInitialize);
    on<SelectBillEvt>(_onSelectBill);
    on<SelectCompanyEvt>(_onSelectCompany);
    on<SelectAccountEvt>(_onSelectAccount);
    on<SelectCardEvt>(_onSelectCard);
    on<UpdateBillDetailsEvt>(_onUpdateBillDetails);
    on<SendOtpEvt>(_onSendOtp);
    on<ConfirmBillPaymentWithOtpEvt>(_onConfirmWithOtp);
  }

  final BillPaymentRepository repository;

  Future<void> _onInitialize(
    BillPaymentInitializeEvt event,
    Emitter<BillPaymentState> emit,
  ) async {
    emit(state.copyWith(status: const BillPaymentStatus.loading()));
    try {
      final companies = await repository.fetchCompanies(event.type);
      final bills = await repository.fetchBills();
      final accounts = await repository.fetchAccounts();
      final cards = await repository.fetchCards();

      emit(
        state.copyWith(
          status: const BillPaymentStatus.loaded(),
          bills: bills,
          companies: companies,
          accounts: accounts,
          cards: cards,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const BillPaymentStatus.failure(),
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onSelectBill(SelectBillEvt event, Emitter<BillPaymentState> emit) {
    emit(
      state.copyWith(
        selectedBill: event.bill,
        selectedCompany: event.bill.company,
        amount: event.bill.amount,
      ),
    );
    _recalculateFee(emit);
  }

  void _onSelectCompany(
    SelectCompanyEvt event,
    Emitter<BillPaymentState> emit,
  ) {
    emit(state.copyWith(selectedCompany: event.company));
    _recalculateFee(emit);
  }

  void _onSelectAccount(
    SelectAccountEvt event,
    Emitter<BillPaymentState> emit,
  ) {
    emit(state.copyWith(selectedAccount: event.account, clearCard: true));
    _recalculateFee(emit);
  }

  void _onSelectCard(SelectCardEvt event, Emitter<BillPaymentState> emit) {
    emit(state.copyWith(selectedCard: event.card, clearAccount: true));
    _recalculateFee(emit);
  }

  void _onUpdateBillDetails(
    UpdateBillDetailsEvt event,
    Emitter<BillPaymentState> emit,
  ) {
    emit(
      state.copyWith(
        amount: event.amount ?? state.amount,
        billCode: event.billCode ?? state.billCode,
        phoneNumber: event.phoneNumber ?? state.phoneNumber,
      ),
    );
    if (event.amount != null) _recalculateFee(emit);
  }

  /// Send OTP to email
  Future<void> _onSendOtp(
    SendOtpEvt event,
    Emitter<BillPaymentState> emit,
  ) async {
    emit(state.copyWith(status: const BillPaymentStatus.loading()));
    try {
      await repository.sendOtpEmail(event.billId);
      emit(
        state.copyWith(
          status: const BillPaymentStatus.awaitingOtp(),
          otpSent: true,
          transactionId: event.billId,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const BillPaymentStatus.failure(),
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Confirm bill payment with OTP
  Future<void> _onConfirmWithOtp(
    ConfirmBillPaymentWithOtpEvt event,
    Emitter<BillPaymentState> emit,
  ) async {
    emit(state.copyWith(status: const BillPaymentStatus.loading()));
    try {
      final success = await repository.confirmPayTheBill(
        event.billId,
        event.otpCode,
      );

      if (!success) {
        emit(
          state.copyWith(
            status: const BillPaymentStatus.failure(),
            errorMessage: "Invalid OTP",
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: const BillPaymentStatus.success(),
          isOtpVerified: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const BillPaymentStatus.failure(),
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _recalculateFee(Emitter<BillPaymentState> emit) {
    if (state.amount != null) {
      double feeRate = 0.0;
      if (state.selectedCard != null) {
        feeRate = 0.015; // 1.5% for card
      } else if (state.selectedAccount != null) {
        feeRate = 0.01; // 1% for account
      }
      final fee = double.parse((state.amount! * feeRate).toStringAsFixed(2));
      emit(state.copyWith(fee: fee));
    }
  }
}
