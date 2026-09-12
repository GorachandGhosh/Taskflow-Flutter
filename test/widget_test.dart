import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:taskflow/app/app.dart';
import 'package:taskflow/firebase_options.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });

  testWidgets('TaskFlow app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const TaskFlowApp());

    await tester.pump();

    expect(find.byType(TaskFlowApp), findsOneWidget);
  });
}
