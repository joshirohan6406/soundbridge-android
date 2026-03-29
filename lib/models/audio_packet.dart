import 'dart:typed_data';

class AudioPacket {
  final int sequenceNumber;
  final int timestampUs;
  final Uint8List opusData;
  final int channels;
  final int modeIndex;

  AudioPacket({
    required this.sequenceNumber,
    required this.timestampUs,
    required this.opusData,
    required this.channels,
    required this.modeIndex,
  });

  static AudioPacket? fromBytes(Uint8List bytes) {
    if (bytes.length < 16) return null;
    final view = ByteData.sublistView(bytes);
    final seq = view.getUint32(0, Endian.big);
    final ts = view.getUint64(4, Endian.big);
    final len = view.getUint16(12, Endian.big);
    final ch = view.getUint8(14);
    final mod = view.getUint8(15);
    if (bytes.length < 16 + len) return null;
    return AudioPacket(
      sequenceNumber: seq,
      timestampUs: ts,
      opusData: bytes.sublist(16, 16 + len),
      channels: ch,
      modeIndex: mod,
    );
  }
}
