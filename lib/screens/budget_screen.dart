import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:expency/models/transaction.dart';
import 'package:expency/models/transaction_repository.dart';
import '../theme/app_theme.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  late final TextEditingController _overallController;
  late final Map<TransactionCategory, TextEditingController> _controllers;
  bool _saving = false;

  List<TransactionCategory> get _expenseCategories =>
      TransactionCategory.values.where((c) => c != TransactionCategory.income).toList();

  @override
  void initState() {
    super.initState();
    _overallController = TextEditingController(text: _amountText(TransactionRepository.overallBudget));
    _controllers = {
      for (final category in _expenseCategories)
        category: TextEditingController(
          text: _amountText(TransactionRepository.categoryBudgets[category] ?? 0),
        ),
    };
  }

  @override
  void dispose() {
    _overallController.dispose();
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  String _amountText(double value) => value == 0 ? '' : value.toStringAsFixed(0);

  double _expenseFor(TransactionCategory category) => TransactionRepository.transactions
      .where((t) => !t.isIncome && t.category == category)
      .fold(0.0, (total, t) => total + t.amount);

  double _parse(TextEditingController controller) =>
      double.tryParse(controller.text.trim()) ?? 0;

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    final overall = _parse(_overallController);
    if (overall < 0 || _controllers.values.any((controller) => _parse(controller) < 0)) {
      _showMessage('Budgets cannot be negative.');
      return;
    }

    setState(() => _saving = true);
    await TransactionRepository.updateOverallBudget(overall);
    for (final entry in _controllers.entries) {
      await TransactionRepository.updateCategoryBudget(entry.key, _parse(entry.value));
    }
    if (!mounted) return;
    setState(() => _saving = false);
    _showMessage('Budgets saved locally.');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: GoogleFonts.spaceGrotesk()), backgroundColor: kSurface),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spent = TransactionRepository.transactions
        .where((t) => !t.isIncome)
        .fold(0.0, (total, t) => total + t.amount);
    final overall = TransactionRepository.overallBudget;

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: const Text('BUDGETS'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        children: [
          Text('MONTHLY LIMITS', style: GoogleFonts.spaceGrotesk(color: kPrimary, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 2)),
          const SizedBox(height: 8),
          Text('Set a total spending budget and limits for each expense category.', style: GoogleFonts.spaceGrotesk(color: kOnSurfaceVariant, fontSize: 14)),
          const SizedBox(height: 20),
          _BudgetCard(
            title: 'Overall budget',
            subtitle: overall > 0 ? 'Spent $currencySymbol${spent.toStringAsFixed(2)} of $currencySymbol${overall.toStringAsFixed(2)}' : 'No overall limit set',
            icon: Icons.account_balance_wallet_rounded,
            color: kPrimary,
            controller: _overallController,
          ),
          const SizedBox(height: 24),
          Text('CATEGORY BUDGETS', style: GoogleFonts.spaceGrotesk(color: kOnSurface, fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 1)),
          const SizedBox(height: 12),
          ..._expenseCategories.map((category) {
            final limit = TransactionRepository.categoryBudgets[category] ?? 0;
            final spentInCategory = _expenseFor(category);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _BudgetCard(
                title: category.label,
                subtitle: limit > 0 ? 'Spent $currencySymbol${spentInCategory.toStringAsFixed(2)} of $currencySymbol${limit.toStringAsFixed(2)}' : 'No limit set',
                icon: category.icon,
                color: category.color,
                controller: _controllers[category]!,
              ),
            );
          }),
          const SizedBox(height: 12),
          SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                  : Text('SAVE BUDGETS', style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

class _BudgetCard extends StatelessWidget {
  const _BudgetCard({required this.title, required this.subtitle, required this.icon, required this.color, required this.controller});

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.16), shape: BoxShape.circle),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.spaceGrotesk(color: kOnSurface, fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text(subtitle, style: GoogleFonts.spaceGrotesk(color: kOnSurfaceVariant, fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 92,
            child: TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.right,
              style: GoogleFonts.spaceGrotesk(color: kOnSurface, fontWeight: FontWeight.w700),
              decoration: InputDecoration(prefixText: currencySymbol, hintText: '0'),
            ),
          ),
        ],
      ),
    );
  }
}
