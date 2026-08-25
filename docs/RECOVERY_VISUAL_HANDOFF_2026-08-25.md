# 괴이기록국 · Recovery / Visual Cold-Start Handoff · 2026-08-25

> 목적: 새 채팅이 과거 대화 기억 없이도 현재 품질·승인 경계·다음 작업을 복구한다.
> Authority baseline when this handoff branch opened: project `main` `2101ffcdd8fcaeb8b726fa4b86120cc82df948cc`.
> Current handoff PR: `#232`.
> Human evidence: `HUMAN_QA_NOT_RUN`.
> Product reference: `PRODUCT_REFERENCE_ASSET_PENDING`.

## 1. 새 채팅 첫 read order

1. Base 현재 `main`과 `START_HERE.md`/현재 project-work reuse contract를 fresh-read한다.
2. Project 기본 브랜치·현재 `main`·열린 PR을 fresh-read한다.
3. Notion `괴이기록국 · Home` → `04 · Visual · UX · Assets` → Work Control 순으로 읽는다.
4. Google Sheet `00_프로젝트_허브`를 fresh-read하되 migration-only 자료로 취급하고 GitHub/Notion과 충돌하면 보고한다.
5. 이 문서와 `D-2026-08-25-RECOVERY-CONTEXT-ACTION-HIERARCHY`를 읽는다.
6. 과거 전용/폐쇄 Godot executable이나 프로젝트별 격리 포트는 재사용하지 않는다. 재개 시 당시 공용 고정 Godot/포트 정본을 fresh-read한다.

## 2. 현재 제품/시각 방향

핵심 게임 경험:

```text
조사에서 기록·증거·인터뷰 확보
→ 후보 키워드 확보
→ 괴이 매뉴얼의 번호가 붙은 추리문 슬롯 완성
→ 피해자 구출에 규칙 적용
→ Recovery에서 전조를 읽고 같은 규칙을 구체 행동으로 실행
→ Composite Result / 기록 축적
```

시각 정본:
- 배경/프레임: 기록물형 손그림.
- 괴이: 신비롭고 불길한 오컬트 현현.
- 캐릭터: 배경보다 한 단계 더 애니메풍. 일반 조사/회수에서는 작은 Portrait 중심, 큰 그림은 중요 장면/Cut-in에 제한.
- `SOFT_ANIME_NOIR_LOCKED`와 Dossier Hybrid 정보 위계를 유지한다.

## 3. Notion에 이미 있는 핵심 이미지

Home과 `04 · Visual · UX · Assets`에서 다음을 실제 이미지 블록으로 확인한다.

- M04 `비 오는 골목의 빨간 우산` Investigation Anchor: `USER_APPROVED_VISUAL_CANDIDATE / PRODUCT_REFERENCE_ASSET_PENDING`.
- 사용자 제공 추리문·괴이 매뉴얼 reference mockup.
- 사용자 제공 기록 Archive·지도 reference mockup.
- 사용자 제공 메인 메뉴·관제실 reference mockup.
- 사용자 제공 피해자 구출·노선 조작 reference mockup.
- 최신 통합 UI 스타일 reference: 손그림/괴이감 유지 + 캐릭터 애니메풍 강화. `USER_APPROVED_STYLE_REFERENCE / REFERENCE_MOCKUP / NOT_PRODUCT_ASSET`.
- Recovery WIP image: `REFERENCE_MOCKUP / REVISION_REQUIRED / NOT_PRODUCT_ASSET`.

Recovery WIP receipt:
- SHA-256 `606cb6998d4d1d08b44f96fe508b777e631786f05fdbd9a8c0d2b307dbe0e4d2`
- `1672x941`
- `2399097` bytes

## 4. Recovery 최신 승인 결정

상시 기본 행동은 **공격 / 보호 / 보조** 3개다. 각 카테고리를 누르면 관련 세부 목록이 2단 메뉴로 열린다.

괴이의 전조가 발생하면 기본 행동과 별개로 `CONTEXTUAL_TELEGRAPH_RESPONSE` 목록을 표시한다. 예: `위로 이동`, `좌로 이동`, `안내판 조작`, `방송 장치 조작`, `문 닫기`.

파훼의 핵심은 새로운 전투 정답을 푸는 것이 아니라, 앞선 **조사·기록·추리문·괴이 매뉴얼**의 키워드/규칙을 기억하거나 재확인해 올바른 현장 행동으로 바꾸는 것이다.

- 정답을 색·확률·추천·강제 동료 대사로 표시하지 않는다.
- 오대응은 비용/위험뿐 아니라 **실패 관측 기록**을 남긴다.
- 기존 `보호 / 관찰 / 대응 / 공격 / 장비 / 봉쇄 / 후퇴` 평면 7-command UI는 successor가 아니다.

## 5. 다음 이미지 작업

**다음 이미지 1순위:** Recovery 최신 결정에 맞춘 CASE-01 저승역 수정 전체 시안을 **정확히 1장** 만든다.

승인 뒤 순서:
1. Recovery Telegraph Badge.
2. Recovery Context Action List.
3. 공격/보호/보조 Category Bar.
4. Composite Result 전체 시안.
5. 추리/구출/Archive/메뉴 공용 UI 구성요소 분해.
6. 캐릭터 Portrait/L2/L3 Cut-in 규격화.
7. M04 red umbrella layer/reuse 분해.
8. 공용 UI Component 8종 승인화.
9. 1280×720 / 1920×1080 실제 runtime readability + rights/provenance + runtime consumption 검증.

새 이미지 생성은 사용자의 이미지 생성 승인 절차를 따른다. 전체 시안 승인 전 개별 구성요소를 final asset으로 자동 승격하지 않는다.

## 6. GitHub 미완료/병렬 상태

- PR #231 `docs: align front doors with merged runtime canon`은 이 작업과 무관한 기존 draft다. **read-only**로 둔다.
- PR #230 `feat: resume CASE-01 inference-sentence runtime`은 closed/unmerged이며 branch `gpt/case01-deduction-sentence-runtime-20260824`, head `2674ae0db39ef1ca40ebe42daf95f56b76afe57e`를 보존한다. 자동 재오픈/merge하지 않는다.
- #230 재개 시 Base current protected-change/reuse-first 계약을 먼저 fresh-read한다.
- 이번 #232는 문서/계약/handoff만 담당하고 runtime code나 Scene을 구현했다고 주장하지 않는다.

## 7. Evidence ceiling

- `HUMAN_QA_NOT_RUN` 유지.
- M04 `PRODUCT_REFERENCE_ASSET_PENDING` 유지.
- Recovery WIP는 수정 필요 reference일 뿐 product asset이 아니다.
- 자동 CI가 GREEN이어도 visual/runtime/Human PASS가 아니다.
- M01 Human QA packet은 준비되어 있으나 실제 사람 세션 증거는 아직 없다.

## 8. Google Sheet conflict

2026-08-25 fresh-read 기준 Google Sheet `00_프로젝트_허브`는 여전히 2026-08-11 / project main `cba130ee...` / PR #189·#186·#183 / Base `315c66ee...` 계열을 가리킨다.

현재 GitHub/Notion authority와 충돌한다. Sheet는 migration-only이므로 수정하지 말고 충돌을 보고한다.

## 9. 재개 품질 체크

새 작업자는 구현 전에 다음 질문에 답할 수 있어야 한다.
- 추리 Phase의 핵심 행동은 무엇인가? → 후보 키워드로 추리문 슬롯을 채운다.
- Recovery의 기본 행동은? → 공격 / 보호 / 보조.
- 괴이 파훼 행동은 어디서 오는가? → 전조에 따라 제시되는 구체적인 world action이고, 과거 조사/추리 지식으로 정답을 판단한다.
- 최신 Recovery 이미지는 final인가? → 아니다. `REFERENCE_MOCKUP / REVISION_REQUIRED / NOT_PRODUCT_ASSET`.
- 실제 Human QA는 끝났는가? → `HUMAN_QA_NOT_RUN`.
- 다음 생성 이미지는? → Recovery 수정 전체 시안 정확히 1장.

이 답을 설명할 수 없으면 구현보다 authority recovery를 먼저 한다.
