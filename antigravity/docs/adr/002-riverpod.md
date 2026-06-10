# ADR-002: Riverpod 상태 관리 선택

## 상태
채택됨

## 배경
Flutter 앱에서 상태 관리 라이브러리로 Provider, Riverpod, Bloc, GetX 중 선택이 필요했다.

## 결정
`flutter_riverpod ^2.6.1`의 `StateNotifier` + `AsyncValue` 조합을 채택한다.

## 근거

| 비교 항목 | Provider | **Riverpod** | Bloc |
|---|---|---|---|
| 전역 오염 | BuildContext 필요 | 불필요 | 불필요 |
| 비동기 처리 | 수동 | AsyncValue 자동 | 수동 |
| 학습 난이도 | 낮음 | 중간 | 높음 |
| 타입 안전성 | 낮음 | 높음 | 높음 |

- `AsyncValue`로 로딩·에러·데이터 3가지 상태를 한 타입으로 처리할 수 있다.
- `StateNotifierProvider`로 검색 결과와 즐겨찾기를 전역 상태로 관리한다.
- `ConsumerWidget`으로 필요한 위젯만 리빌드해 성능을 최적화한다.

## 결과
- `SearchNotifier`: 검색·필터·스마트 검색 상태를 `AsyncValue<List<Elevator>>`로 관리
- `FavoritesNotifier`: 즐겨찾기를 `Set<String>`으로 관리
