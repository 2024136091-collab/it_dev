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

### ElevatorService 단위 테스트 (`test/elevator_service_test.dart`)

Flutter 위젯 없이 순수 Dart 로직만 검증하는 13개 테스트.

- `search`: 건물명·승강기번호 검색, 빈 문자열 처리
- `filterByRegion` / `filterByCategory`: 지역·카테고리 필터링 (전체/업체 특수 케이스 포함)
- `aiSearch`: "오래된"·"장애인"·"점검" 키워드 분기와 fallback 검색
- `groupByBuilding`: 건물명 기준 그룹핑, 동일 건물 다중 승강기 묶음

```bash
flutter test test/elevator_service_test.dart
```

## 정적 분석

```bash
flutter analyze
# 결과: error 0건 (info 경고만 존재)
```

## 통합 테스트

### 자동 통합 플로우 테스트 (`test/integration_flow_test.dart`)

`WidgetTester`로 여러 화면을 실제로 내비게이션하며 검증하는 자동화된 위젯 레벨 통합 테스트.
홈 검색 → 검색 결과(그룹핑 확인) → 상세 화면 → 즐겨찾기 등록 → 즐겨찾기 화면 확인까지
한 테스트에서 화면 전환을 모두 거친다.

```bash
flutter test test/integration_flow_test.dart
```

### 수동 통합 테스트 시나리오 (체크리스트)

자동화하지 않고 직접 눈으로 확인하는 보조 시나리오입니다.

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
| 단위 테스트 (15건: 위젯 1 + 서비스 13 + 통합 1) | ✅ 전부 통과 |
| 정적 분석 (error) | ✅ 0건 |
| Web 빌드 | ✅ 성공 |
| 수동 통합 테스트 | ✅ 전 시나리오 통과 |
