# AGENTS.md — 승강기 정보검색 앱

AI Agent(Claude Code)를 활용한 Flutter 앱 개발 정책 문서입니다.

## 프로젝트 개요

- **앱명**: 승강기 정보검색
- **플랫폼**: Flutter Web (Android·iOS 추후 예정)
- **학번**: 2024136091 | **이름**: 김재호
- **소속**: 신구대학교 컴퓨터소프트웨어학과 앱프로그래밍응용

## 아키텍처 규칙

4레이어 단방향 의존 구조를 반드시 유지합니다.

```
Presentation → Application → Domain → Data
```

- `presentation/` 레이어는 `domain/models/`(데이터 클래스)는 import 가능하나, `domain/services/`를 직접 호출하지 않습니다.
- `presentation/` 레이어의 비즈니스 로직 호출은 반드시 `application/providers/`를 통해서만 합니다.
- `data/` 레이어는 `presentation/`을 import하지 않습니다.
- 비즈니스 로직은 반드시 `domain/services/`에 작성합니다.

## 디렉토리 구조

```
lib/
├── domain/models/          Elevator, InspectionRecord
├── domain/services/        ElevatorService (검색·필터·스마트 검색)
├── data/repositories/      ApiRepository, LocalRepository
├── application/providers/  SearchNotifier, FavoritesNotifier (Riverpod)
└── presentation/screens/   5개 화면
```

## 코드 규칙

- 상태 관리: `StateNotifier` + `AsyncValue` (Riverpod)
- 화면 위젯: `ConsumerStatefulWidget` 또는 `ConsumerWidget`
- 더미 데이터 ID: 국가승강기정보센터 번호 형식 `XXXX-XXX`
- 즐겨찾기: `Set<String>` 인메모리 저장 (`LocalRepository`)
- `withOpacity` 대신 `withValues()` 사용 권장

## ADR 목록

| # | 결정 | 파일 |
|---|---|---|
| 001 | 4레이어 아키텍처 채택 | docs/adr/001-layered-architecture.md |
| 002 | Riverpod 상태 관리 선택 | docs/adr/002-riverpod.md |
| 003 | 더미 데이터 우선 개발 | docs/adr/003-dummy-data-first.md |

## 빌드 명령

```bash
flutter pub get
flutter build web --release
# 결과물: build/web/
```

## 테스트

```bash
flutter test              # 단위 테스트
flutter analyze           # 정적 분석
```

## 관련 문서

- [요구사항](docs/requirements.md)
- [WBS](docs/wbs.md)
- [개발환경 설정](docs/setup.md)
- [빌드·배포](docs/deploy.md)
- [테스트](docs/testing.md)
