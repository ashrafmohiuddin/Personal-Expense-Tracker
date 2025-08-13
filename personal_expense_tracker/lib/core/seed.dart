import '../features/transactions/domain/models/transaction.dart';
import '../features/assets/domain/models/asset.dart';
import '../features/transactions/data/repositories/transaction_repository.dart';
import '../features/assets/data/repositories/asset_repository.dart';

class SeedData {
  static const List<String> defaultCategories = [
    'Food & Dining',
    'Transportation',
    'Shopping',
    'Entertainment',
    'Healthcare',
    'Utilities',
    'Housing',
    'Education',
    'Travel',
    'Salary',
    'Freelance',
    'Investment',
    'Gifts',
    'Other',
  ];

  static const List<Asset> defaultAssets = [
    Asset(
      name: 'Monthly Salary',
      amount: 50000.0,
      type: AssetType.salary,
      isRecurring: true,
      description: 'Primary source of income',
    ),
    Asset(
      name: 'Emergency Fund',
      amount: 100000.0,
      type: AssetType.savings,
      isRecurring: false,
      description: 'Emergency savings account',
    ),
  ];

  static const List<Transaction> sampleTransactions = [
    Transaction(
      type: TransactionType.income,
      amount: 50000.0,
      category: 'Salary',
      merchant: 'Company Inc.',
      date: DateTime.now().subtract(const Duration(days: 1)),
      note: 'Monthly salary payment',
    ),
    Transaction(
      type: TransactionType.expense,
      amount: 1200.0,
      category: 'Food & Dining',
      merchant: 'Grocery Store',
      date: DateTime.now().subtract(const Duration(days: 2)),
      note: 'Weekly groceries',
    ),
    Transaction(
      type: TransactionType.expense,
      amount: 500.0,
      category: 'Transportation',
      merchant: 'Fuel Station',
      date: DateTime.now().subtract(const Duration(days: 3)),
      note: 'Fuel for car',
    ),
  ];

  static Future<void> seedDatabase(
    TransactionRepository transactionRepo,
    AssetRepository assetRepo,
  ) async {
    // Add sample transactions
    for (final transaction in sampleTransactions) {
      await transactionRepo.addTransaction(transaction);
    }

    // Add default assets
    for (final asset in defaultAssets) {
      await assetRepo.addAsset(asset);
    }
  }
}
