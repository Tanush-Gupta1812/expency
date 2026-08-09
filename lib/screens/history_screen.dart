import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/transaction.dart';
import '../widgets/transaction_list_item.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedFilter = 'This Month';
  String _searchQuery = '';

  final List<String> _filters = ['This Month', 'Today', 'This Week', 'Older'];

  List<Transaction> get _filtered {
    final now = DateTime.now();
    return kSampleTransactions.where((t) {
      // Time filter
      bool inRange = switch (_selectedFilter) {
        'Today' => t.date.year == now.year &&
            t.date.month == now.month &&
            t.date.day == now.day,
        'This Week' => now.difference(t.date).inDays <= 7,
        'This Month' => t.date.year == now.year && t.date.month == now.month,
        'Older' => now.difference(t.date).inDays > 30,
        _ => true,
      };
      // Search filter
      bool matchesSearch = _searchQuery.isEmpty ||
          t.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          t.category.label.toLowerCase().contains(_searchQuery.toLowerCase());
      return inRange && matchesSearch;
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  double get _totalOut =>
      _filtered.where((t) => !t.isIncome).fold(0.0, (s, t) => s + t.amount);

  // Group by date label
  Map<String, List<Transaction>> get _grouped {
    final now = DateTime.now();
    final Map<String, List<Transaction>> groups = {};
    for (final t in _filtered) {
      final diff = now.difference(t.date).inDays;
      final label = diff == 0
          ? 'TODAY'
          : diff == 1
              ? 'YESTERDAY'
              : '${t.date.day}/${t.date.month}/${t.date.year}';
      groups.putIfAbsent(label, () => []).add(t);
    }
    return groups;
  }

  // Category breakdown for donut
  Map<TransactionCategory, double> get _breakdown {
    final expenses = _filtered.where((t) => !t.isIncome);
    final total = expenses.fold(0.0, (s, t) => s + t.amount);
    final Map<TransactionCategory, double> result = {};
    for (final t in expenses) {
      result[t.category] = (result[t.category] ?? 0) + t.amount;
    }
    if (total > 0) {
      result.updateAll((k, v) => v / total);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: Stack(
        children: [
          CustomPaint(painter: _DotGridPainter(), size: MediaQuery.sizeOf(context)),
          SafeArea(
            child: Column(
              children: [
                // â”€â”€ App Bar
                _HistoryAppBar(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      // â”€â”€ Search
                      _SearchBar(
                        onChanged: (q) => setState(() => _searchQuery = q),
                      ),
                      const SizedBox(height: 12),

                      // â”€â”€ Filter pills
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _filters
                              .map((f) => Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: _FilterChip(
                                      label: f,
                                      selected: _selectedFilter == f,
                                      onTap: () =>
                                          setState(() => _selectedFilter = f),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // â”€â”€ Breakdown card
                      if (_breakdown.isNotEmpty) ...[
                        _BreakdownCard(
                          totalOut: _totalOut,
                          breakdown: _breakdown,
                        ),
                        const SizedBox(height: 24),
                      ],

                      // â”€â”€ Grouped list
                      ..._grouped.entries.map((entry) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _DateHeader(label: entry.key),
                              const SizedBox(height: 8),
                              ...entry.value.map((t) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: TransactionListItem(transaction: t),
                                  )),
                              const SizedBox(height: 16),
                            ],
                          )),
                    ],
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

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF222222);
    for (double x = 0; x < size.width; x += 20) {
      for (double y = 0; y < size.height; y += 20) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

class _HistoryAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: _blur,
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.75),
            border: Border(
              bottom: BorderSide(color: kPrimary.withValues(alpha: 0.25)),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(Icons.account_balance_wallet_rounded, color: kPrimary),
              const Spacer(),
              Text(
                'FINANCE_CORE',
                style: GoogleFonts.spaceGrotesk(
                  color: kPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 4,
                ),
              ),
              const Spacer(),
              Icon(Icons.notifications_outlined, color: kPrimary),
            ],
          ),
        ),
      ),
    );
  }
}

final _blur = ColorFilter.mode(Colors.transparent, BlendMode.multiply);

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onChanged});
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: onChanged,
            style: GoogleFonts.spaceGrotesk(color: kOnSurface, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'SEARCH TRANSACTIONS...',
              prefixIcon: const Icon(Icons.search_rounded, color: kOnSurfaceVariant),
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          height: 52,
          width: 52,
          decoration: neonBorderDecoration(radius: 12),
          child: const Icon(Icons.tune_rounded, color: kPrimary),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? kPrimary : const Color(0xFF222222),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: selected ? kPrimary : Colors.transparent,
          ),
          boxShadow: selected
              ? [BoxShadow(color: kPrimary.withValues(alpha: 0.45), blurRadius: 14)]
              : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            color: selected ? Colors.black : kOnSurface,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

class _BreakdownCard extends StatelessWidget {
  const _BreakdownCard({required this.totalOut, required this.breakdown});
  final double totalOut;
  final Map<TransactionCategory, double> breakdown;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: glassCard(active: true),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Top gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [kPrimary.withValues(alpha: 0.08), Colors.transparent],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          Text(
            'TOTAL OUT',
            style: GoogleFonts.spaceGrotesk(
              color: kOnSurfaceVariant,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '-\$${totalOut.toStringAsFixed(2)}',
            style: GoogleFonts.spaceGrotesk(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w700,
              letterSpacing: -1,
              shadows: [Shadow(color: kPrimary.withValues(alpha: 0.4), blurRadius: 12)],
            ),
          ),
          const SizedBox(height: 24),

          // Donut chart
          SizedBox(
            width: 160,
            height: 160,
            child: CustomPaint(
              painter: _DonutPainter(breakdown: breakdown),
            ),
          ),
          const SizedBox(height: 24),

          // Legend
          ...breakdown.entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _LegendRow(
                  color: e.key.color,
                  label: e.key.label,
                  percent: (e.value * 100).toStringAsFixed(0),
                ),
              )),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  const _DonutPainter({required this.breakdown});
  final Map<TransactionCategory, double> breakdown;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    const strokeWidth = 18.0;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Background track
    canvas.drawArc(
      rect,
      0,
      2 * math.pi,
      false,
      Paint()
        ..color = const Color(0xFF222222)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    double startAngle = -math.pi / 2;
    for (final entry in breakdown.entries) {
      final sweep = entry.value * 2 * math.pi;
      final color = entry.key.color;

      // Glow pass
      canvas.drawArc(
        rect,
        startAngle,
        sweep,
        false,
        Paint()
          ..color = color.withValues(alpha: 0.35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth + 6
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );

      // Solid arc
      canvas.drawArc(
        rect,
        startAngle,
        sweep,
        false,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.butt,
      );

      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter old) =>
      old.breakdown != breakdown;
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.color,
    required this.label,
    required this.percent,
  });
  final Color color;
  final String label, percent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF333333)),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: color.withValues(alpha: 0.8), blurRadius: 8)],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.spaceGrotesk(color: kOnSurface, fontSize: 14),
            ),
          ),
          Text(
            '$percent%',
            style: GoogleFonts.spaceGrotesk(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              shadows: [Shadow(color: color.withValues(alpha: 0.6), blurRadius: 6)],
            ),
          ),
        ],
      ),
    );
  }
}

class _DateHeader extends StatelessWidget {
  const _DateHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        border: Border(left: BorderSide(color: kPrimary, width: 2)),
      ),
      child: Text(
        label,
        style: GoogleFonts.spaceGrotesk(
          color: kOnSurfaceVariant,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
      ),
    );
  }
}

