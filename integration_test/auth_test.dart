import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tracking_app/main.dart' as app;
import 'package:tracking_app/pages/bottom_navigation.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group("auth_test", () {
    testWidgets("auth", (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 4));

      final signinbutton = find.byKey(const Key("sign_in_button"));
      expect(signinbutton, findsOneWidget);
      await tester.tap(signinbutton);
      await tester.pump(const Duration(seconds: 4));

      expect(find.byType(MyBottomNavigation), findsOneWidget);
    });
    testWidgets("add weight", (tester) async {
      app.main();
      await tester.pumpAndSettle();
      final floatingactionbutton = find.byKey(const Key("floating_button"));
      expect(floatingactionbutton, findsOneWidget);
      await tester.tap(floatingactionbutton);
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      final weightField = find.byKey(const Key("weight_text_field"));
      expect(weightField, findsOneWidget);
      await tester.enterText(
          weightField, '68.5'); // Replace with your desired value
      await tester.pumpAndSettle();
    });
  });
}
