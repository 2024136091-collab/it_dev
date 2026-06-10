# ADR-001: 4레이어 아키텍처 채택

## 상태
채택됨

## 배경
Flutter 앱에서 UI·비즈니스 로직·데이터를 분리하지 않으면 코드가 뒤섞여 유지보수가 어려워진다.

## 결정
Presentation → Application → Domain → Data 단방향 4레이어 구조를 채택한다.

| 레이어 | 역할 |
|---|---|
| Presentation | Flutter 위젯, 화면 5개 |
| Application | Riverpod StateNotifier, 상태 관리 |
| Domain | ElevatorService, 비즈니스 로직 |
| Data | ApiRepository, LocalRepository |

## 근거
- 각 레이어가 명확한 책임을 가져 테스트와 교체가 용이하다.
- Domain 레이어는 Flutter·Riverpod에 의존하지 않아 순수 Dart로 단위 테스트 가능하다.
- API 연동 시 Data 레이어만 수정하면 나머지 레이어는 변경 불필요하다.

## 결과
- 더미 데이터 → 실제 API 전환 시 `ApiRepository`만 수정하면 된다.
- `ElevatorService.aiSearch()`는 Domain에 위치해 UI와 독립적으로 동작한다.
