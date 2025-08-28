import 'package:banking_app/features/bills/entities/bill_entity.dart';
import 'package:banking_app/features/bills/entities/payment_history_entity.dart';
import 'package:banking_app/features/bills/models/bill_model.dart';
import 'package:banking_app/features/bills/models/payment_history_model.dart';
import 'package:banking_app/features/setting/entities/setting_entity.dart';
import 'package:banking_app/features/setting/models/setting_model.dart';
import 'package:banking_app/features/transactions/entities/transaction_entity.dart';
import 'package:banking_app/features/transactions/models/transaction_model.dart';
import 'package:banking_app/features/transfer/entities/contact_entity.dart';
import 'package:banking_app/features/transfer/models/contact_model.dart';
import 'package:path_provider/path_provider.dart';
import '../../objectbox.g.dart';

class ObjectBoxService {
  static ObjectBoxService? _instance;
  static ObjectBoxService get instance => _instance!;

  late final Store _store;
  late final Box<BillEntity> _billBox;
  late final Box<TransactionEntity> _transactionBox;
  late final Box<ContactEntity> _contactBox;
  late final Box<SettingEntity> _settingBox;
  late final Box<PaymentHistoryEntity> _paymentHistoryBox;

  ObjectBoxService._create(this._store) {
    _billBox = Box<BillEntity>(_store);
    _transactionBox = Box<TransactionEntity>(_store);
    _contactBox = Box<ContactEntity>(_store);
    _settingBox = Box<SettingEntity>(_store);
    _paymentHistoryBox = Box<PaymentHistoryEntity>(_store);
  }

  static Future<void> initialize() async {
    if (_instance != null) return;
    final dir = await getApplicationDocumentsDirectory();
    final store = openStore(directory: "${dir.path}/objectbox");
    _instance = ObjectBoxService._create(store);
  }

  List<T> _find<T>(
    QueryBuilder<T> builder, {
    bool distinct = false,
    int? limit,
    int? offset,
  }) {
    final query = builder.build();
    final result = query.find();
    query.close();

    if (offset != null || limit != null) {
      return result.skip(offset ?? 0).take(limit ?? result.length).toList();
    }
    return result;
  }

  T? _findFirst<T>(QueryBuilder<T> builder) {
    final query = builder.build();
    final result = query.findFirst();
    query.close();
    return result;
  }

  Future<void> saveBill(BillModel bill) async =>
      _billBox.put(BillEntity.fromModel(bill));

  Future<List<BillModel>> getAllBills() async =>
      _billBox.getAll().map((e) => e.toModel()).toList();

  Future<List<BillModel>> getBillsByUser(String userId) async => _find(
    _billBox.query(BillEntity_.userId.equals(userId)),
  ).map((e) => e.toModel()).toList();

  Future<List<BillModel>> getBillsByType(
    BillType type, {
    String? userId,
  }) async {
    Condition<BillEntity> condition = BillEntity_.billTypeIndex.equals(
      type.index,
    );
    if (userId != null) {
      condition = condition & BillEntity_.userId.equals(userId);
    }
    final builder = _billBox.query(condition);
    return _find(builder).map((e) => e.toModel()).toList();
  }

  Future<void> updateBill(BillModel bill) async {
    final existing = _findFirst(
      _billBox.query(BillEntity_.billId.equals(bill.id)),
    );
    if (existing != null) {
      final updated = BillEntity.fromModel(bill)..id = existing.id;
      _billBox.put(updated);
    }
  }

  Future<void> deleteBill(String billId) async {
    final entity = _findFirst(
      _billBox.query(BillEntity_.billId.equals(billId)),
    );
    if (entity != null) _billBox.remove(entity.id);
  }

  Future<void> saveTransaction(TransactionModel tx) async =>
      _transactionBox.put(TransactionEntity.fromModel(tx));

  Future<List<TransactionModel>> getAllTransactions() async =>
      _transactionBox.getAll().map((e) => e.toModel()).toList();

  Future<List<TransactionModel>> getTransactionsByUser(String userId) async =>
      _find(
        _transactionBox.query(TransactionEntity_.userId.equals(userId)),
      ).map((e) => e.toModel()).toList();

  Future<List<TransactionModel>> getRecentTransactions({
    String? userId,
    int limit = 10,
  }) async {
    final builder = userId != null
        ? _transactionBox.query(TransactionEntity_.userId.equals(userId))
        : _transactionBox.query();
    builder.order(TransactionEntity_.createdAt, flags: Order.descending);
    return _find(builder, limit: limit).map((e) => e.toModel()).toList();
  }

  Future<void> updateTransaction(TransactionModel tx) async {
    final existing = _findFirst(
      _transactionBox.query(TransactionEntity_.transactionId.equals(tx.id)),
    );
    if (existing != null) {
      final updated = TransactionEntity.fromModel(tx)..id = existing.id;
      _transactionBox.put(updated);
    }
  }

  Future<void> deleteTransaction(String transactionId) async {
    final entity = _findFirst(
      _transactionBox.query(
        TransactionEntity_.transactionId.equals(transactionId),
      ),
    );
    if (entity != null) _transactionBox.remove(entity.id);
  }

  Future<void> saveContact(ContactModel c) async =>
      _contactBox.put(ContactEntity.fromModel(c));

  Future<List<ContactModel>> getAllContacts() async =>
      _contactBox.getAll().map((e) => e.toModel()).toList();

  Future<List<ContactModel>> getContactsByUser(String userId) async => _find(
    _contactBox.query(ContactEntity_.userId.equals(userId)),
  ).map((e) => e.toModel()).toList();

  Future<List<ContactModel>> searchContacts(
    String searchQuery, {
    String? userId,
  }) async {
    Condition<ContactEntity> condition = ContactEntity_.name.contains(
      searchQuery,
      caseSensitive: false,
    );
    if (userId != null) {
      condition = condition & ContactEntity_.userId.equals(userId);
    }
    final builder = _contactBox.query(condition);
    return _find(builder).map((e) => e.toModel()).toList();
  }

  Future<List<ContactModel>> getFavoriteContacts(String userId) async => _find(
    _contactBox.query(
      ContactEntity_.userId.equals(userId) &
          ContactEntity_.isFavorite.equals(true),
    ),
  ).map((e) => e.toModel()).toList();

  Future<void> updateContact(ContactModel c) async {
    final existing = _findFirst(
      _contactBox.query(ContactEntity_.contactId.equals(c.id)),
    );
    if (existing != null) {
      final updated = ContactEntity.fromModel(c)..id = existing.id;
      _contactBox.put(updated);
    }
  }

  Future<void> saveSettings(SettingModel s) async =>
      _settingBox.put(SettingEntity.fromModel(s));

  Future<SettingModel?> getSettings(String userId) async => _findFirst(
    _settingBox.query(SettingEntity_.userId.equals(userId)),
  )?.toModel();

  Future<void> updateSettings(SettingModel s) async {
    final existing = _findFirst(
      _settingBox.query(SettingEntity_.userId.equals(s.id!)),
    );
    if (existing != null) {
      final updated = SettingEntity.fromModel(s)..id = existing.id;
      _settingBox.put(updated);
    } else {
      await saveSettings(s);
    }
  }

  Future<void> savePaymentHistory(PaymentHistoryModel p) async =>
      _paymentHistoryBox.put(PaymentHistoryEntity.fromModel(p));

  Future<List<PaymentHistoryModel>> getPaymentHistory({
    String? userId,
    String? billId,
    int limit = 50,
  }) async {
    Condition<PaymentHistoryEntity>? condition;
    if (userId != null) {
      condition = (condition == null)
          ? PaymentHistoryEntity_.userId.equals(userId)
          : condition & PaymentHistoryEntity_.userId.equals(userId);
    }
    if (billId != null) {
      condition = (condition == null)
          ? PaymentHistoryEntity_.billId.equals(billId)
          : condition & PaymentHistoryEntity_.billId.equals(billId);
    }

    final builder = condition != null
        ? _paymentHistoryBox.query(condition)
        : _paymentHistoryBox.query();

    builder.order(PaymentHistoryEntity_.paymentDate, flags: Order.descending);
    return _find(builder, limit: limit).map((e) => e.toModel()).toList();
  }

  Future<List<PaymentHistoryModel>> getPaymentHistoryByStatus(
    PaymentStatus status, {
    String? userId,
  }) async {
    Condition<PaymentHistoryEntity> condition = PaymentHistoryEntity_
        .statusIndex
        .equals(status.index);

    if (userId != null) {
      condition = condition & PaymentHistoryEntity_.userId.equals(userId);
    }

    final builder = _paymentHistoryBox.query(condition);
    return _find(builder).map((e) => e.toModel()).toList();
  }

  Future<void> clearAllData() async {
    _billBox.removeAll();
    _transactionBox.removeAll();
    _contactBox.removeAll();
    _settingBox.removeAll();
    _paymentHistoryBox.removeAll();
  }

  void close() => _store.close();
}
