# Display Resolution and Window Mode Design

Decision: `D-2026-08-10-DISPLAY-RESOLUTION-WINDOW-MODE`

## Goal

PC 플레이어가 메인 메뉴의 `설정 / 접근성`에서 게임 창 크기와 전체화면 여부를 직접 바꾸고, 재실행 후에도 선택이 유지되게 한다.

## Current state

- `project.godot`: viewport 1280×720, `canvas_items`, `expand`.
- `scripts/ui/accessibility_settings.gd`: `screen_shake`, `flash`, `horror_distortion`만 저장.
- `scripts/ui/main_menu.gd`: 설정 패널에서 세 접근성 슬라이더만 제공.

## Architecture

### DisplaySettings owner

새 전용 `DisplaySettings` 소유자가 표시 설정만 담당한다.

Persisted values:

- `display_mode`: `windowed` | `fullscreen`
- `resolution`: `1280x720` | `1600x900` | `1920x1080`

안전하지 않은 값은 기본값으로 정규화한다.

`AccessibilitySettings`에는 표시 설정을 넣지 않는다.

### Runtime application

설정 적용 함수는 한 경로에서만 다음을 수행한다.

1. 저장값 정규화
2. 표시 모드 적용
3. 창 모드이면 선택한 픽셀 크기 적용
4. 설정 저장
5. 실제 적용 결과를 UI에 반영

전체화면에서 해상도 선택은 보존하되 즉시 창 크기를 강제로 바꾸지 않는다. 다시 창 모드로 전환할 때 마지막 창 해상도를 적용한다.

## UI

기존 `설정 / 접근성` 패널 상단에 `화면` 섹션을 둔다.

- `표시 모드`: 창 모드 / 전체화면
- `해상도`: 1280×720 / 1600×900 / 1920×1080

그 아래 기존 화면 흔들림/섬광/공포 왜곡을 유지한다.

키보드/게임패드 포커스 순서에 새 컨트롤을 포함한다. 색상만으로 현재 선택을 표현하지 않는다.

## Error handling

- 저장 파일이 없으면 기본값 사용.
- 손상된 값은 기본값으로 복구 후 저장.
- 창 크기 적용이 불가능하면 현재 창을 유지하고 UI에는 실제 적용값을 표시.
- project viewport/stretch 설정은 변경하지 않는다.

## Testing

RED부터 다음을 고정한다.

1. 허용 해상도 목록과 기본값.
2. 잘못된 저장값 정규화.
3. 창 모드에서 3개 해상도 각각 적용 요청.
4. 전체화면 전환과 마지막 창 해상도 보존.
5. 재실행 시 저장값 로드.
6. 설정 패널에 표시 모드/해상도 컨트롤 존재 및 포커스 가능.
7. 1280×720, 1600×900, 1920×1080에서 main menu responsive layout 회귀 없음.

## Out of scope

VSync, FPS cap, 렌더 스케일, HDR, 모니터 선택, borderless 세분화, Android 설정은 이번 Decision에 포함하지 않는다.
