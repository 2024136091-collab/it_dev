// 통합 플로우 테스트 (위젯 레벨)
//
// flutter_test의 WidgetTester로 여러 화면을 실제로 내비게이션하며
// 검색 → 결과 → 상세 → 즐겨찾기로 이어지는 사용자 시나리오 전체를 검증한다.
// (docs/testing.md의 "수동 통합 테스트 시나리오" 중 핵심 플로우를 자동화한 버전)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:antigravity/main.dart';

void main() {
  testWidgets('검색 → 결과 → 상세 → 즐겨찾기로 이어지는 전체 플로우', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: ElevatorApp()));

    // 1. 홈에서 "신구대학교" 검색
    await tester.enterText(find.byType(TextField), '신구대학교');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    // 2. 검색 결과 화면: 본관·도서관 그룹이 표시되어야 한다
    expect(find.text('신구대학교 본관'), findsWidgets);
    expect(find.text('신구대학교 도서관'), findsWidgets);

    // 3. 첫 번째 승강기 카드를 탭해 상세 화면으로 이동
    await tester.tap(find.byIcon(Icons.elevator).first);
    await tester.pumpAndSettle();

    // 4. 상세 화면: 기본 정보 카드가 표시되어야 한다
    expect(find.text('기본 정보'), findsOneWidget);

    // 5. 즐겨찾기 등록
    await tester.tap(find.byIcon(Icons.star_border));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.star), findsWidgets);

    // 6. 상세 → 결과 화면으로 복귀 후 홈으로 복귀, 즐겨찾기 화면 진입
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('즐겨찾기'));
    await tester.pumpAndSettle();

    // 7. 즐겨찾기 화면에 방금 등록한 승강기가 표시되어야 한다
    expect(find.text('즐겨찾기한 승강기가 없습니다.'), findsNothing);
    expect(find.text('신구대학교 본관'), findsOneWidget);
  });
}
