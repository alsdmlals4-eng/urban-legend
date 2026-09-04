이 파일이 프로젝트 고유 값·경로·보호 요구·명시 승인과 관련
→ 이 파일과 프로젝트 정본이 우선

외부 process framework가 실행 절차를 추가
→ EXTERNAL_PROCESS_OVERLAY로만 합성
→ 프로젝트/Base 정본 권한은 획득하지 않음
```

v4.4에서 관찰했던 Base 구조·Skill 수·Action pin·릴리스 상태는 역사적 증거다.
v4.5는 그것을 현재 사실로 하드코딩하지 않는다.

현재 v4.5 작성 시점에 관찰한 Base `main`:

```yaml
base_main_observed:
  sha: 7ce3fb64fa6303c5da6c7fc27c979f7233b761ac
  meaning: HISTORICAL_OBSERVATION_ONLY
  use_as_permanent_authority: false
```

매 작업 시작 시 실제 Base `main`을 다시 조회한다.

### 0.1 지시 범위 경계 — 문서 작성과 실제 실행을 분리

이 작업지시문을 작성·갱신하는 요청에서는 **지시문 범위를 넘어 실제 저장소·PR·Base·Godot·PowerShell·Codex 작업을 실행하지 않는다.**

```yaml
instruction_authoring_request:
  may_edit_instruction_document: true
  may_research_and_compare: true
  may_inspect_attached_or_explicitly_requested_sources: true
  may_execute_project_build_or_repo_mutation: false
  may_merge_or_close_prs: false
  may_run_powershell_codex_godot: false
```

실제 실행은 사용자가 별도의 실행 요청을 하거나, 이 계약의 실행 단계에 명시적으로 진입했을 때만 허용한다.

### 0.2 프로젝트 작업 순서 — 절대 순서

프로젝트의 정상 작업 순서는 다음 세 단계다.

```text
PHASE A — GPT CHAT PLANNING
1. 게임 세부기획서 작업구조 개선
2. 기획 작업
3. 필요한 이미지 생성·검토
4. Grill Me로 기획 충돌 승인
5. 주요 승인 Decision을 GitHub 정본·계획 데이터·연결 Google Sheet에 즉시 동기화
6. 최대 10건 승인 배치마다 planning/document PR 검수·적대적 검토·필요시 병합
7. 사용자와 함께 기획 전체를 닫음

USER GATE
→ 사용자가 명시적으로 “기획 완료” 선언

PHASE B — FINAL PLANNING REVIEW
8. 전체 기획 정본 재조회
9. 기능 단위 분해
10. 이미 반영됨 / 현재에도 유효 / 충돌·구형 분류
11. 벤치마킹·현업 비교
12. 작업순서·의존성·보호범위 최종 확정
13. 적대적 검토·브레인스토밍·Superpowers 검증
14. 구현 패키지 Definition of Ready 닫기

PHASE C — POWERSHELL / CODEX / GODOT BUILD
15. PowerShell에서 Codex 실행
