# 개발환경 설정

## 필수 도구

| 도구 | 버전 | 용도 |
|---|---|---|
| Flutter SDK | 3.41.9 (stable) | 앱 개발·빌드 |
| Dart | Flutter 내장 | 언어 |
| VS Code | 최신 | 코드 편집 |
| Git | 최신 | 버전 관리 |
| Chrome | 최신 | Web 디버깅 |

## Flutter 설치 및 환경 설정

```bash
# 1. Flutter SDK 다운로드 후 PATH 등록
# https://docs.flutter.dev/get-started/install

# 2. 설치 확인
flutter doctor

# 3. Web 지원 활성화
flutter config --enable-web
```

## 프로젝트 클론 및 실행

```bash
# 저장소 클론
git clone https://github.com/2024136091-collab/it_dev.git
cd it_dev/antigravity

# 패키지 설치
flutter pub get

# Web 디버그 실행
flutter run -d web-server --web-port 8080

# 정적 분석
flutter analyze
```

## 주요 패키지

```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.6.1
  flutter_map: ^6.1.0
  latlong2: ^0.9.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

## 프로젝트 구조

```
antigravity/
├── lib/
│   ├── main.dart
│   ├── domain/          비즈니스 로직 (Flutter 미의존)
│   ├── data/            데이터 소스
│   ├── application/     Riverpod 상태 관리
│   └── presentation/    Flutter 화면
├── docs/                문서
├── test/                테스트
├── AGENTS.md            AI Agent 정책
└── README.md
```
