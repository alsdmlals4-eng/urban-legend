# Urban Legend 작업 규칙

한국어로 결과부터 설명한다. 새 변경은 의도·현재 상태·변경/보호 범위·방법·검증 기준을 먼저 제시하고 승인받는다. 같은 승인 범위의 “진행해”는 구현·교정·검증·허용된 정상 병합을 계속하라는 뜻이며 재승인·재계획을 반복하지 않는다.

## Current-authority read order

1. 이 파일 → `START_HERE.md`.
2. `docs/CURRENT_DECISION_OVERLAY.md` → `docs/CURRENT_HANDOFF.md`의 현재 블록과 승인 계약.
3. 최신 원격 main·현재 브랜치·사용자 변경·같은 작업의 열린 PR을 비교한다. 실제 대상 코드·씬·데이터·자산 consumer와 관련 검사를 확인한다.
4. 제품 변경이면 `docs/CURRENT_PLANNING_CANON.md`, `docs/current-planning-canon.json`과 필요한 분야 정본을 읽는다.
5. `docs/BASE_RULES_VERSION.md`와 `skills/PROJECT_BASE_ADAPTER.json`에서 채택 계약·선택 적용 정책을 구분하고, `docs/WORK_MODE_AND_SKILL_ROUTING.md`로 필요한 Skill·reference만 선택한다.

우선순위는 최신 사용자 지시 → 프로젝트 보호 규칙 → 현재 결정·승인 계약 → 책임 원본과 실제 구현 증거 → 채택 Base 계약 → 미채택 Base 최신/외부 사례다. 브랜치의 승인·구현을 main 병합으로 표시하지 않는다. Issue 상태·과거 SHA·PDF·대화는 현재 실행 권한을 대신하지 않는다.

## 보호와 권한

- `scripts/`, `scenes/`, `data/`, `assets/`, `addons/`, `project.godot`, `knowledge/base-pack`을 보호한다. 특히 `scripts/core/game_state.gd`와 `data/episodes`의 저장·기존 ID·사건 의미는 승인 없이 바꾸지 않는다.
- 게임 코어·경제·주요 UX·승인 아트·저장 의미·추가 비용·보안·파괴적 작업은 별도 결정이다. 설치 플러그인·전역 설정을 임의 변경하지 않는다.
- 정상 사용자 변경·다른 PR·작업 폴더를 보존한다. 기존 open/draft/ready PR은 읽기 전용이다. 이번 승인으로 최신 main에서 만든 명확한 current-task PR만 필수 검사·독립 검토·미해결 논의 확인 후 정상 병합할 수 있다. 강제 push·direct main push·관리자 우회는 금지한다.
- 파일명·나이만으로 삭제하지 않는다. 폐기 후보는 사용처·고유 정보·복구 근거를 확인하고 사용자 직접 삭제 방식으로 안내한다.
- 프로젝트 파일은 `C:/Users/user/Documents/GitHub/urban-legend` 안에 둔다. 별도 지정된 증빙 PDF 출력 경로만 사용자 승인 예외다.

## 실행과 증거

- 현재 구현·승인 자산·관련 Base 사례를 먼저 재사용한다. 중요한 새 판단만 추가 조사·실질 대안 비교한다.
- 읽기 전용 요청은 조사·답변만 한다. 같은 계약의 계획·조사·전체 검토 예산은 단계와 플러그인 사이에서 재사용한다. 상세 실행 규칙은 `docs/OPERATING_MODEL.md`가 소유한다.
- 필수 source 미확인은 그 의존 작업만 보류하며 원문을 추정하지 않는다. 독립적이며 이미 승인된 작업은 계속할 수 있다.
- 실제 도구 능력과 권한으로 실행한다. 외부 AI 위임이나 엔진 검사를 앱 이름·스킬 존재만으로 강제하지 않는다.
- 자동 검사·실제 실행·사람 경험·자산 승인·main 병합·출시는 별개다. 미실행은 `NOT_RUN`; 문서/AI 평가로 재미 PASS를 만들지 않는다.
- 플레이어 경험 변경은 `docs/UX_UI_SYSTEM.md#experience-verification`의 재미 가설→실제 consumer→반증·검증 연결을 기존 작업 기록에서 사용한다. 별도 재미 보고서나 새 감독 스킬을 만들지 않는다.
- 현재 상태는 기존 Decision/Handoff에 누적한다. 작업일지·증빙집도 기존 월별 문서에 날짜별로 추가한다.

## 조건부 자료

`docs/DOCUMENTATION_MAP.md`는 분야별 주소를 찾을 때, `docs/CURRENT_STATUS.md`·`docs/CURRENT_CONFIRMED_DECISIONS.md`·과거 계획은 역사/회귀 계보가 필요할 때만 읽는다. Notion·Sheets는 `HISTORICAL_READ_ONLY_NO_WRITE` 자료다. PDF는 기획 원본에서 만든 파생 검토본이지 독립 정본이 아니다.

엔진·저장·게임 규칙은 현재 기획 및 실제 구현 owner, 이미지 제작·승격은 `docs/IMAGE_ASSET_WORKFLOW.md`와 `ASSET_MANIFEST.yml`, 출시·권리는 `docs/PLATFORM_RELEASE_AND_ASSET_RIGHTS_PROFILE.md`를 해당 작업에서 확인한다. 전체 skills·archive·QA 이력을 기본 로드하지 않는다.
