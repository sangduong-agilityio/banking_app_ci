import 'package:banking_app/features/transactions/models/transaction_model.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class TransactionEntity {
  @Id()
  int id = 0;

  String transactionId = '';
  String userId = '';
  int typeIndex = 0;
  double amount = 0.0;
  String? imageUrl;
  String? recipientName;
  String? recipientAccount;
  String? recipientPhone;
  String? description;
  int statusIndex = 0;
  String? referenceNumber;
  String? paymentMethod;
  String? cardLastFour;
  @Property(type: PropertyType.dateNano)
  DateTime createdAt = DateTime.now();
  @Property(type: PropertyType.dateNano)
  DateTime? updatedAt;

  // Getters and setters for enums
  TransactionType get type => TransactionType.values[typeIndex];
  set type(TransactionType value) => typeIndex = value.index;

  TransactionStatus get status => TransactionStatus.values[statusIndex];
  set status(TransactionStatus value) => statusIndex = value.index;

  TransactionEntity();

  TransactionEntity.fromModel(TransactionModel model) {
    transactionId = model.id;
    userId = model.userId;
    type = model.type;
    amount = model.amount;
    imageUrl = model.imageUrl;
    recipientName = model.recipientName;
    recipientAccount = model.recipientAccount;
    recipientPhone = model.recipientPhone;
    description = model.description;
    status = model.status;
    referenceNumber = model.referenceNumber;
    paymentMethod = model.paymentMethod;
    cardLastFour = model.cardLastFour;
    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
  }

  TransactionModel toModel() {
    return TransactionModel(
      id: transactionId,
      userId: userId,
      type: type,
      amount: amount,
      imageUrl: imageUrl,
      recipientName: recipientName,
      recipientAccount: recipientAccount,
      recipientPhone: recipientPhone,
      description: description,
      status: status,
      referenceNumber: referenceNumber,
      paymentMethod: paymentMethod,
      cardLastFour: cardLastFour,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
