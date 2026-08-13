import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expency/theme/app_theme.dart';
import 'package:expency/models/transaction.dart';

class TransactionExpansionCard extends StatelessWidget {
  const TransactionExpansionCard({
    super.key,
    required this.transaction,
    required this.onRename,
    required this.onEdit,
    required this.onChangeCategory,
    required this.onDelete,
    required this.onClose,
  });

  final Transaction transaction;
  final VoidCallback onRename;
  final VoidCallback onEdit;
  final VoidCallback onChangeCategory;
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
                child: const Icon(Icons.close_rounded, color: kOnSurfaceVariant, size: 20),
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
                        ExpansionTag(text: transaction.category.label.toUpperCase(), color: transaction.category.color),
                        const SizedBox(width: 8),
                        ExpansionTag(text: transaction.type.name.toUpperCase(), color: transaction.isIncome ? kIncome : kExpense),
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
          DetailRow(label: 'Date', value: _formatDate(transaction.date)),
          const SizedBox(height: 10),
          DetailRow(label: 'Category', value: transaction.category.label),
          const SizedBox(height: 10),
          DetailRow(label: 'Type', value: transaction.type.name.toUpperCase()),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: PillButton(
                  label: 'Rename',
                  icon: Icons.drive_file_rename_outline_rounded,
                  onTap: onRename,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: PillButton(
                  label: 'Edit',
                  icon: Icons.edit_rounded,
                  onTap: onEdit,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          PillButton(
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

class ExpansionTag extends StatelessWidget {
  const ExpansionTag({super.key, required this.text, required this.color});
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

class DetailRow extends StatelessWidget {
  const DetailRow({super.key, required this.label, required this.value});

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
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.spaceGrotesk(
            color: kOnSurface,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
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
