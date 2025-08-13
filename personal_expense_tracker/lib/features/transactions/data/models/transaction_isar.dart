import 'package:isar/isar.dart';
import '../../domain/models/transaction.dart';

part 'transaction_isar.g.dart';

@collection
class TransactionIsar {
  Id id = Isar.autoIncrement;

  @enumerated
  late TransactionType type;

  late double amount;

  @Index()
  late String category;

  String? merchant;

  String? tripId;

  @Index()
  late DateTime date;

  String? note;

  TransactionIsar();

  TransactionIsar.fromDomain(Transaction transaction) {
    type = transaction.type;
    amount = transaction.amount;
    category = transaction.category;
    merchant = transaction.merchant;
    tripId = transaction.tripId;
    date = transaction.date;
    note = transaction.note;
  }

  Transaction toDomain() {
    return Transaction(
      id: id.toString(),
      type: type,
      amount: amount,
      category: category,
      merchant: merchant,
      tripId: tripId,
      date: date,
      note: note,
    );
  }
}
