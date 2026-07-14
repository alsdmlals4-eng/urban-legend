# Codex 계정 교대 가이드

## 프로필 경계

- 계정 A/B는 각각 `C:\Users\user\.codex-profiles\account-a`, `account-b`를 `CODEX_HOME`으로 사용한다.
- 각 프로필의 `auth.json`과 플러그인 연결은 공유하지 않는다. 로그인은 프로필마다 사용자가 최초 1회 수행한다.
- 검증된 개인 스킬만 `C:\Users\user\.codex\skills`에서 junction으로 공유한다. `.system`, 인증, 플러그인 상태는 연결하지 않는다.
- 프로필 전환 전에 실행 중인 ChatGPT/Codex 프로세스를 완전히 종료한다.

## 사용량 수명주기

- 작업 시작·큰 단계 전환·커밋 직후에 데스크톱 `/status` 또는 CLI `/usage`의 최신 값을 확인한다.
- 에이전트에 정확한 수치가 노출되지 않으면 상태는 `UNKNOWN`이며 남은 비율을 임의로 계산하지 않는다.
- 5% 이하는 `PREPARE`: 범위 확장을 멈추고 원자 작업·최소 검증·handoff 작성을 준비한다.
- 2% 이하는 `HARD_STOP`: 신규 구현을 멈추고 작업 브랜치 checkpoint, `CURRENT_HANDOFF.md`, push만 수행한다.
- 갑작스러운 종료로 dirty worktree가 남으면 다음 계정은 이를 사용자 변경으로 보존하고 diff부터 감사한다.

## 신규 계정 최초 지시문

```text
C:\Users\user\Documents\GitHub\urban-legend 프로젝트를 인수한다.

AGENTS.md → docs/BASE_RULES_VERSION.md → docs/DOCUMENTATION_MAP.md →
docs/PROJECT_CONTEXT.md → docs/CURRENT_HANDOFF.md → 현재 작업의 조건부 문서 순으로 읽는다.
git status, 현재 브랜치, origin/main, 최근 커밋과 실제 테스트로 문서 내용을 검증한다.
로드맵만 보고 완료를 추정하지 않는다.

먼저 완료·미완료 범위, 문서와 구현의 불일치, dirty worktree, 다음 vertical slice를 압축 보고한다.
고위험 미확정 결정이 없으면 CURRENT_HANDOFF의 next_action부터 이어간다.
완료 후 실제 실행 main 통합·재검증·커밋·origin/main push까지 수행한다.
GPT와 DeepSeek 산출물은 기존 patch/review 계약으로만 검수한다.
```

## 이후 짧은 재개 지시문

```text
urban-legend 작업을 이어간다. AGENTS.md, CURRENT_HANDOFF.md, git status와 최근 커밋을 확인하고
마지막 미완료 작업부터 계속하라. 로드맵보다 실제 코드와 테스트를 우선하고 완료 후 main 통합·push까지 진행하라.
```
