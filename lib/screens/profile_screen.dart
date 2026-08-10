import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import '../theme/app_theme.dart';
import '../models/transaction_repository.dart';
import 'budget_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    TransactionRepository.addListener(_onRepositoryChanged);
  }

  @override
  void dispose() {
    TransactionRepository.removeListener(_onRepositoryChanged);
    super.dispose();
  }

  void _onRepositoryChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: Stack(
        children: [
          // Dot grid + cyan top glow
          Positioned.fill(child: CustomPaint(painter: _GridPainter())),
          Positioned(
            top: -60,
            left: 0,
            right: 0,
            child: Container(
              height: 280,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    kPrimary.withValues(
                      alpha: ThemeManager.neonGlowEnabled ? 0.14 : 0,
                    ),
                    Colors.transparent,
                  ],
                  radius: 0.9,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _ProfileAppBar(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      // â”€â”€ Avatar section
                      _AvatarSection(),
                      const SizedBox(height: 24),

                      // â”€â”€ Storage Sync
                      _SectionCard(
                        icon: Icons.cloud_sync_rounded,
                        title: 'Storage Sync',
                        children: [
                          _ActionRow(
                            icon: Icons.code_rounded,
                            label: 'Backup Data (JSON)',
                            onTap: () => _showSnack('JSON backup coming soon'),
                          ),
                          _Divider(),
                          _ActionRow(
                            icon: Icons.description_rounded,
                            label: 'Export to CSV',
                            onTap: () => _showSnack('CSV export coming soon'),
                          ),
                          _Divider(),
                          _ActionRow(
                            icon: Icons.history_rounded,
                            label: 'Restore Local Backup',
                            onTap: () => _showSnack('Restore coming soon'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // â”€â”€ Preferences
                      _SectionCard(
                        icon: Icons.tune_rounded,
                        title: 'Preferences',
                        children: [
                          _ActionRow(
                            icon: Icons.account_balance_wallet_rounded,
                            label: 'Manage Budgets',
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => const BudgetScreen(),
                              ),
                            ),
                          ),
                          _Divider(),
                          // Currency
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Currency Symbol',
                                        style: GoogleFonts.spaceGrotesk(
                                            color: kOnSurface, fontSize: 15),
                                      ),
                                      Text(
                                        'Selected: ${selectedCurrency.name} ($currencySymbol)',
                                        style: GoogleFonts.spaceGrotesk(
                                          color: kOnSurfaceVariant,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _GhostButton(
                                  label: 'EDIT',
                                  onTap: _showCurrencyPicker,
                                ),
                              ],
                            ),
                          ),
                          _Divider(),

                          // Neon glow
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.auto_awesome_rounded,
                                  color: kOnSurfaceVariant,
                                  size: 22,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Neon Glow',
                                    style: GoogleFonts.spaceGrotesk(
                                      color: kOnSurface,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                _NeonSwitch(
                                  value: ThemeManager.neonGlowEnabled,
                                  onChanged: (value) async {
                                    await TransactionRepository
                                        .updateNeonGlowEnabled(value);
                                    if (mounted) setState(() {});
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // â”€â”€ System Info
                      _SectionCard(
                        icon: Icons.info_outline_rounded,
                        title: 'System Info',
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Privacy Policy',
                                    style: GoogleFonts.spaceGrotesk(
                                        color: kOnSurfaceVariant, fontSize: 15),
                                  ),
                                ),
                                const Icon(Icons.open_in_new_rounded,
                                    color: kOnSurfaceVariant, size: 16),
                              ],
                            ),
                          ),
                          _Divider(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'About App',
                                    style: GoogleFonts.spaceGrotesk(
                                        color: kOnSurfaceVariant, fontSize: 15),
                                  ),
                                ),
                                Text(
                                  'v1.0.0',
                                  style: GoogleFonts.spaceGrotesk(
                                    color: const Color(0xFF5F5E5E),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Clear data
                          const SizedBox(height: 8),
                          _ClearDataButton(onTap: () => _confirmClear(context)),
                        ],
                      ),
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

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.spaceGrotesk()),
        backgroundColor: kSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showCurrencyPicker() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: kSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => FractionallySizedBox(
        heightFactor: 0.75,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SELECT CURRENCY',
                style: GoogleFonts.spaceGrotesk(
                  color: kPrimary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  children: currencyOptions
                      .map(
                        (currency) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            '${currency.name} (${currency.code})',
                            style: GoogleFonts.spaceGrotesk(color: kOnSurface),
                          ),
                          leading: Text(
                            currency.symbol,
                            style: GoogleFonts.spaceGrotesk(
                              color: kPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          trailing: Radio<String>(
                            value: currency.code,
                            groupValue: TransactionRepository.currencyCode,
                            activeColor: kPrimary,
                            onChanged: (_) async {
                              await TransactionRepository.updateCurrencyCode(currency.code);
                              if (!mounted) return;
                              setState(() {});
                              if (sheetContext.mounted) Navigator.pop(sheetContext);
                            },
                          ),
                          onTap: () async {
                            await TransactionRepository.updateCurrencyCode(currency.code);
                            if (!mounted) return;
                            setState(() {});
                            if (sheetContext.mounted) Navigator.pop(sheetContext);
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  Future<bool> _authenticateBiometric() async {
    try {
      final bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final bool isSupported = await _localAuth.isDeviceSupported();
      if (!canCheckBiometrics || !isSupported) {
        return false;
      }
      return await _localAuth.authenticate(
        localizedReason: 'Verify your identity to clear all data',
        biometricOnly: true,
      );
    } catch (e) {
      debugPrint('Biometric auth error: $e');
      return false;
    }
  }

  void _confirmClear(BuildContext ctx) {
    bool accepted = false;

    showDialog(
      context: ctx,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (dialogCtx, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF111111),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: kError.withValues(alpha: 0.4)),
          ),
          title: Text(
            'CLEAR ALL DATA?',
            style: GoogleFonts.spaceGrotesk(
              color: kError,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This will permanently delete all local transactions and cannot be undone.',
                style: GoogleFonts.spaceGrotesk(color: kOnSurfaceVariant, fontSize: 14),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: accepted,
                    activeColor: kPrimary,
                    checkColor: Colors.black,
                    onChanged: (value) {
                      setDialogState(() => accepted = value ?? false);
                    },
                  ),
                  Expanded(
                    child: Text(
                      'I understand this action cannot be undone.',
                      style: GoogleFonts.spaceGrotesk(
                        color: kOnSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: Text('CANCEL',
                  style: GoogleFonts.spaceGrotesk(color: kOnSurfaceVariant)),
            ),
            TextButton(
              onPressed: accepted
                  ? () async {
                      final authenticated = await _authenticateBiometric();
                      if (!authenticated) {
                        if (!mounted) return;
                        _showSnack('Biometric verification failed');
                        return;
                      }
                      if (dialogCtx.mounted) Navigator.pop(dialogCtx);
                      await TransactionRepository.clearAllData();
                      if (!mounted) return;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (!mounted) return;
                        _showSnack('Data cleared');
                      });
                    }
                  : null,
              child: Text(
                'CLEAR',
                style: GoogleFonts.spaceGrotesk(
                  color: accepted ? kError : kOnSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ Sub-widgets â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF222222);
    const spacing = 20.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

class _ProfileAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ColorFilter.mode(Colors.transparent, BlendMode.multiply),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.75),
            border: Border(bottom: BorderSide(color: kPrimary.withValues(alpha: 0.25))),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
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
            ],
          ),
        ),
      ),
    );
  }
}

class _AvatarSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Stack(
          alignment: Alignment.center,
          children: [
            // Outer glow ring
            Container(
              width: 104,
              height: 104,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: glowColor(kPrimary, 0.5), blurRadius: 24),
                ],
                border: Border.all(color: kPrimary, width: 2),
              ),
            ),
            CircleAvatar(
              radius: 48,
              backgroundColor: const Color(0xFF1A1A1A),
              child: Icon(Icons.person_rounded, size: 48, color: kPrimary),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Local Only badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: kPrimary.withValues(alpha: 0.35)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: kIncome,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: glowColor(kIncome, 1), blurRadius: 5)],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'LOCAL ONLY',
                style: GoogleFonts.spaceGrotesk(
                  color: kOnSurfaceVariant,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.children,
  });
  final IconData icon;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            kPrimary.withValues(alpha: 0.08),
            const Color(0x801A1A1A),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kPrimary.withValues(alpha: 0.2)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: kPrimary, size: 20),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.spaceGrotesk(
                  color: kOnSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF111111),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF333333)),
        ),
        child: Row(
          children: [
            Icon(icon, color: kOnSurfaceVariant, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.spaceGrotesk(color: kOnSurface, fontSize: 15),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: kOnSurfaceVariant, size: 20),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      const SizedBox(height: 8);
}

class _GhostButton extends StatelessWidget {
  const _GhostButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          border: Border.all(color: kPrimary),
          borderRadius: BorderRadius.circular(6),
          boxShadow: [BoxShadow(color: glowColor(kPrimary, 0.15), blurRadius: 10)],
        ),
        child: Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            color: kPrimary,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}

class _NeonSwitch extends StatelessWidget {
  const _NeonSwitch({required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeThumbColor: kPrimary,
      activeTrackColor: kPrimary.withValues(alpha: 0.3),
      inactiveThumbColor: kOnSurfaceVariant,
      inactiveTrackColor: kOutline.withValues(alpha: 0.4),
    );
  }
}

class _ClearDataButton extends StatelessWidget {
  const _ClearDataButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: kError.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: glowColor(kError, 0.08), blurRadius: 12)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warning_rounded, color: kError, size: 18),
            const SizedBox(width: 10),
            Text(
              'CLEAR ALL LOCAL DATA',
              style: GoogleFonts.spaceGrotesk(
                color: kError,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

