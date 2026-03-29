import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import '../../../models/audio_packet.dart';
import '../../../core/constants.dart';

class UdpReceiver {
  RawDatagramSocket? _socket;
  void Function(AudioPacket packet)? onPacket;
  bool _running = false;

  Future<void> start() async {
    _socket = await RawDatagramSocket.bind(
      InternetAddress.anyIPv4,
      SBConstants.audioPort,
    );
    _running = true;
    _socket!.listen((event) {
      if (event == RawSocketEvent.read) {
        final dg = _socket!.receive();
        if (dg != null) {
          final packet = AudioPacket.fromBytes(
            Uint8List.fromList(dg.data),
          );
          if (packet != null) {
            onPacket?.call(packet);
          }
        }
      }
    });
  }

  Future<void> stop() async {
    _running = false;
    _socket?.close();
    _socket = null;
  }
}
