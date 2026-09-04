# Project Core MVP Rebase Plan — 완료된 문서 재기준화 이력

> 상태: `COMPLETED_DOCUMENT_REBASE`  
> 완료일: 2026-07-23  
> 이 문서는 PR #55에서 프로젝트 코어·GDD·상태·로드맵을 재기준화한 과거 실행 이력이다.  
> **현재 구현 계획:** `docs/superpowers/plans/2026-07-23-core-mvp-001-implementation-plan.md`  
> **현재 통합 명세:** `docs/superpowers/specs/2026-07-23-project-core-integrated-spec.md`

## 완료된 범위

- 기존 비전투 정체성을 조사와 연결된 전조 기반 턴제 회수로 재기준화
- 프로젝트 코어를 `CORE_RECORDED / CORE_STRESS_TESTED`로 기록
- 현재 구현과 승인 목표를 `POC_PENDING`으로 분리
- CORE-MVP-001~004 단계와 Production gate 설정
- PR 검토·벤치마킹·적대적 검토 결과를 활성 문서에 전파
- 운영·활성 문서 계약 CI 통과

## 현재 사용 규칙

이 문서를 런타임 구현 지침으로 사용하지 않는다. CORE-MVP-001 구현은 다음 문서를 순서대로 따른다.

```text
docs/PROJECT_CORE.md
→ docs/planning/PROJECT_CORE_STRESS_TEST_AND_BENCHMARK.md
→ docs/superpowers/specs/2026-07-23-project-core-integrated-spec.md
→ docs/superpowers/plans/2026-07-23-core-mvp-001-implementation-plan.md
→ TEST_CHECKLIST.md
→ 실제 코드·데이터·테스트
```

## 보호 상태

- 구현 기준선: MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A
- 화면 버전: Ver 4.2
- 저장 Schema: `mvp-039`, `mvp-038` 이관
- CORE-MVP-001은 기존 저장·세 사건·조사/회수 장면을 직접 수정하지 않는 독립 PoC로 계획됨
- 신규 플레이어 행동 증거 전 Production gate는 `HOLD_UNTIL_PLAYER_EVIDENCE`
