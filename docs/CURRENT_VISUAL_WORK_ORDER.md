# 괴이기록국 · Current Visual Work Order

> Role: `CURRENT_VISUAL_WORK_ORDER`
> Updated: `2026-08-22`
> Status: `PLANNING_COMPLETE / PRODUCT_REFERENCE_ASSET_PENDING / IMPLEMENTATION_NOT_AUTHORIZED`
> Art treatment: `SOFT_ANIME_NOIR_LOCKED`
> Presentation invariant: `DOSSIER_HYBRID_IS_PRESENTATION_LANGUAGE_NOT_MEDIUM`
> Decision: `D-2026-08-20-INVESTIGATION-SCENE-KEYWORD-DEDUCTION-LIMITED-CHARACTER-EXPOSURE`

이 문서는 현재 시각/화면 계약을 소유한다. 최종 기획은 완료됐지만 제품 코드·Scene·save·asset promotion 권한은 별도다.

## 1. Current approved direction

- 메인 아트 treatment: **소프트 애니 누아르**, `SOFT_ANIME_NOIR_LOCKED`.
- `Korean Urban Occult Dossier Hybrid` = UI·정보 위계·현장/기록 composition 언어 (`DOSSIER_HYBRID_IS_PRESENTATION_LANGUAGE_NOT_MEDIUM`).
- 조사 = 장면 이미지 + 서술 + 2~4 선택지.
- 조사 결과 = 관측 사실 / 기록 / 키워드 / 위험 사례 / 관계·태도 기억 / 비용.
- 추리 = 별도 괴이 매뉴얼에서 출처 → 경쟁 가설 → 지지/반박/미해결 → 추리문 → Manual 슬롯.
- 일반 조사에서 큰 캐릭터 전신/반신 상시 노출 금지.
- 회수 = 괴이/전조 중심, 캐릭터는 작은 상태 표현 + 의미 있는 스킬 순간 Cut-in.
- 픽셀/도트 = CCTV·센서·로그·지도·괴이 간섭의 보조 관측 언어.

## 2. Character exposure policy

```text
L0 일반 조사          = 환경·사건·증거 중심, 큰 캐릭터 없음
L1 짧은 지원/대사     = 이름 + 문장 또는 작은 Portrait
L2 중요 서사           = 제한적인 반신/장면 일러스트
L3 회수 스킬           = 짧은 Cut-in
L4 도감/편성/프로필    = 전신/상세 일러스트
```

캐릭터 사용 빈도를 줄여 중요한 순간의 품질·보상감을 높인다.

## 3. Current screen order

### A. Investigation Anchor

1. 사건 장소/이상 현상 이미지
2. 3~7문장 관측 서술
3. 2~4개 조사/대화/행동 선택
4. 필요 시 작은 기록/지원 표시

금지: 상시 대형 Manual/Hypothesis panel, 캐릭터가 현장을 가리는 구성, 핵심 키워드의 probability-only 획득.

### B. Deduction / Manual Anchor

- 좌측: Manual INDEX / 관측 provenance
- 중앙: 경쟁 가설·추론문
- 우측: Manual 의미 슬롯 / 후보 키워드
- 하단/별도 층: 지지/반박/미해결
- 항상 `현장으로 돌아가기`

정답 후보를 시각 위계로 미리 알려주지 않는다.

### C. Rescue Anchor

- 규칙 요약 + 피해자 상태 동시 확인.
- 행동/역할은 현재 근거와 연결.
- 새 정답 퍼즐보다 추리에서 만든 규칙의 실제 적용.
- 실패 이유는 추론 부족과 입력/적용 오류를 분리.

### D. Recovery Anchor

1. 괴이/현현체
2. 다음 전조
3. 보호 대상
4. 참조 규칙/예상 영향
5. 보호 / 관찰 / 대응 / 공격 / 장비 / 봉쇄 / 후퇴
6. 동료 지원 상태

M01 상세는 `docs/M01_RECOVERY_SCENE_PACKET.md`를 따른다. Cut-in은 전조·보호 대상·봉쇄 조건을 가리지 않는다.

### E. Composite Result

단일 S/A/B 하나로 압축하지 않는다.
- 피해자 상태
- 확인 규칙/증거
- 위험 사례/보호 책임
- 안정화/잔향
- 미해결 질문
- 후속 관계·연구·정보 공유

## 4. Product-reference asset boundary

`PRODUCT_REFERENCE_ASSET_PENDING`:
- screen grammar와 visual treatment는 최종 기획에 포함되어 `COMPLETE`.
- concrete M01/M04 이미지·레이어·rights/provenance·최종 해상도 가독성 reference는 아직 승인하지 않았다.
- product-reference 승격은 runtime/Human QA와 별도 Gate다.

## 5. Current work sequence

```text
1. 사용자 최종 '기획완료' — COMPLETE
2. fresh-main Reality Gate — HANDOFF_READY_WITH_KNOWN_REALIGNMENT
3. current implementation design/plan readback
4. runtime implementation 명시 실행 권한
5. COMPOSITE_RESULT semantic realignment + monthly_state + M01 First Session
6. #181 기존 plan으로 main menu / Ver 4.3
7. M04 shared-system/baseline 준비
8. concrete image 후보 생성/선정 시 product-reference asset approval
9. M04 release-near visual/audio/VFX 구현
10. 자동/runtime QA + Human QA
```

## 6. Approval boundary

### Planning COMPLETE
- 조사/추리 화면 분리
- 장면형 조사 문법
- 환경·증거 우선 화면
- 캐릭터 노출 레벨
- 회수 skill Cut-in
- pixel/dot 보조 관측 언어
- 소프트 애니 누아르 treatment
- Dossier UI presentation language
- M01/M04 화면 책임 분리

### Pending / not run
- product-reference image/asset 승격
- runtime implementation 실행
- Human QA / new-player validation
- 1280×720/1920×1080 최종 product-reference 시각 PASS
- Android
- POC_PASSED
- Production expansion

## 7. Sync rule

향후 시각/UX 의미 변경은 Notion과 Repository를 같은 작업 범위에서 갱신하고 readback한다. 구현·asset·Human evidence Gate는 서로 분리한다. 진행 중 unrelated PR은 read-only로 유지한다.
