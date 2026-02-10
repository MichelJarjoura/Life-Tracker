import 'dart:convert';

import 'package:get/get.dart';
import 'package:liquidity_tracker/models/transactions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionController extends GetxController {
  var transactions = <Transaction>[].obs;

  void saveTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final String encode = jsonEncode(
      transactions.map((t) => t.toJson()).toList(),
    );

    await prefs.setString('transactions', encode);
  }

  void loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();

    final String? transactionsJson = prefs.getString('transactions');

    if (transactionsJson != null) {
      final List<dynamic> decoded = jsonDecode(transactionsJson);
      transactions.value = decoded
          .map((json) => Transaction.fromJson(json))
          .toList();
    }
  }

  // Computed properties
  double get totalIncome {
    return transactions
        .where((t) => t.isIncome)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get totalExpenses {
    return transactions
        .where((t) => !t.isIncome)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get balance {
    return totalIncome - totalExpenses;
  }

  // Get transactions grouped by category
  Map<String, double> get expensesByCategory {
    Map<String, double> categoryMap = {};
    for (var transaction in transactions.where((t) => !t.isIncome)) {
      categoryMap[transaction.category] =
          (categoryMap[transaction.category] ?? 0) + transaction.amount;
    }
    return categoryMap;
  }

  // Get recent transactions (last 10)
  List<Transaction> get recentTransactions {
    var sorted = List<Transaction>.from(transactions);
    sorted.sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(10).toList();
  }

  void addTransaction(Transaction transaction) {
    transactions.add(transaction);

    saveTransactions();
  }

  void deleteTransaction(String id) {
    transactions.removeWhere((t) => t.id == id);

    saveTransactions();
  }

  @override
  void onInit() {
    super.onInit();
    // Add some sample data
    loadTransactions();
  }
}
