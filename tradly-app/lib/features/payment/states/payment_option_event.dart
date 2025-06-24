import 'package:equatable/equatable.dart';
import 'package:tradly_app/features/payment/models/order_model.dart';

class PaymentOptionEvt extends Equatable {
  const PaymentOptionEvt();

  @override
  List<Object?> get props => [];
}

final class PaymentOptionInitializeEvt extends PaymentOptionEvt {
  const PaymentOptionInitializeEvt();

  @override
  List<Object?> get props => [];
}

class PaymentOptionSelectEvt extends PaymentOptionEvt {
  const PaymentOptionSelectEvt({
    required this.paymentType,
  });

  final PaymentType paymentType;

  @override
  List<Object?> get props => [paymentType];
}

class PaymentOptionAddEvt extends PaymentOptionEvt {
  const PaymentOptionAddEvt({
    required this.paymentMethod,
  });

  final PaymentMethod paymentMethod;

  @override
  List<Object?> get props => [paymentMethod];
}

class PaymentOptionCheckoutEvt extends PaymentOptionEvt {
  const PaymentOptionCheckoutEvt({
    required this.paymentMethod,
  });

  final PaymentMethod paymentMethod;
  @override
  List<Object?> get props => [paymentMethod];
}

class PaymentOptionUpdateDeliveryAddress extends PaymentOptionEvt {
  const PaymentOptionUpdateDeliveryAddress({
    required this.address,
  });

  final String address;
}

class PaymentOptionAddCardEvt extends PaymentOptionEvt {
  const PaymentOptionAddCardEvt({
    required this.card,
  });

  final PaymentMethod card;

  @override
  List<Object?> get props => [card];
}
