import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:antigravity/main.dart';

void main() {
  testWidgets('홈 화면 렌더링 테스트', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: ElevatorApp()),
    );

    expect(find.text('승강기 정보검색'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
  });
}
