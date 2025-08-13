import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/transaction_isar.dart';
import '../../domain/models/transaction.dart';
import '../../../core/services/database_service.dart';

part 'transaction_repository.g.dart';

@riverpod
class TransactionRepository extends _$TransactionRepository {
  late final Isar _isar;

  @override
  Future<void> build() async {
    _isar = DatabaseService.instance;
  }

  // Streams
  Stream<List<Transaction>> watchAllTransactions() {
    return _isar.transactionIsars
        .where()
        .sortByDate()
        .watch(fireImmediately: true)
        .map((list) => list.map((e) => e.toDomain()).toList());
  }

  Stream<List<Transaction>> watchTransactionsByType(TransactionType type) {
    return _isar.transactionIsars
        .filter()
        .typeEqualTo(type)
        .sortByDate()
        .watch(fireImmediately: true)
        .map((list) => list.map((e) => e.toDomain()).toList());
  }

  Stream<List<Transaction>> watchTransactionsByDateRange(
    DateTime start,
    DateTime end,
  ) {
    return _isar.transactionIsars
        .filter()
        .dateBetween(start, end)
        .sortByDate()
        .watch(fireImmediately: true)
        .map((list) => list.map((e) => e.toDomain()).toList());
  }

  // Aggregates
  Stream<double> watchTotalIncome() {
    return _isar.transactionIsars
        .filter()
        .typeEqualTo(TransactionType.income)
        .watch(fireImmediately: true)
        .map((list) => list.fold(0.0, (sum, item) => sum + item.amount));
  }

  Stream<double> watchTotalExpenses() {
    return _isar.transactionIsars
        .filter()
        .typeEqualTo(TransactionType.expense)
        .watch(fireImmediately: true)
        .map((list) => list.fold(0.0, (sum, item) => sum + item.amount));
  }

  Stream<double> watchNetBalance() {
    return _isar.transactionIsars
        .where()
        .watch(fireImmediately: true)
        .map((list) {
          double income = 0.0;
          double expenses = 0.0;
          for (final item in list) {
            if (item.type == TransactionType.income) {
              income += item.amount;
            } else {
              expenses += item.amount;
            }
          }
          return income - expenses;
        });
  }

  // Weekly aggregates
  Stream<double> watchWeeklyIncome() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));
    return _isar.transactionIsars
        .filter()
        .typeEqualTo(TransactionType.income)
        .and()
        .dateBetween(weekStart, weekEnd)
        .watch(fireImmediately: true)
        .map((list) => list.fold(0.0, (sum, item) => sum + item.amount));
  }

  Stream<double> watchWeeklyExpenses() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));
    return _isar.transactionIsars
        .filter()
        .typeEqualTo(TransactionType.expense)
        .and()
        .dateBetween(weekStart, weekEnd)
        .watch(fireImmediately: true)
        .map((list) => list.fold(0.0, (sum, item) => sum + item.amount));
  }

  // Monthly aggregates
  Stream<double> watchMonthlyIncome() {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0);
    return _isar.transactionIsars
        .filter()
        .typeEqualTo(TransactionType.income)
        .and()
        .dateBetween(monthStart, monthEnd)
        .watch(fireImmediately: true)
        .map((list) => list.fold(0.0, (sum, item) => sum + item.amount));
  }

  Stream<double> watchMonthlyExpenses() {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0);
    return _isar.transactionIsars
        .filter()
        .typeEqualTo(TransactionType.expense)
        .and()
        .dateBetween(monthStart, monthEnd)
        .watch(fireImmediately: true)
        .map((list) => list.fold(0.0, (sum, item) => sum + item.amount));
  }

  // CRUD operations
  Future<void> addTransaction(Transaction transaction) async {
    final transactionIsar = TransactionIsar.fromDomain(transaction);
    await _isar.writeTxn(() async {
      await _isar.transactionIsars.put(transactionIsar);
    });
  }

  Future<void> updateTransaction(Transaction transaction) async {
    if (transaction.id == null) return;
    final transactionIsar = TransactionIsar.fromDomain(transaction);
    transactionIsar.id = int.parse(transaction.id!);
    await _isar.writeTxn(() async {
      await _isar.transactionIsars.put(transactionIsar);
    });
  }

  Future<void> deleteTransaction(String id) async {
    await _isar.writeTxn(() async {
      await _isar.transactionIsars.delete(int.parse(id));
    });
  }

  Future<Transaction?> getTransaction(String id) async {
    final transactionIsar = await _isar.transactionIsars.get(int.parse(id));
    return transactionIsar?.toDomain();
  }

  // Categories
  Stream<List<String>> watchCategories() {
    return _isar.transactionIsars
        .where()
        .watch(fireImmediately: true)
        .map((list) => list.map((e) => e.category).toSet().toList()..sort());
  }
}
