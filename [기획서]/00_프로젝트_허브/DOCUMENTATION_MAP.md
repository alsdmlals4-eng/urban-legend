# Urban Legend Documentation Map

## 기본 읽기

`START_HERE → ACTIVE_CONTEXT → 이 표의 본책 → 등록 부록 → 실제 파일/테스트`

운영체계 이주 계약·보존 기준선은 `BASE_SYNC_AUDIT.md`, 사용자 확인은 `INTERVIEW_REGISTRY.json`과 `INTERVIEWS/`, 실행 계약은 `EXECUTABLE_PROMPTS/`에서 찾는다.

| 질문 | 책임 원본 |
|---|---|
| 프로젝트 전체 방향·금지 범위 | `00_프로젝트_종합_책임_원본.md` |
| 설정·사건·대화·콘텐츠 | `../01_설정_내러티브/01_설정_내러티브_본책.md` |
| 조사·선택·미니게임·캠페인 | `../02_게임_디자인/02_게임_디자인_본책.md` |
| UX·UI·접근성 | `../03_UX_UI_접근성/03_UX_UI_접근성_본책.md` |
| Godot·저장·Scene·데이터 | `../04_개발_엔지니어링/04_개발_엔지니어링_본책.md` |
| import·자산 파이프라인 | `../05_테크니컬아트_콘텐츠_파이프라인/05_테크니컬아트_콘텐츠_파이프라인_본책.md` |
| 아트 | `../06_아트/06_아트_본책.md` |
| 사운드 | `../07_사운드/07_사운드_본책.md` |
| 자동·수동 QA와 캡처 | `../08_QA/08_QA_본책.md` |
| Roadmap·Issue·위험·인수 | `../09_프로덕션_PM/09_프로덕션_PM_본책.md` |
| 참고 사례·리서치 | `../10_분석_유저리서치/10_분석_유저리서치_본책.md` |
| 이주·발행·최종 게이트 | `../11_통합검수/11_통합검수_본책.md` |

Registry는 `DESIGN_DOCUMENT_REGISTRY.json`, `SKILL_REGISTRY.json`, `ASSET_REGISTRY.json`이 원본이다. 과거 원문은 `[백업]`, 재개 조건이 있는 미결 제안은 `[보류]`로 라우팅하며 활성 지시로 해석하지 않는다.

## 전역 productivity 경계

`SKILL_REGISTRY.json`의 `global_productivity`는 Base `d2457e75a856260d309203e20262f2a2142d2dd6`와 `Base:skills/PRODUCTIVITY_SOURCE_MANIFEST.json`을 가리킨다. productivity 스킬을 이 저장소에 복사하지 않는다. 프로젝트 상태는 `ACTIVE_CONTEXT.md`와 프로젝트 `HANDOFF.md`, 임시 대화 인수인계는 전역 `handoff`, 이전 세션 재개는 전역 `resume-work`를 사용한다.
