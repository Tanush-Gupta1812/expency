import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'package:expency/models/transaction.dart';

class AddTransactionSheet extends StatefulWidget {
  const AddTransactionSheet({
    super.key,
    required this.onAdd,
    this.initialTransaction,
    this.onUpdate,
  });
  final ValueChanged<Transaction> onAdd;
  final Transaction? initialTransaction;
  final ValueChanged<Transaction>? onUpdate;

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  TransactionType _type = TransactionType.expense;
  TransactionCategory _category = TransactionCategory.food;
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  List<TransactionCategory> get _availableCategories {
    if (_type == TransactionType.income) {
      return [TransactionCategory.income];
    }
    return TransactionCategory.values
        .where((category) => category != TransactionCategory.income)
        .toList();
  }

  void _setType(TransactionType type) {
    setState(() {
      _type = type;
      if (_type == TransactionType.income) {
        _category = TransactionCategory.income;
      } else if (_category == TransactionCategory.income) {
        _category = TransactionCategory.food;
      }
    });
  }

  bool get _isEditing => widget.initialTransaction != null;

  @override
  void initState() {
    super.initState();
    final transaction = widget.initialTransaction;
    if (transaction != null) {
      _type = transaction.type;
      _category = transaction.category;
      _titleController.text = transaction.title;
      _amountController.text = transaction.amount.toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleController.text.trim();
    final amount = double.tryParse(_amountController.text.trim());
    if (title.isEmpty || amount == null || amount <= 0) return;

    final transaction = Transaction(
      id: widget.initialTransaction?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      amount: amount,
      type: _type,
      category: _category,
      date: widget.initialTransaction?.date ?? DateTime.now(),
    );
    if (_isEditing) {
      widget.onUpdate?.call(transaction);
    } else {
      widget.onAdd(transaction);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final accent = _type == TransactionType.expense ? kPrimary : kIncome;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
        boxShadow: [BoxShadow(color: glowColor(accent, 0.2), blurRadius: 30)],
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: kOutline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              _isEditing ? 'EDIT TRANSACTION' : 'NEW TRANSACTION',
              style: GoogleFonts.spaceGrotesk(
                color: accent,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 3,
                shadows: [Shadow(color: glowColor(accent, 0.5), blurRadius: 8)],
              ),
            ),
            const SizedBox(height: 20),

            // Income / Expense toggle
            Row(
              children: [
                _TypeButton(
                  label: 'Expense',
                  selected: _type == TransactionType.expense,
                  color: accent,
                  onTap: () => _setType(TransactionType.expense),
                ),
                const SizedBox(width: 12),
                _TypeButton(
                  label: 'Income',
                  selected: _type == TransactionType.income,
                  color: kIncome,
                  onTap: () => _setType(TransactionType.income),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Title input
            TextField(
              controller: _titleController,
              style: GoogleFonts.spaceGrotesk(color: kOnSurface),
              decoration: InputDecoration(
                hintText: 'TITLE',
                hintStyle: GoogleFonts.spaceGrotesk(color: kOnSurfaceVariant),
                filled: true,
                fillColor: const Color(0xFF111111),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: kPrimary.withValues(alpha: 0.18)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: kPrimary.withValues(alpha: 0.12)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: accent.withValues(alpha: 0.9), width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              ),
            ),
            const SizedBox(height: 12),

            // Amount input
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: GoogleFonts.spaceGrotesk(color: kOnSurface, fontSize: 18),
              decoration: InputDecoration(
                hintText: 'AMOUNT (${selectedCurrency.code})',
                hintStyle: GoogleFonts.spaceGrotesk(color: kOnSurfaceVariant),
                filled: true,
                fillColor: const Color(0xFF111111),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: kPrimary.withValues(alpha: 0.18)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: kPrimary.withValues(alpha: 0.12)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: accent.withValues(alpha: 0.9), width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              ),
            ),
            const SizedBox(height: 16),

            // Category picker
            Text(
              'CATEGORY',
              style: GoogleFonts.spaceGrotesk(
                color: kOnSurfaceVariant,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableCategories.map((c) {
                final sel = _category == c;
                return GestureDetector(
                  onTap: () => setState(() => _category = c),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: sel ? c.color.withValues(alpha: 0.2) : const Color(0xFF111111),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: sel ? c.color : const Color(0xFF333333),
                      ),
                      boxShadow: sel
                          ? [BoxShadow(color: glowColor(c.color, 0.3), blurRadius: 10)]
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(c.icon, color: sel ? c.color : kOnSurfaceVariant, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          c.label,
                          style: GoogleFonts.spaceGrotesk(
                            color: sel ? c.color : kOnSurfaceVariant,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Submit
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                  shadowColor: accent.withValues(alpha: 0.5),
                ),
                child: Text(
                  _isEditing ? 'SAVE CHANGES' : 'ADD TRANSACTION',
                  style: GoogleFonts.spaceGrotesk(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeButton extends StatelessWidget {
  const _TypeButton({
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? color : kOutline),
          boxShadow: selected
              ? [BoxShadow(color: glowColor(color, 0.25), blurRadius: 12)]
              : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            color: selected ? color : kOnSurfaceVariant,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

