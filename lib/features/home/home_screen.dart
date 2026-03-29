import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../services/storage/history_service.dart';
import '../../models/session_history_entry.dart';
import '../../widgets/sb_badge.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<SessionHistoryEntry> _recent = [];

  @override
  void initState() {
    super.initState();
    _loadRecent();
  }

  Future<void> _loadRecent() async {
    final history = await HistoryService.getAll();
    if (mounted) {
      setState(() => _recent = history.take(3).toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SBColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _topBar(),
              const SizedBox(height: 28),
              _actionCards(),
              const SizedBox(height: 28),
              if (_recent.isNotEmpty) _recentSessions(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _bottomNav(),
    );
  }

  Widget _topBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good to see you',
              style: TextStyle(
                fontFamily: SBFonts.dmSans,
                fontSize: 13,
                color: SBColors.textSecondary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'SoundBridge',
              style: TextStyle(
                fontFamily: SBFonts.syne,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: SBColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => context.push('/settings'),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: SBColors.surface2,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: SBColors.border1),
            ),
            child: const Icon(
              Icons.settings_rounded,
              color: SBColors.textSecondary,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _actionCards() {
    return Column(
      children: [
        // Join session — full width primary card
        GestureDetector(
          onTap: () => context.push('/join'),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: SBColors.surface2,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: SBColors.border1),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: SBColors.blueAccent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.qr_code_scanner_rounded,
                    color: SBColors.blue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Join session',
                        style: TextStyle(
                          fontFamily: SBFonts.syne,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: SBColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Scan QR, tap NFC, or paste a link',
                        style: TextStyle(
                          fontFamily: SBFonts.dmSans,
                          fontSize: 13,
                          color: SBColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: SBColors.textTertiary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _smallCard(
                icon: Icons.broadcast_on_personal_rounded,
                color: SBColors.teal,
                title: 'Host',
                subtitle: 'Stream from phone',
                onTap: () => context.push('/host'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _smallCard(
                icon: Icons.history_rounded,
                color: SBColors.pink,
                title: 'History',
                subtitle: 'Past sessions',
                onTap: () => context.push('/history'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _smallCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: SBColors.surface2,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: SBColors.border1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontFamily: SBFonts.syne,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: SBColors.textPrimary,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: TextStyle(
                fontFamily: SBFonts.dmSans,
                fontSize: 12,
                color: SBColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recentSessions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent sessions',
              style: TextStyle(
                fontFamily: SBFonts.syne,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: SBColors.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: () => context.push('/history'),
              child: Text(
                'See all',
                style: TextStyle(
                  fontFamily: SBFonts.dmSans,
                  fontSize: 13,
                  color: SBColors.blue,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._recent.map((e) => _recentTile(e)),
      ],
    );
  }

  Widget _recentTile(SessionHistoryEntry e) {
    return GestureDetector(
      onTap: () => context.push('/join'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: SBColors.surface2,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: SBColors.border1),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: SBColors.blueAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  e.hostName.isNotEmpty ? e.hostName[0].toUpperCase() : 'S',
                  style: TextStyle(
                    fontFamily: SBFonts.syne,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: SBColors.blue,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.hostName,
                    style: TextStyle(
                      fontFamily: SBFonts.dmSans,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: SBColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${e.mode.label} mode · ${_timeAgo(e.date)}',
                    style: TextStyle(
                      fontFamily: SBFonts.dmSans,
                      fontSize: 12,
                      color: SBColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${e.avgLatencyMs}ms',
                  style: TextStyle(
                    fontFamily: SBFonts.jetbrains,
                    fontSize: 13,
                    color: latencyColor(e.avgLatencyMs),
                  ),
                ),
                const SizedBox(height: 4),
                e.joinMethod.name == 'nfc' ? SbBadge.nfc() : SbBadge.qr(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  Widget _bottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: SBColors.surface1,
        border: Border(top: BorderSide(color: SBColors.border1)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.home_rounded, 'Home', true, () {}),
              _navItem(Icons.qr_code_scanner_rounded, 'Join', false,
                  () => context.push('/join')),
              _navItem(Icons.graphic_eq_rounded, 'Listen', false,
                  () => context.push('/listen')),
              _navItem(Icons.tune_rounded, 'EQ', false,
                  () => context.push('/equalizer')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(
    IconData icon,
    String label,
    bool active,
    VoidCallback onTap,
  ) {
    final color = active ? SBColors.blue : SBColors.textTertiary;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontFamily: SBFonts.dmSans,
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
