# MVP-044~046 Execution Plan

## Implementation status (2026-07-16)

| Package | Status | Verified scope |
|---|---|---|
| WF-00 | complete | Local delegated runner and workflow contracts restored. |
| MVP-044 | partial | 7 AFTER, 9 DAILY, 9 FACTION entries use the existing optional-event completion records; full approved source text still needs integration. |
| MVP-045 | partial | 12 chains / 30 scenes and textual records exist; source-condition fidelity still needs integration. |
| MVP-046 | partial | Registry, fallback and six cut-in definitions exist; real-scene presentation integration still needs verification and completion. |
| MVP-047 | partial | HQ research half-day, 3/3/5-point project completion, 35/25-fragment crafting, and Raymond Kane's one-event 35-fragment safety-line contract are implemented. Fourth-case content and full economy QA remain pending. |
| Final visual capture | pending | Needs interactive 1280×720 and 1920×1080 review; no completion claim is made here. |

> 문서 위치: `docs/planning/MVP044_046_EXECUTION_PLAN.md` | 감사 기준: `docs/audits/MVP044_046_REPOSITORY_AUDIT.md` | [백업]: `docs/archive/backup/YYYY-MM-DD/`

이 문서는 승인된 전달 패키지를 실제 코드·데이터·테스트에 연결하는 작업 순서다. 완료 여부는 이 문서가 아니라 현재 브랜치의 코드와 검증 결과로 판단한다.

## 의존 순서

```text
워크플로·문서 계약
→ MVP-044 서사 ID와 선택형 기록 안정화
→ MVP-045 관계 기억·이관
→ MVP-046 공용 연출
→ 세 사건·DB·저장 전체 회귀
```

## 구현 패키지

1. **WF-00** — 프로젝트 로컬 위임 실행기, 문서 계약, 저장소 감사 문서. 실패한 기존 계약 테스트를 복구한다.
2. **MVP044-01** — `기록관 아카` 표시 호환과 저승역 한 장면, AFTER·DAILY·FACTION 각 1편의 수직 구현. 기존 일상 구조를 공용 선택형 서사로 확장하되 반일·위험·필수 단서를 변경하지 않는다.
3. **MVP044-02~05** — 나머지 세 사건 문구, AFTER 7·DAILY 9·FACTION 9, 지원 대사 게이트, DB·재진입 검증. 기존 일상 3편과 반복 의뢰는 유지한다.
4. **MVP045-01~06** — `relationship_event_records`, `mvp-039 → mvp-045` 이관, 관계 카탈로그·해금, 12체인·30장면, DB와 사건 반응. 관계 태그는 선택 기억에서만 최대 2개로 파생한다.
5. **MVP046-01~06** — 의미 표정·자산 폴백, 공용 대화 스테이지, 컷인 6종, 관계·사건 연결, 모션·플래시 감소와 입력 복귀.
6. **FINAL-00** — 세 사건, 선택형 서사, 관계, DB, 저장, Day 8/10, 해상도·입력·문서 회귀.

## 저장과 인터페이스

- MVP-044: 기존 선택형 완료 기록을 확장하고 `mvp-039`를 유지한다.
- MVP-045: 전용 관계 기록 배열과 접근자를 추가하고 누락 필드는 빈 배열로 이관한다. 구 완료 기록에 선택이 없으면 중립 기억으로 진행만 보장한다.
- MVP-046: `presentation`, `stage_events`, 사용자 접근성 설정은 선택적이며 캠페인 상태를 소유하지 않는다.
- UI 컴포넌트는 ID·요청만 반환한다. `GameState` 변경은 공용 접근자에서만 수행한다.

## 게이트와 검증

- 매 패키지마다 failing test → 최소 구현 → 통과 테스트 → `git diff --check` 순서를 지킨다.
- 저장 변경은 구 저장 이관, 멱등 완료, 재진입, DB 표시를 함께 검증한다.
- UI 변경은 1280×720·1920×1080의 한국어 줄바꿈, 오버랩, 키보드·마우스 포커스, 입력 차단·복귀를 캡처한다.
- 매 패키지는 독립 커밋으로 남긴다. 전체 회귀를 통과한 변경만 `origin`에 푸시한다.

## 운영 경계

- 외부 ZIP과 원본 이미지는 이동·삭제하지 않는다.
- 문서 대체는 `docs/DOCUMENT_LIFECYCLE.md`에 따라 [백업]으로 보관한다.
- DeepSeek 산출물은 계약·SHA·허용 경로를 검토한 뒤에만 참고한다.
- Base 승격 후보 없음.
