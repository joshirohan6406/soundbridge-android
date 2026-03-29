import 'dart:typed_data';

/// Packet Loss Concealment — generates comfort noise when packets are missing.
class PlcService {
  static Uint8List generateComfortNoise(int sampleCount, int channels) {
    // Generate very low amplitude noise as comfort fill
    final samples = Uint8List(sampleCount * channels * 2);
    for (int i = 0; i < samples.length; i++) {
      samples[i] = (128 + (i % 3 == 0 ? 1 : 0)).clamp(0, 255);
    }
    return samples;
  }
}
