import 'package:flutter/foundation.dart';
import '../models/transaction.dart';
import '../models/asset.dart';
import '../services/storage_factory.dart';
import '../utils/dummy_data.dart';

class ExpenseProvider with ChangeNotifier {
  final _storageService = StorageFactory.instance;
  
  List<Transaction> _transactions = [];
  List<Asset> _assets = [];
  bool _isLoading = false;

  List<Transaction> get transactions => _transactions;
  List<Asset> get assets => _assets;
  bool get isLoading => _isLoading;

  // Get transactions for a specific date range
  List<Transaction> getTransactionsByDateRange(DateTime start, DateTime end) {
    return _transactions.where((transaction) {
      return transaction.date.isAfter(start.subtract(const Duration(days: 1))) &&
             transaction.date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  // Get recent transactions (last 10)
  List<Transaction> get recentTransactions {
    return _transactions.take(10).toList();
  }

  // Get total expenses for a date range
  double getTotalExpenses(DateTime start, DateTime end) {
    return getTransactionsByDateRange(start, end)
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  // Get total income for a date range
  double getTotalIncome(DateTime start, DateTime end) {
    return getTransactionsByDateRange(start, end)
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  // Get expenses by category for a date range
  Map<String, double> getExpensesByCategory(DateTime start, DateTime end) {
    Map<String, double> categoryTotals = {};
    final transactions = getTransactionsByDateRange(start, end)
        .where((t) => t.type == TransactionType.expense);
    
    for (var transaction in transactions) {
      categoryTotals[transaction.category] = 
          (categoryTotals[transaction.category] ?? 0) + transaction.amount;
    }
    return categoryTotals;
  }

  // Load all transactions
  Future<void> loadTransactions() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _storageService.init();
      _transactions = await _storageService.getTransactions();
      
      // Load dummy data if no transactions exist
      if (_transactions.isEmpty) {
        _transactions = DummyData.getSampleTransactions();
      }
    } catch (e) {
      debugPrint('Error loading transactions: $e');
      // Fallback to dummy data on error
      _transactions = DummyData.getSampleTransactions();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add new transaction
  Future<void> addTransaction(Transaction transaction) async {
    try {
      final id = await _storageService.insertTransaction(transaction);
      final newTransaction = transaction.copyWith(id: id);
      _transactions.insert(0, newTransaction);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding transaction: $e');
      rethrow;
    }
  }

  // Update transaction
  Future<void> updateTransaction(Transaction transaction) async {
    try {
      await _storageService.updateTransaction(transaction);
      final index = _transactions.indexWhere((t) => t.id == transaction.id);
      if (index != -1) {
        _transactions[index] = transaction;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating transaction: $e');
      rethrow;
    }
  }

  // Delete transaction
  Future<void> deleteTransaction(int id) async {
    try {
      await _storageService.deleteTransaction(id);
      _transactions.removeWhere((t) => t.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting transaction: $e');
      rethrow;
    }
  }

  // Load all assets
  Future<void> loadAssets() async {
    try {
      await _storageService.init();
      _assets = await _storageService.getAssets();
      
      // Load dummy data if no assets exist
      if (_assets.isEmpty) {
        _assets = DummyData.getSampleAssets();
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading assets: $e');
      // Fallback to dummy data on error
      _assets = DummyData.getSampleAssets();
      notifyListeners();
    }
  }

  // Add new asset
  Future<void> addAsset(Asset asset) async {
    try {
      final id = await _storageService.insertAsset(asset);
      final newAsset = asset.copyWith(id: id);
      _assets.add(newAsset);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding asset: $e');
      rethrow;
    }
  }

  // Update asset
  Future<void> updateAsset(Asset asset) async {
    try {
      await _storageService.updateAsset(asset);
      final index = _assets.indexWhere((a) => a.id == asset.id);
      if (index != -1) {
        _assets[index] = asset;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating asset: $e');
      rethrow;
    }
  }

  // Delete asset
  Future<void> deleteAsset(int id) async {
    try {
      await _storageService.deleteAsset(id);
      _assets.removeWhere((a) => a.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting asset: $e');
      rethrow;
    }
  }

  // Get total assets value
  double get totalAssetsValue {
    return _assets.fold(0.0, (sum, asset) => sum + asset.amount);
  }

  // Get recurring monthly income
  double get recurringMonthlyIncome {
    return _assets
        .where((asset) => asset.isRecurring && asset.type == AssetType.salary)
        .fold(0.0, (sum, asset) => sum + asset.amount);
  }
} 