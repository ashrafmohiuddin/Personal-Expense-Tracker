class Transaction {
  final int? id;
  final double amount;
  final String description;
  final String category;
  final String? trip;
  final DateTime date;
  final TransactionType type;

  Transaction({
    this.id,
    required this.amount,
    required this.description,
    required this.category,
    this.trip,
    required this.date,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'description': description,
      'category': category,
      'trip': trip,
      'date': date.toIso8601String(),
      'type': type.toString(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      amount: map['amount'],
      description: map['description'],
      category: map['category'],
      trip: map['trip'],
      date: DateTime.parse(map['date']),
      type: TransactionType.values.firstWhere(
        (e) => e.toString() == map['type'],
      ),
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction.fromMap(json);
  }

  Transaction copyWith({
    int? id,
    double? amount,
    String? description,
    String? category,
    String? trip,
    DateTime? date,
    TransactionType? type,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      category: category ?? this.category,
      trip: trip ?? this.trip,
      date: date ?? this.date,
      type: type ?? this.type,
    );
  }
}

enum TransactionType {
  expense,
  income,
}

extension TransactionTypeExtension on TransactionType {
  String get displayName {
    switch (this) {
      case TransactionType.expense:
        return 'Expense';
      case TransactionType.income:
        return 'Income';
    }
  }
} 