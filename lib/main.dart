import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router.dart';
import 'core/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: SoundBridgeApp(),
    ),
  );
}

class SoundBridgeApp extends StatelessWidget {
  const SoundBridgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SoundBridge',
      debugShowCheckedModeBanner: false,
      theme: soundBridgeTheme(),
      routerConfig: router,
    );
  }
}