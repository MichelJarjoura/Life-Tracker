import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../constants/app_theme.dart';
import '../../controllers/transaction_controller.dart';
import '../../models/transactions.dart';
import '../../utils/app_date_utils.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<TransactionController>();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: [
          // ── Balance hero ───────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Obx(
              () => _BalanceHero(
                balance: ctrl.balance,
                income: ctrl.totalIncome,
                expenses: ctrl.totalExpenses,
              ),
            ),
          ),

          // ── Analytics ─────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Obx(() {
              final cats = ctrl.expensesByCategory;
              return _SectionCard(
                title: 'Expenses by category',
                child: cats.isEmpty
                    ? const _EmptyChart()
                    : _DonutChart(data: cats),
              );
            }),
          ),

          // ── Transactions header ────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent transactions',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Obx(
                    () => Text(
                      '${ctrl.transactions.length} total',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Transaction list ───────────────────────────────────────────────
          Obx(() {
            final list = ctrl.recentTransactions;
            if (list.isEmpty) {
              return const SliverToBoxAdapter(child: _EmptyTransactions());
            }
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => _TransactionTile(
                  transaction: list[i],
                  onDelete: () => ctrl.deleteTransaction(list[i].id),
                ),
                childCount: list.length,
              ),
            );
          }),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context, ctrl),
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}

// ─── Balance Hero ─────────────────────────────────────────────────────────────

class _BalanceHero extends StatelessWidget {
  const _BalanceHero({
    required this.balance,
    required this.income,
    required this.expenses,
  });
  final double balance, income, expenses;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5B21B6), Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Total Balance',
            style: TextStyle(color: Colors.white60, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            '\$${balance.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.5,
              height: 1,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  label: 'Income',
                  amount: income,
                  icon: Icons.arrow_downward_rounded,
                  color: AppColors.income,
                ),
              ),
              Container(width: 1, height: 40, color: Colors.white12),
              Expanded(
                child: _MiniStat(
                  label: 'Expenses',
                  amount: expenses,
                  icon: Icons.arrow_upward_rounded,
                  color: AppColors.expense,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
  });
  final String label;
  final double amount;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
          child: Icon(icon, color: color, size: 14),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white54, fontSize: 11),
            ),
            Text(
              '\$${amount.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Section Card ─────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

// ─── Donut Chart ──────────────────────────────────────────────────────────────

class _DonutChart extends StatelessWidget {
  const _DonutChart({required this.data});
  final Map<String, double> data;

  static const _palette = [
    Color(0xFF7C3AED),
    Color(0xFF10B981),
    Color(0xFFF59E0B),
    Color(0xFF3B82F6),
    Color(0xFFEF4444),
    Color(0xFFEC4899),
    Color(0xFF8B5CF6),
  ];

  @override
  Widget build(BuildContext context) {
    final entries = data.entries.toList();
    final total = data.values.fold(0.0, (s, v) => s + v);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Square chart box: fl_chart uses the shortest side — a wide short
        // rectangle made the donut look clipped or uneven on phones.
        final maxW = constraints.maxWidth;
        final dim = (maxW * 0.88).clamp(200.0, 272.0);
        // fl_chart: outer radius = centerSpaceRadius + section.radius (ring
        // thickness). Both must fit inside half the box or the arc draws past
        // the bounds and overlaps center text / legend.
        final inset = 8.0;
        final maxOuterRadius = dim / 2 - inset;
        final centerHoleRadius = maxOuterRadius * 0.48;
        final ringThickness = maxOuterRadius - centerHoleRadius;

        return Column(
          children: [
            Center(
              child: SizedBox(
                width: dim,
                height: dim,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.hardEdge,
                  children: [
                    PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: centerHoleRadius,
                        sections: List.generate(entries.length, (i) {
                          return PieChartSectionData(
                            value: entries[i].value,
                            color: _palette[i % _palette.length],
                            radius: ringThickness,
                            showTitle: false,
                          );
                        }),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: (12 * dim / 240).clamp(11.0, 13.0),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: (2 * dim / 240).clamp(2.0, 4.0)),
                        Text(
                          '\$${total.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: (22 * dim / 240).clamp(18.0, 24.0),
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ...List.generate(entries.length, (i) {
              final amount = entries[i].value;
              final pct = total > 0 ? amount / total * 100 : 0.0;
              final color = _palette[i % _palette.length];

              return Padding(
                padding: EdgeInsets.only(top: i == 0 ? 0 : 10),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: Text(
                        entries[i].key,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      flex: 2,
                      child: Text(
                        '\$${amount.toStringAsFixed(2)}',
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 44,
                      child: Text(
                        '${pct.toStringAsFixed(0)}%',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: color,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

// ─── Transaction Tile ─────────────────────────────────────────────────────────

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.transaction, required this.onDelete});
  final Transaction transaction;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.isIncome;
    final color = isIncome ? AppColors.income : AppColors.expense;

    return Dismissible(
      key: Key(transaction.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        color: AppColors.expense.withOpacity(0.15),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: AppColors.expense,
        ),
      ),
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) => onDelete(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(
                _categoryIcon(transaction.category),
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${transaction.category} · ${AppDateUtils.formatRelativeTime(transaction.date)}',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${isIncome ? '+' : '−'}\$${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: color,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) => showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Delete transaction?'),
      content: const Text('This action cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.expense),
          child: const Text('Delete'),
        ),
      ],
    ),
  );

  IconData _categoryIcon(String cat) {
    switch (cat.toLowerCase()) {
      case 'food':
        return Icons.restaurant_outlined;
      case 'transport':
        return Icons.directions_car_outlined;
      case 'entertainment':
        return Icons.movie_outlined;
      case 'coffee shops':
        return Icons.coffee_outlined;
      case 'utilities':
        return Icons.bolt_outlined;
      case 'shopping':
        return Icons.shopping_bag_outlined;
      case 'income':
        return Icons.attach_money_rounded;
      default:
        return Icons.category_outlined;
    }
  }
}

// ─── Empty States ─────────────────────────────────────────────────────────────

class _EmptyChart extends StatelessWidget {
  const _EmptyChart();

  @override
  Widget build(BuildContext context) => const SizedBox(
    height: 100,
    child: Center(
      child: Text(
        'No expenses yet',
        style: TextStyle(color: AppColors.textMuted, fontSize: 14),
      ),
    ),
  );
}

class _EmptyTransactions extends StatelessWidget {
  const _EmptyTransactions();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
    child: Column(
      children: [
        Icon(
          Icons.receipt_long_outlined,
          size: 52,
          color: AppColors.textMuted.withOpacity(0.5),
        ),
        const SizedBox(height: 16),
        const Text(
          'No transactions yet',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Tap Add to record your first transaction',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textMuted, fontSize: 13),
        ),
      ],
    ),
  );
}

// ─── Add Transaction Dialog ───────────────────────────────────────────────────

void _showAddDialog(BuildContext context, TransactionController ctrl) {
  final titleCtrl = TextEditingController();
  final amountCtrl = TextEditingController();
  var category = 'Food';
  var isIncome = false;

  const categories = [
    'Food',
    'Entertainment',
    'Shopping',
    'Coffee shops',
    'Utilities',
    'Income',
    'Other',
  ];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
    ),
    builder: (ctx) {
      final mq = MediaQuery.of(ctx);
      return Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: mq.viewInsets.bottom + mq.padding.bottom + 24,
        ),
        child: StatefulBuilder(
        builder: (ctx, setState) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'New transaction',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),

            // Income / Expense toggle
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Row(
                children: [
                  _TypeToggle(
                    label: 'Expense',
                    selected: !isIncome,
                    color: AppColors.expense,
                    onTap: () => setState(() => isIncome = false),
                  ),
                  _TypeToggle(
                    label: 'Income',
                    selected: isIncome,
                    color: AppColors.income,
                    onTap: () => setState(() => isIncome = true),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: titleCtrl,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: amountCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                hintText: 'Amount',
                prefixText: '\$ ',
                prefixStyle: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: category,
              dropdownColor: AppColors.surfaceAlt,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
              ),
              decoration: const InputDecoration(hintText: 'Category'),
              items: categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => category = v);
              },
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                final title = titleCtrl.text.trim();
                final amount = double.tryParse(amountCtrl.text.trim());
                if (title.isEmpty || amount == null || amount <= 0) return;

                ctrl.addTransaction(
                  Transaction(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: title,
                    amount: amount,
                    date: DateTime.now(),
                    category: category,
                    isIncome: isIncome,
                  ),
                );
                Navigator.pop(ctx);
              },
              child: const Text('Save transaction'),
            ),
          ],
        ),
      ),
    );
    },
  );
}

class _TypeToggle extends StatelessWidget {
  const _TypeToggle({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: selected ? Border.all(color: color, width: 1) : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: selected ? color : AppColors.textMuted,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    ),
  );
}
