금지:

```text
같은 범위인데 “정말 진행할까요?”
같은 범위인데 “PR 올릴까요?”
같은 범위인데 “병합할까요?”
HEAD가 바뀌었다는 이유만으로 기획 승인 재요청
```

### 12.2 HEAD/base가 변경된 경우

사용자 승인은 유지될 수 있지만 기술 검증은 다시 만든다.

```yaml
validation_identity:
  review_head_sha:
  base_sha:
  merge_base_sha:
  test_merge_sha:
  merge_group_sha:
  ci_validation_target_sha:
```

현재 저장소가 실제로 요구하는 SHA를 검증한다.

---

## 13. BCP-020 PLAYER_EXPERIENCE_EVIDENCE_GATE

Base current의 플레이어 경험 계약을 프로젝트에 적용한다.

네 증거를 하나의 `validation passed`로 뭉뚱그리지 않는다.

| 증거 | 증명 | 증명하지 않음 |
|---|---|---|
| `TECH_EVIDENCE` | 코드·데이터·Schema·엔진 실행의 기술 상태 | 사람이 이해/재미/기억을 얻는지 |
| `UI_EVIDENCE` | 렌더·입력·포커스·해상도·시각 상태 | 처음 보는 사용자가 다음 행동을 찾는지 |
| `HUMAN_USABILITY_EVIDENCE` | 사람이 조작·정보 구조·다음 행동을 이해하는지 | 의도한 감정·고민·기억이 생기는지 |
| `PLAYER_EXPERIENCE_EVIDENCE` | 의도한 고민·감정·선택·보상·기억이 실제 플레이에 생기는지 | 장기 유지율·판매 성과 |

사람 관찰을 실행하지 않았으면:

```yaml
HUMAN_USABILITY_EVIDENCE: NOT_RUN
PLAYER_EXPERIENCE_EVIDENCE: NOT_RUN
```

자동 테스트·렌더 캡처·텍스트 검사로 위 두 상태를 `PASS`로 올리지 않는다.

사람 검증을 했다면:

```yaml
human_test:
  participant_context:
  prior_exposure:
  task:
  questions:
  observed_actions:
  answers:
  failure_points:
  sample_limitations:
```

---

## 14. FIRST SESSION / FIRST 10 MINUTES CONTRACT

`FIRST_10_MINUTES`는 고정 시간 제한이 아니라 **대표 경험의 압축판 기본값**이다.

장르·세션 길이에 따라 시간 창은 조정할 수 있지만 다음 흐름은 관찰 가능해야 한다.

```text
대표 문제
→ 대표 행동
→ 첫 의미 있는 선택
→ 첫 관찰 가능한 결과
→ 다음 질문
```

```yaml
first_session_contract:
  representative_problem:
  representative_action:
  first_meaningful_choice:
  first_observable_result:
  next_question_created:
  time_window: FIRST_10_MINUTES_DEFAULT | PROJECT_ADAPTED
```

공포·미스터리처럼 정보를 숨기는 것은 허용한다.
