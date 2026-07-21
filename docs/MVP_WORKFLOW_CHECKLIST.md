# MVP Workflow Checklist

실제 MVP를 시작·구현·종료할 때 사용하는 계약이다. L0 문서 수정에는 사용하지 않는다.

## 시작

1. 최신 사용자 지시, `START_HERE.md`, `AGENTS.md`, `CURRENT_STATUS.md`, `PROJECT_CORE.md` 확인.
2. Work Mode와 주 프로젝트 Skill 최대 1개·Base 지원 Skill 최대 3개 선택.
3. 목표·플레이어 가치·포함·제외·완료 기준·영향 파일·검증 확정.
4. 보호 경로·저장·ID·Schema·코어 영향을 판정.
5. 작은 end-to-end 결과와 의존성·rollback을 정한다.

## Definition of Ready

- 현재 구현과 승인 계획이 구분된다.
- 대상 ZIP/Issue/Goal과 실제 파일이 연결된다.
- 코어 영향이 `유지 / 재승인 필요 / 미검증`으로 판정됐다.
- 자동·수동 완료 증거와 미실행 처리 방식이 있다.

## 구현

- 사용자 변경과 기존 정상 경로를 보존한다.
- `scripts/core/game_state.gd`, `data/episodes/**`, `project.godot`, `knowledge/base-pack/**`은 관련 승인·회귀 없이 변경하지 않는다.
- 저장 키·기존 ID를 재사용하고 새 상태 소유자를 만들지 않는다.
- 프로젝트 용어는 괴이 기록국·안정화 상태·위험 사례·잔향·괴이 매뉴얼·기록관 아카를 사용한다.
- 구현되지 않은 계획을 완료로 표시하지 않는다.

## 구조 개선 요청일 때

```text
baseline·소비자·코어
→ pruning 판정표
→ 조건부 상세는 reference
→ 행동 보존 refactor
→ adversarial attack
→ 비판 검증
→ MUST_FIX·승인 SHOULD_FIX 최소 수정
→ regression-recheck
```

삭제·통합 전 고유 입력·산출물·검증·호환성을 보존표로 남긴다.

## 자동 검증

```text
python -m unittest tests/test_base_operating_sync.py tests/test_skill_package_integrity.py
python tools/docs/build_game_design_doc.py --check  # GDD 변경 시
git diff --check
Godot --headless --path . --quit                    # runtime 변경 시
```

- Registry·Base index·Coverage·프로젝트 패키지·Alias·경로·코어 계약을 검사한다.
- JSON·Scene·스크립트·저장 왕복·영향 플레이는 변경 범위에 맞게 추가한다.
- 미실행 항목은 `NOT_RUN` 또는 `UNVERIFIED`다.

## PR 감사

- changed-file 전체와 삭제·rename·바이너리를 확인한다.
- 보호 게임 경로 변경에는 명시 요청·회귀·복구가 있다.
- Base pin·Skill 수·Coverage·PR 설명과 실제 CI가 일치한다.
- stacked PR의 차단 finding을 상속하지 않는다.
- 적대적 finding은 MUST_FIX/SHOULD_FIX/DEFER/REJECT/UNVERIFIED로 남긴다.

## Definition of Done

- 관찰 가능한 완료 기준과 실제 증거가 연결된다.
- 프로젝트 코어·저장·기존 세 사건·정상 사용자 흐름이 보존된다.
- 의도적 기능 변경과 구조 개선이 분리된다.
- Current Status·Roadmap·Test·분야 원본의 갱신 필요를 심사했다.
- 실제 Work Mode·Skill·Mode·결과·미검증·rollback·다음 진입점을 보고했다.
