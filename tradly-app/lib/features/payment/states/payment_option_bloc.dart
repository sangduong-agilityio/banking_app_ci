import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradly_app/features/payment/models/order_model.dart';
import 'package:tradly_app/features/payment/states/payment_option_event.dart';
import 'package:tradly_app/features/payment/states/payment_option_state.dart';

class PaymentOptionBloc extends Bloc<PaymentOptionEvt, PaymentOptionState> {
  PaymentOptionBloc() : super(PaymentOptionState()) {
    on<PaymentOptionInitializeEvt>(_onInitialize);
    on<PaymentOptionSelectEvt>(_onPaymentOptionSelect);
    on<PaymentOptionAddEvt>(_onAddPaymentMethod);
    // on<PaymentOptionCheckoutEvt>(_onProcessCheckout);
    // on<PaymentOptionUpdateDeliveryAddress>(_onUpdateDeliveryAddress);
  }

  Future<void> _onInitialize(
    PaymentOptionInitializeEvt event,
    Emitter<PaymentOptionState> emit,
  ) {
    emit(
      PaymentOptionState(
        status: const PaymentOptionStatus.loading(),
      ),
    );
    return Future.value();
  }

  Future<void> _onPaymentOptionSelect(
    PaymentOptionSelectEvt event,
    Emitter<PaymentOptionState> emit,
  ) {
    emit(state.copyWith(selectedPaymentType: event.paymentType));
    return Future.value();
  }

  void _onAddPaymentMethod(
    PaymentOptionAddEvt event,
    Emitter<PaymentOptionState> emit,
  ) {
    final updatedMethods = List<PaymentMethod>.from(state.paymentMethods ?? []);

    if (!updatedMethods.any((method) => method.id == event.paymentMethod.id)) {
      updatedMethods.add(event.paymentMethod);
    }

    emit(state.copyWith(paymentMethods: updatedMethods));
  }
}
