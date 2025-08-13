import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction.dart' as app_models;
import '../models/asset.dart';

abstract class StorageService {
  Future<void> init();
  Future<List<app_models.Transaction>> getTransactions();
  Future<int> insertTransaction(app_models.Transaction transaction);
  Future<int> updateTransaction(app_models.Transaction transaction);
  Future<int> deleteTransaction(int id);
  Future<List<Asset>> getAssets();
  Future<int> insertAsset(Asset asset);
  Future<int> updateAsset(Asset asset);
  Future<int> deleteAsset(int id);
  Future<void> clearAllData();
}

class WebStorageService implements StorageService {
  static const String _transactionsKey = 'transactions';
  static const String _assetsKey = 'assets';
  static const String _nextTransactionIdKey = 'next_transaction_id';
  static const String _nextAssetIdKey = 'next_asset_id';

  late SharedPreferences _prefs;

  @override
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Future<List<app_models.Transaction>> getTransactions() async {
    final transactionsJson = _prefs.getStringList(_transactionsKey) ?? [];
    return transactionsJson
        .map((json) => app_models.Transaction.fromMap(jsonDecode(json)))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<int> insertTransaction(app_models.Transaction transaction) async {
    final nextId = _prefs.getInt(_nextTransactionIdKey) ?? 1;
    final newTransaction = transaction.copyWith(id: nextId);
    
    final transactions = await getTransactions();
    transactions.insert(0, newTransaction);
    
    await _saveTransactions(transactions);
    await _prefs.setInt(_nextTransactionIdKey, nextId + 1);
    
    return nextId;
  }

  @override
  Future<int> updateTransaction(app_models.Transaction transaction) async {
    final transactions = await getTransactions();
    final index = transactions.indexWhere((t) => t.id == transaction.id);
    
    if (index != -1) {
      transactions[index] = transaction;
      await _saveTransactions(transactions);
      return 1;
    }
    return 0;
  }

  @override
  Future<int> deleteTransaction(int id) async {
    final transactions = await getTransactions();
    final initialLength = transactions.length;
    transactions.removeWhere((t) => t.id == id);
    
    if (transactions.length != initialLength) {
      await _saveTransactions(transactions);
      return 1;
    }
    return 0;
  }

  @override
  Future<List<Asset>> getAssets() async {
    final assetsJson = _prefs.getStringList(_assetsKey) ?? [];
    return assetsJson
        .map((json) => Asset.fromMap(jsonDecode(json)))
        .toList();
  }

  @override
  Future<int> insertAsset(Asset asset) async {
    final nextId = _prefs.getInt(_nextAssetIdKey) ?? 1;
    final newAsset = asset.copyWith(id: nextId);
    
    final assets = await getAssets();
    assets.add(newAsset);
    
    await _saveAssets(assets);
    await _prefs.setInt(_nextAssetIdKey, nextId + 1);
    
    return nextId;
  }

  @override
  Future<int> updateAsset(Asset asset) async {
    final assets = await getAssets();
    final index = assets.indexWhere((a) => a.id == asset.id);
    
    if (index != -1) {
      assets[index] = asset;
      await _saveAssets(assets);
      return 1;
    }
    return 0;
  }

  @override
  Future<int> deleteAsset(int id) async {
    final assets = await getAssets();
    final initialLength = assets.length;
    assets.removeWhere((a) => a.id == id);
    
    if (assets.length != initialLength) {
      await _saveAssets(assets);
      return 1;
    }
    return 0;
  }

  Future<void> _saveTransactions(List<app_models.Transaction> transactions) async {
    final transactionsJson = transactions
        .map((t) => jsonEncode(t.toMap()))
        .toList();
    await _prefs.setStringList(_transactionsKey, transactionsJson);
  }

  Future<void> _saveAssets(List<Asset> assets) async {
    final assetsJson = assets
        .map((a) => jsonEncode(a.toMap()))
        .toList();
    await _prefs.setStringList(_assetsKey, assetsJson);
  }

  @override
  Future<void> clearAllData() async {
    await _prefs.remove(_transactionsKey);
    await _prefs.remove(_assetsKey);
    await _prefs.remove(_nextTransactionIdKey);
    await _prefs.remove(_nextAssetIdKey);
  }
}

class MobileStorageService implements StorageService {
  final StorageService _sqliteService;

  MobileStorageService(this._sqliteService);

  @override
  Future<void> init() async {
    await _sqliteService.init();
  }

  @override
  Future<List<app_models.Transaction>> getTransactions() => _sqliteService.getTransactions();

  @override
  Future<int> insertTransaction(app_models.Transaction transaction) => _sqliteService.insertTransaction(transaction);

  @override
  Future<int> updateTransaction(app_models.Transaction transaction) => _sqliteService.updateTransaction(transaction);

  @override
  Future<int> deleteTransaction(int id) => _sqliteService.deleteTransaction(id);

  @override
  Future<List<Asset>> getAssets() => _sqliteService.getAssets();

  @override
  Future<int> insertAsset(Asset asset) => _sqliteService.insertAsset(asset);

  @override
  Future<int> updateAsset(Asset asset) => _sqliteService.updateAsset(asset);

  @override
  Future<int> deleteAsset(int id) => _sqliteService.deleteAsset(id);

  @override
  Future<void> clearAllData() => _sqliteService.clearAllData();
} 