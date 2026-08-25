# 괴이기록국 · Current Visual Work Order

> Role: `CURRENT_VISUAL_WORK_ORDER`
> Updated: `2026-08-25`
> Status: `PLANNING_COMPLETE / RUNTIME_IMPLEMENTED / USER_APPROVED_VISUAL_CANDIDATE / RECOVERY_WIP_REVISION_REQUIRED / PRODUCT_REFERENCE_ASSET_PENDING / HUMAN_QA_NOT_RUN`
> Art treatment: `SOFT_ANIME_NOIR_LOCKED`
> Presentation invariant: `DOSSIER_HYBRID_IS_PRESENTATION_LANGUAGE_NOT_MEDIUM`
> Decisions: `D-2026-08-20-INVESTIGATION-SCENE-KEYWORD-DEDUCTION-LIMITED-CHARACTER-EXPOSURE`, `D-2026-08-25-RECOVERY-CONTEXT-ACTION-HIERARCHY`

이 문서는 현재 시각/화면 계약을 소유한다. 공유 runtime 구현은 PR #224를 통해 main에 반영됐고, M04 Investigation Anchor 1안은 사용자 결과 승인을 받았다. Recovery의 최신 상호작용 의미는 2026-08-25 사용자 결정으로 갱신됐으며, 현재 Recovery 이미지는 수정 전 WIP reference다. 현재 mutation 경계는 **Recovery 수정 시안, product-reference asset 승격, runtime 가독성 검증, release-near polish, Human evidence**다.

## 1. Current approved direction

- 메인 아트 treatment: **소프트 애니 누아르**, `SOFT_ANIME_NOIR_LOCKED`.
- 현재 사용자 스타일 reference: 기록물형 손그림 배경/프레임 + 신비롭고 불길한 괴이 + 캐릭터는 한 단계 더 애니메풍.
- `Korean Urban Occult Dossier Hybrid` = UI·정보 위계·현장/기록 composition 언어 (`DOSSIER_HYBRID_IS_PRESENTATION_LANGUAGE_NOT_MEDIUM`).
- 조사 = 장면 이미지 + 서술 + 2~4 선택지.
- 조사 결과 = 관측 사실 / 기록 / 키워드 / 위험 사례 / 관계·태도 기억 / 비용.
- 추리 = 별도 괴이 매뉴얼에서 provenance와 후보 키워드를 읽고 **번호가 붙은 추리문 슬롯을 완성**해 Manual 규칙을 만든다.
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
- 중앙: 추리문 / 번호 슬롯
- 우측: 후보 키워드
- 하단/별도 층: 근거·출처·지지/반박/미해결 참고
- 항상 `현장으로 돌아가기`

정답 후보를 시각 위계로 미리 알려주지 않는다. 조사에서 확보한 후보 키워드로 추리문 슬롯을 채우는 것이 primary action이다.

### C. Rescue Anchor

- 규칙 요약 + 피해자 상태 동시 확인.
- 행동/역할은 현재 근거와 연결.
- 새 정답 퍼즐보다 추리에서 만든 규칙의 실제 적용.
- 실패 이유는 추론 부족과 입력/적용 오류를 분리.

### D. Recovery Anchor

Visual/interaction priority:
1. 괴이/현현체
2. 다음 전조
3. 보호 대상
4. 참조 규칙/예상 영향
5. **전조 대응 행동 — `CONTEXTUAL_TELEGRAPH_RESPONSE`**
6. 상시 기본 행동 **공격 / 보호 / 보조**
7. 동료/자원 상태

상시 1차 메뉴는 **공격 / 보호 / 보조** 세 카테고리뿐이며, 누르면 관련 세부 행동 목록이 2단 메뉴로 열린다.

괴이 전조가 발생하면 별도의 전조 대응 목록에 `위로 이동`, `좌로 이동`, `안내판 조작`, `방송 장치 조작`, `문 닫기`처럼 현재 현장에서 수행 가능한 world action을 제시한다. 올바른 전조 대응은 앞선 조사·기록·추리문·괴이 매뉴얼의 키워드/규칙을 기억하거나 재확인해 판단한다. UI는 정답을 색·확률·추천 표식으로 선공개하지 않는다.

오대응은 비용/위험과 함께 **실패 관측 기록**을 남겨 이후 판단 근거가 된다.

기존 평면 1차 메뉴 `보호 / 관찰 / 대응 / 공격 / 장비 / 봉쇄 / 후퇴`는 폐기된 predecessor다.

M01 상세 runtime predecessor는 `docs/M01_RECOVERY_SCENE_PACKET.md`에 남아 있을 수 있으므로 재개 시 이 successor decision과 reconcile한다. Cut-in은 전조·보호 대상·상황 행동을 가리지 않는다.

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

Recovery WIP는 별도다.
- state: `REFERENCE_MOCKUP / REVISION_REQUIRED / NOT_PRODUCT_ASSET`.
- SHA-256: `606cb6998d4d1d08b44f96fe508b777e631786f05fdbd9a8c0d2b307dbe0e4d2`.
- source: `1672x941`, `2399097` bytes.
- Notion Home + Visual surface native attachment/readback.
- 다음 이미지는 successor hierarchy를 반영한 Recovery 수정 전체 시안 정확히 1장이다.

## 5. Current work sequence

```text
1. 사용자 최종 기획완료 — COMPLETE
2. runtime reconciliation / COMPOSITE_RESULT / monthly_state / M01 First Session — COMPLETE_MERGED (#224)
3. main menu Ver 4.3 / M04 shared-system baseline — COMPLETE_MERGED (#224)
4. current authority + Base protected baseline reconciliation — COMPLETE (#225~#227)
5. M01 First Session Human QA packet — READY_TO_RUN / HUMAN_QA_NOT_RUN
6. M04 product-reference text Brief 승인 — COMPLETE
7. M04 Investigation Anchor 후보 1개 생성/사용자 승인/Notion upload — COMPLETE
8. CASE-01 통합 UI style reference — USER_APPROVED_STYLE_REFERENCE
9. Recovery first WIP — COMPLETE_AS_REFERENCE / REVISION_REQUIRED
10. Recovery successor command hierarchy — APPROVED; next image = 수정 전체 시안 정확히 1장
11. Recovery 승인 후 component extraction → Composite Result mockup → 공용 UI component 승인화
12. M04 product-reference promotion + layer/reuse + rights/provenance + 1280×720/1920×1080 runtime 검증
13. M04 release-near visual/audio/VFX 구현
14. M04 actual runtime/input + Human player-experience QA
```

## 6. Approval boundary

### Complete
- 조사/추리 화면 분리
- 장면형 조사 문법
- 후보 키워드 → 추리문 슬롯 primary action
- 환경·증거 우선 화면
- 캐릭터 노출 레벨
- 회수 skill Cut-in policy
- Recovery 기본 category vs contextual telegraph-response 의미 분리
- pixel/dot 보조 관측 언어
- 소프트 애니 누아르 treatment
- 최신 손그림+괴이감+애니메 캐릭터 style reference
- Dossier UI presentation language
- M01/M04 화면 책임 분리
- 공용 runtime/state/result implementation
- M04 Investigation Anchor 1안 사용자 결과 승인
- 사람용 Notion Visual/Home 이미지 upload/readback

### Pending / not run
- Recovery successor 수정 전체 시안 사용자 결과 승인
- Recovery component extraction
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
