import 'package:banking_app/features/setting/models/user_model.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class SettingEntity {
  @Id()
  int id = 0;

  String? userId;
  String? email;
  String? username;
  String? phoneNumber;
  String? accountNumber;
  String? homeAddress;
  String? profileImage;
  @Property(type: PropertyType.dateNano)
  DateTime? createdAt;
  @Property(type: PropertyType.dateNano)
  DateTime? updatedAt;

  SettingEntity();

  SettingEntity.fromModel(UserModel model) {
    userId = model.id;
    email = model.email;
    username = model.username;
    phoneNumber = model.phoneNumber;
    accountNumber = model.accountNumber;
    homeAddress = model.homeAddress;
    profileImage = model.profileImage;
    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
  }

  UserModel toModel() {
    return UserModel(
      id: userId,
      email: email,
      username: username,
      phoneNumber: phoneNumber,
      accountNumber: accountNumber,
      homeAddress: homeAddress,
      profileImage: profileImage,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
