import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/session.dart';

class SessionNotifier extends StateNotifier<Session?> {
  SessionNotifier() : super(null);

  void setSession(Session session) => state = session;
  void clearSession() => state = null;
  void updateNfcStatus(bool active) {
    if (state != null) {
      state = state!.copyWith(nfcActive: active);
    }
  }
}

final sessionProvider = StateNotifierProvider<SessionNotifier, Session?>(
  (ref) => SessionNotifier(),
);
