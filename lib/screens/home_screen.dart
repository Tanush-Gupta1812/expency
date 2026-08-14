import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:expency/theme/app_theme.dart';
import 'package:expency/models/transaction.dart';
import 'package:expency/models/transaction_repository.dart';
import '../widgets/transaction_list_item.dart';
import '../widgets/add_transaction_sheet.dart';
import '../widgets/transaction_expansion_card.dart';

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

  Future<void> _openImportFromScreenshot() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;

    debugPrint('IMPORT SCREENSHOT: Image picked: ${file.path}');
    final inputImage = InputImage.fromFilePath(file.path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final recognizedText = await textRecognizer.processImage(inputImage);
      debugPrint('IMPORT SCREENSHOT: OCR text length: ${recognizedText.text.length}');
      debugPrint('IMPORT SCREENSHOT: OCR raw text: \n${recognizedText.text}');
      final extracted = _extractExpensesFromLayout(recognizedText);
      debugPrint('IMPORT SCREENSHOT: Extracted count: ${extracted.length}');
      for (final exp in extracted) {
        debugPrint('IMPORT SCREENSHOT: Extracted expense: ${exp.recipient} -> ${exp.amount}');
      }
      if (extracted.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No expense lines detected in screenshot.', style: GoogleFonts.spaceGrotesk()),
              backgroundColor: kSurface,
            ),
          );
        }
        return;
      }

      final transactions = <Transaction>[];
      final uniqueRecipients = <String>{};
      final recipientCategoryOverrides = <String, TransactionCategory>{};

      for (final expense in extracted) {
        final recipientKey = expense.recipient.toLowerCase().trim();
        if (!_hasCategoryForRecipient(recipientKey) && !uniqueRecipients.contains(recipientKey)) {
          final pickedCategory = await _pickCategoryForRecipient(expense.recipient, amount: expense.amount);
          final category = pickedCategory ?? TransactionCategory.other;
          uniqueRecipients.add(recipientKey);
          recipientCategoryOverrides[recipientKey] = category;
          await TransactionRepository.setRecipientCategory(expense.recipient, category);
        }

        final category = recipientCategoryOverrides[recipientKey] ?? _getCategoryForRecipient(recipientKey) ?? TransactionCategory.other;
        transactions.add(Transaction(
          id: '${DateTime.now().microsecondsSinceEpoch}_${transactions.length}',
          title: expense.recipient,
          amount: expense.amount,
          type: TransactionType.expense,
          category: category,
          date: DateTime.now(),
        ));
      }

      if (transactions.isNotEmpty) {
        await TransactionRepository.addTransactions(transactions);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${transactions.length} expenses imported.', style: GoogleFonts.spaceGrotesk()),
              backgroundColor: kSurface,
            ),
          );
        }
      }
    } finally {
      textRecognizer.close();
    }
  }

  bool _hasCategoryForRecipient(String recipientKey) {
    return TransactionRepository.recipientCategoryMap.containsKey(recipientKey);
  }

  TransactionCategory? _getCategoryForRecipient(String recipientKey) {
    return TransactionRepository.recipientCategoryMap[recipientKey];
  }

  Future<TransactionCategory?> _pickCategoryForRecipient(String recipient, {double? amount}) async {
    return showModalBottomSheet<TransactionCategory>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => CategoryPickerSheet(
        recipient: recipient,
        amount: amount,
      ),
    );
  }

  String _cleanRecipient(String name) {
    String cleaned = name;
    final prefixes = [
      RegExp(r'^to:\s*', caseSensitive: false),
      RegExp(r'^paid\s+(successfully\s+)?(to\s+)?', caseSensitive: false),
      RegExp(r'^towards\s*', caseSensitive: false),
      RegExp(r'^transfer\s+to\s*', caseSensitive: false),
      RegExp(r'^sent?\s+to\s*', caseSensitive: false),
      RegExp(r'^debited\s+for\s*', caseSensitive: false),
    ];
    for (final prefix in prefixes) {
      cleaned = cleaned.replaceFirst(prefix, '');
    }
    return cleaned.trim();
  }


  List<_ExtractedExpense> _extractExpensesFromLayout(RecognizedText recognizedText) {
    final List<TextLine> allLines = [];
    for (final block in recognizedText.blocks) {
      for (final line in block.lines) {
        allLines.add(line);
      }
    }
    if (allLines.isEmpty) return [];

    debugPrint('=== ML Kit Detected Lines (${allLines.length}) ===');
    for (final line in allLines) {
      debugPrint('LINE: "${line.text}" | RECT: ${line.boundingBox}');
    }

    allLines.sort((a, b) => a.boundingBox.top.compareTo(b.boundingBox.top));

    final filteredLines = allLines;

    final expenses = <_ExtractedExpense>[];

    final amountRegex = RegExp(
      r'([-\+])?\s*([₹ZzFf7])\s*(\d+(?:,\d{3})*(?:\.[0-9]{1,2})?)\b',
      caseSensitive: false
    );
    final noiseLineRegex = RegExp(
      r'^(total|subtotal|balance|paid\s+successfully|transaction\s+successful|completed|status|debited\s+from|from|txn\s+id|transaction\s+id|ref\s+no|utr|wallet\s+txn|account|a/c|card|xxxx|google\s+pay|gpay|paytm|phonepe|july|august|september|october|november|december|january|february|march|april|may|june)\b',
      caseSensitive: false
    );

    bool isOverlap(Rect a, Rect b) {
      double overlapY = (a.bottom < b.bottom ? a.bottom : b.bottom) - (a.top > b.top ? a.top : b.top);
      double minHeight = a.height < b.height ? a.height : b.height;
      return overlapY > 0.4 * minHeight;
    }

    for (int i = 0; i < filteredLines.length; i++) {
      final amountLine = filteredLines[i];
      final amountMatch = amountRegex.firstMatch(amountLine.text);
      if (amountMatch == null) continue;

      if (amountMatch.group(1) == '+') continue;

      final amountValText = amountMatch.group(3)?.replaceAll(',', '');
      final amount = double.tryParse(amountValText ?? '');
      if (amount == null || amount <= 0) continue;

      TextLine? bestLabelLine;
      double bestDistanceX = double.maxFinite;

      for (final candidate in filteredLines) {
        if (candidate == amountLine) continue;

        if (isOverlap(amountLine.boundingBox, candidate.boundingBox)) {
          if (candidate.boundingBox.right <= amountLine.boundingBox.left + 5) {
            if (noiseLineRegex.hasMatch(candidate.text)) continue;
            if (RegExp(r'^[0-9/\-:+ ]+$').hasMatch(candidate.text)) continue;

            double distanceX = amountLine.boundingBox.left - candidate.boundingBox.right;
            if (distanceX < bestDistanceX) {
              bestDistanceX = distanceX;
              bestLabelLine = candidate;
            }
          }
        }
      }

      String recipient = 'Expense';
      if (bestLabelLine != null) {
        recipient = _cleanRecipient(bestLabelLine.text);
      } else {
        for (int j = i - 1; j >= 0; j--) {
          final candidate = filteredLines[j];
          if (noiseLineRegex.hasMatch(candidate.text)) continue;
          if (RegExp(r'^[0-9/\-:+ ]+$').hasMatch(candidate.text)) continue;
          if (amountRegex.hasMatch(candidate.text)) continue;

          recipient = _cleanRecipient(candidate.text);
          break;
        }
      }

      final lowerRecip = recipient.toLowerCase();
      if (lowerRecip.contains('total') || 
          lowerRecip.contains('balance') || 
          lowerRecip.contains('check out your')) {
        continue;
      }

      expenses.add(_ExtractedExpense(recipient: recipient, amount: amount));
    }

    return expenses;
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

  Future<void> _changeTransactionCategory(Transaction transaction) async {
    final category = await _pickCategoryForRecipient(transaction.title, amount: transaction.amount);
    if (category == null || category == transaction.category) return;
    await TransactionRepository.updateTransaction(Transaction(
      id: transaction.id,
      title: transaction.title,
      amount: transaction.amount,
      type: transaction.type,
      category: category,
      date: transaction.date,
    ));
  }

  void _renameTransaction(Transaction transaction) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => RenameTransactionDialog(
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

                      // ── Quick Actions
                      _QuickActions(
                        onAddExpense: _openAddTransaction,
                        onImportScreenshot: _openImportFromScreenshot,
                      ),
                      const SizedBox(height: 28),

                      // ── Recent Activity
                      Text(
                        'Recent Activity',
                        style: GoogleFonts.spaceGrotesk(
                          color: kOnSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
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
                                      child: TransactionExpansionCard(
                                        transaction: t,
                                        onRename: () {
                                          _renameTransaction(t);
                                        },
                                        onEdit: () {
                                          _editTransaction(t);
                                        },
                                        onChangeCategory: () {
                                          _changeTransactionCategory(t);
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
  const _QuickActions({required this.onAddExpense, required this.onImportScreenshot});
  final VoidCallback onAddExpense;
  final VoidCallback onImportScreenshot;

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
            label: 'Import Screenshot',
            icon: Icons.image_rounded,
            solid: false,
            onTap: onImportScreenshot,
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
              ? [BoxShadow(color: glowColor(kPrimary, 0.35), blurRadius: 18)]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: FittedBox(
            fit: BoxFit.scaleDown,
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
        ),
      ),
    );
  }
}




class CategoryPickerSheet extends StatefulWidget {
  const CategoryPickerSheet({super.key, required this.recipient, this.amount});
  final String recipient;
  final double? amount;

  @override
  State<CategoryPickerSheet> createState() => CategoryPickerSheetState();
}

class CategoryPickerSheetState extends State<CategoryPickerSheet> {
  TransactionCategory _selectedCategory = TransactionCategory.other;

  @override
  void initState() {
    super.initState();
    _selectedCategory = TransactionCategory.values.firstWhere(
      (category) => category != TransactionCategory.income,
      orElse: () => TransactionCategory.other,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: kPrimary.withValues(alpha: 0.35)),
        boxShadow: [BoxShadow(color: glowColor(kPrimary, 0.2), blurRadius: 30)],
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Text(
            'Assign category for',
            style: GoogleFonts.spaceGrotesk(color: kOnSurfaceVariant, fontSize: 12, letterSpacing: 2),
          ),
          const SizedBox(height: 6),
          Text(
            widget.recipient,
            style: GoogleFonts.spaceGrotesk(color: kOnSurface, fontSize: 18, fontWeight: FontWeight.w700),
          ),
          if (widget.amount != null) ...[  
            const SizedBox(height: 4),
            Text(
              '₹${widget.amount!.toStringAsFixed(2)}',
              style: GoogleFonts.spaceGrotesk(color: kPrimary, fontSize: 22, fontWeight: FontWeight.w800),
            ),
          ],
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: TransactionCategory.values
                .where((category) => category != TransactionCategory.income)
                .map((category) {
              final selected = _selectedCategory == category;
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = category),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: selected ? category.color.withValues(alpha: 0.2) : const Color(0xFF111111),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: selected ? category.color : const Color(0xFF333333)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(category.icon, color: selected ? category.color : kOnSurfaceVariant, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        category.label,
                        style: GoogleFonts.spaceGrotesk(
                          color: selected ? category.color : kOnSurfaceVariant,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(_selectedCategory),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimary,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: Text(
                'SAVE CATEGORY',
                style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700, letterSpacing: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _ExtractedExpense {
  _ExtractedExpense({required this.recipient, required this.amount});
  final String recipient;
  final double amount;
}

class RenameTransactionDialog extends StatefulWidget {
  const RenameTransactionDialog({
    super.key,
    required this.transaction,
    required this.onSave,
  });

  final Transaction transaction;
  final ValueChanged<String> onSave;

  @override
  State<RenameTransactionDialog> createState() => RenameTransactionDialogState();
}

class RenameTransactionDialogState extends State<RenameTransactionDialog> {
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

