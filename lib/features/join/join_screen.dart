import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../services/join/nfc_service.dart';
import 'widgets/qr_scanner_view.dart';
import 'widgets/nfc_tap_view.dart';
import 'widgets/nfc_unavailable_view.dart';
import 'widgets/link_paste_view.dart';

class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  bool _nfcAvailable = false;
  bool _checkingNfc = true;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
    _checkNfc();
  }

  Future<void> _checkNfc() async {
    final available = await NfcService.isAvailable;
    if (mounted) {
      setState(() {
        _nfcAvailable = available;
        _checkingNfc = false;
      });
    }
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SBColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            _tabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabs,
                children: [
                  QrScannerView(
                    onSessionFound: (session) =>
                        context.go('/listen', extra: session),
                  ),
                  _checkingNfc
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: SBColors.teal,
                          ),
                        )
                      : _nfcAvailable
                          ? NfcTapView(
                              onSessionFound: (session) =>
                                  context.go('/listen', extra: session),
                            )
                          : const NfcUnavailableView(),
                  LinkPasteView(
                    onSessionFound: (session) =>
                        context.go('/listen', extra: session),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
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
            'Join session',
            style: TextStyle(
              fontFamily: SBFonts.syne,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: SBColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: SBColors.surface1,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: SBColors.border1),
        ),
        child: TabBar(
          controller: _tabs,
          indicator: BoxDecoration(
            color: SBColors.surface3,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: SBColors.border2),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: SBColors.textPrimary,
          unselectedLabelColor: SBColors.textTertiary,
          labelStyle: TextStyle(
            fontFamily: SBFonts.dmSans,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: SBFonts.dmSans,
            fontSize: 13,
          ),
          dividerColor: Colors.transparent,
          tabs: const [
            Tab(text: 'QR scan'),
            Tab(text: 'NFC tap'),
            Tab(text: 'Link'),
          ],
        ),
      ),
    );
  }
}