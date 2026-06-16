# 성능 최적화

실제 적용된 최적화 기법과 코드 근거입니다.

## 1. 위젯 단위 리빌드 최소화 (Riverpod 스코프 분리)

`ConsumerWidget`을 화면 전체가 아니라 작은 단위로 쪼개서, 상태가 바뀔 때 해당 위젯만
리빌드되도록 했습니다. 예를 들어 즐겨찾기 토글은 `_ElevatorCard` 하나에서만
`ref.watch(favoritesProvider)`를 호출하므로, 별표를 누를 때 검색 결과 리스트 전체가
다시 그려지지 않고 카드 한 개만 리빌드됩니다.

```dart
// lib/presentation/screens/search_result_screen.dart
class _ElevatorCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(favoritesProvider).contains(elevator.id); // 카드 단위로만 watch
    ...
```

(ADR-002에도 "ConsumerWidget으로 필요한 위젯만 리빌드해 성능을 최적화한다"로 명시되어 있음)

## 2. 리스트 지연 렌더링

검색 결과·지역 필터 칩 목록은 `ListView.separated`(builder 기반)로 구현해, 화면에 보이는
항목만 위젯을 생성합니다. 건물·승강기 수가 늘어나도 한 번에 모든 카드를 미리 그리지 않습니다.

```dart
// lib/presentation/screens/search_result_screen.dart
ListView.separated(
  itemCount: buildings.length,
  itemBuilder: (context, i) => _BuildingGroup(...), // 보이는 만큼만 생성
)
```

## 3. const 생성자 적극 활용

색상·아이콘·여백 등 정적인 위젯에는 전부 `const`를 붙여, 부모가 리빌드되어도 Flutter가
해당 서브트리를 재생성하지 않고 재사용하도록 했습니다 (`flutter analyze`의 `prefer_const_constructors` 린트로 강제).

## 4. 애니메이션 컨트롤러 정리로 메모리 누수 방지

스마트 검색 화면의 점 애니메이션(`AnimationController`)은 `dispose()`에서 반드시 해제합니다.

```dart
// lib/presentation/screens/ai_search_screen.dart
@override
void dispose() {
  _dotController.dispose();
  _controller.dispose();
  super.dispose();
}
```

## 5. 빌드 최적화

배포는 `flutter build web --release`로 트리쉐이킹·축소(minify)가 적용된 산출물을 사용합니다.

## 향후 계획 (13주차 API 연동 시)

- 실제 API 응답은 `AsyncValue`로 캐싱해 동일 검색어 재호출 방지
- 페이지네이션 또는 무한 스크롤 도입 (현재는 더미 데이터 16건이라 불필요)
