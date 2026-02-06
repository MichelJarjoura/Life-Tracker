import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _summaryCards(),
            const SizedBox(height: 20),
            _spendingOverview(),
            const SizedBox(height: 20),
            _categories(),
          ],
        ),
      ),
    );
  }

  // 🔹 HEADER

  // 🔹 TOTAL + TRANSACTIONS
  Widget _summaryCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _infoCard(title: "Total", value: "\$100.50", color: Colors.blue),
          const SizedBox(width: 15),
          _infoCard(title: "Transactions", value: "3", color: Colors.purple),
        ],
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 SPENDING OVERVIEW
  Widget _spendingOverview() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Spending Overview",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 180,
              child: Row(
                children: [
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        borderData: FlBorderData(show: false),
                        centerSpaceRadius: 60,
                        sectionsSpace: 3,
                        sections: [
                          PieChartSectionData(
                            value: 100,
                            color: Colors.blue,
                            title: "",
                            radius: 30,
                          ),
                          PieChartSectionData(
                            value: 30,
                            color: Colors.purple,
                            title: "",
                            radius: 30,
                          ),
                          PieChartSectionData(
                            value: 25,
                            color: Colors.pink,
                            title: "",
                            radius: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _LegendItem(color: Colors.blue, text: "Food"),
                        SizedBox(height: 10),
                        _LegendItem(color: Colors.purple, text: "Transport"),
                        SizedBox(height: 10),
                        _LegendItem(color: Colors.pink, text: "Entertainment"),
                        SizedBox(height: 10),
                        _LegendItem(color: Colors.yellow, text: "b1"),
                        SizedBox(height: 10),
                        _LegendItem(color: Colors.deepPurple, text: "b2"),
                        SizedBox(height: 10),
                        _LegendItem(color: Colors.orange, text: "b3"),
                        SizedBox(height: 10),
                        _LegendItem(color: Colors.deepOrange, text: "b4"),
                        SizedBox(height: 10),
                        _LegendItem(color: Colors.green, text: "b5"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 CATEGORIES
  Widget _categories() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            _categoryRow(
              icon: Icons.fastfood,
              title: "Food",
              amount: "\$45.50",
              percent: 0.45,
              color: Colors.blue,
            ),
            const SizedBox(height: 15),
            _categoryRow(
              icon: Icons.directions_car,
              title: "Transport",
              amount: "\$30.00",
              percent: 0.30,
              color: Colors.purple,
            ),
            const SizedBox(height: 15),
            _categoryRow(
              icon: Icons.movie,
              title: "Entertainment",
              amount: "\$25.00",
              percent: 0.25,
              color: Colors.pink,
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryRow({
    required IconData icon,
    required String title,
    required String amount,
    required double percent,
    required Color color,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 10),
            Expanded(child: Text(title)),
            Text(amount),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: percent,
          color: color,
          backgroundColor: color.withOpacity(0.2),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const _LegendItem({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}
