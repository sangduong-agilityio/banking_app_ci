enum PaymentType {
  debitCreditCard,
  netbanking,
  cashOnDelivery,
  wallet,
}

class PaymentMethod {
  final String id;
  final PaymentType? type;
  final String? cardNumber;
  final String? holderName;
  final String? expiryDate;
  final String? cvc;
  final String? cardType;

  PaymentMethod({
    required this.id,
    this.type,
    this.cardNumber,
    this.holderName,
    this.expiryDate,
    this.cvc,
    this.cardType,
  });

  PaymentMethod copyWith({
    String? id,
    PaymentType? type,
    String? cardNumber,
    String? holderName,
    String? expiryDate,
    String? cvc,
    String? cardType,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      type: type ?? this.type,
      cardNumber: cardNumber ?? this.cardNumber,
      holderName: holderName ?? this.holderName,
      expiryDate: expiryDate ?? this.expiryDate,
      cvc: cvc ?? this.cvc,
      cardType: cardType ?? this.cardType,
    );
  }
}

class OrderModel {
  final String id;
  final String productName;
  final double price;
  final double originalPrice;
  final int quantity;
  final String imageUrl;
  final DateTime orderDate;
  final OrderStatus status;
  final String deliveryAddress;
  final String customerName;
  final String mobile;

  OrderModel({
    required this.id,
    required this.productName,
    required this.price,
    required this.originalPrice,
    required this.quantity,
    required this.imageUrl,
    required this.orderDate,
    required this.status,
    required this.deliveryAddress,
    required this.customerName,
    required this.mobile,
  });
}

enum OrderStatus {
  placed,
  paymentConfirmed,
  processed,
  delivered,
}
