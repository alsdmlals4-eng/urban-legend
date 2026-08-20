# 괴이기록국 · Current Visual Work Order

> Role: `CURRENT_VISUAL_WORK_ORDER`
> Updated: `2026-08-20`
> Status: `PLAN_LOCK / VISUAL_DIRECTION_USER_APPROVED / IMPLEMENTATION_NOT_AUTHORIZED`
> Decision: `D-2026-08-20-INVESTIGATION-SCENE-KEYWORD-DEDUCTION-LIMITED-CHARACTER-EXPOSURE`
> GitHub base observed for this sync: `1e75e5dc871ce1ce4d547b0521f6e9b680c46684`

이 문서는 **현재 시각/화면 기획의 승인사항과 작업 순서**만 소유한다. 제품 코드·Scene·save·asset promotion 권한을 열지 않는다. 최신 사용자 지시가 이 문서보다 우선한다.

## 1. Current approved direction

- 메인 아트: 사용자가 선택한 **1번 소프트 애니 누아르** 방향.
- 조사: **장면 이미지 + 서술 + 2~4 선택지** 중심.
- 조사 결과: `관측 사실 / 기록 / 키워드 / 위험 사례 / 관계·태도 기억 / 비용`.
- 추리: 조사에서 얻은 키워드와 기록을 별도 **괴이 매뉴얼**에서 조합.
- 추리 화면: `출처 → 경쟁 가설 → 지지/반박/미해결 → 추리문 → Manual 슬롯`.
- 캐릭터: 일반 조사에서 큰 전신/반신 상시 노출 금지.
- 회수: 괴이/전조 중심. 캐릭터는 작은 상태 표현, 스킬 발동 때만 짧은 Cut-in.
- 픽셀/도트: 메인 캐릭터 그림체가 아니라 기록국의 보조 관측 언어로 사용.

## 2. Character exposure policy

```text
L0 일반 조사          = 환경·사건·증거 중심, 큰 캐릭터 없음
L1 짧은 지원/대사     = 이름 + 문장 또는 작은 Portrait
L2 중요 서사           = 제한적인 반신/장면 일러스트
L3 회수 스킬           = 짧은 Cut-in
L4 도감/편성/프로필    = 전신/상세 일러스트
```

목표는 캐릭터를 제거하는 것이 아니라 **캐릭터 사용 빈도를 줄이고 중요한 순간의 품질과 의미를 높이는 것**이다.

## 3. Current screen order

### A. Investigation Anchor

우선순위:
1. 사건 장소/이상 현상 이미지
2. 3~7문장 관측 서술
3. 2~4개 조사/대화/행동 선택
4. 필요 시 작은 기록/지원 표시

금지:
- 상시 대형 Manual/Hypothesis panel
- 캐릭터 2명 이상을 전면에 세워 현장을 가리는 구성
- 핵심 키워드의 확률-only 획득

### B. Deduction / Manual Anchor

- 좌측: 5개 Manual INDEX
- 중앙: 추리문/관계 슬롯
- 우측: 후보 키워드 + provenance
- 하단: 경쟁 가설/지지/반박/미해결
- 항상 `현장으로 돌아가기` 제공

### C. Recovery Anchor

우선순위:
1. 괴이/현현체
2. 다음 전조
3. 보호 대상
4. `보호 / 관찰 / 대응 / 공격 / 장비 / 봉쇄 / 후퇴`
5. 동료 지원 상태

캐릭터는 스킬 발동 시 Cut-in을 허용하되 전조를 가리면 안 된다.

## 4. Current work sequence

```text
1. GitHub + Notion 승인사항/작업순서 동기화
2. Investigation Anchor 검토
3. Deduction / Manual Anchor 검토
4. Recovery + skill Cut-in Anchor 검토
5. 공용 UI Component / pixel observation language 정리
6. 승인 이미지 layer/structure/reuse 계약
7. M04 빨간 우산에 동일 문법 적용 검증
8. Planning Closure Gap 재확인
9. 사용자 명시 '기획 완료'
10. latest GitHub main 재조회
11. 승인 Planning Canon GitHub 동기화
12. Codex/HiGodot 단일 구현 계약
13. 구현 후 자동 QA + Human QA
```

## 5. Approval boundary

### Approved now
- 조사/추리 화면 분리
- 장면형 조사 문법
- 환경·증거 우선 화면
- 캐릭터 노출 레벨 정책
- 회수 스킬 Cut-in
- 보조 pixel/dot 관측 언어

### Not approved / not run
- 실제 runtime 구현
- 제품 asset 승격
- Human QA PASS
- new-player validation
- 1280×720/1920×1080 실기기 시각 PASS
- Android
- POC_PASSED
- Production expansion

## 6. Sync rule

앞으로 시각/UX/화면 기획에서 사용자가 새 방향을 승인하면:

1. Notion의 관련 Screen/Visual/Decision 문서를 먼저 또는 같은 작업 묶음에서 갱신한다.
2. 이 파일의 `Current approved direction / Current work sequence`를 최신 상태로 유지한다.
3. 장기 정본으로 남길 결정은 별도 `docs/decisions/D-*.md`에 기록한다.
4. 구현 권한은 별도 Gate로 유지한다.
5. 진행 중인 다른 open/draft PR을 후속 수정 대상으로 삼지 않는다.
