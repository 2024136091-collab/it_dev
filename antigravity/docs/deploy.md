# 빌드 및 배포

## 빌드 단계

```
소스 코드 → flutter build web → build/web/ → GitHub Pages
```

## Web 빌드

```bash
# Release 빌드 (최적화 포함)
flutter build web --release

# 결과물 위치
# build/web/index.html  ← 진입점
# build/web/main.dart.js ← 컴파일된 Dart 코드
# build/web/assets/    ← 폰트·이미지
```

## 로컬 서버 확인

```bash
# 빌드 후 로컬에서 확인
python -m http.server 8081 --directory build/web
# → http://localhost:8081 접속
```

## GitHub Pages 배포

발표 자료 저장소(`Elevator-info`)의 `index.html`을 GitHub Pages로 서빙합니다.

```
배포 URL: https://2024136091-collab.github.io
저장소: github.com/2024136091-collab/2024136091-collab.github.io
브랜치: main / (root)
```

## 배포 흐름

```
1. elevator.md 수정
   ↓
2. npx @marp-team/marp-cli elevator.md -o index.html
   ↓
3. git add · commit · push
   ↓
4. GitHub Pages 자동 반영 (약 1분 소요)
```

## 저장소 구조

| 저장소 | URL | 용도 |
|---|---|---|
| it_dev | github.com/2024136091-collab/it_dev | Flutter 앱 소스 |
| Elevator-info | github.com/2024136091-collab/Elevator-info | 발표 자료 |
| 2024136091-collab.github.io | github.com/2024136091-collab/... | GitHub Pages |
