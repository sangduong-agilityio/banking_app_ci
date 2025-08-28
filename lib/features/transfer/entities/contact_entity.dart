import 'package:banking_app/features/transfer/models/contact_model.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class ContactEntity {
  @Id()
  int id = 0;

  String contactId = '';
  String userId = '';
  String name = '';
  String? email;
  String? phoneNumber;
  String? accountNumber;
  String? imageUrl;
  String? lastTransactionAmount;
  bool isFavorite = false;
  @Property(type: PropertyType.dateNano)
  DateTime createdAt = DateTime.now();
  @Property(type: PropertyType.dateNano)
  DateTime? lastContactedAt;

  ContactEntity();

  ContactEntity.fromModel(ContactModel model) {
    contactId = model.id;
    userId = model.userId;
    name = model.name;
    email = model.email;
    phoneNumber = model.phoneNumber;
    accountNumber = model.accountNumber;
    imageUrl = model.imageUrl;
    lastTransactionAmount = model.lastTransactionAmount;
    isFavorite = model.isFavorite;
    createdAt = model.createdAt;
    lastContactedAt = model.lastContactedAt;
  }

  ContactModel toModel() {
    return ContactModel(
      id: contactId,
      userId: userId,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      accountNumber: accountNumber,
      imageUrl: imageUrl,
      lastTransactionAmount: lastTransactionAmount,
      isFavorite: isFavorite,
      createdAt: createdAt,
      lastContactedAt: lastContactedAt,
    );
  }
}
