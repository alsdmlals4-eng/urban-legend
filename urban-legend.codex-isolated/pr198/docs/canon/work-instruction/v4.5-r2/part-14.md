tracked Scene/Resource가 local-only 후보에 영구 의존하지 않는다.

### Local Godot Reference

```text
REFERENCE_ONLY
```

참고 자료의 발견은 active adoption이 아니다.

검증:

- upstream
- version/commit
- license
- Godot compatibility
- 실제 소비 경로
- 제거/rollback

### Shared Audio Vault

원본 Vault는 읽기 전용 source library로 취급한다.

```text
shared vault
→ rights/hash review
→ approved copy
→ project res://
→ import/loop/volume validation
```

production runtime에서 외부 절대 경로를 참조하지 않는다.

---

## 19. UI 컴포넌트 Gate

UI 변경은 최소 다음을 정의한다.

```yaml
component:
  purpose:
  states:
    - default
    - hover_or_focus
    - pressed
    - disabled
    - loading_when_applicable
    - error_when_applicable
  input:
    keyboard_mouse:
    gamepad:
    touch:
    android_back:
  focus_behavior:
  accessibility:
  responsive_behavior:
  motion:
  audio_haptic_feedback:
```

체크:

- 정보 우선순위
- 다음 행동 발견 가능성
- 입력 장벽
- 해상도/비율
- 한글/CJK
- reduced motion
- 오류/빈 상태/복구
- focus
- touch target

---

## 20. HiGodot·GUT·Hera 책임 분리

이 섹션은 v4.4의 프로젝트 고유 채택 정책을 보존한다.
실제 프로젝트 adoption record가 다르면 프로젝트 정본이 우선한다.

### HiGodot

```text
SOLO PERSISTENT GODOT AUTHORING AUTHORITY
```

채택된 경우 persistent Godot 변경:

- Scene
- Node
- Script
- Resource
- Theme
- Animation
- Signal
- Project settings
- Input Map
- Autoload

를 다른 도구가 우회 저작하지 않는다.

### GUT

Godot 4.7.x에서 formal adoption이 있을 때:

```text
GUT 9.7.1 / godot_4_7
→ deterministic GDScript test authority
```

GUT은 production authoring 권위가 아니다.

### Hera

```text
LIVE_QA_AND_OBSERVABILITY_ONLY
```

- persistent source mutation 금지
- acceptance 후 tracked source delta = NONE
- exact CLI/addon pair 검증
- localhost transport 정책 확인

---

## 21. Godot 버전·실행

버전을 추측하지 않는다.

확인:

```text
project.godot
Godot binary
CI
export presets
project docs
plugin compatibility
```

v4.5 작성 시 외부 기준:

```yaml
godot:
  target_family_from_project_contract: 4.7.x
  observed_stable_reference: 4.7.1-stable
  observed_release_date: 2026-07-14
  current_4_8_archive_state_when_v4_5_written: dev
```

