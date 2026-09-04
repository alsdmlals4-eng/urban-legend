# Grill Me Batch 2 Ledger

> 상위 운영 Decision: `D-2026-08-02-GRILLME-10-MERGE-CADENCE`
> 현재 카운터: `10 / 10`
> 상태: `BATCH_COMPLETE / CONTENT_AUDIT_PASS / SEPARATE_MERGE_APPROVAL_REQUIRED`
> 갱신일: 2026-08-03
> 누적 Draft PR: `#140`
> 책임 감사: `docs/audits/2026-08-03-grillme-batch-2-premerge-audit.md`
> 구현: `NOT_AUTHORIZED`
> 사람 검증: `NOT_RUN`

Grill Me Batch 2의 새 제품 Decision 10개가 승인됐다. 새 제품 질문은 중지한다. PR #140의 내용·정본·범위 감사 보완은 완료했으며, 최종 PR HEAD 자동 검증과 사용자의 별도 병합 승인이 남아 있다.

## 운영 계약

```text
현재 정본 확인
→ 게임·현업 사례 벤치마킹
→ 적용점/비적용점 분리
→ 제작비·UX·밸런스·재플레이 비교
→ 적대적 검토
→ 선택지와 권장안
→ 사용자 승인
→ GitHub·Sheet 동일 Decision ID 동기화
```

정본 충돌 교정·오탈자·동기화·같은 질문의 후속 Spec은 새 제품 Decision으로 중복 계산하지 않는다.

## 승인 Decision 10개

### 1 / 10 — `D-2026-08-02-INVESTIGATION-CORE-TRUTH-AND-RANK-GATING`

- 필수 진실은 비판정 또는 확정 우회 경로로 획득
- 능력·태그·판정은 비용·근거·위험·구출·전투 우위를 변화
- 최고 랭크·업적에는 지정 준비 조건을 사용할 수 있음
- 일반 클리어와 캠페인 진행은 차단하지 않음

### 2 / 10 — `D-2026-08-02-INVESTIGATION-RANK-CONDITION-DISCLOSURE`

- 최고 랭크 요구 능력·태그와 수치를 출동 전 공개
- 정확한 사용 지점·정답·최적 순서는 비공개
- 첫 클리어 뒤 미달 이유와 숙련 체크리스트 공개

### 3 / 10 — `D-2026-08-03-INCIDENT-MULTIAXIS-GATED-RANKING`

- 조사 정확도·피해자 보호·현장 통제·기록 완성도 네 축
- 단순 합산이 아닌 관문형 종합 랭크
- 치명적 실패 상쇄 금지
- 사건 랭크를 연도 결산의 평균 점수로 사용하지 않음

### 4 / 10 — `D-2026-08-03-INCIDENT-RANK-STAGES-AND-LABELS`

- `C 조건부 대응 / B 적정 대응 / A 우수 대응 / S 정밀 대응`
- 축별 `미달 / 충족 / 우수 / 정밀`
- 정상 종결 실패·기관 강제 봉쇄에는 종합 랭크 없음

### 5 / 10 — `D-2026-08-03-INCIDENT-REPLAY-CANON-AND-MASTERY-RECORDS`

- 일반 재도전은 숙련 기록만 갱신
- 실제 서사 변경은 이후 진행 폐기형 캠페인 되감기만 허용
- 캠페인 정본과 숙련 기록 분리

### 6 / 10 — `D-2026-08-03-INCIDENT-CHECKPOINT-RETRY-AND-CANON-CONFIRMATION`

- 조사 소단락·구출 시작·전투 시작 체크포인트
- 선택·턴 단위 자유 되감기 미지원
- 결과 보고서에서 명시적으로 정본 확정
- 확정 전 사건당 1회 출동 재개

### 7 / 10 — `D-2026-08-03-CAMPAIGN-REWIND-UNLOCK-AND-BRANCH-SLOTS`

- 첫 1년차 완료 뒤 조건 없이 해금
- 첫 플레이 중 사용 불가
- 횟수·재화 비용 없음
- 최대 3개 캠페인 분기 슬롯
- 최초 완료 캠페인 자동 보호
- 분기별 정본 분리·숙련 기록 공유

### 8 / 10 — `D-2026-08-03-CAMPAIGN-REWIND-CANON-ANCHOR-SCOPE`

- 지속 결과 사건마다 출동 준비 확정 직전 `정본 앵커` 지정
- 당시 보유 범위에서 출동 준비 재구성
- 이후 성장·장비·관계의 과거 소급 반입 금지
- 조사·구출·회수 전투 중간 지점으로 직접 이동 금지
- 캠페인 정본 변경 시 사건 전체 재진행
- 읽은 텍스트와 비상호작용 연출 빠른 넘김 지원

### 9 / 10 — `D-2026-08-03-ACCESSIBILITY-EQUIVALENCE-AND-MASTERY-GATES`

- 화면·음향·입력·시간 관련 접근성 등가 기능은 모든 랭크와 업적에 중립
- 판단을 보존하면 입력 방식과 관계없이 S 랭크 가능
- 판단 자동 해결도 일반 클리어와 핵심 서사를 차단하지 않음
- 자동 해결이 대신한 숙련 관문만 직접 충족으로 처리하지 않음
- 가능한 경우 같은 판단을 검증하는 접근성 등가 과제로 대체
- 대체 불가 운동·감각 과제는 S 필수 조건에서 제외

### 10 / 10 — `D-2026-08-03-MASTERY-REWARD-SCOPE-AND-CAMPAIGN-NEUTRALITY`

- S 랭크·업적 보상은 캠페인 필수 전력·필수 서사와 분리
- 일반 플레이만으로 핵심 사건·필수 동료·핵심 엔딩·메인 진실 접근 보장
- 사건 인장·칭호·비전투 코스메틱·전시품·문서 테마·비필수 부록 중심
- 게임플레이 보상은 캠페인에 반입할 수 없는 기록 재현 전용 변칙·도전 프리셋으로 제한
- 캠페인 종속 후일담은 활성 캠페인 정본만 참조
- 기록 재현의 대안 결과는 비정본 자료로 표시
- 특수 업적은 S 랭크 관문과 분리
- 영구 능력치·필수 스킬·최고 장비·진엔딩·접근성·저장·기본 편의 기능을 숙련 보상으로 독점하지 않음

## 적대적 감사 결과

발견·보완:

1. `PROJECT_CORE.md`의 구형 `이중 코어 / 조작형 위험 검증 / 공격 누락` 표현을 최신 `조사 → 피해자 구출 → 회수 전투` 권위로 교정했다.
2. 숙련 부록이 기록 재현 S 결과로 캠페인 피해자·관계·기관 후일담을 덮어쓰지 못하도록 정본 참조 규칙을 추가했다.
3. PROJECT_CORE 문서 계약의 고정 상태 문자열과 CORE-MVP-001 설계·구현계획 참조를 보존했다.
4. Markdown 후행 공백을 제거해 `git diff --check` 실패를 교정했다.
5. main 현재 권위 문서의 Batch 2 `0/10` 표기는 병합 전 상태로 정확하므로 선반영하지 않았다. 병합 뒤 실제 merge SHA로 post-merge authority sync가 필요하다.

내용 판정: `PASS_AFTER_CORRECTIONS`

## 자동 검증 정책

PR 변경 경로가 자동 실행하는 필수 검증:

- Validate documentation contracts
- Validate Urban Legend BCA Adoption

CORE-MVP-001·ANNUAL-MVP-001 워크플로는 코드·테스트·현재 권위 문서 등 각 workflow의 `paths` 대상이 바뀔 때만 실행된다. 이번 신규 Decision·Design·감사 문서 범위에서는 `NOT_TRIGGERED_BY_PATH_FILTER`이며 성공으로 가장하지 않는다.

최종 exact-head run ID와 결론은 PR #140 설명과 Google Sheet 감사 행에 기록한다. 문서 자체에 exact head를 적은 뒤 다시 커밋하는 자기참조를 피한다.

## 책임 원본

- 각 `docs/decisions/` Decision 파일
- `docs/planning/2026-08-02-investigation-system-design.md`
- `docs/PROJECT_CORE.md`
- `docs/audits/2026-08-03-grillme-batch-2-premerge-audit.md`
- Google Sheet 동일 Decision ID

## 남은 Gate

```text
최종 HEAD 확정
→ path-triggered exact-head CI 성공
→ main 대비 behind 0·14 docs-only 재확인
→ 리뷰·댓글 차단 0 재확인
→ Draft 해제
→ 사용자 별도 병합 승인
→ 병합
→ 실제 merge SHA 기반 post-merge authority sync
```

감사 통과와 Draft 해제는 병합 승인이 아니다. 사용자의 명시적인 `병합 승인` 전에는 PR #140을 병합하지 않는다.
