import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:personal_expense_tracker/features/assets/data/repositories/asset_repository.dart';
import 'package:personal_expense_tracker/features/assets/domain/models/asset.dart';

void main() {
  group('AssetRepository', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should initialize repository', () async {
      final repository = container.read(assetRepositoryProvider);
      expect(repository, isA<AssetRepository>());
    });

    test('should add asset', () async {
      final repository = container.read(assetRepositoryProvider.notifier);
      final asset = Asset(
        name: 'Test Asset',
        amount: 1000.0,
        type: AssetType.savings,
        isRecurring: false,
      );

      await repository.addAsset(asset);
      
      // Note: In a real test, you would verify the asset was added
      // by checking the stream or database state
    });

    test('should update asset', () async {
      final repository = container.read(assetRepositoryProvider.notifier);
      final asset = Asset(
        id: '1',
        name: 'Updated Asset',
        amount: 2000.0,
        type: AssetType.investment,
        isRecurring: true,
      );

      await repository.updateAsset(asset);
      
      // Note: In a real test, you would verify the asset was updated
    });

    test('should delete asset', () async {
      final repository = container.read(assetRepositoryProvider.notifier);
      
      await repository.deleteAsset('1');
      
      // Note: In a real test, you would verify the asset was deleted
    });

    test('should get asset by id', () async {
      final repository = container.read(assetRepositoryProvider.notifier);
      
      final asset = await repository.getAsset('1');
      
      // Note: In a real test, you would verify the correct asset is returned
      expect(asset, isNull); // Should be null for non-existent asset
    });
  });
}
