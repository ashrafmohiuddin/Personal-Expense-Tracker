import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset.freezed.dart';
part 'asset.g.dart';

@freezed
class Asset with _$Asset {
  const factory Asset({
    String? id,
    required String name,
    required double amount,
    required AssetType type,
    required bool isRecurring,
    String? description,
  }) = _Asset;

  factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);
}

enum AssetType {
  @JsonValue('salary')
  salary,
  @JsonValue('investment')
  investment,
  @JsonValue('savings')
  savings,
  @JsonValue('other')
  other,
}

extension AssetTypeExtension on AssetType {
  String get displayName {
    switch (this) {
      case AssetType.salary:
        return 'Salary';
      case AssetType.investment:
        return 'Investment';
      case AssetType.savings:
        return 'Savings';
      case AssetType.other:
        return 'Other';
    }
  }
}
