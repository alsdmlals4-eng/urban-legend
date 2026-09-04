# 완료 QA·규칙·인수인계 백업

> 문서 위치: `docs/archive/backup/2026-07-16/COMPLETED_QA_RULES_HANDOFF_BACKUP.md` | 현행 검증: `TEST_CHECKLIST.md`

## 보관 이유

`TEST_CHECKLIST.md`, `docs/BASE_RULES_VERSION.md`, `docs/CURRENT_HANDOFF.md`에 완료된 과거 기록이 계속 누적되어 새 작업이 필요 없는 항목까지 재검토하는 문제가 있었다. 현행 파일에는 현재 검증 계약과 최신 인수 상태만 남기고, 완료 상세와 과거 Base 후보는 이 백업과 `docs/qa/`에서 찾는다.

## 완료 QA 인덱스

| 범위 | 완료 내용 | 상세 기록 |
|---|---|---|
| 두 사건 캠페인 | 3인 편성, HQ 중단·재개, 저장, 의뢰, 10일 마감 | `docs/qa/TWO_CASE_CAMPAIGN_MANUAL_QA.md` |
| MVP-039 | 조사·회수·결과 판단 근거 UX | `docs/qa/MVP039_MANUAL_UX_VALIDATION.md` |
| MVP-040 | 폐주파수 방송국 발견·3단서·3회수·보고서·DB | `docs/qa/MVP041_THREE_CASE_CAMPAIGN_MANUAL_QA.md` |
| MVP-041 | 세 사건 전체 캠페인, Day 8 자연 발견, 136개 회귀 테스트 | `docs/qa/MVP041_THREE_CASE_CAMPAIGN_MANUAL_QA.md` |
| MVP-042 | 일정 비소모 일상 카드 3장, 저장 이관, 28개 검증 | `docs/qa/MVP042_DAILY_EPISODE_VALIDATION.md` |
| MVP-043 | 저승역 UI·권나래 주인공·초기 5인·자동 전조 회수·캐릭터 아트 | `docs/qa/MVP043_UI_PROTAGONIST_VALIDATION.md` |

## MVP-043 완료 확인 요약

- 1280×720, 1920×1080, 1918×943 안전 프레임
- 장소·현장 기록·페이지형 괴이 매뉴얼 3열
- 후보 5개와 위험 사례 기반 비활성화 근거
- 권나래 주인공 저장 이관과 서포트 0~2명
- 윤서하·한유리 포함 초기 5인 편성 후보
- 외부 접점 4인은 편성에서 제외
- `LOG`/`로그` 플레이어 노출을 `아카 안내`/`기록관 아카`로 이관
- 팀 상태 팝오버, 자동 전조, 가로 대응 카드, 소비품 보조 행
- 초기 5인 20종·외부 4인 8종 캐릭터 아트 검증
- 3×3 학습 비저장, 4×4 최종 결과 단일 저장

이 항목은 기본 체크리스트에서 반복하지 않는다. 관련 기능을 변경할 때만 상세 QA를 다시 연다.

## 과거 Base 승격 후보 요약

정리 전 `docs/BASE_RULES_VERSION.md`에는 2026-07-10~14의 Base 동기화·승격 후보가 누적돼 있었다.

- 항상 읽는 짧은 불변 규칙과 조건부 문서 라우팅 분리
- 외부 AI 산출물은 신뢰하지 않는 입력으로 취급
- Godot 장면 스테이지와 상태 도크 분리
- 저장 난수 상태 보존과 불러오기 재추첨 방지
- 긴 활동도 한 슬롯만 완료하고 결과 확인과 다음 슬롯 전환 분리
- 실패에 다음 판단 근거를 남기는 학습 가능한 실패
- 안내자는 미확보 단서·정답·숨은 수치를 누설하지 않음
- 시각·음향 신호를 동등하게 제공
- 장비·시장·연구가 핵심 추리를 대신하지 않음

프로젝트 고유 수치·경로·용어는 Base 승격 대상이 아니다. 현재 Base 동기화 정보만 `docs/BASE_RULES_VERSION.md`에 남긴다.

## 이전 CURRENT_HANDOFF

정리 전 handoff는 GDD v0.2 상세화와 추리 UX 벤치마킹 작업을 최신 상태로 기록하고 있었다.

```yaml
status: COMPLETE
goal: GDD v0.2 상세화·추리 UX 벤치마킹과 문서 전용 백로그 갱신
completed_work_commit: 6e37a0e5828245ee7b716cbb43455d4c31f3584e
remaining_work: DOCX 페이지 PNG 시각 QA, 세 번째 사건, 일상 에피소드, 연구·장비, 플레이타임 측정
next_action: 두 구현 사건 수동 플레이와 고위험 변경 분리
```

이 내용은 MVP-040~043 이후 더 이상 현재 인수 상태가 아니다. 최신 handoff는 `docs/CURRENT_HANDOFF.md`를 따른다.

## 전체 원문 조회

```bash
git show 130466e66d3115876a85ba06f47b7661fae3f304:TEST_CHECKLIST.md
git show 130466e66d3115876a85ba06f47b7661fae3f304:docs/BASE_RULES_VERSION.md
git show 130466e66d3115876a85ba06f47b7661fae3f304:docs/CURRENT_HANDOFF.md
```
