import 'package:flutter_test/flutter_test.dart';
import 'package:jastar_hub_community/app/app.dart';

void main() {
  testWidgets('App should build without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const JastarHubApp());
  });
}
