# 철회된 감사 기록 — 고정 4턴 전조·패턴 주기

> Decision ID: `DEC-20260806-118-CANON-V2-FOUR-TURN-TELEGRAPH-PATTERN-CYCLE`
> 결론: `RETRACTED_MISINTERPRETATION / AUDIT_PREMISE_INVALID`
> 활성 권위: `NOT_ACTIVE_AUTHORITY`
> 구현: `IMPLEMENTATION_NOT_AUTHORIZED`
> 사람 검증: `HUMAN_QA_NOT_RUN`
> UI·접근성 검증: `UI_ACCESSIBILITY_NOT_RUN`
> 배치 병합: `BATCH_MERGE_NOT_STARTED`
> 병합: `MERGE_NOT_AUTHORIZED`

기존 감사는 “사용자가 고정 4턴 구조를 승인했다”는 잘못된 전제를 사용했다. 따라서 현행 `battle_scene.gd`와 단일 전조 데이터를 `LEGACY_RUNTIME_CONFLICT`로 판정한 결론도 무효다.

프로젝트를 다시 읽은 결과, 해당 실행은 사용자가 설명한 실제 구조와 정합한다.

```text
괴이가 가진 패턴 집합
→ 완성된 패턴 하나 선택
→ 단일 전조 공개
→ 가설·근거·대응
→ 즉시 정오 판정
→ 안정도 또는 피해
→ 기록
→ 다음 패턴
```

4턴은 예시일 뿐 전역 규칙이 아니다. 본 파일은 감사 실패와 교정 이력을 숨기지 않기 위해 보존하며, 실제 재감사는 다음 파일이 담당한다.

`docs/audits/2026-08-06-recovery-pattern-authority-project-wide-reaudit.md`
