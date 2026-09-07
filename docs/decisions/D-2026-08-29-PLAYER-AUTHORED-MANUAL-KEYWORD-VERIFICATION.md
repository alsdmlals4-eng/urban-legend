# D-2026-08-29-PLAYER-AUTHORED-MANUAL-KEYWORD-VERIFICATION

> 상태: `USER_APPROVED / CURRENT_PLANNING_CANON / IMPLEMENTATION_CONTRACT_PENDING / NOT_IMPLEMENTED`
> 승인일: 2026-08-29
> 범위: 조사로 얻은 진짜 키워드, 빈칸 매뉴얼 조립, 구출 미니게임과 전조 기반 회수에서의 비정답표 검증
> runtime·asset 변경: `NOT_AUTHORIZED_BY_THIS_DECISION`
> 사람 검증: `NOT_RUN`

## 결정

괴이 매뉴얼은 읽기 전용 가설 요약이나 시스템 정답표가 아니다. 사건별로 미리 작성된 **읽을 수 있는 추리문**에 빈 키워드 슬롯을 두고, 플레이어가 조사에서 직접 획득·기억한 정상 키워드를 배치하여 실행 규칙을 만든다.

```text
조사 장면에서 관찰·선택
→ 원본 출처와 획득 맥락이 남은 정상 키워드 획득
→ 빈칸이 있는 추리문과 후보를 비교
→ 플레이어가 매뉴얼 슬롯을 채워 후보 규칙을 기록
→ 구출 미니게임에서 절차·순서·타이밍을 직접 수행
→ 회수의 현재 전조 → 가설 → 근거 → 대응으로 현장 검증
→ 확인 규칙 / 위험 사례 / 재조사 필요 기록
```

플레이어는 매뉴얼에서 “정답”을 받지 않는다. 그럴듯한 규칙은 작성할 수 있지만, UI는 의미상 맞았는지 즉시 맞음/틀림·추천·호환 점수로 알려 주지 않는다. 실제 구출 수행과 회수의 관측 가능한 결과가 그 규칙을 검증·반증하며, 실패는 다음 판단에 쓸 위험 사례와 관찰을 남긴다.

## 키워드와 후보의 규칙

### 정상 키워드

- 정상 키워드는 조사 행동으로만 획득한다.
- 키워드는 `원본 출처`, `획득 행동`, `획득 시점/맥락`, `연결 증거`를 보존한다.
- 플레이어가 같은 장면을 떠올릴 수 있도록, 추상 점수보다 구체적 관찰 문구로 표시한다.

### 변조 후보와 보조 후보

- 변조 후보는 이미 획득한 정상 키워드의 **의미 있는 변수 하나만** 바꾼 파생 후보다. 예: 횟수, 시간, 순서, 방향, 대상, 도구, 금지 조건.
- 변조 후보는 독립 조사 장면·독립 원본 출처·가짜 기록을 갖지 않으며 UI에서 처음부터 변조라고 표시하지 않는다.
- 사실이지만 해당 슬롯에 쓰이지 않는 보조 후보는 변조와 별개로 표시한다.
- 정상·변조·보조의 구분을 색상·정렬·필터·추천으로 답안화하지 않는다. 플레이어의 근거는 조사 기억 + 정상 키워드 원본 + 추리문 문맥이다.
- 한 페이지에는 해당 사건과 슬롯에 필요한 작은 후보 풀만 둔다. 후보를 무차별 대입하는 것이 최적 풀이가 되지 않게 한다.

## 매뉴얼과 현장 검증 경계

| 단계 | 플레이어가 하는 일 | 시스템이 해서는 안 되는 일 |
| --- | --- | --- |
| 조사 | 관찰 뒤 방법을 고르고 정상 키워드를 획득한다 | 출처 없는 정답 키워드를 지급하거나 정답을 추천한다 |
| 매뉴얼 | 빈칸·출처·맥락을 비교해 후보 규칙을 쓴다 | 즉시 semantic correct/wrong, 정답 점수, 정답 필터를 표시한다 |
| 구출 미니게임 | 절차, 위치, 순서, 타이밍을 직접 수행한다 | 완성한 문장만으로 구출을 자동 해결한다 |
| 회수 | 현재 전조를 보고 가설·근거·대응을 고른다 | 동료·UI가 숨은 규칙이나 정답 대응을 대신 선택한다 |
| 결과 | 관찰 결과를 확인 규칙·위험 사례·재조사 필요로 남긴다 | 정상 클리어 시 완성 정답 매뉴얼을 자동 공개한다 |

구조상 불가능한 조합(중복 불가, 슬롯 타입 불일치, 미획득 정상 키워드 등)은 즉시 막을 수 있다. 그러나 의미상 그럴듯한 오답은 작성 가능해야 하며, 잘못된 후보가 나중에 왜 반증되었는지도 기록할 수 있어야 한다.

## 현행 구현과의 정합성

- M01 Canon v2에는 매뉴얼 page/slot, evidence record의 `source_id`·`usage_refs`, 구조상 rescue stage가 존재한다.
- 그러나 M01 `candidate_keywords`와 `semantic_relations`는 빈 배열이고, M04에는 같은 composition schema가 없다.
- 현재 조사/회수 Scene의 매뉴얼은 정보 표시·근거 선택의 baseline이지, 플레이어가 빈칸에 후보를 배치하는 consumer가 아니다.
- M01의 `normal_clear.reveal_complete_manual: true`는 이 결정의 **“정답 매뉴얼 자동 공개 금지”**와 충돌한다. 후속 implementation contract에서 save migration·결과 copy·기존 replay semantics를 함께 검증하며 교체할 stale data behavior다. 이번 결정으로 runtime data를 변경하지 않는다.

## 첨부 UI 참고의 권한 경계

사용자가 제공한 `ChatGPT Image 2026년 8월 11일 오후 05_42_02.png` 및 `12.png`는 다음 의미만 참고한다.

- 한 페이지에 읽을 수 있는 추리문과 명시적 빈칸이 공존한다.
- 후보 키워드, 출처 보조, 매뉴얼 인덱스가 추리 행동을 보조한다.

두 이미지는 `USER_PROVIDED_PLANNING_UI_REFERENCE / NOT_PROJECT_ASSET / NOT_RUNTIME_ASSET / NOT_COPIED_TO_REPOSITORY`다. 이미지의 장식, 문구, 캐릭터, 아이콘, 화면 구성은 구현 요구사항이나 승인 자산이 아니며, 이미지 속 긴 텍스트는 프로젝트 정본이 아니다.

## 계보와 범위 제한

- `D-2026-08-03-INVESTIGATION-MANUAL-STRUCTURED-KEYWORD-ASSEMBLY`에서 **읽을 수 있는 추리문, 의미 슬롯, 구조 검증만 즉시 차단** 원칙을 `ADAPT`한다. 그 문서의 `PENDING_BATCH_MERGE` 상태는 current authority가 아니다.
- `D-2026-08-03-INVESTIGATION-MUTATED-KEYWORDS-AND-MANUAL-DRIVEN-EXECUTION`에서 **한 변수 변조 후보와 원본 출처 보존**만 `ADAPT`한다.
- 위 predecessor의 공격·취약·고정 전투 흐름은 `SUPERSEDED`. 현행 회수는 `전조 → 가설 → 근거 → 대응 → 안정화/회수`다.
- 현재 Project 문서의 current authority는 이 Decision, `CURRENT_PLANNING_CANON`, `current-planning-canon.json`, Master GDD다. Notion과 과거 decision은 history/provenance다.

## 후속 구현 계약의 필수 검증

1. M01 또는 M04 한 사건에 source-backed normal / mutated / helper 후보 데이터를 넣는다.
2. 빈칸 매뉴얼 입력, 구조 검증, 저장/불러오기 및 old-save fallback을 automated로 검증한다.
3. UI가 semantic correct/wrong, 정답 추천, 변조 식별, normal-clear answer reveal을 표시하지 않는지 검증한다.
4. 한 구출 미니게임과 한 회수 전조가 작성된 후보 규칙을 **자동 해결 없이** 관찰 가능한 결과로 검증하는지 검증한다.
5. 신규 플레이어가 외부 가이드 없이 “조사 기억과 출처로 후보를 고르고, 현장 결과로 판정했다”고 설명하는 Human QA를 수행한다.

## Base 승격

`NO_BASE_PROMOTION`: 빈칸 매뉴얼, 정상/변조 후보, M01/M04의 데이터·회수 연결은 괴이기록국 고유의 콘텐츠·플레이 규칙이다. 공용 Base에는 일반적인 evidence/provenance 원칙이 이미 있으므로 project-specific 값을 제거해도 새 재사용 교훈이 남지 않는다.
