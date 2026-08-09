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

  void _onRepositoryChanged() {
    if (mounted) {
      setState(() {
        _transactions = List.from(TransactionRepository.transactions);
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
                    kPrimary.withValues(alpha: 0.12),
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
                  leading: _NavIcon(icon: Icons.account_balance_wallet_rounded),
                  actions: [
                    _NavIcon(icon: Icons.notifications_outlined),
                    const SizedBox(width: 4),
                  ],
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
                          .map((t) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: TransactionListItem(transaction: t),
                              )),
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

class _NavIcon extends StatelessWidget {
  const _NavIcon({required this.icon});
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: kPrimary),
      onPressed: () {},
    );
  }
}

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
            text: 'Welcome back, ',
            style: GoogleFonts.spaceGrotesk(
              color: kOnSurface,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
            children: [
              TextSpan(
                text: 'Alex',
                style: GoogleFonts.spaceGrotesk(
                  color: kPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  shadows: [Shadow(color: kPrimary.withValues(alpha: 0.5), blurRadius: 8)],
                ),
              ),
              const TextSpan(text: '.'),
            ],
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
          // Gradient top overlay
          Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        kPrimary.withValues(alpha: 0.08),
                        Colors.transparent,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              Column(
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
                      text: '₹${_fmt(balance, showSign: false).split('.')[0]}',
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
                              Shadow(color: kPrimary.withValues(alpha: 0.6), blurRadius: 12),
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
                        amount: '+₹${_fmt(income)}',
                        icon: Icons.arrow_upward_rounded,
                        color: kIncome,
                      ),
                      const SizedBox(width: 12),
                      _StatPill(
                        label: 'Expense',
                        amount: '-₹${_fmt(expense)}',
                        icon: Icons.arrow_downward_rounded,
                        color: kExpense,
                      ),
                    ],
                  ),
                ],
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
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.12), blurRadius: 12)],
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
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            label: 'Add Expense',
            icon: Icons.add_rounded,
            solid: true,
            onTap: onAddExpense,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionButton(
            label: 'Transfer',
            icon: Icons.swap_horiz_rounded,
            solid: false,
            onTap: () {},
          ),
        ),
      ],
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
              ? [BoxShadow(color: kPrimary.withValues(alpha: 0.35), blurRadius: 18)]
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

