그러나 **지금 무엇을 시도할 수 있는지**까지 숨기지 않는다.

---

## 15. DECISION SCREEN COMPREHENSION GATE

핵심 의사결정 화면은 다음 네 질문을 답할 수 있어야 한다.

```text
현재 상황은 무엇인가
무엇을 선택할 수 있는가
선택에 필요한 정보는 무엇인가
선택하면 어떤 비용·위험·결과가 예상되는가
```

검증:

```yaml
decision_screen:
  current_situation_readable:
  available_choices_readable:
  needed_information_readable:
  cost_risk_result_readable:
  intentionally_hidden_information:
  hidden_information_does_not_hide_action_purpose:
```

장식·애니메이션 품질은 이 Gate를 대신하지 않는다.

---

## 16. MINIGAME_NARRATIVE_FUNCTION_GATE

**프로젝트 코어가 아닌 별도 미니게임 후보**에만 적용한다.

```yaml
minigame_narrative_function:
  main_game_information_used:
  player_decision_tested:
  narrative_or_system_result_changed:
  failure_learning:
  rule_learning_time:
  reusability:
  content_cost:
  flow_interrupt_cost:
```

통과 방향:

- 본편 정보·규칙이 실제 판단에 쓰인다.
- 성공/실패가 사건·자원·기록·다음 선택을 바꾼다.
- 실패가 다음 시도 학습을 남긴다.
- 공통 프레임/데이터 변형으로 재사용 가능성을 검토한다.
- 더 짧은 선택지/공통 상호작용이 같은 경험을 낼 수 있는지 비교한다.

**주의**

퍼즐·전투·제작 자체가 프로젝트 코어면 이를 미니게임으로 낮춰 평가하지 않는다.

```text
CORE PUZZLE / CORE COMBAT / CORE CRAFTING
→ CORE_INTERACTION_EVIDENCE
→ project core contract
```

---

## 17. Visual Requirement Gate

이미지를 만들기 전에 다음 순서로 판단한다.

```text
필요성
→ Delete Test
→ 기존 승인 자산 재사용 가능성
→ UI/게임플레이/서사에서의 역할
→ 중요도 P0~P3
→ 제작 방식
→ 승인
→ 프로젝트 Asset Vault promote
```

이미지가 없어도 경험·정보 구조가 유지되면 장식 자산일 수 있다.

`DRAFT`, `placeholder`, 임시 생성 이미지를 최종 승인 자산처럼 사용하지 않는다.

---

## 18. Asset Vault·Reference Library·Audio Vault

### 프로젝트 Asset Vault

```text
candidate
→ provenance
→ rights/license
→ technical validation
→ user/project approval
→ PROJECT_ASSET_APPROVED
→ tracked promotion
→ Godot res:// consumption
```

`res://assets/_vault_local/`은 local-only 후보 공간이다.
