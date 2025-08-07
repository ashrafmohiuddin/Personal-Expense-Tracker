import '../models/transaction.dart';
import '../models/asset.dart';

class DummyData {
  static List<Transaction> getSampleTransactions() {
    final now = DateTime.now();
    return [
      Transaction(
        id: 1,
        amount: 45.50,
        description: 'Grocery Shopping',
        category: 'Food & Dining',
        trip: null,
        date: now.subtract(const Duration(days: 1)),
        type: TransactionType.expense,
      ),
      Transaction(
        id: 2,
        amount: 120.00,
        description: 'Gas Station',
        category: 'Transportation',
        trip: null,
        date: now.subtract(const Duration(days: 2)),
        type: TransactionType.expense,
      ),
      Transaction(
        id: 3,
        amount: 85.00,
        description: 'Movie Tickets',
        category: 'Entertainment',
        trip: null,
        date: now.subtract(const Duration(days: 3)),
        type: TransactionType.expense,
      ),
      Transaction(
        id: 4,
        amount: 2500.00,
        description: 'Monthly Salary',
        category: 'Salary',
        trip: null,
        date: now.subtract(const Duration(days: 5)),
        type: TransactionType.income,
      ),
      Transaction(
        id: 5,
        amount: 65.00,
        description: 'Restaurant Dinner',
        category: 'Food & Dining',
        trip: null,
        date: now.subtract(const Duration(days: 4)),
        type: TransactionType.expense,
      ),
      Transaction(
        id: 6,
        amount: 180.00,
        description: 'Shopping Mall',
        category: 'Shopping',
        trip: null,
        date: now.subtract(const Duration(days: 6)),
        type: TransactionType.expense,
      ),
      Transaction(
        id: 7,
        amount: 95.00,
        description: 'Doctor Visit',
        category: 'Healthcare',
        trip: null,
        date: now.subtract(const Duration(days: 7)),
        type: TransactionType.expense,
      ),
      Transaction(
        id: 8,
        amount: 350.00,
        description: 'Freelance Project',
        category: 'Freelance',
        trip: null,
        date: now.subtract(const Duration(days: 8)),
        type: TransactionType.income,
      ),
      Transaction(
        id: 9,
        amount: 220.00,
        description: 'Hotel Booking',
        category: 'Travel',
        trip: 'Business Trip',
        date: now.subtract(const Duration(days: 10)),
        type: TransactionType.expense,
      ),
      Transaction(
        id: 10,
        amount: 75.00,
        description: 'Coffee Shop',
        category: 'Food & Dining',
        trip: null,
        date: now.subtract(const Duration(days: 11)),
        type: TransactionType.expense,
      ),
      Transaction(
        id: 11,
        amount: 120.00,
        description: 'Electricity Bill',
        category: 'Utilities',
        trip: null,
        date: now.subtract(const Duration(days: 12)),
        type: TransactionType.expense,
      ),
      Transaction(
        id: 12,
        amount: 500.00,
        description: 'Investment Dividend',
        category: 'Investment',
        trip: null,
        date: now.subtract(const Duration(days: 15)),
        type: TransactionType.income,
      ),
    ];
  }

  static List<Asset> getSampleAssets() {
    final now = DateTime.now();
    return [
      Asset(
        id: 1,
        name: 'Primary Salary',
        amount: 5000.00,
        type: AssetType.salary,
        description: 'Monthly salary from main job',
        startDate: now.subtract(const Duration(days: 30)),
        isRecurring: true,
      ),
      Asset(
        id: 2,
        name: 'Savings Account',
        amount: 15000.00,
        type: AssetType.savings,
        description: 'Emergency fund and savings',
        startDate: now.subtract(const Duration(days: 90)),
        isRecurring: false,
      ),
      Asset(
        id: 3,
        name: 'Stock Portfolio',
        amount: 25000.00,
        type: AssetType.investment,
        description: 'Diversified stock investments',
        startDate: now.subtract(const Duration(days: 180)),
        isRecurring: false,
      ),
      Asset(
        id: 4,
        name: 'Freelance Income',
        amount: 1500.00,
        type: AssetType.salary,
        description: 'Monthly freelance projects',
        startDate: now.subtract(const Duration(days: 60)),
        isRecurring: true,
      ),
      Asset(
        id: 5,
        name: 'Crypto Holdings',
        amount: 8000.00,
        type: AssetType.investment,
        description: 'Cryptocurrency investments',
        startDate: now.subtract(const Duration(days: 120)),
        isRecurring: false,
      ),
    ];
  }
} 