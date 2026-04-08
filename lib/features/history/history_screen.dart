import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../models/session_history_entry.dart';
import '../../models/join_method.dart';
import '../../services/storage/history_service.dart';
import '../../core/utils.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<SessionHistoryEntry> _entries = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final entries = await HistoryService.getAll();
    if (mounted) {
      setState(() {
        _entries = entries;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SBColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _header(context),
            const SizedBox(height: 8),
            Expanded(
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: SBColors.blue,
                      ),
                    )
                  : _entries.isEmpty
                      ? _emptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: _entries.length,
                          itemBuilder: (_, i) => _tile(_entries[i]),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: SBColors.surface2,
                borderRadius: BorderRadius.circular(11),
                border: Border.all(color: SBColors.border1),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: SBColors.textPrimary,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Text(
            'Session history',
            style: TextStyle(
              fontFamily: SBFonts.syne,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: SBColors.textPrimary,
            ),
          ),
          const Spacer(),
          if (_entries.isNotEmpty)
            GestureDetector(
              onTap: () async {
                await HistoryService.clear();
                _load();
              },
              child: Text(
                'Clear',
                style: TextStyle(
                  fontFamily: SBFonts.dmSans,
                  fontSize: 13,
                  color: SBColors.red,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _tile(SessionHistoryEntry e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SBColors.surface2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: SBColors.border1),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: SBColors.blueAccent,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Center(
              child: Text(
                e.hostName.isNotEmpty
                    ? e.hostName[0].toUpperCase()
                    : 'S',
                style: TextStyle(
                  fontFamily: SBFonts.syne,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: SBColors.blue,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
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
                const SizedBox(height: 3),
                Text(
                  '${e.mode.label} · ${SBUtils.formatDuration(e.duration)} · ${_dateLabel(e.date)}',
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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: e.joinMethod == JoinMethod.nfc
                      ? SBColors.tealAccent
                      : SBColors.blueAccent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  e.joinMethod.label,
                  style: TextStyle(
                    fontFamily: SBFonts.dmSans,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: e.joinMethod == JoinMethod.nfc
                        ? SBColors.teal
                        : SBColors.blue,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.history_rounded,
            size: 56,
            color: SBColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            'No sessions yet',
            style: TextStyle(
              fontFamily: SBFonts.syne,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: SBColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your past sessions will appear here',
            style: TextStyle(
              fontFamily: SBFonts.dmSans,
              fontSize: 14,
              color: SBColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  String _dateLabel(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}