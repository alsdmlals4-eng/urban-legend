# D-2026-08-01-LEGACY-PR-DISPOSITION — 구형 PR 보존·종료 정책

> 상태: `APPROVED_OPERATIONAL_DECISION`
> 승인일: 2026-08-01
> 사용자 승인: “권장안대로 진행”
> 추적: Issue #121 / Draft PR #122
> 제품 구현 권한: `NONE`

## 1. 결정

오래된 브랜치를 현재 main에 그대로 병합하지 않는다.

```text
PR #120
= Draft 유지 / HOLD

PR #54
= 유효 요소 기록 후 종료

PR #26
= 유효 요소 기록 후 종료
```

## 2. PR #120 — Base v9.3·Vertical Slice v9 이관

상태:

- Draft 유지
- 실행·병합·Codex Goal 사용 금지
- PR #122의 기획 최종 승인과 Canon Migration 완료 전 `HOLD`

이유:

- Base 이관 자체는 필요할 수 있으나 현재 제품 권위·SCREEN/SIT·저장·테스트 계약이 아직 최종 확정되지 않았다.
- PR #120의 Codex Goal을 먼저 실행하면 구형 제품 계약을 새 Base 구조에 고정할 위험이 있다.

재개 조건:

1. Validation 기획 최종 승인
2. Canon Migration Bundle 완료
3. SCREEN-01~07 / SIT-001~008 승인
4. 저장·테스트 마이그레이션 계획 승인
5. PR #122와 변경 파일·병합 순서 재검토

## 3. PR #54 — 프로젝트 Skill 라우팅 계약 강화

### 보존할 요소

- 사건 작성 로컬 Skill의 `author / revise / fairness-review` mode
- Base 지원 Skill과 프로젝트 분야 인수인계의 개념적 분리
- 라우팅 예시 중복과 no-match 회귀 검증 필요성

### 현재 상태 판정

- 로컬 사건 작성 Skill mode는 후속 main Registry에 이미 존재한다.
- Base pin·Registry·생성 운영 뷰는 PR #54 이후 여러 차례 변경됐다.
- 오디오→UX 라우팅의 남은 문제는 PR #54를 그대로 병합하지 않고 Base v9.3 이관 시 현재 Schema로 재검토해야 한다.

### 처리

- `SUPERSEDED_BY_LATER_BASE_SYNC / PARTIAL_CONCEPT_PRESERVED`
- 병합하지 않고 종료한다.
- 필요한 라우팅 개선은 PR #120 재개 시 새 main 기준으로 재작성한다.

## 4. PR #26 — Agentic GitHub Workflow 템플릿

### 보존할 요소

- Planning Task와 Codex Goal을 분리하는 원칙
- 목표 플레이어 경험·범위·제외 범위·검증 증거를 Issue/PR에 기록하는 방식
- 구현 전 실제 파일 확인과 작업 후 남은 위험 보고
- 리뷰 Artifact와 Walkthrough 개념

### 그대로 병합하지 않는 이유

- 오래된 main과 문서 경로를 기준으로 한다.
- 모바일 UI, Serena, HTML 대시보드 등 현재 프로젝트 기본 전제와 맞지 않는 항목이 포함된다.
- 현행 Benchmark-first, Canon/Sheet Sync, 적대적 검토, 사용자 최종 승인 Gate가 반영되지 않았다.
- 현재는 Codex Goal을 기획 최종 승인 뒤 마지막 단계로 제한한다.

### 처리

- `CONCEPT_PRESERVED / TEMPLATE_STALE`
- 병합하지 않고 종료한다.
- 향후 Issue/PR 템플릿을 개정할 때 현행 운영 계약으로 새로 작성한다.

## 5. 병합·보존 원칙

- 구형 PR을 닫아도 GitHub 기록과 diff는 보존한다.
- 유효 개념은 이 결정 문서와 Canon Migration Bundle에서 추적한다.
- 오래된 브랜치의 코드를 cherry-pick하지 않는다.
- 필요한 변경은 최신 main과 최신 Base pin에서 새 작업으로 작성한다.
- 종료된 PR을 구현 증거나 현재 승인 상태로 인용하지 않는다.

## 6. 다음 Gate

```text
PR #120 HOLD 주석
→ PR #54·#26 종료 주석
→ Canon Migration Bundle에 추적 연결
→ 기획 최종 승인 뒤 PR #120 재평가
```
