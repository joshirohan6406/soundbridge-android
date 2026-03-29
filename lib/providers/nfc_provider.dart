import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/join/nfc_service.dart';

class NfcState {
  final bool isAvailable;
  final bool isBroadcasting;

  const NfcState({
    this.isAvailable = false,
    this.isBroadcasting = false,
  });

  NfcState copyWith({bool? isAvailable, bool? isBroadcasting}) => NfcState(
        isAvailable: isAvailable ?? this.isAvailable,
        isBroadcasting: isBroadcasting ?? this.isBroadcasting,
      );
}

class NfcNotifier extends StateNotifier<NfcState> {
  NfcNotifier() : super(const NfcState()) {
    _init();
  }

  Future<void> _init() async {
    final available = await NfcService.isAvailable;
    state = state.copyWith(isAvailable: available);
  }

  void setBroadcasting(bool value) {
    state = state.copyWith(isBroadcasting: value);
  }
}

final nfcProvider = StateNotifierProvider<NfcNotifier, NfcState>(
  (ref) => NfcNotifier(),
);
