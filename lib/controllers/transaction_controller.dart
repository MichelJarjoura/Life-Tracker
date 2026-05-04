import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transactions.dart';
import '../constants/storage_keys.dart';

class TransactionController extends GetxController {
  final transactions = <Transaction>[].obs;

  // ─── Persistence ────────────────────────────────────────────────────────────
  Future<void> _saveTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(transactions.map((t) => t.toJson()).toList());
    await prefs.setString(StorageKeys.transactions, encoded);
  }

  Future<void> loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(StorageKeys.transactions);
    if (json != null) {
      final list = jsonDecode(json) as List<dynamic>;
      transactions.value = list
          .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList();
    }
  }

  // ─── Computed ───────────────────────────────────────────────────────────────
  double get totalIncome =>
      transactions.where((t) => t.isIncome).fold(0.0, (s, t) => s + t.amount);

  double get totalExpenses =>
      transactions.where((t) => !t.isIncome).fold(0.0, (s, t) => s + t.amount);

  double get balance => totalIncome - totalExpenses;

  Map<String, double> get expensesByCategory {
    final map = <String, double>{};
    for (final t in transactions.where((t) => !t.isIncome)) {
      map[t.category] = (map[t.category] ?? 0) + t.amount;
    }
    return map;
  }

  List<Transaction> get recentTransactions {
    final sorted = List<Transaction>.from(transactions)
      ..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(10).toList();
  }

  // ─── CRUD ───────────────────────────────────────────────────────────────────
  void addTransaction(Transaction t) {
    transactions.add(t);
    _saveTransactions();
  }

  void deleteTransaction(String id) {
    transactions.removeWhere((t) => t.id == id);
    _saveTransactions();
  }

  // ─── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    loadTransactions();
  }
}
