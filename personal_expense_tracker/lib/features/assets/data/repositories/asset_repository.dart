import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/asset_isar.dart';
import '../../domain/models/asset.dart';
import '../../../core/services/database_service.dart';

part 'asset_repository.g.dart';

@riverpod
class AssetRepository extends _$AssetRepository {
  late final Isar _isar;

  @override
  Future<void> build() async {
    _isar = DatabaseService.instance;
  }

  // Streams
  Stream<List<Asset>> watchAllAssets() {
    return _isar.assetIsars
        .where()
        .watch(fireImmediately: true)
        .map((list) => list.map((e) => e.toDomain()).toList());
  }

  Stream<List<Asset>> watchRecurringAssets() {
    return _isar.assetIsars
        .filter()
        .isRecurringEqualTo(true)
        .watch(fireImmediately: true)
        .map((list) => list.map((e) => e.toDomain()).toList());
  }

  Stream<List<Asset>> watchAssetsByType(AssetType type) {
    return _isar.assetIsars
        .filter()
        .typeEqualTo(type)
        .watch(fireImmediately: true)
        .map((list) => list.map((e) => e.toDomain()).toList());
  }

  // Aggregates
  Stream<double> watchTotalAssets() {
    return _isar.assetIsars
        .where()
        .watch(fireImmediately: true)
        .map((list) => list.fold(0.0, (sum, item) => sum + item.amount));
  }

  Stream<double> watchMonthlyIncome() {
    return _isar.assetIsars
        .filter()
        .isRecurringEqualTo(true)
        .watch(fireImmediately: true)
        .map((list) => list.fold(0.0, (sum, item) => sum + item.amount));
  }

  // CRUD operations
  Future<void> addAsset(Asset asset) async {
    final assetIsar = AssetIsar.fromDomain(asset);
    await _isar.writeTxn(() async {
      await _isar.assetIsars.put(assetIsar);
    });
  }

  Future<void> updateAsset(Asset asset) async {
    if (asset.id == null) return;
    final assetIsar = AssetIsar.fromDomain(asset);
    assetIsar.id = int.parse(asset.id!);
    await _isar.writeTxn(() async {
      await _isar.assetIsars.put(assetIsar);
    });
  }

  Future<void> deleteAsset(String id) async {
    await _isar.writeTxn(() async {
      await _isar.assetIsars.delete(int.parse(id));
    });
  }

  Future<Asset?> getAsset(String id) async {
    final assetIsar = await _isar.assetIsars.get(int.parse(id));
    return assetIsar?.toDomain();
  }
}
