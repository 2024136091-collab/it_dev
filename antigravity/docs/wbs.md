# WBS (Work Breakdown Structure)

## 일정 개요

| 주차 | 기간 | 목표 |
|---|---|---|
| 9주차 | 2026-05-06 ~ 05-12 | 요구사항 분석·기획 |
| 10주차 | 2026-05-13 ~ 05-19 | 아키텍처 설계·환경 구성 |
| 11주차 | 2026-05-20 ~ 05-26 | 핵심 기능 구현 |
| 12주차 | 2026-05-27 ~ 06-10 | 추가 기능·발표 준비 |
| 13주차 | 2026-06-11 ~ 06-17 | API 연동·마무리 |

## 세부 작업

### 1. 기획 및 설계
- [x] 요구사항 분석
- [x] 4레이어 아키텍처 설계
- [x] 데이터 모델 정의 (Elevator, InspectionRecord)
- [x] 국가승강기정보센터 API 번호 체계 분석

### 2. 환경 구성
- [x] Flutter 프로젝트 생성 (antigravity)
- [x] flutter_riverpod 패키지 추가
- [x] GitHub 저장소 연결 (it_dev)

### 3. 핵심 기능 구현
- [x] Domain 레이어: ElevatorService
- [x] Data 레이어: ApiRepository (더미 데이터), LocalRepository
- [x] Application 레이어: SearchNotifier, FavoritesNotifier
- [x] Presentation: 홈·검색결과·상세·즐겨찾기 화면

### 4. 추가 기능 구현
- [x] 지역 필터 (8개 권역)
- [x] 건물 유형 필터 (업체·학교·병원·아파트)
- [x] 승강기 종류 필터
- [x] 건물별 그룹핑 표시
- [x] 스마트 자연어 검색 화면

### 5. 발표 준비
- [x] Marp 발표 자료 작성
- [x] GitHub Pages 배포
- [x] 문서화 (README, AGENTS.md, ADR)

### 6. 예정 작업 (13주차)
- [ ] 국가승강기정보센터 실제 API 연동
- [ ] Dio HTTP 클라이언트 적용
- [ ] Android·iOS 빌드 테스트
