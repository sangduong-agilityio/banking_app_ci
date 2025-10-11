import 'package:flutter_bloc/flutter_bloc.dart';
import 'bill_payment_event.dart';
import 'bill_payment_state.dart';
import 'package:banking_app/features/bill_payment/repositories/bill_payment_repository.dart';
import 'package:banking_app/features/bill_payment/models/bill_payment_model.dart';
import 'package:banking_app/features/bill_payment/models/company_model.dart';
import 'package:banking_app/features/home/models/account_model.dart';
import 'package:banking_app/features/home/models/card_model.dart';
import 'package:banking_app/core/bloc/base_bloc.dart';

/// Manages the state for the bill payment feature, handling user interactions
/// and business logic.
class BillPaymentBloc extends BaseBloc<BillPaymentEvt, BillPaymentState> {
  BillPaymentBloc({required this.repository})
    : super(const BillPaymentState(status: BillPaymentStatus.initial())) {
    on<BillPaymentInitializeEvt>(_onInitialize);
    on<SelectBillEvt>(_onSelectBill);
    on<SelectCompanyEvt>(_onSelectCompany);
    on<SelectAccountEvt>(_onSelectAccount);
    on<SelectCardEvt>(_onSelectCard);
    on<UpdateBillDetailsEvt>(_onUpdateBillDetails);
    on<SendOtpEvt>(_onSendOtp);
    on<PayBillEvt>(_onPayBill);
    on<ConfirmBillPaymentWithOtpEvt>(_onConfirmWithOtp);
  }

  final BillPaymentRepository repository;

  /// Handles the initialization of the bill payment screen, fetching necessary data.
  Future<void> _onInitialize(
    BillPaymentInitializeEvt event,
    Emitter<BillPaymentState> emit,
  ) async {
    emit(state.copyWith(status: const BillPaymentStatus.loading()));

    final result = await executeWithErrorHandling(
      () async {
        final companies = await repository.fetchCompanies(event.type);
        final bills = await repository.fetchBills();
        final accounts = await repository.fetchAccounts();
        final cards = await repository.fetchCards();

        return {
          'companies': companies,
          'bills': bills,
          'accounts': accounts,
          'cards': cards,
        };
      },
      operationName: 'bill_payment_initialize',
      isCritical: true,
      context: {
        'bill_type': event.type.name,
        'event_type': 'BillPaymentInitializeEvt',
      },
    );

    if (result != null) {
      emit(
        state.copyWith(
          status: const BillPaymentStatus.loaded(),
          bills: result['bills'] as List<BillPaymentModel>,
          companies: result['companies'] as List<CompanyModel>,
          accounts: result['accounts'] as List<AccountModel>,
          cards: result['cards'] as List<CardModel>,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: const BillPaymentStatus.failure(),
          errorMessage: 'Failed to load bill payment data',
        ),
      );
    }
  }

  /// Handles the selection of a pre-existing bill.
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

  /// Handles the selection of a company.
  void _onSelectCompany(
    SelectCompanyEvt event,
    Emitter<BillPaymentState> emit,
  ) {
    emit(state.copyWith(selectedCompany: event.company));
    _recalculateFee(emit);
  }

  /// Handles the selection of a payment account.
  void _onSelectAccount(
    SelectAccountEvt event,
    Emitter<BillPaymentState> emit,
  ) {
    emit(state.copyWith(selectedAccount: event.account, clearCard: true));
    _recalculateFee(emit);
  }

  /// Handles the selection of a payment card.
  void _onSelectCard(SelectCardEvt event, Emitter<BillPaymentState> emit) {
    emit(state.copyWith(selectedCard: event.card, clearAccount: true));
    _recalculateFee(emit);
  }

  /// Updates bill details such as amount, bill code, or phone number.
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

  /// Sends an OTP to the user's email to authorize the transaction.
  Future<void> _onSendOtp(
    SendOtpEvt event,
    Emitter<BillPaymentState> emit,
  ) async {
    emit(state.copyWith(status: const BillPaymentStatus.loading()));

    try {
      await executeWithErrorHandling(
        () async => await repository.sendOtpEmail(event.billId),
        operationName: 'send_bill_payment_otp',
        isCritical: false,
        context: {'bill_id': event.billId},
      );

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
          errorMessage: 'Failed to send OTP',
        ),
      );
    }
  }

  /// Confirms the bill payment with the provided OTP.
  Future<void> _onConfirmWithOtp(
    ConfirmBillPaymentWithOtpEvt event,
    Emitter<BillPaymentState> emit,
  ) async {
    emit(state.copyWith(status: const BillPaymentStatus.loading()));

    final result = await executeWithErrorHandling(
      () async {
        final success = await repository.confirmPayTheBill(
          event.billId,
          event.otpCode,
        );

        if (!success) {
          throw Exception('Invalid OTP');
        }

        return await repository.fetchBills();
      },
      operationName: 'confirm_bill_payment_with_otp',
      isCritical: true,
      context: {'bill_id': event.billId, 'has_otp': event.otpCode.isNotEmpty},
    );

    if (result != null) {
      emit(
        state.copyWith(
          status: const BillPaymentStatus.success(),
          isOtpVerified: true,
          bills: result,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: const BillPaymentStatus.failure(),
          errorMessage: 'Invalid OTP or payment confirmation failed',
        ),
      );
    }
  }

  /// Initiates the bill payment process.
  Future<void> _onPayBill(
    PayBillEvt event,
    Emitter<BillPaymentState> emit,
  ) async {
    emit(state.copyWith(status: const BillPaymentStatus.loading()));

    final result = await executeWithErrorHandling(
      () async {
        final bill = await repository.payBill(
          bill: event.bill,
          fromAccountId: state.selectedAccount?.id,
          fromCardId: state.selectedCard?.id,
        );

        await repository.sendOtpEmail(bill.id ?? '');
        return bill;
      },
      operationName: 'pay_bill',
      isCritical: true,
      context: {
        'bill_id': event.bill.id,
        'bill_amount': event.bill.amount,
        'has_account': state.selectedAccount != null,
        'has_card': state.selectedCard != null,
      },
    );

    if (result != null) {
      emit(
        state.copyWith(
          selectedBill: result,
          status: const BillPaymentStatus.awaitingOtp(),
          otpSent: true,
          transactionId: result.transactionId,
          billId: result.id,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: const BillPaymentStatus.failure(),
          errorMessage: 'Bill payment failed',
        ),
      );
    }
  }

  /// Recalculates the transaction fee based on the selected payment method.
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

  @override
  String? getCurrentUserId() {
    return state.selectedAccount?.userId ?? state.selectedCard?.userId;
  }
}
