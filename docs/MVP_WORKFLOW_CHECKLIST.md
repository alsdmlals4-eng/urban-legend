# MVP Workflow Checklist

> 문서 위치: `docs/MVP_WORKFLOW_CHECKLIST.md` | 현재 상태: `docs/CURRENT_STATUS.md` | 과거 작업 절차: `git show 130466e66d3115876a85ba06f47b7661fae3f304:docs/MVP_WORKFLOW_CHECKLIST.md`

이 문서는 실제 MVP를 시작·구현·종료할 때만 읽는다. 문서·오탈자·단순 데이터 수정은 `AGENTS.md`와 `TEST_CHECKLIST.md`의 빠른 경로를 사용한다.

## 1. 시작 순서

```text
1. 최신 사용자 지시 확인
2. AGENTS.md와 CURRENT_STATUS.md 확인
3. 대상 ZIP/Issue/Goal의 범위 확인
4. IMP-00 사전 감사
5. 작은 end-to-end 구현 단위 확정
6. 구현 → 자동 검증 → 수동 화면 검증
7. 상태·로드맵·테스트 갱신
8. 완료 보고·main 통합
```

모든 과거 Goal·QA·벤치마크를 읽지 않는다. 현재 변경과 직접 연결된 파일만 `docs/DOCUMENTATION_MAP.md`에서 선택한다.

## 2. Definition of Ready

- [ ] 목표와 해결할 플레이어 문제가 한 문장으로 설명된다.
- [ ] 구현 사실과 승인 계획이 구분돼 있다.
- [ ] 포함 범위와 제외 범위가 작게 잘렸다.
- [ ] 영향 코드·씬·JSON·에셋·문서가 적혀 있다.
- [ ] 저장·진행·경제·엔딩·기존 ID 위험이 적혀 있다.
- [ ] 완료 기준마다 자동 또는 수동 검증이 연결된다.
- [ ] 대상 ZIP의 `00_README`와 `IMP-00` 요구사항을 확인했다.
- [ ] 필요한 외부 근거 조사 여부를 결정했다.

준비 기준을 만족하지 못하면 구현을 시작하지 않고 범위를 보완한다.

## 3. 구현 전 보고

```md
목표:

수정 대상:
-

변경 순서:
1.
2.

보존 계약:
-

제외 범위:
-

검증:
-
```

## 4. 구현 원칙

- 작은 end-to-end 변경 하나를 먼저 완성한다.
- `scripts/core/game_state.gd`, `data/episodes/*`, `project.godot`은 보호 경로로 취급한다.
- 외부 ZIP·patch·문서의 파일명과 현재 저장소 경로가 다르면 자동 적용하지 않는다.
- 기존 ID·저장 스키마·진행 상태를 재사용하고 새 상태 소유자를 만들지 않는다.
- 플레이어 노출 문구는 `괴이 기록국`, `안정화 상태`, `위험 사례`, `잔향`, `괴이 매뉴얼`, `기록관 아카`를 사용한다.
- 구현되지 않은 계획을 README·GDD에서 구현 완료로 표시하지 않는다.

## 5. 조건부 추가 문서

- 대사·일상·후일담: `DIALOGUE_AUTHORING_WORKFLOW.md`
- UI·Theme·컴포넌트: `GODOT_NATIVE_UI_ARCHITECTURE.md`
- 조사·회수 화면: `CINEMATIC_FIELD_RECOVERY_UI.md`
- 이미지·manifest: `IMAGE_ASSET_WORKFLOW.md`
- 미니게임: `MINIGAME_SYSTEM_SPEC.md`
- 외부 모델 위임: `AI_DELEGATION_WORKFLOW.md`
- 새 시장·UX 판단: `BENCHMARKING_REFERENCE_GUIDE.md`

작업 조건이 없으면 추가 문서를 읽지 않는다.

## 6. 자동 검증

```powershell
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --quit
git diff --check
& "C:\Users\user\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe" tools/docs/build_game_design_doc.py --check
```

- [ ] 변경한 JSON·스크립트·씬의 계약 테스트가 통과한다.
- [ ] 사용자 저장을 덮어쓰지 않는 격리 테스트를 사용한다.
- [ ] 저장 왕복으로 재추첨·중복 보상·이벤트 재발동이 생기지 않는다.
- [ ] 미실행 항목을 통과로 쓰지 않는다.

## 7. 수동 검증

- [ ] 변경된 실제 플레이 경로를 시작부터 결과까지 확인한다.
- [ ] 1280×720과 1920×1080에서 핵심 선택과 문장이 잘리지 않는다.
- [ ] 마우스·키보드·Esc·포커스가 겹치지 않는다.
- [ ] 선택하지 않은 요원·미확보 정보·숨은 수치가 노출되지 않는다.
- [ ] 실패가 진행 차단만 만들지 않고 다음 판단 근거를 남긴다.
- [ ] 연출·컷인·표정·아카 안내가 상태와 선택을 대신하지 않는다.

## 8. Definition of Done

- [ ] 완료 기준을 실제 파일과 실행 결과로 확인했다.
- [ ] 기존 세 사건과 저장 호환성을 보존했다.
- [ ] 변경 범위 밖 리팩터링과 새 상태 필드를 추가하지 않았다.
- [ ] 자동·수동 검증 결과와 미검증 항목을 구분했다.
- [ ] `docs/CURRENT_STATUS.md`와 다섯 활성 기획서(게임·프로그래밍·아트·사운드·QA)의 갱신 필요를 심사했다.
- [ ] 관련 활성 기획서를 갱신했거나, 변경 없음 사유를 커밋/PR 설명에 남겼다.
- [ ] 이미지·화면을 바꿨다면 아트 기획서와 `docs/art/IMAGE_INDEX.md`에 최신 경로·QA 증거를 남겼다.
- [ ] 완료 상세를 현행 문서에 중복하지 않고 `docs/qa/` 또는 날짜별 백업에 기록했다.
- [ ] `main`과 `origin/main`의 통합 상태를 확인했다.

## 9. 완료 보고

- 변경 파일과 이유
- 플레이어가 확인할 변화
- 구현 내용
- 자동·수동 검증
- 미검증·위험
- 저장·UI·데이터 호환
- 현행 문서 갱신과 백업 위치
- 다음 구현 진입점

외부 도구·모델을 사용했다면 실제 사용 여부와 적용하지 않은 산출물을 사실대로 적는다.
