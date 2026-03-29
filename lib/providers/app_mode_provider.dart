import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppMode { idle, hosting, listening }

class AppModeNotifier extends StateNotifier<AppMode> {
  AppModeNotifier() : super(AppMode.idle);

  void setHosting() => state = AppMode.hosting;
  void setListening() => state = AppMode.listening;
  void setIdle() => state = AppMode.idle;
}

final appModeProvider = StateNotifierProvider<AppModeNotifier, AppMode>(
  (ref) => AppModeNotifier(),
);
