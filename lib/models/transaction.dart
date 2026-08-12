import 'package:flutter/material.dart';

enum TransactionType { income, expense }

enum TransactionCategory {
  food,
  gear,
  stationary,
  income,
  housing,
  transport,
  health,
  entertainment,
  other,
}

extension TransactionCategoryExt on TransactionCategory {
  String get label {
    switch (this) {
      case TransactionCategory.food: return 'Food';
      case TransactionCategory.gear: return 'Gear';
      case TransactionCategory.stationary: return 'Stationary';
      case TransactionCategory.income: return 'Income';
      case TransactionCategory.housing: return 'Housing';
      case TransactionCategory.transport: return 'Transport';
      case TransactionCategory.health: return 'Health';
      case TransactionCategory.entertainment: return 'Entertainment';
      case TransactionCategory.other: return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case TransactionCategory.food: return Icons.restaurant_rounded;
      case TransactionCategory.gear: return Icons.shopping_cart_rounded;
      case TransactionCategory.stationary: return Icons.edit_note_rounded;
      case TransactionCategory.income: return Icons.payments_rounded;
      case TransactionCategory.housing: return Icons.home_rounded;
      case TransactionCategory.transport: return Icons.directions_car_rounded;
      case TransactionCategory.health: return Icons.favorite_rounded;
      case TransactionCategory.entertainment: return Icons.movie_rounded;
      case TransactionCategory.other: return Icons.category_rounded;
    }
  }

  Color get color {
    switch (this) {
      case TransactionCategory.food: return const Color(0xFF00FF00);
      case TransactionCategory.gear: return const Color(0xFFFF00FF);
      case TransactionCategory.stationary: return const Color(0xFF5B9BFF);
      case TransactionCategory.income: return const Color(0xFF00DBE9);
      case TransactionCategory.housing: return const Color(0xFFFF00FF);
      case TransactionCategory.transport: return const Color(0xFFFFD700);
      case TransactionCategory.health: return const Color(0xFFFF6B6B);
      case TransactionCategory.entertainment: return const Color(0xFFBF5FFF);
      case TransactionCategory.other: return const Color(0xFF849495);
    }
  }
}

class Transaction {
  final String id;
  final String title;
  final double amount;
  final TransactionType type;
  final TransactionCategory category;
  final DateTime date;

  const Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
  });

  bool get isIncome => type == TransactionType.income;
  double get signedAmount => isIncome ? amount : -amount;

  Transaction copyWith({
    String? id,
    String? title,
    double? amount,
    TransactionType? type,
    TransactionCategory? category,
    DateTime? date,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type.name,
      'category': category.name,
      'date': date.toIso8601String(),
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: TransactionType.values.byName(json['type'] as String),
      category: TransactionCategory.values.byName(json['category'] as String),
      date: DateTime.parse(json['date'] as String),
    );
  }
}


// â”€â”€â”€ Sample data (replaces DB for now) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
final List<Transaction> kSampleTransactions = [
  Transaction(
    id: '1',
    title: 'Megacorp Salary',
    amount: 4200.00,
    type: TransactionType.income,
    category: TransactionCategory.income,
    date: DateTime.now().subtract(const Duration(days: 1)),
  ),
  Transaction(
    id: '2',
    title: 'Cybernetics Co.',
    amount: 450.00,
    type: TransactionType.expense,
    category: TransactionCategory.gear,
    date: DateTime.now(),
  ),
  Transaction(
    id: '3',
    title: 'Neo Noodle Bar',
    amount: 24.50,
    type: TransactionType.expense,
    category: TransactionCategory.food,
    date: DateTime.now(),
  ),
  Transaction(
    id: '4',
    title: 'Freelance Project',
    amount: 1200.00,
    type: TransactionType.income,
    category: TransactionCategory.income,
    date: DateTime.now().subtract(const Duration(days: 3)),
  ),
  Transaction(
    id: '5',
    title: 'Apartment Rent',
    amount: 1600.00,
    type: TransactionType.expense,
    category: TransactionCategory.housing,
    date: DateTime.now().subtract(const Duration(days: 5)),
  ),
  Transaction(
    id: '6',
    title: 'Metro Pass',
    amount: 45.00,
    type: TransactionType.expense,
    category: TransactionCategory.transport,
    date: DateTime.now().subtract(const Duration(days: 6)),
  ),
  Transaction(
    id: '7',
    title: 'Tech Subscription',
    amount: 29.99,
    type: TransactionType.expense,
    category: TransactionCategory.entertainment,
    date: DateTime.now().subtract(const Duration(days: 7)),
  ),
  Transaction(
    id: '8',
    title: 'Health Insurance',
    amount: 180.00,
    type: TransactionType.expense,
    category: TransactionCategory.health,
    date: DateTime.now().subtract(const Duration(days: 8)),
  ),
];

