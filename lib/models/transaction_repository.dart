import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'transaction.dart';

class TransactionRepository {
  static final List<Transaction> _transactions = [];
  static final List<VoidCallback> _listeners = [];
  static bool _isInitialized = false;

  static double _overallBudget = 0.0;
  static final Map<TransactionCategory, double> _categoryBudgets = {};
  static bool _neonGlowEnabled = true;
  static String _currencyCode = 'INR';

  static List<Transaction> get transactions => List.unmodifiable(_transactions);
  static double get overallBudget => _overallBudget;
  static Map<TransactionCategory, double> get categoryBudgets => Map.unmodifiable(_categoryBudgets);
  static bool get neonGlowEnabled => _neonGlowEnabled;
  static String get currencyCode => _currencyCode;

  static void addListener(VoidCallback listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  static void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  static void _notifyListeners() {
    for (final listener in _listeners) {
      try {
        listener();
      } catch (e) {
        debugPrint('Error notifying listener: $e');
      }
    }
  }

  static Future<void> init() async {
    if (_isInitialized) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final hasRunBefore = prefs.getBool('has_run_before') ?? false;

      if (!hasRunBefore) {
        // First run: pre-populate with sample transactions
        _transactions.addAll(kSampleTransactions);
        await _saveToPrefs(prefs);
        await prefs.setBool('has_run_before', true);
      } else {
        final data = prefs.getString('transactions_data');
        if (data != null) {
          final List<dynamic> decoded = jsonDecode(data);
          _transactions.clear();
          _transactions.addAll(
            decoded.map((x) => Transaction.fromJson(x as Map<String, dynamic>)),
          );
        }
        
        // Load overall budget
        _overallBudget = prefs.getDouble('overall_budget') ?? 0.0;

        // Load category budgets
        final catBudgetsJson = prefs.getString('category_budgets');
        if (catBudgetsJson != null) {
          final Map<String, dynamic> decoded = jsonDecode(catBudgetsJson);
          _categoryBudgets.clear();
          decoded.forEach((key, value) {
            try {
              final cat = TransactionCategory.values.byName(key);
              _categoryBudgets[cat] = (value as num).toDouble();
            } catch (_) {}
          });
        }
      }
      _neonGlowEnabled = prefs.getBool('neon_glow_enabled') ?? true;
      _currencyCode = prefs.getString('currency_code') ?? 'INR';
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing TransactionRepository: $e');
    }
  }

  static Future<void> addTransaction(Transaction t) async {
    _transactions.add(t);
    _notifyListeners();
    await _save();
  }

  static Future<void> updateTransaction(Transaction transaction) async {
    final index = _transactions.indexWhere((item) => item.id == transaction.id);
    if (index == -1) return;
    _transactions[index] = transaction;
    _notifyListeners();
    await _save();
  }

  static Future<void> deleteTransaction(String id) async {
    _transactions.removeWhere((transaction) => transaction.id == id);
    _notifyListeners();
    await _save();
  }

  static Future<void> clearAllData() async {
    _transactions.clear();
    _overallBudget = 0.0;
    _categoryBudgets.clear();
    _notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('transactions_data');
    await prefs.remove('overall_budget');
    await prefs.remove('category_budgets');
    // Keep 'has_run_before' as true so it doesn't re-populate on restart
    await prefs.setBool('has_run_before', true);
  }

  static Future<void> updateOverallBudget(double value) async {
    _overallBudget = value;
    _notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('overall_budget', value);
    } catch (e) {
      debugPrint('Error saving overall budget: $e');
    }
  }

  static Future<void> updateCategoryBudget(TransactionCategory category, double value) async {
    _categoryBudgets[category] = value;
    _notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final Map<String, double> temp = {};
      _categoryBudgets.forEach((key, val) {
        temp[key.name] = val;
      });
      await prefs.setString('category_budgets', jsonEncode(temp));
    } catch (e) {
      debugPrint('Error saving category budgets: $e');
    }
  }

  static Future<void> updateNeonGlowEnabled(bool value) async {
    _neonGlowEnabled = value;
    _notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('neon_glow_enabled', value);
    } catch (e) {
      debugPrint('Error saving neon glow setting: $e');
    }
  }

  static Future<void> updateCurrencyCode(String value) async {
    _currencyCode = value;
    _notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('currency_code', value);
    } catch (e) {
      debugPrint('Error saving currency setting: $e');
    }
  }

  static Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await _saveToPrefs(prefs);
    } catch (e) {
      debugPrint('Error saving transactions: $e');
    }
  }

  static Future<void> _saveToPrefs(SharedPreferences prefs) async {
    final data = jsonEncode(_transactions.map((tx) => tx.toJson()).toList());
    await prefs.setString('transactions_data', data);
  }
}
