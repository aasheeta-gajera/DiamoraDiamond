import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:daimo/main.dart' as app; // Update if your actual app name is different

void main() {
  // Bind integration testing framework
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized() as IntegrationTestWidgetsFlutterBinding;

  testWidgets("App Startup Performance Test", (WidgetTester tester) async {
    // Record performance metrics
    await binding.traceAction(() async {
      app.main(); // Launch the app
      await tester.pumpAndSettle(); // Wait for all animations and builds to finish
    }, reportKey: 'startup_performance');
  });
}
