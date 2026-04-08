import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import '../../models/session.dart';
import '../../models/join_method.dart';
import '../../providers/playback_provider.dart';
import '../../providers/network_stats_provider.dart';
import '../../services/network/client/websocket_client.dart';
import '../../services/audio/client/udp_receiver.dart';
import '../../services/audio/client/jitter_buffer.dart';
import '../../services/network/client/clock_sync_service.dart';
import '../../services/network/client/network_monitor.dart';
import '../../core/constants.dart';
import 'widgets/latency_badge.dart';
import 'widgets/visualizer_zone.dart';
import 'widgets/connection_status_bar.dart';
import '../../models/audio_mode.dart';

class ListenerScreen extends ConsumerStatefulWidget {
  const ListenerScreen({super.key});

  @override
  ConsumerState<ListenerScreen> createState() => _ListenerScreenState();
}

class _ListenerScreenState extends ConsumerState<ListenerScreen> {
  Session? _session;
  JoinMethod _joinMethod = JoinMethod.qr;
  final _wsClient = WebSocketClient();
  final _udpReceiver = UdpReceiver();
  final _clockSync = ClockSyncService();
  final _networkMonitor = NetworkMonitor();
  late JitterBuffer _jitterBuffer;
  double _volume = 1.0;

  @override
  void initState() {
    super.initState();
    _jitterBuffer = JitterBuffer(
      targetDepthMs: SBConstants.bufferMusic,
      maxDepthMs: 220,
      minDepthMs: 80,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = GoRouterState.of(context).extra;
      if (args is Session) {
        _session = args;
        _connect();
      }
    });
  }

  Future<void> _connect() async {
    if (_session == null) return;
    ref.read(playbackProvider.notifier).setConnecting(
          _session!.hostName,
          _joinMethod,
        );

    // Clock sync
    await _clockSync.sync(_session!.ip, _session!.httpPort);

    // WebSocket
    _wsClient.onConnected = () {
      ref.read(playbackProvider.notifier).setConnected();
      _wsClient.send({
        'type': SBConstants.msgJoinConfirm,
        'deviceId': 'android_device_1',
        'displayName': 'My Phone',
        'joinMethod': _joinMethod.name,
      });
      _networkMonitor.startReporting(
        _wsClient.send,
        'android_device_1',
      );
    };

    _wsClient.onDisconnected = () {
      ref.read(playbackProvider.notifier).setReconnecting();
    };

    _wsClient.onMessage = (data) {
      final type = data['type'] as String? ?? '';
      if (type == SBConstants.msgModeChange) {
        final mode = data['mode'] as String? ?? 'music';
        final bufferMs = (data['bufferMs'] as num?)?.toInt() ?? 120;
        _jitterBuffer.flush();
        ref.read(playbackProvider.notifier).setMode(
              AudioMode.fromName(mode),
            );
      } else if (type == SBConstants.msgResync) {
        _jitterBuffer.flush();
      } else if (type == SBConstants.msgSetVolume) {
        final vol = (data['volume'] as num?)?.toDouble() ?? 1.0;
        setState(() => _volume = vol);
      } else if (type == SBConstants.msgSessionEnd) {
        _disconnect();
        if (mounted) context.go('/home');
      }
    };

    await _wsClient.connect(_session!.ip, _session!.controlPort);

    // UDP
    _udpReceiver.onPacket = (packet) {
      _jitterBuffer.insert(packet);
    };
    await _udpReceiver.start();
  }

  Future<void> _disconnect() async {
    _networkMonitor.stop();
    await _wsClient.disconnect();
    await _udpReceiver.stop();
    _jitterBuffer.flush();
    ref.read(playbackProvider.notifier).reset();
  }

  @override
  void dispose() {
    _disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playback = ref.watch(playbackProvider);
    final stats = ref.watch(networkStatsProvider);

    return Scaffold(
      backgroundColor: SBColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _topRow(playback, stats),
            const SizedBox(height: 8),
            _nowListening(playback),
            const SizedBox(height: 16),
            ConnectionStatusBar(status: playback.status),
            const SizedBox(height: 16),
            const VisualizerZone(),
            const SizedBox(height: 20),
            _statsRow(stats),
            const SizedBox(height: 20),
            _volumeControl(),
            const SizedBox(height: 16),
            _equalizerButton(),
            const Spacer(),
            _leaveButton(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _topRow(PlaybackState playback, NetworkStats stats) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'via ${playback.joinMethod.label} join',
            style: TextStyle(
              fontFamily: SBFonts.dmSans,
              fontSize: 12,
              color: SBColors.textSecondary,
            ),
          ),
          LatencyBadge(latencyMs: stats.latencyMs),
        ],
      ),
    );
  }

  Widget _nowListening(PlaybackState playback) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            'Now listening',
            style: TextStyle(
              fontFamily: SBFonts.dmSans,
              fontSize: 11,
              color: SBColors.textTertiary,
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _session?.hostName ?? 'Connecting...',
            style: TextStyle(
              fontFamily: SBFonts.syne,
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: SBColors.textPrimary,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: SBColors.blueAccent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: SBColors.blue.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.graphic_eq_rounded,
                  color: SBColors.blue,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  '${playback.mode.label} mode',
                  style: TextStyle(
                    fontFamily: SBFonts.dmSans,
                    fontSize: 12,
                    color: SBColors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statsRow(NetworkStats stats) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
              child: _statBox(
            value: '${stats.latencyMs}ms',
            label: 'Latency',
            valueColor: latencyColor(stats.latencyMs),
          )),
          const SizedBox(width: 10),
          Expanded(
              child: _statBox(
            value: stats.qualityLabel,
            label: 'Quality',
            valueColor: SBColors.teal,
          )),
          const SizedBox(width: 10),
          Expanded(
              child: _statBox(
            value: '${_jitterBuffer.adaptiveDepthMs}ms',
            label: 'Buffer',
            valueColor: SBColors.textPrimary,
          )),
        ],
      ),
    );
  }

  Widget _statBox({
    required String value,
    required String label,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: SBColors.surface2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: SBColors.border1),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: SBFonts.jetbrains,
              fontSize: 18,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: SBFonts.dmSans,
              fontSize: 11,
              color: SBColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _volumeControl() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My volume',
                style: TextStyle(
                  fontFamily: SBFonts.dmSans,
                  fontSize: 13,
                  color: SBColors.textSecondary,
                ),
              ),
              Text(
                '${(_volume * 100).round()}%',
                style: TextStyle(
                  fontFamily: SBFonts.jetbrains,
                  fontSize: 13,
                  color: SBColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: SBColors.blue,
              inactiveTrackColor: SBColors.surface3,
              thumbColor: SBColors.blue,
              overlayColor: SBColors.blueAccent,
              trackHeight: 4,
            ),
            child: Slider(
              value: _volume,
              onChanged: (v) => setState(() => _volume = v),
            ),
          ),
        ],
      ),
    );
  }

  Widget _equalizerButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => context.push('/equalizer'),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: SBColors.surface2,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: SBColors.border2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.tune_rounded,
                color: SBColors.textPrimary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Open equalizer',
                style: TextStyle(
                  fontFamily: SBFonts.dmSans,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: SBColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _leaveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () async {
          await _disconnect();
          if (mounted) context.go('/home');
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: SBColors.red.withValues(alpha: 0.4),
            ),
          ),
          child: Text(
            'Leave session',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: SBFonts.dmSans,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: SBColors.red,
            ),
          ),
        ),
      ),
    );
  }
}


