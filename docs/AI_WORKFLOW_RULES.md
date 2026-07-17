# AI Workflow Rules

## 멀티모델 위임

토큰 효율형 작업 분류, 최소 입력 묶음, 공급자별 산출물, 실패 인수와 20건 측정은 `docs/AI_DELEGATION_WORKFLOW.md`를 따른다. 대사는 `docs/DIALOGUE_AUTHORING_WORKFLOW.md`, 이미지는 `docs/IMAGE_ASSET_WORKFLOW.md`를 추가 적용한다. 보호 경로와 실제 적용·검증은 항상 Codex가 소유한다.

## 대사 작업 전용 경로

대화문, 튜토리얼 안내문, 상황별 반응문 수정은 `docs/DIALOGUE_AUTHORING_WORKFLOW.md`를 따른다. 외부 GPT가 `dialogue_rewrite.patch`와 `dialogue_review.md`를 만들고, DeepSeek가 읽기 전용으로 구조·설정·미확보 정보 누설을 검수한 뒤, Codex가 실제 diff 확인과 최소 검증을 담당한다. Codex와 내부 하위 에이전트는 대량 대사 초안 작성의 기본 경로가 아니다.

> **Base 기반 로컬 사본 + 도시괴담 기록국 확장**: 공용 흐름의 원본은 [`alsdmlals4-eng/Base`](https://github.com/alsdmlals4-eng/Base)이며, 이 문서는 현재 프로젝트의 ChatGPT, HTML, Goal 작업 규칙을 덧붙인다. 기준 커밋은 `docs/BASE_RULES_VERSION.md`에 기록한다.

`AGENTS.md`의 기본 규칙이 항상 우선한다.

반복 규칙은 아래 문서에 나누어 둔다.

- `docs/CODEX_SHARED_WORK_RULES.md`: Codex 공통 구현 규칙, Serena, 보고 형식
- `docs/AI_SHARED_WORK_RULES.md`: 새 프로젝트에도 복사 가능한 공용 AI 작업 원칙과 DoR/DoD
- `docs/AI_SKILL_ADOPTION_GUIDE.md`: 외부 스킬 최소 라우팅, 권한 사전점검, context compact 기준
- `docs/MVP_WORKFLOW_CHECKLIST.md`: 작업 순서, 시작/종료 체크리스트, 좋은 프롬프트 변환, HTML/Issue/Goal 체크리스트
- `docs/BENCHMARKING_REFERENCE_GUIDE.md`: 벤치마킹 기준과 표 형식

---

## 0. 최우선 고정 규칙

모든 작업은 실제 수정, Issue/Goal/문서 작성, 검수 보고 전에 아래 순서를 먼저 따른다.

1. **프로젝트 로컬 Base 사본 확인**
   - `docs/BASE_RULES_VERSION.md`
   - `docs/AI_SHARED_WORK_RULES.md`
   - `docs/AI_WORKFLOW_RULES.md`
   - `docs/AI_SKILL_ADOPTION_GUIDE.md`
   - `docs/MVP_WORKFLOW_CHECKLIST.md`
   - `docs/BENCHMARKING_REFERENCE_GUIDE.md`
2. **GitHub Base 원본은 필요한 작업에서만 확인**
   - Base 동기화, 공용 규칙 승격, 사용자 명시 요청, 기준 차이 확인에서만 원격 원본을 읽는다.
   - Base 원본과 로컬 사본이 다르면 차이와 적용 결론을 기록한다.
3. **프로젝트 전용 규칙 확인**
   - `AGENTS.md`
   - `docs/CODEX_SHARED_WORK_RULES.md`
   - `docs/DOCUMENTATION_MAP.md`
   - 현재 Issue / MVP 기준선
4. **필요한 근거와 스킬 라우팅**
   - 기획·UX·시장·새 시스템 작업은 관련 벤치마킹을 수행한다. 이미 확정된 구현은 고정 참고와 충돌 여부만 확인한다.
   - 벤치마킹 결과는 개선점/수정점으로 압축한다.
   - Issue/문서에는 필요한 맥락만 반영하고, Codex Goal에는 실행에 필요한 지시만 남긴다.
   - 외부 스킬은 `docs/AI_SKILL_ADOPTION_GUIDE.md`에 따라 최소 라우팅하고 설치 전 권한을 확인한다.
5. **사용자 요청을 좋은 프롬프트로 변환**
   - 사용자의 짧은 요청을 그대로 실행하지 않는다.
   - 작업 전 반드시 목표, 배경, 사용자 의도, 플레이어 경험, 벤치마킹 개선점/수정점, 구현 범위, 제외 범위, 데이터 요구사항, Godot 영향, 완료 기준, 테스트 방법, 결과물 형식을 정리한다.
6. **변환된 작업 범위를 기준으로 진행**
   - Issue, HTML, Goal, 문서, 구현 검수는 변환된 작업 범위와 제외 범위에 맞춰 진행한다.

사용자가 범위와 완료 기준을 이미 제공했다면 질문을 반복하지 않고 이해한 작업 프롬프트를 짧게 공유한 뒤 진행한다.

---

## 1. 프로젝트 플랫폼 기준

현재 `도시괴담 기록국`의 1차 출시 목표는 **PC 기준 Steam 출시**다.

UI/UX 판단은 기본적으로 다음을 우선한다.

- PC 16:9 화면
- 마우스/키보드 입력
- Steam 데모/상점 페이지에서 이해되는 첫인상
- 창 모드와 전체화면에서 모두 읽히는 정보 위계
- 패드 대응은 후순위 검토
- 모바일 세로 화면 최적화는 별도 요청이 있을 때만 범위에 포함

---

## 2. 고정 벤치마킹 링크

매 작업에서 아래 링크를 먼저 확인한다.

1. Unity Asset Store
   - `https://assetstore.unity.com/ko-KR?srsltid=AfmBOoqVvQhMXSGdC4kGuQE4OgvNyuvG7CaIQqlUdoY1qXryac39ZLi0`
   - 확인 항목: 에셋/템플릿/툴 패키징, UI 키트 구성, 상점형 정보 구조, 기능 소개 방식.
2. Tales of Tuscany Demo
   - `https://athenian-rhapsody.itch.io/tales-of-tuscany-demo`
   - 확인 항목: 데모 소개, Steam 위시리스트 유도, 핵심 기능 소개, 개성 있는 선택지/미니게임 표현, 플레이어 반응.

고정 링크의 결과는 장문으로 복사하지 않고, 개선점/수정점/적용 여부로 압축한다.

---

## 3. ChatGPT 표준 작업 순서

기획, Issue 작성, Codex Goal 작성 전에는 다음 순서를 따른다.

1. 작업 유형 분류
2. 사용자 최신 지시 확인
3. 프로젝트의 Base 로컬 사본 확인
4. 필요한 경우 GitHub Base 원본 확인
5. 프로젝트 전용 규칙과 스킬 라우팅 확인
6. 현재 MVP / Issue 기준선 확인
7. 벤치마킹 수행 및 개선점/수정점 도출
8. 좋은 프롬프트 변환
9. 작업 준비 상태 체크
10. Definition of Ready 확인
11. 구현 범위 / 제외 범위 확정
12. 위험 분석 / 영향 파일 예상
13. 필요한 Issue/Goal/문서 갱신. 처음 보는 사용자가 읽는 활성 기획서는 `docs/DOCUMENTATION_MAP.md`의 다섯 문서뿐이며, 작업은 관련 문서를 갱신하거나 변경 없음 사유를 남긴다.
14. 구현 또는 검수
15. Godot 확인
16. 결과 보고 / 회고
17. Base 승격 후보 여부 판단

세부 체크리스트는 `docs/MVP_WORKFLOW_CHECKLIST.md`를 따른다.

---

## 4. 좋은 프롬프트 변환 규칙

사용자의 짧은 요청을 그대로 처리하지 않는다.

작업 시작 전 반드시 다음을 보강한다.

- 목표
- 배경
- 사용자의 의도
- 플레이어 경험
- 벤치마킹 개선점/수정점
- 구현 범위
- 제외 범위
- 데이터 요구사항
- Godot 씬/노드 영향
- 완료 기준
- 테스트 방법
- 결과물 형식

좋은 프롬프트 변환 결과는 내부 판단으로만 끝내지 않는다. MVP 작업, Issue 작성, Goal 작성, 검수 작업에서는 결과 보고의 `지침 준수 / 작업과정`에 요약해서 표시한다.

---

## 5. 벤치마킹 규칙

벤치마킹에는 `docs/BENCHMARKING_REFERENCE_GUIDE.md`의 표 형식을 따른다.

표 형식:

```md
| # | 게임/사례 | 관찰포인트 | 개선점/수정점 | 기록국 적용(+사유) |
|---:|---|---|---|---|
```

Codex Goal에는 긴 벤치마킹 전문을 넣지 않는다. 필요한 경우 문서 참조와 최종 적용 기준만 넣는다.

---

## 6. HTML 대시보드 규칙

MVP-028부터 HTML 대시보드는 기본 산출물이 아니다. 사용자가 명시적으로 요청한 작업에서만 별도 범위와 검증 방법을 정해 작성한다. 과거 대시보드는 `docs/archive/legacy/urban_legend_flow_dashboard.html`에 보관하며 현재 구현 기준으로 사용하지 않는다.

---

## 7. 결과 보고 규칙

결과 보고는 작업에 해당하는 항목만 포함하고, 실행하지 않은 절차를 목록으로 반복하지 않는다.

```md
## 좋은 프롬프트 변환 요약

- 목표:
- 구현 범위:
- 제외 범위:
- 완료 기준:

## 변경 파일

-

## 검증 / 미검증 / 위험

-

## Base 승격 후보

- 없음 / 후보와 공용화 근거
```

---

## 8. Codex Goal 규칙

- Issue는 전체 기준서, Codex Goal은 실행 지시서로 작성한다.
- Goal은 Issue와 작업 전 확인 파일을 참조하는 **짧은 실행 지시서**로 작성한다.
- Issue 본문에 이미 있는 작업 범위, 제외 범위, 완료 기준은 Goal에 장문 반복하지 않는다.
- 프로젝트 공통 규칙에 이미 있는 내용은 Goal에 반복하지 않는다.
- 로드맵에 이미 정리된 MVP 목록은 Goal에 반복하지 않는다.
- Goal에는 Codex가 실제로 수행해야 하는 작업 순서와 충돌 방지 조건만 남긴다.
- Goal에는 요청하지 않은 HTML 대시보드 수정, 긴 벤치마킹 전문, 장문 세계관 설명을 넣지 않는다.

Goal 압축 기준:

```text
Issue로 대체 가능하면 Issue 번호만 남긴다.
작업 전 확인 파일로 대체 가능하면 파일 경로만 남긴다.
로드맵으로 대체 가능하면 로드맵 참조만 남긴다.
공통 규칙으로 대체 가능하면 규칙 문서 참조만 남긴다.
```

---

## 9. Codex 작업 전 확인 순서

Codex는 작업 시작 전 다음을 확인한다.

1. `AGENTS.md`
2. `docs/AI_WORKFLOW_RULES.md`
3. `docs/CODEX_SHARED_WORK_RULES.md`
4. `docs/MVP_WORKFLOW_CHECKLIST.md`
5. 현재 Issue 본문
6. `README.md`
7. 실제 수정 대상 파일

---

## 10. 우선순위

규칙 충돌 시 우선순위는 다음과 같다.

1. 사용자 최신 지시
2. `AGENTS.md`
3. 현재 GitHub Issue 본문
4. `/goal`
5. `docs/CODEX_SHARED_WORK_RULES.md`
6. `docs/MVP_WORKFLOW_CHECKLIST.md`
7. `docs/BENCHMARKING_REFERENCE_GUIDE.md`
8. 이 문서
9. 과거 대화 요약

---

## 11. 살아 있는 기획서와 최적화 루프

- 활성 게임 설계 원본은 `[기획서]/01_게임기획서.md`다. `docs/GAME_DESIGN_DOCUMENT.md`와 `docs/URBAN_LEGEND_GAME_DESIGN.docx`는 상세 계약·생성 배포 부록이며, GDD를 실제로 수정할 때만 DOCX를 재생성한다.
- 작업 시작 시 실제 구현, 최신 MVP, Issue/Goal, 다섯 활성 기획서·상세 부록의 불일치를 확인한다.
- 작업 종료 시 최신화한 활성 기획서(게임·프로그래밍·아트·사운드·QA), 벤치마킹 결론, 반영한 개선점, 후속 후보, 사용 스킬·도구 효율을 기록한다. 최신 이미지는 아트 기획서와 이미지 인덱스만 원본으로 사용한다.
- GDD를 수정하면 DOCX를 재생성하고 완료 보고에서 두 파일을 사용자에게 모두 보여준다.
- 기획·UX·신규 시스템·시장 판단은 최신 공식 근거를 확인한다. 단순 확정 작업은 기존 근거 유지 여부만 심사한다.
- 큰 단계·MVP 종료 시 GDD 버전·로드맵·테스트 기준을 갱신하고, 5개 MVP마다 문서·참조·스킬·도구 최적화를 감사한다.
