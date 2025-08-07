class Asset {
  final int? id;
  final String name;
  final double amount;
  final AssetType type;
  final String? description;
  final DateTime? startDate;
  final bool isRecurring;

  Asset({
    this.id,
    required this.name,
    required this.amount,
    required this.type,
    this.description,
    this.startDate,
    required this.isRecurring,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'type': type.toString(),
      'description': description,
      'startDate': startDate?.toIso8601String(),
      'isRecurring': isRecurring ? 1 : 0,
    };
  }

  factory Asset.fromMap(Map<String, dynamic> map) {
    return Asset(
      id: map['id'],
      name: map['name'],
      amount: map['amount'],
      type: AssetType.values.firstWhere(
        (e) => e.toString() == map['type'],
      ),
      description: map['description'],
      startDate: map['startDate'] != null 
          ? DateTime.parse(map['startDate']) 
          : null,
      isRecurring: map['isRecurring'] == 1,
    );
  }

  Asset copyWith({
    int? id,
    String? name,
    double? amount,
    AssetType? type,
    String? description,
    DateTime? startDate,
    bool? isRecurring,
  }) {
    return Asset(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      isRecurring: isRecurring ?? this.isRecurring,
    );
  }
}

enum AssetType {
  salary,
  investment,
  savings,
  other,
}

extension AssetTypeExtension on AssetType {
  String get displayName {
    switch (this) {
      case AssetType.salary:
        return 'Salary';
      case AssetType.investment:
        return 'Investment';
      case AssetType.savings:
        return 'Savings';
      case AssetType.other:
        return 'Other';
    }
  }
} 