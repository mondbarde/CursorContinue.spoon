# CursorContinue.spoon

Cursor에서 엔터 더블탭으로 지정 문구를 입력하고 Enter로 전송하는 Hammerspoon Spoon.
기본 문구: "진행시켜"
지원: Cursor(Todesktop 래퍼 포함) 전면일 때만 동작(기본).

## 설치
1) `CursorContinue.spoon.zip` 압축 해제 → `~/.hammerspoon/Spoons/`로 이동
2) `~/.hammerspoon/init.lua`에 아래 추가:

```lua
hs.loadSpoon("CursorContinue")
spoon.CursorContinue.phrase = "계속해줘"
spoon.CursorContinue.doubleTapInterval = 0.35
spoon.CursorContinue.onlyWhenCursorFrontmost = true
spoon.CursorContinue.showAlertOnTrigger = true
spoon.CursorContinue:start()
```

3) Hammerspoon 메뉴 → Reload Config

## 수동 빌드
```bash
./build.sh
ls dist/  # CursorContinue.spoon.zip
```

## GitHub 릴리스
- 태그 푸시(`v0.1.0` 형태) 시 자동으로 `.spoon.zip`를 빌드하고 릴리스에 첨부합니다.

## 권한
- 시스템 설정 → 개인정보 보호 및 보안
- 접근성: Hammerspoon 허용
- 입력 모니터링: Hammerspoon 허용

## 문제 해결
- Hammerspoon Console에서 `hs.eventtap.isSecureInputEnabled()`가 true면 어떤 앱이 보안 키보드 입력을 잡고 있음 → 해당 앱 옵션 해제 후 재시도
- Reload Config 또는 Hammerspoon 재실행

## 옵션
- `doubleTapInterval`: 두 번 누르는 허용 간격(초), 기본 0.35
- `phrase`: 입력할 문구, 기본 "계속해줘"
- `consumeDoubleEnter`: 트리거 시 두 번째 엔터를 원본 앱에 전달하지 않음(true 기본)
- `onlyWhenCursorFrontmost`: Cursor 전면일 때만 동작(true 기본)
- `showAlertOnTrigger`: 트리거 시 알림 표시(true 기본)

## 라이선스
MIT
