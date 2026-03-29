import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/splash/splash_screen.dart';
import '../features/home/home_screen.dart';
import '../features/join/join_screen.dart';
import '../features/listener/listener_screen.dart';
import '../features/host/host_screen.dart';
import '../features/equalizer/equalizer_screen.dart';
import '../features/history/history_screen.dart';
import '../features/settings/settings_screen.dart';

final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/join',
      builder: (context, state) => const JoinScreen(),
    ),
    GoRoute(
      path: '/listen',
      builder: (context, state) => const ListenerScreen(),
    ),
    GoRoute(
      path: '/host',
      builder: (context, state) => const HostScreen(),
    ),
    GoRoute(
      path: '/equalizer',
      builder: (context, state) => const EqualizerScreen(),
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const HistoryScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
