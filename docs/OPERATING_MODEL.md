# Urban Legend 운영 모델

## 책임과 읽기

권한·current-authority 순서는 `AGENTS.md`가 소유한다. 현재 결정은 `docs/CURRENT_DECISION_OVERLAY.md`, 다음 행동은 `docs/CURRENT_HANDOFF.md`, 기획은 `docs/CURRENT_PLANNING_CANON.md`와 `docs/current-planning-canon.json`이 소유한다. 이 문서는 그 값·게임 일정·완료 SHA를 복제하지 않는다.

채택 Base는 `docs/BASE_RULES_VERSION.md`와 `skills/PROJECT_BASE_ADAPTER.json`에서 확인한다. released lock과 최신 운영정책의 선택 적용은 별개다. `skills/PROJECT_PATH_ADAPTER.json`은 생성된 역사 호환 뷰이며 현재 Active Context를 결정하지 않는다.

## 승인과 연속 실행

| 요청/상황 | 행동 |
|---|---|
| 읽기 전용 조사·상태·검토 | 관련 정본·실제 증거 확인 후 답변. 수정·새 실행 문서·승인을 만들지 않음 |
| 새 변경 | 의도·현재 상태·변경/보호·방법·완료/검증을 설명하고 승인 |
| 유효한 같은 계약의 승인·“진행해” | `REUSED_APPROVAL`; 남은 구현·수정·검증·정상 PR·readback을 계속 |
| 기술적 선택·범위 안 결함 | 정본·테스트로 최소 안전안을 판단하고 기록 |
| 새 핵심 방향·주요 UX·비용·보안·파괴적 변경 | 바뀐 부분만 사용자 결정 |
| 필요한 원문 접근 실패 | `SOURCE_DEPENDENCY_SCOPED_BLOCKER`: 의존 작업은 `BLOCKED_UNVERIFIED`; 원문을 추정하지 않음 |
| 독립 승인 작업이 남음 | source·consumer·승인·검증을 재결합해 계속. 전체 중단 지시 또는 모두 같은 자료에 의존하면 중단 |

같은 계약의 승인·계획·벤치마크·검토 예산은 Base/설치 Skill/단계 간 공유한다. 긴 작업을 작은 검증 단위로 나누되 첫 조각만 끝내고 전체 승인 범위를 완료했다고 하지 않는다.

## 재사용·선택·조사

현재 구현·승인 자산 → 관련 Base 사례/방법 → 직접 관련된 검증 사례 → 필요한 외부 원출처 순으로 비교한다. 동일 범위의 유효한 근거는 `REUSED_EVIDENCE`다. 중요한 새 설계·정책 결정만 최소 3개 실질 대안을 비교한다. 단일 정답 수정·승인된 구현에 허수 대안을 만들지 않는다.

Skill 선택은 `docs/WORK_MODE_AND_SKILL_ROUTING.md`를 따른다. 외부 AI/DeepSeek 위임은 실제 필요·허용된 도구·비용·쓰기 경계가 모두 확인될 때만 선택한다. 설치 스킬의 일괄 위임 문구가 새 권한을 만들지 않는다. 설치 파일·전역 설정은 프로젝트 규칙 정비로 변경하지 않는다.

## 구현·표현·재미의 경계

코어와 사건 의미는 `docs/PROJECT_CORE.md` 및 현재 승인 기획을 보호한다. 표시 계층이 판정·정답·저장을 새로 소유하지 않는다. 플레이어 경험에 영향을 주는 변경은 `docs/UX_UI_SYSTEM.md#experience-verification`에서 경험 가설과 반증을 실제 파일·상태·피드백·검증에 연결한다.

기획·기능·아트 문서 존재는 게임 구현이나 재미 증거가 아니다. 사람 검수 미실행이 이미 승인된 구현 전체를 막지는 않지만 사람 경험·최종 자산·출시 승인으로 승격하지 않는다.

## 검증과 검토

1. 변경된 계약·실제 consumer·실패 경로에 맞는 검사를 먼저 선택한다. 운영 문서·Skill 작업은 링크/라우팅/무결성과 `python -m pytest tests -q` 또는 `python -m unittest discover -s tests -p 'test_*.py'`를 사용한다. 보존된 중첩 저장소까지 무차별 수집하지 않는다.
2. Godot 실행·화면·저장 왕복은 그 consumer에 영향이 있을 때 필요하다. 순수 운영문서 수정에 엔진 실행·이미지 생성·PDF 발행을 강제하지 않는다. 저장·UI 변경의 해당 검증을 생략하는 예외는 아니다.
3. 전체 적대 검토는 승인 계약 전체에서 **정확히 2회** 공유한다. 공격→근거 검증→필수 교정→회귀를 기록하며 단계별로 초기화하지 않는다. 이후 새 finding은 영향 교정·회귀로 처리한다. 독립 검토는 작성자 자체 검토와 구분한다.
4. 승인 범위의 필수 누락·퇴행·미해결 지적을 다시 계산한다. `CLEAN_REVIEW_EXIT`는 유효 blocking finding이 없고 acceptance를 충족할 때만 사용한다.
5. 원격 필수 검사·독립 검토·미해결 논의·정확한 HEAD를 확인한 current-task PR만 정상 병합한다. 실패 검사·다른 PR을 우회하지 않는다. 병합 후 새 main과 변경 파일·검증·남은 작업을 다시 읽는다.

## 기록·보고·보존

현재 변경/근거/미검증/다음 행동은 기존 Decision/Handoff에 짧게 남긴다. 월별 작업일지는 같은 문서에 날짜별 누적하며 새 버전·새 보고서를 매 작업마다 만들지 않는다. 상세 증거는 기존 검사/작업 기록으로 연결한다.

결과 → 바뀐 점과 이유 → 확인 방법 → 실제 검사와 미검증·남은 위험 순으로 한국어 보고한다. 고정 장문 양식을 강제하지 않는다. `DOC / MACHINE / RUNTIME / HUMAN / USER_APPROVAL / MERGE / RELEASE`는 구분한다.

중복 지침은 책임 원본으로 통합하지만 고유 결정·승인 자산·실패 증거·역사 호환 입력은 보존한다. 삭제 후보는 실제 참조와 복구 가능성을 확인해 사용자 직접 삭제 방식으로 안내한다. 학습은 `skills/SKILL_LEARNING_LOG.md`에 필요한 것만 누적하며, 공용 후보 발견만으로 Base 승격을 주장하지 않는다.
