# 괴이기록국 · Current Visual Work Order

> Role: `CURRENT_VISUAL_WORK_ORDER`
> Updated: `2026-08-21`
> Status: `PLAN_LOCK / VISUAL_PLANNING_CLOSURE_READY / PRODUCT_REFERENCE_ASSET_PENDING / IMPLEMENTATION_NOT_AUTHORIZED`
> Art treatment: `SOFT_ANIME_NOIR_LOCKED`
> Presentation invariant: `DOSSIER_HYBRID_IS_PRESENTATION_LANGUAGE_NOT_MEDIUM`
> Decision: `D-2026-08-20-INVESTIGATION-SCENE-KEYWORD-DEDUCTION-LIMITED-CHARACTER-EXPOSURE`

이 문서는 **현재 시각/화면 기획의 승인사항과 작업 순서**만 소유한다. 제품 코드·Scene·save·asset promotion 권한을 열지 않는다. 최신 사용자 지시가 이 문서보다 우선한다.

## 1. Current approved direction

- 메인 아트 treatment: 사용자가 선택한 **1번 소프트 애니 누아르**, `SOFT_ANIME_NOIR_LOCKED`.
- `Korean Urban Occult Dossier Hybrid`는 UI·정보 위계·현장/기록 composition 언어이며 메인 아트 매체를 다시 여는 경쟁안이 아니다 (`DOSSIER_HYBRID_IS_PRESENTATION_LANGUAGE_NOT_MEDIUM`).
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

- 좌측: Manual INDEX / 관측 사실 provenance
- 중앙: 경쟁 가설·추론문
- 우측: Manual 의미 슬롯 / 후보 키워드
- 하단 또는 별도 층: 지지/반박/미해결
- 항상 `현장으로 돌아가기` 제공

정답 후보를 색·위치·크기로 미리 강조하지 않는다.

### C. Rescue Anchor

- 규칙 요약과 피해자 상태를 동시에 확인한다.
- 행동/역할은 반드시 현재 근거와 연결된다.
- 새 정답 퍼즐을 추가하기보다 추리에서 만든 규칙을 조작으로 적용한다.
- 구출 실패 이유는 추론 부족과 입력/적용 오류를 구분한다.

### D. Recovery Anchor

우선순위:
1. 괴이/현현체
2. 다음 전조
3. 보호 대상
4. 참조 규칙/예상 영향
5. `보호 / 관찰 / 대응 / 공격 / 장비 / 봉쇄 / 후퇴`
6. 동료 지원 상태

캐릭터는 스킬 발동 시 Cut-in을 허용하되 전조를 가리면 안 된다. M01 세 패턴 상세는 `docs/M01_RECOVERY_SCENE_PACKET.md`를 따른다.

### E. Composite Result

단일 S/A/B 결과 하나로 사건을 압축하지 않는다.
- 피해자 상태
- 확인 규칙
- 위험 사례
- 안정화/잔향
- 미해결 질문
- 후속 관계·연구·정보 공유

## 4. Product-reference asset boundary

`PRODUCT_REFERENCE_ASSET_PENDING`:
- 화면 구조·정보 위계·아트 treatment는 기획 closure ready다.
- 아직 선택/생성/검수되지 않은 M01/M04 이미지를 product reference로 승인하지 않는다.
- 구체 이미지 후보가 생긴 뒤 P0 Investigation/Deduction/Recovery 승인 조건, 해상도 가독성, layer/reuse, rights/provenance를 검증한다.
- asset 승인과 runtime/Human QA는 별도 Gate다.

## 5. Current work sequence

```text
1. Visual/UI planning closure GitHub + Notion 동기화
2. M01 Investigation/Deduction/Rescue/Recovery end-to-end readback
3. M04 Schedule/Investigation/Manual/Rescue/Recovery/Result acceptance readback
4. 공용 UI Component / pixel observation language 정합성 확인
5. 사용자 최종 '기획 완료' 선언
6. latest GitHub main 재조회 + Reality Gate
7. ID/save migration matrix + 구현 보호 계약
8. Codex/HiGodot 단일 구현 계약
9. 구체 이미지 후보가 존재할 때 product-reference asset approval
10. 구현 후 자동 QA + Human QA
```

## 6. Approval boundary

### Planning approved / closure ready
- 조사/추리 화면 분리
- 장면형 조사 문법
- 환경·증거 우선 화면
- 캐릭터 노출 레벨 정책
- 회수 스킬 Cut-in
- 보조 pixel/dot 관측 언어
- 소프트 애니 누아르 treatment
- 사건 파일/Dossier UI presentation language
- M01/M04 화면 책임 분리

### Pending / not run
- 최종 사용자 `기획 완료` 선언
- 실제 product-reference 이미지/asset 승격
- 실제 runtime 구현
- Human QA PASS
- new-player validation
- 1280×720/1920×1080 실기기 시각 PASS
- Android
- POC_PASSED
- Production expansion

## 7. Sync rule

앞으로 시각/UX/화면 기획에서 사용자가 새 방향을 승인하면:

1. Notion의 관련 Screen/Visual/Decision 문서를 먼저 또는 같은 작업 묶음에서 갱신한다.
2. 이 파일의 `Current approved direction / Current work sequence`를 최신 상태로 유지한다.
3. 장기 정본으로 남길 결정은 별도 `docs/decisions/D-*.md` 또는 current closure contract에 기록한다.
4. 구현 권한은 별도 Gate로 유지한다.
5. 진행 중인 다른 open/draft PR을 후속 수정 대상으로 삼지 않는다.
