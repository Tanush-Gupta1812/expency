import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'package:expency/models/transaction.dart';

class TransactionListItem extends StatelessWidget {
  const TransactionListItem({super.key, required this.transaction, this.onTap});
  final Transaction transaction;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = transaction;
    final color = t.category.color;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0x801A1A1A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kPrimary.withValues(alpha: 0.15)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Category icon
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: color.withValues(alpha: 0.5)),
                    boxShadow: [
                      BoxShadow(color: glowColor(color, 0.25), blurRadius: 10),
                    ],
                  ),
                  child: Icon(t.category.icon, color: color, size: 20),
                ),
                const SizedBox(width: 14),

                // Title + meta
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.title,
                        style: GoogleFonts.spaceGrotesk(
                          color: kOnSurface,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            _timeLabel(t.date),
                            style: GoogleFonts.spaceGrotesk(
                              color: kOnSurfaceVariant,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: color.withValues(alpha: 0.35)),
                            ),
                            child: Text(
                              t.category.label.toUpperCase(),
                              style: GoogleFonts.spaceGrotesk(
                                color: color,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Amount
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${t.isIncome ? '+' : '-'}$currencySymbol${t.amount.toStringAsFixed(2)}',
                      style: GoogleFonts.spaceGrotesk(
                        color: t.isIncome ? kIncome : kOnSurface,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        shadows: t.isIncome
                            ? [Shadow(color: glowColor(kIncome, 0.5), blurRadius: 8)]
                            : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Icon(Icons.chevron_right_rounded,
                        color: kOnSurfaceVariant, size: 16),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _timeLabel(DateTime d) {
    final now = DateTime.now();
    final diff = now.difference(d).inDays;
    if (diff == 0) return '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    if (diff == 1) return 'Yesterday';
    return '${d.day}/${d.month}/${d.year}';
  }
}

