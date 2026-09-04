godot_launch_authority: AUTHORIZED_AFTER_LOCAL_SYNC
```

### 4.1 경로 해석

- `project_local_path` = Git 저장소 루트.
- `godot_project_path` = 실제 `project.godot`이 존재하는 폴더.
- 둘이 같아도 정상.
- 로컬 경로는 사용자 환경 입력이며 Base 공용 정본으로 승격하지 않는다.
- `shared_audio_vault_path`의 `shered` 표기는 v4.4의 사용자 원문을 그대로 보존한다.

### 4.2 보호 입력

```text
[핵심 내용]

```

프로젝트 목적·확정 방향·필수 경험·기능·콘텐츠·금지 사항·완료 기준은 의미를 삭제하거나 약화하지 않는다.

---

## 5. Work Mode·Skill 라우팅

Base current Registry를 자동 라우팅 권위로 사용한다.

```text
요청
→ PLAN | BUILD | REVIEW
→ 작업 수준 L0~L4
→ primary discipline 최대 1개
→ 필요한 foundation/validation/handoff만 추가
→ 각 Skill에서 필요한 mode만 실행
→ 실제 사용한 Skill/mode와 결과 기록
```

규칙:

- 사용자가 Skill 이름을 기억할 필요가 없다.
- `load_by_default=false`는 자동 선택 금지가 아니다.
- trigger 불일치 Skill을 관성적으로 로드하지 않는다.
- Skill을 읽은 것과 실행한 것을 구분한다.
- 새 범위·새 실패·정본 변경이 생기면 라우팅을 재계산한다.
- 외부 process overlay는 Base Skill 라우팅을 대체하지 않는다.

---

## 6. 전체 생명주기

```text
CURRENT BASE RECOVERY
→ PROJECT WHOLE-STATE RECOVERY
→ ENTRY STATE RECONCILIATION
→ PLAN
→ BENCHMARK
→ EXISTING SOLUTION FIRST
→ GRILL ME ONLY FOR MATERIAL PLANNING CONFLICT
→ APPROVED DECISION SYNC
→ BUILD
→ TEST-FIRST / VALIDATION
→ PLAYER-EXPERIENCE EVIDENCE AS APPLICABLE
→ ADVERSARIAL ATTACK
→ VALIDATE CRITIQUE
→ APPROVED MINIMAL FIX
→ REGRESSION RECHECK
→ EXACT CURRENT PR VALIDATION TARGET
→ REQUIRED CI-GATE
→ MERGE WITH REUSED APPROVAL
→ NEW MAIN READBACK
→ POST-MERGE ADVERSARIAL RECHECK
→ SAFE BRANCH CLEANUP
→ LOCAL FETCH/PULL
→ GODOT PROJECT PLAY
→ FINAL EVIDENCE REPORT
```

한 시점의 주 Work Mode는 하나다.
복합 작업은 `PLAN → BUILD → REVIEW`로 전환한다.

---

## 7. 프로젝트 전체 복원

작업 시작 전에 다음을 서로 대조한다.

```yaml
repository:
  current_main_sha:
  current_branch:
  working_tree_state:
  open_same_goal_prs:
  recently_merged_same_goal_prs:

project:
  current_confirmed_decisions:
  active_context:
  current_goal:
  next_work:
