    local_main_sha:
    godot_run:
```

---

## 39. 완료 판정

최상위 성공은 다음처럼 단계별 증거가 있어야 한다.

```text
BASE_CURRENT_AUTHORITY_RECOVERED
→ PROJECT_STATE_RECONCILED
→ PLANNING_COMPLETE
→ DECISIONS_SYNCED
→ IMPLEMENTATION_COMPLETE
→ TECH_EVIDENCE_RECORDED
→ UI_EVIDENCE_RECORDED_WHEN_APPLICABLE
→ HUMAN/PLAYER_EVIDENCE_RECORDED_OR_EXPLICIT_NOT_RUN
→ ADVERSARIAL_REVIEW_COMPLETE
→ EXACT_CURRENT_VALIDATION_TARGET_PASSED
→ CI_GATE_PASSED
→ MERGED_MAIN_VERIFIED
→ POST_MERGE_RECHECK_COMPLETE
→ LOCAL_SYNCED_OR_EXPLICIT_BLOCKED
→ PROJECT_PLAY_VALIDATED_OR_EXPLICIT_BLOCKED
```

`NOT_RUN`을 숨기지 않는다.

---

## 40. 실패 조건

다음 중 하나라도 있으면 완료를 선언하지 않는다.

### Base·권위

- instruction 작성 요청인데 실제 Base/프로젝트 작업까지 실행
- Base current main 재조회 없음
- recursive inventory 또는 미검증 범위 표시 없음
- Registry 없이 임의 Skill 선택
- v4.5의 snapshot을 영구 current authority로 사용
- v4.5의 Base 절차 복사본을 current Base보다 우선

### External Process

- 외부 process overlay가 project/Base canon을 덮어씀
- overlay가 안전 Gate를 약화
