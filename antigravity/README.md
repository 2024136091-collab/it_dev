# 승강기 정보검색 앱

신구대학교 컴퓨터소프트웨어학과 앱프로그래밍응용 프로젝트 (2024136091 김재호)

## 개요

국가승강기정보센터(국승정) 공공 API 구조를 기반으로 승강기 설치·점검·위치 정보를 한 곳에서 빠르게 조회하는 Flutter 앱입니다.

## 주요 기능

| 기능 | 설명 |
|---|---|
| 승강기 검색 | 건물명·주소·승강기 번호(XXXX-XXX)로 검색 |
| 스마트 자연어 검색 | "오래된 승강기 찾아줘" 같은 문장형 질의를 규칙 기반으로 해석 |
| 지역 필터 | 서울·경기·강원 등 8개 권역별 필터 |
| 건물 유형 필터 | 학교·병원·아파트·오피스·상업시설·업체 분류 |
| 건물별 그룹핑 | 검색 결과를 건물 단위로 묶어 표시 |
| 점검 이력 조회 | 최근 점검 날짜·결과·담당자 확인 |
| 즐겨찾기 | 자주 조회하는 승강기 로컬 저장 |

## 아키텍처 — 4레이어

```
Presentation  →  Application  →  Domain  →  Data
(Flutter 위젯)    (Riverpod)    (Service)  (Repository)
```

```
lib/
├── domain/
│   ├── models/elevator.dart            Elevator · InspectionRecord
│   └── services/elevator_service.dart  검색·필터·스마트 검색 로직
├── data/repositories/
│   ├── api_repository.dart             더미 데이터 (API 연동 준비)
│   └── local_repository.dart           즐겨찾기 저장
├── application/providers/
│   ├── elevator_providers.dart         SearchNotifier (Riverpod)
│   └── favorites_providers.dart        FavoritesNotifier
└── presentation/screens/
    ├── home_screen.dart                홈 화면
    ├── ai_search_screen.dart           스마트 자연어 검색 화면
    ├── search_result_screen.dart       검색 결과 (건물별 그룹)
    ├── detail_screen.dart              승강기 상세 정보
    └── favorites_screen.dart           즐겨찾기 목록
```

## 기술 스택

- **Flutter** — Android·iOS·Web 단일 코드베이스 (현재 Web 빌드 완료)
- **flutter_riverpod** — `StateNotifier` + `AsyncValue` 상태 관리
- **국가승강기정보센터 API** — 승강기 번호 체계 `XXXX-XXX` 기반

## 빌드 방법

```bash
flutter pub get
flutter build web --release
```

## 발표 자료

[https://num.slogs.dev](https://num.slogs.dev)
