import 'package:isar/isar.dart';
import '../../domain/models/asset.dart';

part 'asset_isar.g.dart';

@collection
class AssetIsar {
  Id id = Isar.autoIncrement;

  late String name;

  late double amount;

  @enumerated
  late AssetType type;

  late bool isRecurring;

  String? description;

  AssetIsar();

  AssetIsar.fromDomain(Asset asset) {
    name = asset.name;
    amount = asset.amount;
    type = asset.type;
    isRecurring = asset.isRecurring;
    description = asset.description;
  }

  Asset toDomain() {
    return Asset(
      id: id.toString(),
      name: name,
      amount: amount,
      type: type,
      isRecurring: isRecurring,
      description: description,
    );
  }
}
