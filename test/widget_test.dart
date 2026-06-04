// 云游助手 Widget 测试
import 'package:flutter_test/flutter_test.dart';
import 'package:yunyou_assistant/main.dart';

void main() {
  testWidgets('App launches with login page', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // 验证登录页面元素存在
    expect(find.text('云游助手'), findsOneWidget);
    expect(find.text('游客一键登录'), findsOneWidget);
  });
}
