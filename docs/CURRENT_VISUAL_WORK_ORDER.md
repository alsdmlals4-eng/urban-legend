# 괴이기록국 · Current Visual Work Order

> Role: `CURRENT_VISUAL_WORK_ORDER`
> Updated: `2026-08-24`
> Status: `PLANNING_COMPLETE / RUNTIME_IMPLEMENTED / USER_APPROVED_VISUAL_CANDIDATE / PRODUCT_REFERENCE_ASSET_PENDING / HUMAN_QA_NOT_RUN`
> Art treatment: `SOFT_ANIME_NOIR_LOCKED`
> Presentation invariant: `DOSSIER_HYBRID_IS_PRESENTATION_LANGUAGE_NOT_MEDIUM`
> Decision: `D-2026-08-20-INVESTIGATION-SCENE-KEYWORD-DEDUCTION-LIMITED-CHARACTER-EXPOSURE`

이 문서는 현재 시각/화면 계약을 소유한다. 공유 runtime 구현은 PR #224를 통해 main에 반영됐고, M04 Investigation Anchor 1안은 사용자 결과 승인을 받았다. 현재 mutation 경계는 **product-reference asset 승격, runtime 가독성 검증, release-near polish, Human evidence**다.

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

현재 M04 Investigation Anchor 1안은 `USER_APPROVED_VISUAL_CANDIDATE`다.

- receipt owner: `docs/visual/M04_PRODUCT_REFERENCE_APPROVAL_BRIEF.md`.
- candidate SHA-256: `4c67a65c9f7469bf39c231c81710fd71f0796501d13231c8fd7020bdad20462f`.
- source size: `1672x941`, `2291020` bytes.
- 사람용 Notion `04 · Visual · UX · Assets`에 native attachment로 업로드/readback 완료.
- 이 승인은 시각 후보 승인이지 `PRODUCT_REFERENCE_ASSET_APPROVED`가 아니다.
- 실제 product-reference 승격 전 layer/reuse, rights/provenance, 1280×720/1920×1080 runtime readability, runtime consumption을 검증한다.
- Human QA와 product-reference asset Gate는 서로 독립이다.

## 5. Current work sequence

```text
1. 사용자 최종 기획완료 — COMPLETE
2. runtime reconciliation / COMPOSITE_RESULT / monthly_state / M01 First Session — COMPLETE_MERGED (#224)
3. main menu Ver 4.3 / M04 shared-system baseline — COMPLETE_MERGED (#224)
4. current authority + Base protected baseline reconciliation — COMPLETE (#225~#227)
5. M01 First Session Human QA packet — READY_TO_RUN / HUMAN_QA_NOT_RUN
6. M04 product-reference text Brief 승인 — COMPLETE
7. M04 Investigation Anchor 후보 정확히 1개 생성 — COMPLETE
8. 사용자 결과 승인 + Notion upload/readback — COMPLETE
9. product-reference promotion 검토 + layer/reuse + rights/provenance + 1280×720/1920×1080 runtime 검증 — NEXT
10. M04 release-near visual/audio/VFX 구현
11. M04 actual runtime/input + Human player-experience QA
```

## 6. Approval boundary

### Complete
- 조사/추리 화면 분리
- 장면형 조사 문법
- 환경·증거 우선 화면
- 캐릭터 노출 레벨
- 회수 skill Cut-in
- pixel/dot 보조 관측 언어
- 소프트 애니 누아르 treatment
- Dossier UI presentation language
- M01/M04 화면 책임 분리
- 공용 runtime/state/result implementation
- M04 shared-system validation baseline
- M04 Investigation Anchor 1안 사용자 결과 승인
- M04 사람용 Notion Visual surface 업로드/readback

### Pending / not run
- M01 actual Human QA / new-player validation
- M04 product-reference asset 승격
- layer/reuse production source 검증
- rights/provenance promotion 검토
- 1280×720/1920×1080 최종 runtime 시각 PASS
- M04 release-near visual/audio/VFX Human QA
- Android
- POC_PASSED
- Production expansion

자동 검증 성공이나 사용자 시각 후보 승인은 Human/runtime/product-asset PASS를 의미하지 않는다.

## 7. Sync rule

향후 시각/UX 의미 변경은 Notion과 Repository를 같은 작업 범위에서 갱신하고 readback한다. 구현·asset·Human evidence Gate는 서로 분리한다. 진행 중 unrelated PR은 read-only로 유지한다.
