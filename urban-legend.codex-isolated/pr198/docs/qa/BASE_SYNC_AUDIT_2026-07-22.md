# Base 동기화·Skill 최적화·적대적 감사 — 2026-07-22

## 기준과 사용 Skill

- Base: `alsdmlals4-eng/Base@41a20584dd2ee51d917e5c9d7cab6838e1ceba7e`.
- Registry blob: `14950c9361b3c939990560ae8cc683a936633e89`.
- 대상: urban-legend PR #46.
- 실행: `PLAN → BUILD → REVIEW`.
- 핵심 Skill: 코어 판정, Skill 통합, 가지치기, 본문 간소화, 행동 보존 리팩토링, 적대적 검토, 변경 검증, 정본 최신성 감사.

## 최신 Base 대조

이전 pin 이후 6개 커밋의 전체 diff와 변경된 운영 원본·25개 Registry·새/축약 Skill 패키지·reference·Coverage·상시 테스트를 대조했다. 이전 13개 기능을 유지한 채 프로젝트 코어·적대적 검토와 9개 독립 책임이 추가됐으며, Base는 최종 25개 활성 Skill과 18개 Coverage 책임을 가진다.

## 통합 전 기능 보존표

| 기능 | 처리 | 보존 위치 |
|---|---|---|
| Base 25개 trigger·경계 | KEEP | `BASE_SKILL_INDEX.json` + 원격 고정 전문 |
| Base 18개 공용 책임 | KEEP | `BASE_SKILL_COVERAGE.json` |
| 프로젝트 분야 10개 | KEEP·SIMPLIFY | 각 compact `SKILL.md` |
| 공통 DoR·DoD·보고 | MERGE | `PROJECT_DISCIPLINE_CONTRACT.md` |
| 프로젝트 코어 경계 | ADD | `PROJECT_CORE.md` `IDENTIFIED` |
| 통합검수 중복 ID | ALIAS | 기존 Legacy Alias |
| Base 커밋 다중 문서 복제 | PRUNE | `BASE_RULES_VERSION.md` 단일 사람용 원본 |
| Base 전체 Skill 본문 로컬 복제 | REJECT | 필요 패키지만 원격 고정 참조 |
| GDD PDF·Manifest 강제 | DEFER | 기존 Markdown→DOCX 유지 |

## 적대적 finding과 판정

1. **HIGH / MUST_FIX — 최신 Base drift**: PR #46이 13개·이전 커밋을 완전성 기준으로 사용했다. 25개·새 blob·Coverage로 갱신.
2. **HIGH / MUST_FIX — 다중 pin 원본**: 여러 문서에 커밋을 복제해 갱신 누락이 재발했다. 사람용 원본을 Base Version으로 단일화하고 기계 pin만 Registry·Index·Adapter에 유지.
3. **MEDIUM / MUST_FIX — Registry 책임 혼합**: Base 전체 메타데이터와 프로젝트 계약이 한 파일에 있어 drift와 리뷰 비용이 컸다. Base Index·Coverage로 분리.
4. **MEDIUM / SHOULD_FIX — 프로젝트 Skill 반복**: 10개 본문의 공통 실행 구조를 공유 계약으로 이동하고 고유 기능은 본문에 유지.
5. **HIGH / MUST_FIX — 코어 검수 기준 부재**: 불변 규칙은 있었지만 구조 개선의 제거·대체 기준이 한 문서로 없었다. `PROJECT_CORE` IDENTIFIED 추가.
6. **REJECT — 분야 Skill 추가 합병**: 10개는 입력·산출물·도구·검증 경계가 달라 합치면 오라우팅과 기능 손실이 발생한다.
7. **DEFER — 코어 확정과 발행 v3**: 사용자 전문 승인과 별도 발행 범위가 필요하다.

## 간소화 원칙

각 프로젝트 Skill은 목적·경계·mode·read-first·고유 workflow·done/failure·지원 라우팅을 본문에 남겼다. 공통 DoR·DoD·보고·구조 개선 계약만 한 단계 공유 문서로 이동했다. 빈 라우터나 거대 reference를 만들지 않았다.

## 자동 검증

- Base commit·blob·25개 ID·선택적 로드.
- 18개 Coverage 책임과 ACTIVE target.
- 프로젝트 Registry↔10개 패키지 1:1.
- 공유 계약 연결, compact body, 고유 mode·원본·기능 토큰.
- trigger 중복·대표 routing·지원 Skill 존재.
- 프로젝트 코어 상태·불변 용어·보호 경로.
- GDD 발행 호환·Legacy Alias·진입점·오래된 pin 잔존.

## 범위

게임 코드·데이터·Scene·자산·저장 Schema는 변경하지 않는다. Godot headless·수동 플레이는 `NOT_RUN — runtime scope unchanged`이며 자동 PASS가 아니다.

## 최종 게이트

현재 PR head의 두 unittest와 GitHub Actions 성공, changed-file 전수검사, 삭제·rename·보호 게임 경로 0건, PR 설명과 실제 증거 일치를 모두 요구한다.
