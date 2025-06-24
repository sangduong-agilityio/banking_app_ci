import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tradly_app/features/payment/models/order_model.dart';

part 'payment_option_state.freezed.dart';

final class PaymentOptionState extends Equatable {
  const PaymentOptionState({
    this.paymentMethods,
    this.selectedPaymentType,
    this.deliveryAddress,
    this.totalPrice,
    this.itemCount,
    this.status = const PaymentOptionStatus.initial(),
    this.hasAddress = false,
  });
  final PaymentOptionStatus status;
  final List<PaymentMethod>? paymentMethods;
  final PaymentType? selectedPaymentType;
  final String? deliveryAddress;
  final double? totalPrice;
  final int? itemCount;
  final bool hasAddress;

  PaymentOptionState copyWith({
    List<PaymentMethod>? paymentMethods,
    PaymentType? selectedPaymentType,
    String? deliveryAddress,
    double? totalPrice,
    int? itemCount,
    bool? hasAddress,
    PaymentOptionStatus? status,
  }) {
    return PaymentOptionState(
      paymentMethods: paymentMethods ?? this.paymentMethods,
      selectedPaymentType: selectedPaymentType ?? this.selectedPaymentType,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      totalPrice: totalPrice ?? this.totalPrice,
      itemCount: itemCount ?? this.itemCount,
      hasAddress: hasAddress ?? this.hasAddress,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        paymentMethods,
        selectedPaymentType,
        deliveryAddress,
        totalPrice,
        itemCount,
        hasAddress,
        status,
      ];
}

@freezed
sealed class PaymentOptionStatus with _$PaymentOptionStatus {
  const factory PaymentOptionStatus.initial() = PaymentOptionStatusInitial;
  const factory PaymentOptionStatus.loading() = PaymentOptionStatusLoading;
  const factory PaymentOptionStatus.success() = PaymentOptionStatusSuccess;
  const factory PaymentOptionStatus.failure() = PaymentOptionStatusFailure;
}
