# AI Skill Adoption Guide

> Base 공용 가이드의 도시괴담 기록국 로컬 사본 + Godot 프로젝트 적용 결론. 공용 원본 기준 커밋은 `docs/BASE_RULES_VERSION.md`에 기록한다.

외부 스킬은 선택형 보조 수단이다. 최신 사용자 지시, `AGENTS.md`, 현재 Issue/Goal, 실제 파일과 실행 결과보다 우선하지 않는다. 설치 실패도 프로젝트 작업을 막지 않는다.

## 1. 이번에 확인한 구조

| 저장소 | 구조와 source of truth | 가져올 원칙 | 이 프로젝트에서 제외 |
|---|---|---|---|
| [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) | `skills/ponytail/SKILL.md` 중심. audit/review/debt/gain 보조 스킬과 benchmark/test 분리 | 필요성 확인 → 기존 코드 → 엔진 기본 기능 → 기존 의존성 → 최소 구현 순서 | 입력 검증, 저장 안정성, 접근성, 테스트를 줄이는 극단적 축소 |
| [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) | `skills/`가 원본, plugin 배포본은 mirror. hook·installer·benchmark·eval 분리 | filler와 중복 제거, 경로·명령·숫자·코드 보존, 위험 작업은 명료한 문장으로 전환 | 모든 보고를 파편 문장으로 강제하거나 원본 백업을 무조건 생성 |
| [Leonxlnx/taste-skill](https://github.com/Leonxlnx/taste-skill) | UI 구현, redesign, image generation 스킬을 `skills/`에서 분리 | brief·사용자·기존 화면 감사 후 variance/motion/density를 정하고 preflight | 랜딩 페이지 미학을 Godot 운영 UI에 복사, 대형 아트·모션 자동 추가 |
| [mattpocock/skills](https://github.com/mattpocock/skills) | engineering/productivity 스킬 분리. `CONTEXT.md`, spec, ticket, feedback loop 산출물 연결 | 기존 test seam 우선, 버그 재현 command 먼저, 작은 composable workflow | GitHub label·tracker·TypeScript 테스트 규칙을 프로젝트 사실처럼 가정 |
| [affaan-m/ECC](https://github.com/affaan-m/ECC) | `.agents/skills/` 공통 원본과 harness별 배포층, hooks·roles·security·verification 포함 | phase-boundary compact, 권한 preflight, 역할 분리, 검증 단계화 | 대형 bundle 전체 설치, 프로젝트에 없는 80% coverage·npm 단계 강제 |
| [mvanhorn/last30days-skill](https://github.com/mvanhorn/last30days-skill) | `skills/last30days/SKILL.md`와 `scripts/` research engine, provider·permission 진단 분리 | 기간 제한, 다중 출처, 최신성/반응/사실 분리, raw research와 결론 분리 | 브라우저 쿠키, 유료 API, 외부 저장을 자동 허용 |
| [obra/superpowers](https://github.com/obra/superpowers) | brainstorming→plan→implementation→review→finish의 composable skill chain | spec-first, systematic debugging, TDD, completion 전 fresh verification | 오탈자나 이미 확정된 Goal에도 모든 승인 gate와 새 문서를 강제 |

외부 저장소의 설치법과 기능은 바뀔 수 있다. 실제 설치·업데이트 요청이 있을 때 최신 원본, 라이선스, 실행 스크립트와 권한을 다시 확인한다.

## 2. 도시괴담 기록국 라우팅

| 작업 | 기본 원칙 | 선택 도구 |
|---|---|---|
| 명확한 MVP Goal 구현 | Goal 요약 후 기존 Godot 구조 안에서 최소 변경 | Ponytail 원칙, verification |
| 모호한 기능/UX 방향 | 플레이어 문제와 제외 범위를 먼저 확정 | brainstorming 또는 to-spec 계열 |
| 버그·화면 깨짐 | 증상을 잡는 headless/scene/manual loop부터 확보 | systematic debugging 또는 diagnosing-bugs |
| Godot UI 개선 | PC 16:9, 실제 플레이 흐름, 기존 컨테이너를 먼저 감사 | Taste의 brief/density 원칙만 적용 |
| 저장·외부 API·파일 입력 | 저장 호환성과 trust boundary를 별도 점검 | ECC security 원칙 |
| 최근 시장·Steam·도구 조사 | 날짜 범위와 1차 출처를 명시 | last30days 원칙 또는 web research |
| 긴 세션 | 문서에 결정 저장 후 phase 경계에서 context 축약 | strategic-compact 원칙 |

기본 한도는 프로세스 스킬 1개 + 도메인 스킬 1개다. 같은 기능을 중복하는 스킬을 여러 개 동시에 호출하지 않는다.

### 자원 인식형 도구·에이전트 운영

- 성능 문제가 생기면 작업량을 줄이기 전에 전체 메모리, 상위 점유 프로세스, 중복 MCP·언어 서버·브라우저 렌더러를 측정한다.
- 대부분의 작업에 필요하지 않은 MCP, 대시보드, 언어 서버 같은 선택형 보조 도구는 기본 비활성화하거나 필요한 작업에서만 실행한다.
- 핵심 작업량과 사용자가 요구한 병렬 흐름은 보존하되, 같은 저장소의 대용량 외부 worker는 측정된 여유가 없으면 한 번에 하나만 실행한다.
- 외부 worker 결과는 전체 원시 대화보다 작업 계약, 변경 diff, 검증 결과, 길이가 제한된 보고서로 회수한다. 원시 로그는 실패 분석에 필요할 때만 읽는다.
- 단계가 끝나면 사용이 끝난 subprocess와 보조 서버를 종료하고, 성공한 임시 작업 공간만 안전하게 정리한다. 실패하거나 변경이 남은 작업 공간은 자동 삭제하지 않는다.
- 최적화 완료 여부는 설정값이 아니라 재시작 후 프로세스 수와 전후 자원 사용량으로 검증한다.

### 로컬 AI 작업 자원 예산

- GPT는 Chrome에서 활성 탭 2~3개까지 사용한다. 완료된 탭만 닫고 진행 중인 탭은 유지한다.
- Codex 구현 소유자는 한 번에 하나로 유지한다.
- DeepSeek에는 대용량 작업을 맡길 수 있지만, 같은 저장소에서는 한 번에 하나의 worker만 실행한다.
- DeepSeek 결과는 전체 대화가 아니라 작업 계약, diff, 검증 결과, 800단어 이하 보고서로 회수한다.
- Serena는 기본 비활성화하고 GDScript 심볼·호출 관계 탐색이 필요할 때만 켠다.
- DeepSeek 작업은 `collect → verify → cleanup`을 마친 뒤 다음 worker를 시작한다.

## 3. 최소 구현 사다리

1. 이 변경이 현재 Issue와 플레이어 경험에 필요한가?
2. 같은 기능·문구·helper가 저장소에 이미 있는가?
3. Godot node, container, signal, JSON 흐름으로 해결되는가?
4. 이미 로드된 프로젝트 구조로 해결되는가?
5. 가장 작은 diff가 올바른 공통 경로에 놓이는가?

작은 diff가 잘못된 위치의 증상만 가리면 채택하지 않는다. 저장 손실 방지, 입력 검증, 오류 처리, 접근성, 사용자의 명시 요구는 삭제 대상이 아니다.

## 4. Active context capsule

긴 탐색 결과는 아래 형태로 줄여 다음 단계에 넘긴다.

```md
## Active Context
- Goal:
- Player value:
- Decisions:
- Scope:
- Excluded:
- Files:
- Risks:
- Next verification:
```

반드시 보존:

- 최신 사용자 결정과 현재 MVP/Issue
- 정확한 파일 경로, scene path, command, version, id
- 재현 증상, 실패 원인, 마지막 검증 결과
- 저장/호환성/보안 위험
- 다음 실행 명령과 미완료 항목

줄일 것:

- 이미 GitHub 문서에 저장된 전문
- 같은 결론을 반복하는 Goal·Issue·보고 문구
- 적용하지 않은 대안의 장문 설명
- 성공한 tool call 목록과 전체 raw log
- 이전 MVP의 완료된 세부 작업

compact 시점:

- 조사 → 계획
- 계획 확정 → 구현
- 디버깅 완료 → 다음 기능
- MVP 완료 → 다음 MVP

부분 구현, 저장 스키마 변경, 재현 중인 버그 한가운데서는 context를 줄이지 않는다.

## 5. 작업 프롬프트 형식

```md
# Goal
한 문장 목표와 플레이어 가치

## Evidence
Issue, 규칙, 실제 파일, 필요한 외부 근거

## Scope
수정할 동작과 파일

## Excluded
추가하지 않을 기능, 데이터, 리팩터링

## Constraints
Godot 4.7, PC/Steam, 저장 호환성, 기존 흐름

## Completion
조건 → 행동 → 관찰 결과

## Verification
headless, 변경 scene, 수동 플레이 경로

## Report
변경 파일, 이유, 검증, 미검증, 위험
```

Issue와 공통 규칙에 이미 있는 설명은 반복하지 않는다. Goal에는 구현자가 지금 판단해야 할 결정만 남긴다.

## 6. 설치·권한 사전점검

외부 skill/plugin/hook/MCP 설치 전 확인:

- 읽고 쓰는 로컬 경로
- 실행하는 script와 subprocess
- 호출하는 외부 host/API
- API key, cookie, token 사용 여부
- 자동 commit/push/post 여부
- 원본 파일 overwrite와 backup 정책
- 제거/rollback 방법

사용자가 설치까지 요청하지 않았다면 구조와 원칙만 반영한다. 이번 검토에서는 새 플러그인과 의존성을 설치하지 않는다.

## 7. 완료 검증

- Godot 프로젝트: project headless → 변경 scene 직접 실행 → 해당 플레이 경로 수동 확인 순서.
- 문서 작업: 경로·링크·SHA·읽기 순서·중복 규칙을 확인한다.
- GitHub 작업: 대상 저장소·branch·commit을 다시 읽어 실제 반영을 확인한다.
- 실행하지 못한 검증은 통과로 쓰지 않는다.
- 최종 보고는 결과, 변경 이유, 검증 근거, 미검증, 남은 위험 순으로 쓴다.
