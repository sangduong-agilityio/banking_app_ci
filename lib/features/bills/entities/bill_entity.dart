import 'package:banking_app/features/bills/models/bill_model.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class BillEntity {
  @Id()
  int id = 0;

  String billId = '';
  String userId = '';
  int billTypeIndex = 0;
  String providerName = '';
  String accountNumber = '';
  String address = '';
  String phoneNumber = '';
  String billCode = '';
  String startDate = '';
  String endDate = '';
  @Property(type: PropertyType.dateNano)
  DateTime? dueDate;
  @Property(type: PropertyType.dateNano)
  DateTime createdAt = DateTime.now();
  @Property(type: PropertyType.dateNano)
  DateTime updatedAt = DateTime.now();

  // Getters and setters for enum
  BillType get billType => BillType.values[billTypeIndex];
  set billType(BillType value) => billTypeIndex = value.index;

  BillEntity();

  // Factory constructor from BillModel
  BillEntity.fromModel(BillModel model) {
    billId = model.id;
    userId = model.userId;
    billType = model.billType;
    providerName = model.providerName;
    accountNumber = model.accountNumber;
    address = model.address;
    phoneNumber = model.phoneNumber;
    billCode = model.billCode;
    startDate = model.startDate;
    endDate = model.endDate;
    dueDate = model.dueDate;
    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
  }

  // Convert to BillModel
  BillModel toModel() {
    return BillModel(
      id: billId,
      userId: userId,
      billType: billType,
      providerName: providerName,
      accountNumber: accountNumber,
      address: address,
      phoneNumber: phoneNumber,
      billCode: billCode,
      startDate: startDate,
      endDate: endDate,
      dueDate: dueDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
      amount: 0.0,
      tax: 0.0,
      isRecurring: false,
      isFavorite: false,
    );
  }
}
