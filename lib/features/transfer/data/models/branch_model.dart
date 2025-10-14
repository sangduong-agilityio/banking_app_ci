import 'package:freezed_annotation/freezed_annotation.dart';

part 'branch_model.freezed.dart';
part 'branch_model.g.dart';

/// Represents a bank branch.
@freezed
class BranchModel with _$BranchModel {
  const factory BranchModel({
    required String id,
    required String name,
    required String bankId,
    String? address,
    String? code,
  }) = _BranchModel;

  factory BranchModel.fromJson(Map<String, dynamic> json) =>
      _$BranchModelFromJson(json);
}
