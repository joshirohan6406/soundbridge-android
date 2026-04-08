import 'package:flutter_test/flutter_test.dart';
import 'package:soundbridge_android/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('SoundBridge app launches', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: SoundBridgeApp(),
      ),
    );
  });
}