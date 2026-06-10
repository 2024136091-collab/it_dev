# 테스트

## 단위 테스트

`flutter test` 명령으로 실행합니다.

```bash
flutter test
```

### 홈 화면 렌더링 테스트 (`test/widget_test.dart`)

```dart
testWidgets('홈 화면 렌더링 테스트', (WidgetTester tester) async {
  await tester.pumpWidget(
    const ProviderScope(child: ElevatorApp()),
  );
  expect(find.text('승강기 정보검색'), findsOneWidget);
  expect(find.byIcon(Icons.search), findsOneWidget);
});
```

## 정적 분석

```bash
flutter analyze
# 결과: error 0건 (info 경고만 존재)
```

## 통합 테스트 시나리오 (수동)

| 시나리오 | 단계 | 기대 결과 |
|---|---|---|
| 검색 | "신구대학교" 입력 → 검색 | 본관·도서관 2개 건물 표시 |
| 지역 필터 | 검색 후 "서울" 선택 | 서울 소재 승강기만 표시 |
| 즐겨찾기 | 카드 별표 탭 | 즐겨찾기 화면에 추가됨 |
| 스마트 검색 | "오래된 승강기 찾아줘" 입력 | 설치연도 오래된 순 5개 표시 |
| 상세 정보 | 카드 탭 | 승강기 번호·제원·점검이력 표시 |
| 번호 검색 | "2018-399" 검색 | 휴먼시아아파트 표시 |

## 테스트 결과 요약

| 항목 | 결과 |
|---|---|
| 단위 테스트 | ✅ 통과 |
| 정적 분석 (error) | ✅ 0건 |
| Web 빌드 | ✅ 성공 |
| 수동 통합 테스트 | ✅ 전 시나리오 통과 |
