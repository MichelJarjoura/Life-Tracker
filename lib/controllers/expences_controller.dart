import 'package:get/get.dart';
import 'package:liquidity_tracker/models/transactions.dart';

class TransactionController extends GetxController {
  var transactions = <Transaction>[].obs;

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
  }

  void deleteTransaction(String id) {
    transactions.removeWhere((t) => t.id == id);
  }

  @override
  void onInit() {
    super.onInit();
    // Add some sample data
    _loadSampleData();
  }

  void _loadSampleData() {
    final now = DateTime.now();

    transactions.addAll([
      Transaction(
        id: '1',
        title: 'Salary',
        amount: 5000.00,
        date: now.subtract(const Duration(days: 5)),
        category: 'Income',
        isIncome: true,
      ),
      Transaction(
        id: '2',
        title: 'Groceries',
        amount: 150.50,
        date: now.subtract(const Duration(days: 2)),
        category: 'Food',
        isIncome: false,
      ),
      Transaction(
        id: '3',
        title: 'Rent',
        amount: 1200.00,
        date: now.subtract(const Duration(days: 1)),
        category: 'Housing',
        isIncome: false,
      ),
      Transaction(
        id: '4',
        title: 'Freelance Project',
        amount: 800.00,
        date: now.subtract(const Duration(days: 3)),
        category: 'Income',
        isIncome: true,
      ),
      Transaction(
        id: '5',
        title: 'Restaurant',
        amount: 85.00,
        date: now,
        category: 'Food',
        isIncome: false,
      ),
      Transaction(
        id: '6',
        title: 'Gas',
        amount: 60.00,
        date: now.subtract(const Duration(days: 1)),
        category: 'Transport',
        isIncome: false,
      ),
      Transaction(
        id: '7',
        title: 'Online Shopping',
        amount: 250.00,
        date: now.subtract(const Duration(days: 4)),
        category: 'Shopping',
        isIncome: false,
      ),
      Transaction(
        id: '8',
        title: 'Electricity Bill',
        amount: 120.00,
        date: now.subtract(const Duration(days: 6)),
        category: 'Utilities',
        isIncome: false,
      ),
    ]);
  }
}
