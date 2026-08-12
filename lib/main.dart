import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expency/theme/app_theme.dart';
import 'package:expency/screens/home_screen.dart';
import 'package:expency/screens/history_screen.dart';
import 'package:expency/screens/profile_screen.dart';

import 'package:expency/models/transaction_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TransactionRepository.init();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF000000),
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const ExpencyApp());
}


class ExpencyApp extends StatelessWidget {
  const ExpencyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expency',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const _ThemeHost(child: MainShell()),
    );
  }
}

class _ThemeHost extends StatefulWidget {
  const _ThemeHost({required this.child});

  final Widget child;

  @override
  State<_ThemeHost> createState() => _ThemeHostState();
}

class _ThemeHostState extends State<_ThemeHost> {
  @override
  void initState() {
    super.initState();
    TransactionRepository.addListener(_refreshTheme);
  }

  @override
  void dispose() {
    TransactionRepository.removeListener(_refreshTheme);
    super.dispose();
  }

  void _refreshTheme() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Theme(data: buildAppTheme(), child: widget.child);
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

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

  void _onTap(int index) {
    HapticFeedback.selectionClick();
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _NeonBottomNav(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}

// â”€â”€â”€ Neon Bottom Navigation Bar â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _NeonBottomNav extends StatelessWidget {
  const _NeonBottomNav({
    required this.currentIndex,
    required this.onTap,
  });
  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _tabs = [
    _NavTab(icon: Icons.home_rounded, outlineIcon: Icons.home_outlined, label: 'Home'),
    _NavTab(icon: Icons.history_rounded, outlineIcon: Icons.history_rounded, label: 'History'),
    _NavTab(icon: Icons.person_rounded, outlineIcon: Icons.person_outline_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ColorFilter.mode(Colors.transparent, BlendMode.multiply),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.85),
            border: Border(
              top: BorderSide(color: kPrimary.withValues(alpha: 0.3), width: 1),
            ),
            boxShadow: [
              BoxShadow(color: glowColor(kPrimary, 0.1), blurRadius: 20, offset: const Offset(0, -4)),
            ],
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 64,
              child: Row(
                children: List.generate(_tabs.length, (i) {
                  final tab = _tabs[i];
                  final active = i == currentIndex;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onTap(i),
                      behavior: HitTestBehavior.opaque,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOutCubic,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Icon with glow
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              padding: const EdgeInsets.all(6),
                              decoration: active
                                  ? BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: glowColor(kPrimary, 0.5),
                                          blurRadius: 14,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    )
                                  : null,
                              child: Icon(
                                active ? tab.icon : tab.outlineIcon,
                                color: active
                                    ? kPrimary
                                    : kOnSurfaceVariant.withValues(alpha: 0.5),
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              tab.label.toUpperCase(),
                              style: GoogleFonts.spaceGrotesk(
                                color: active
                                    ? kPrimary
                                    : kOnSurfaceVariant.withValues(alpha: 0.5),
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavTab {
  const _NavTab({
    required this.icon,
    required this.outlineIcon,
    required this.label,
  });
  final IconData icon, outlineIcon;
  final String label;
}

