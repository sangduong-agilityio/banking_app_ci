import 'package:banking_app/features/bills/models/payment_history_model.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class PaymentHistoryEntity {
  @Id()
  int id = 0;

  String paymentId = '';
  String billId = '';
  String userId = '';
  double amount = 0.0;
  @Property(type: PropertyType.dateNano)
  DateTime paymentDate = DateTime.now();
  int statusIndex = 0;
  String providerName = '';
  String? transactionId;

  PaymentStatus get status => PaymentStatus.values[statusIndex];
  set status(PaymentStatus value) => statusIndex = value.index;

  PaymentHistoryEntity();

  PaymentHistoryEntity.fromModel(PaymentHistoryModel model) {
    paymentId = model.id;
    billId = model.billId;
    userId = model.userId;
    amount = model.amount;
    paymentDate = model.paymentDate;
    status = model.status;
    providerName = model.providerName;
    transactionId = model.transactionId;
  }

  PaymentHistoryModel toModel() {
    return PaymentHistoryModel(
      id: paymentId,
      billId: billId,
      userId: userId,
      amount: amount,
      paymentDate: paymentDate,
      status: status,
      providerName: providerName,
      transactionId: transactionId,
    );
  }
}
