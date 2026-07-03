// Temel smoke test: uygulama açılış ekranı hatasız oluşuyor mu.
import 'package:flutter_test/flutter_test.dart';

import 'package:amin/main.dart';

void main() {
  testWidgets('AminApp açılış smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AminApp());
    await tester.pump();
    // Açılış ekranında uygulama adı görünür.
    expect(find.text('AMİN'), findsWidgets);
  });
}
