실행하지 않은 branch cleanup을 완료라고 보고하지 않는다.

---

## 34. 로컬 전달

사용자 로컬 정상 경로:

```text
GitHub Desktop
→ Fetch origin
→ Pull origin
→ local main SHA 확인
→ Godot
→ Run Project
```

dirty/diverged 상태에서 force/reset으로 덮지 않는다.

---

## 35. Godot Project Play 완료 Gate

개별 Scene 실행만으로 완료하지 않는다.

필수:

```text
application/run/main_scene
→ startup
→ 대표 문제
→ 대표 행동
→ 첫 선택
→ 첫 결과
→ 성공/실패
→ 복귀 또는 다음 흐름
```

가능하면 Windows·Android 각 delivery profile에서 확인한다.

### 35.1 완성형 Vertical Slice 기준 — v4.4 보호 계약

Vertical Slice가 완료되려면 최소 다음이 실제로 연결되어야 한다.

```yaml
vertical_slice_complete:
  representative_problem:
  representative_player_action:
  meaningful_choice:
  system_response:
  first_result:
  success_failure_or_resolution:
  feedback_and_reward:
  return_or_next_flow:
  save_or_state_continuity_when_applicable:
  windows_run:
  android_run_or_explicit_not_run:
  tech_evidence:
  ui_evidence:
  human_usability_evidence:
  player_experience_evidence:
```

