import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/transaction.dart';
import '../models/transaction_repository.dart';
import '../widgets/transaction_list_item.dart';
import '../widgets/add_transaction_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _balanceAnim;
  late Animation<double> _balanceFade;

  List<Transaction> _transactions = [];
  String? _expandedTransactionId;

  void _onRepositoryChanged() {
    if (mounted) {
      setState(() {
        _transactions = List.from(TransactionRepository.transactions);
        if (_expandedTransactionId != null &&
            !_transactions.any((t) => t.id == _expandedTransactionId)) {
          _expandedTransactionId = null;
        }
      });
    }
  }

  double get _totalIncome => _transactions
      .where((t) => t.isIncome)
      .fold(0.0, (s, t) => s + t.amount);

  double get _totalExpense => _transactions
      .where((t) => !t.isIncome)
      .fold(0.0, (s, t) => s + t.amount);

  double get _balance => _totalIncome - _totalExpense;

  List<Transaction> get _recent => List.from(_transactions)
    ..sort((a, b) => b.date.compareTo(a.date));

  @override
  void initState() {
    super.initState();
    _transactions = List.from(TransactionRepository.transactions);
    TransactionRepository.addListener(_onRepositoryChanged);
    _balanceAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _balanceFade = CurvedAnimation(parent: _balanceAnim, curve: Curves.easeOut);
    _balanceAnim.forward();
  }

  @override
  void dispose() {
    TransactionRepository.removeListener(_onRepositoryChanged);
    _balanceAnim.dispose();
    super.dispose();
  }

  void _openAddTransaction() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddTransactionSheet(
        onAdd: (tx) {
          TransactionRepository.addTransaction(tx);
        },
      ),
    );
  }

  void _openTransactionActions(Transaction transaction) {
    setState(() {
      _expandedTransactionId = _expandedTransactionId == transaction.id ? null : transaction.id;
    });
  }

  void _closeTransactionActions() {
    if (_expandedTransactionId != null) {
      setState(() => _expandedTransactionId = null);
    }
  }

  void _editTransaction(Transaction transaction) {
    _closeTransactionActions();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddTransactionSheet(
        initialTransaction: transaction,
        onAdd: (_) {},
        onUpdate: (updated) => TransactionRepository.updateTransaction(updated),
      ),
    );
  }

  void _renameTransaction(Transaction transaction) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => _RenameTransactionDialog(
        transaction: transaction,
        onSave: (title) async {
          await TransactionRepository.updateTransaction(Transaction(
            id: transaction.id,
            title: title,
            amount: transaction.amount,
            type: transaction.type,
            category: transaction.category,
            date: transaction.date,
          ));
          if (dialogContext.mounted) Navigator.pop(dialogContext);
        },
      ),
    );
  }

  void _confirmDeleteTransaction(Transaction transaction) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: kSurface,
        title: Text('DELETE TRANSACTION?', style: GoogleFonts.spaceGrotesk(color: kError)),
        content: Text('Delete "${transaction.title}" permanently?', style: GoogleFonts.spaceGrotesk()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () async {
              await TransactionRepository.deleteTransaction(transaction.id);
              if (dialogContext.mounted) Navigator.pop(dialogContext);
            },
            child: Text('DELETE', style: GoogleFonts.spaceGrotesk(color: kError)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: Stack(
        children: [
          // â”€â”€ Dot grid background
          _DotGrid(),
          // â”€â”€ Ambient cyan glow at top
          Positioned(
            top: -80,
            left: 0,
            right: 0,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    glowColor(kPrimary, 0.12),
                    Colors.transparent,
                  ],
                  radius: 0.8,
                ),
              ),
            ),
          ),
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // â”€â”€ Top App Bar
                SliverAppBar(
                  pinned: true,
                  backgroundColor: Colors.black.withValues(alpha: 0.75),
                  surfaceTintColor: Colors.transparent,
                  flexibleSpace: ClipRect(
                    child: BackdropFilter(
                      filter: _blurFilter,
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                  title: Text(
                    'FINANCE_CORE',
                    style: GoogleFonts.spaceGrotesk(
                      color: kPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      letterSpacing: 4,
                    ),
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(1),
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Colors.transparent,
                          kPrimary.withValues(alpha: 0.4),
                          Colors.transparent,
                        ]),
                      ),
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // â”€â”€ Greeting
                      _GreetingSection(),
                      const SizedBox(height: 20),

                      // â”€â”€ Balance card
                      FadeTransition(
                        opacity: _balanceFade,
                        child: _BalanceCard(
                          balance: _balance,
                          income: _totalIncome,
                          expense: _totalExpense,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // â”€â”€ Quick Actions
                      _QuickActions(onAddExpense: _openAddTransaction),
                      const SizedBox(height: 28),

                      // â”€â”€ Recent Activity
                      _SectionHeader(title: 'Recent Activity', onViewAll: () {}),
                      const SizedBox(height: 12),
                      ..._recent
                          .take(5)
                          .map((t) {
                            final expanded = t.id == _expandedTransactionId;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Column(
                                children: [
                                  TransactionListItem(
                                    transaction: t,
                                    onTap: () => _openTransactionActions(t),
                                  ),
                                  if (expanded)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: _TransactionExpansionCard(
                                        transaction: t,
                                        onRename: () {
                                          _renameTransaction(t);
                                        },
                                        onEdit: () {
                                          _editTransaction(t);
                                        },
                                        onDelete: () {
                                          _confirmDeleteTransaction(t);
                                        },
                                        onClose: _closeTransactionActions,
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ Sub-widgets â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _DotGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: CustomPaint(painter: _DotGridPainter()),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF222222)
      ..style = PaintingStyle.fill;
    const spacing = 20.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

final _blurFilter = ColorFilter.mode(
  Colors.transparent,
  BlendMode.multiply,
);

class _GreetingSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AUTHENTICATION ACTIVE',
          style: GoogleFonts.spaceGrotesk(
            color: kOnSurfaceVariant.withValues(alpha: 0.7),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.5,
          ),
        ),
        const SizedBox(height: 6),
        RichText(
          text: TextSpan(
            text: 'Welcome back.',
            style: GoogleFonts.spaceGrotesk(
              color: kOnSurface,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.balance,
    required this.income,
    required this.expense,
  });
  final double balance, income, expense;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: glassCard(active: true),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
                    'TOTAL NET WORTH',
                    style: GoogleFonts.spaceGrotesk(
                      color: kOnSurfaceVariant,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      text: '$currencySymbol${_fmt(balance, showSign: false).split('.')[0]}',
                      style: GoogleFonts.spaceGrotesk(
                        color: kOnSurface,
                        fontSize: 42,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -1,
                      ),
                      children: [
                        TextSpan(
                          text: '.${_fmt(balance).split('.').last}',
                          style: GoogleFonts.spaceGrotesk(
                            color: kPrimary,
                            fontSize: 42,
                            fontWeight: FontWeight.w700,
                            shadows: [
                              Shadow(color: glowColor(kPrimary, 0.6), blurRadius: 12),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _StatPill(
                        label: 'Income',
                        amount: '+$currencySymbol${_fmt(income)}',
                        icon: Icons.arrow_upward_rounded,
                        color: kIncome,
                      ),
                      const SizedBox(width: 12),
                      _StatPill(
                        label: 'Expense',
                        amount: '-$currencySymbol${_fmt(expense)}',
                        icon: Icons.arrow_downward_rounded,
                        color: kExpense,
                      ),
                    ],
                  ),
        ],
      ),
    );
  }

  String _fmt(double v, {bool showSign = false}) {
    final s = v.abs().toStringAsFixed(2);
    return s;
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
  });
  final String label, amount;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: const Color(0xFF333333)),
        boxShadow: [BoxShadow(color: glowColor(color, 0.12), blurRadius: 12)],
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: GoogleFonts.spaceGrotesk(
                  color: kOnSurfaceVariant,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                amount,
                style: GoogleFonts.spaceGrotesk(
                  color: kOnSurface,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.onAddExpense});
  final VoidCallback onAddExpense;

  @override
  Widget build(BuildContext context) {
    return _ActionButton(
      label: 'Add Expense',
      icon: Icons.add_rounded,
      solid: true,
      onTap: onAddExpense,
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.solid,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final bool solid;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 58,
        decoration: BoxDecoration(
          color: solid ? kPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: solid ? null : Border.all(color: kPrimary, width: 1.2),
          boxShadow: solid
              ? [BoxShadow(color: glowColor(kPrimary, 0.35), blurRadius: 18)]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: solid ? Colors.black : kPrimary, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.spaceGrotesk(
                color: solid ? Colors.black : kPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.onViewAll});
  final String title;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.spaceGrotesk(
            color: kOnSurface,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        GestureDetector(
          onTap: onViewAll,
          child: Text(
            'VIEW ALL',
            style: GoogleFonts.spaceGrotesk(
              color: kPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
        ),
      ],
    );
  }
}

class _TransactionExpansionCard extends StatelessWidget {
  const _TransactionExpansionCard({
    required this.transaction,
    required this.onRename,
    required this.onEdit,
    required this.onDelete,
    required this.onClose,
  });

  final Transaction transaction;
  final VoidCallback onRename;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final amountColor = transaction.isIncome ? kIncome : kOnSurface;
    final amountSign = transaction.isIncome ? '+' : '-';

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF090909),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kPrimary.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(color: glowColor(kPrimary, 0.15), blurRadius: 18, offset: const Offset(0, 10)),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'DETAILS',
                  style: GoogleFonts.spaceGrotesk(
                    color: kPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2.5,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onClose,
                child: Icon(Icons.close_rounded, color: kOnSurfaceVariant, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: transaction.category.color.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(transaction.category.icon, color: transaction.category.color, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.title,
                      style: GoogleFonts.spaceGrotesk(
                        color: kOnSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _Tag(text: transaction.category.label.toUpperCase(), color: transaction.category.color),
                        const SizedBox(width: 8),
                        _Tag(text: transaction.type.name.toUpperCase(), color: transaction.isIncome ? kIncome : kExpense),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                '$amountSign$currencySymbol${transaction.amount.toStringAsFixed(2)}',
                style: GoogleFonts.spaceGrotesk(
                  color: amountColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _DetailRow(label: 'Date', value: _formatDate(transaction.date)),
          const SizedBox(height: 10),
          _DetailRow(label: 'Category', value: transaction.category.label),
          const SizedBox(height: 10),
          _DetailRow(label: 'Type', value: transaction.type.name.toUpperCase()),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _PillButton(
                  label: 'Rename',
                  icon: Icons.drive_file_rename_outline_rounded,
                  onTap: onRename,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _PillButton(
                  label: 'Edit',
                  icon: Icons.edit_rounded,
                  onTap: onEdit,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _PillButton(
            label: 'Delete',
            icon: Icons.delete_outline_rounded,
            onTap: onDelete,
            color: kError,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.color,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final baseColor = color ?? kPrimary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: baseColor.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: baseColor.withValues(alpha: 0.3)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: baseColor, size: 18),
            const SizedBox(width: 8),
            Text(
              label.toUpperCase(),
              style: GoogleFonts.spaceGrotesk(
                color: baseColor,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.text, required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        text,
        style: GoogleFonts.spaceGrotesk(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              color: kOnSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: GoogleFonts.spaceGrotesk(
              color: kOnSurface,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailActionButton extends StatelessWidget {
  const _DetailActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? kOnSurfaceVariant, size: 18),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.spaceGrotesk(
                  color: textColor ?? kOnSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: kOnSurfaceVariant, size: 18),
          ],
        ),
      ),
    );
  }
}

class _RenameTransactionDialog extends StatefulWidget {
  const _RenameTransactionDialog({
    required this.transaction,
    required this.onSave,
  });

  final Transaction transaction;
  final ValueChanged<String> onSave;

  @override
  State<_RenameTransactionDialog> createState() => _RenameTransactionDialogState();
}

class _RenameTransactionDialogState extends State<_RenameTransactionDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.transaction.title);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kSurface,
      title: Text('RENAME TRANSACTION', style: GoogleFonts.spaceGrotesk(color: kPrimary)),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'TITLE'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () {
            final title = _controller.text.trim();
            if (title.isEmpty) return;
            widget.onSave(title);
          },
          child: Text('SAVE', style: GoogleFonts.spaceGrotesk(color: kPrimary)),
        ),
      ],
    );
  }
}

