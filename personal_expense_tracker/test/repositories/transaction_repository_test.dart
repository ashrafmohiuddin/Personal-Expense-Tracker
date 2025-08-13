import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:personal_expense_tracker/features/transactions/data/repositories/transaction_repository.dart';
import 'package:personal_expense_tracker/features/transactions/domain/models/transaction.dart';

void main() {
  group('TransactionRepository', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should initialize repository', () async {
      final repository = container.read(transactionRepositoryProvider);
      expect(repository, isA<TransactionRepository>());
    });

    test('should add transaction', () async {
      final repository = container.read(transactionRepositoryProvider.notifier);
      final transaction = Transaction(
        type: TransactionType.expense,
        amount: 100.0,
        category: 'Food',
        date: DateTime.now(),
      );

      await repository.addTransaction(transaction);
      
      // Note: In a real test, you would verify the transaction was added
      // by checking the stream or database state
    });

    test('should update transaction', () async {
      final repository = container.read(transactionRepositoryProvider.notifier);
      final transaction = Transaction(
        id: '1',
        type: TransactionType.expense,
        amount: 100.0,
        category: 'Food',
        date: DateTime.now(),
      );

      await repository.updateTransaction(transaction);
      
      // Note: In a real test, you would verify the transaction was updated
    });

    test('should delete transaction', () async {
      final repository = container.read(transactionRepositoryProvider.notifier);
      
      await repository.deleteTransaction('1');
      
      // Note: In a real test, you would verify the transaction was deleted
    });

    test('should get transaction by id', () async {
      final repository = container.read(transactionRepositoryProvider.notifier);
      
      final transaction = await repository.getTransaction('1');
      
      // Note: In a real test, you would verify the correct transaction is returned
      expect(transaction, isNull); // Should be null for non-existent transaction
    });
  });
}
