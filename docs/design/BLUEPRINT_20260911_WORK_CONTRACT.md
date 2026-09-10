# 사람용 통합 블루프린트 제작 계약

상태: IN_PROGRESS / FINAL_USER_REVIEW_PENDING / NO_GAME_IMPLEMENTATION

현재 산출: 46쪽 통합 검토 PDF, 편집 가능한 본문·사건 부록, 신규 자산 후보11개(배경4/직원3/루메3/UI패널1), Aseprite 직원 정적atlas PNG+JSON. 이것은 전체 자산/상태 제작 완료가 아닌 부분 제작 snapshot이다. `REMAINING_WORK_COMPLETION_GATE: NOT_COMPLETE`; 게임 적용·최종 승인 없음.

## 의도·승인

2026-09-11 사용자는 십보강호 92쪽 PDF의 구조만 참고해 괴이기록국: 잔향 보고서의 상세 기획·검토·실사용 이미지 후보·아틀라스·데이터·구현 명세를 준비하도록 승인했다. 이미지 건별 승인 대기는 이번 배치에 적용하지 않지만 최종 채택·런타임 적용은 최종 블루프린트 승인 이후다. 신규 유료 API·설치·강제 병합은 이 권한으로 추론하지 않는다.

## 입력과 판단

- 프로젝트 AGENTS, START_HERE, 운영 모델·문서 지도·Base v9.4.4 pin, master GDD/canon/overlay/handoff, 2026-09-10 일상-사건 설계 §9-11, 실제 main과 open PR을 fresh-read했다.
- 기준 main: c82291101bf0a2bb4d821a12bca9f14070ee2886. 작업 브랜치 선행 문서: 8225a48eb3a54fbe3f6b63d9e51dd9f6cbb1063d. 미커밋 코드·import·UID는 보호한다.
- 예시 PDF는 화면 아틀라스·SWOT·시스템 관계·화면 입출력·상세 데이터·구현 이해/검증 구분을 REFERENCE_ONLY로 사용한다. 무협 규칙·수치·인물·이미지는 채택하지 않는다.
- 기존 프로젝트 이미지와 10게임 연구는 REUSED_EVIDENCE/REFERENCE_ONLY다. 사용자 요청대로 새로운 실사용 후보를 만들며 기존 승인 자산을 삭제/교체하지 않는다.
- Base pin은 유지. 오래된 Notion 동기화·한 후보 뒤 정지 규칙보다 프로젝트 repository-only 및 최신 사용자 배치 제작 지시가 우선한다.
- 설계 수준 Architectural, 주 모드 PLAN → 문서/자산 BUILD → REVIEW. 게임 BUILD는 제외. 프로젝트 게임디자인/system-design, PDF 제작/검수, imagegen, Aseprite candidate 도구를 단계별 적용한다.

## 산출물·완료 기준

1. 화면 아틀라스부터 읽는 한국어 PDF와 수정 가능한 본문 source.
2. 핵심 경험·상세 SWOT/강화/보완·벤치마크와 차별성 가설.
3. 일상→조사→매뉴얼→구출→회수→결과 흐름, 화면별 상태·입력·실패·복귀.
4. 기존 사건 ID/원본 기록/키워드/현장 행동의 연결 표, 데이터 스키마와 저장 호환 규칙.
5. 실사용 후보 원본·규격·alpha·planned consumer·필요 상태·모션·아틀라스·provenance 목록.
6. 승인 이후 순서·수정 경로·acceptance·회귀·롤백이 있는 구현 패킷.
7. PDF 페이지 렌더 확인, 텍스트/필수 항목/경로 검증, 파일 해시와 증거 영수증.

전체 제작 가능성과 현재 구현을 분리한다. 미생성 필수 자산, 불명확한 핵심 규칙, 누락된 소비자가 있으면 IMPLEMENTATION_READY라고 선언하지 않는다. 시장성·재미·접근성·runtime·출시 권리는 실행 증거 없이 PASS로 쓰지 않는다.

## 구조 비교

- 기존 PDF에 부록만 추가: 역사 보존은 좋으나 폐기된 일정을 사람이 현행으로 오인할 위험. REJECT 이번 전달물.
- 예시 92쪽을 그대로 복제: 분량은 비슷해도 이 게임의 추리/구출 인과와 맞지 않음. REJECT.
- 새 통합 편집판 + 기존 정본/구현 차이 부록: 채택. 이전 PDF는 그대로 보존하고 신규 승인 후보로 명확히 분리한다.

## 작업 순서와 보호

정본/예시 감사 → 외부 1차 조사 및 구체 사건 대조 → 문서/화면/자산 필요 매핑 → 실사용 후보 생성과 QA → 상세 본문·데이터·구현 명세 → PDF 조판/렌더 → 누락/반례 검토·교정 → 명시적 파일만 Git 동기화.

원본 및 제품 assets/scripts/scenes/data, 기존 Draft PR 359/360/361/287/231은 read-only. 후보는 프로젝트 .asset-vault 아래 둔다. PDF와 source는 project-owned 경로이며 Notion이나 외부 문서 저장소는 만들지 않는다. 롤백은 이번 문서·후보·생성기 변경만 Git/receipt로 되돌린다.

## 수행·검증 영수증

- PDF: `output/pdf/URBAN_LEGEND_HUMAN_BLUEPRINT_20260911_REVIEW.pdf`; exact PDF/source/asset hashes, 실제 크기·alpha·planned consumer·최종 승인 상태는 동 폴더 `BLUEPRINT_20260911_RECEIPT.json`이 소유한다.
- `tools/validate_blueprint_20260911.py`: 문서 필수항목·PDF/source/PNG hash·인물6개 RGBA/투명 모서리·아틀라스3개region·본문/표 footer 경계 검사 PASS. 이것은 alpha edge 전체 미술 합격이나 runtime 검사가 아니다.
- 기존 `tests.test_runtime_aligned_human_blueprint` 4개 PASS. 과거 정렬 문서 라우터가 보존되는 좁은 회귀 검사이며 신규 게임 설계 구현 검사가 아니다.
- PDF 1차 조판과 전체47쪽 렌더에서 빈 continuation 페이지, Unicode 음수 부호 표시, 아틀라스 라벨 간격을 발견·교정했다. 최종46쪽의 변경 페이지34~46을 다시 렌더해 점검했다. 앞부분1~33쪽은 직전 전체 렌더 검토 이후 내용·배치 변경이 없다. 최종 페이지 번호와 표 경계·부록·찾아보기를 확인했다. 문서 렌더/정적 PASS와 사용자 가독성/게임 UX 승인은 구분한다.
- 별도 문서 검토2회: 미니게임 순서, 현장 읽기전용, 누적/잔여시간, 가짜 관측수 강제, 플레이어 의도 자동 추정, 축약ID, 무료 접근성과 구매 편의의 경계를 교정했다. 자산·모션 미완성이 남으므로 전체 `CLEAN_REVIEW_EXIT`는 선언하지 않는다.
- fresh origin/main은 c82291101bf0a2bb4d821a12bca9f14070ee2886으로 재확인. unrelated Draft PR은 읽기 전용. 게임/runtime/Human/accessibility/rights/release 검증은 NOT_RUN.

## 실패·교정·재사용 학습

1. Aseprite add_frame은 기존 cel을 복제했다. 인물별 원본을 순서대로 가져오며 프레임을 늘리면 인물이 겹친다. 빈3프레임을 먼저 만들고 각 cel에 가져와 새atlas로 내보냈으며 실제 미리보기·region을 재확인했다. 서로 다른 인물 프레임을 애니메이션이라고 부르지 않는다.
2. 이미지 편집 결과가 실제alpha가 아닌 RGB 체크무늬였다. 같은 파일 재편집도 실패해 두 후보를 실사용에서 제외했다. 조건을 유지한 신규 생성으로 RGBA 후보를 확보했다. 투명도는 확장자/미리보기만으로 판단하지 않고 mode/alpha/밝은 배경 합성까지 구분한다.
3. UI panel은 모델이 흰 여백을 붙여 출력했다. Aseprite crop으로 제품 후보 영역을 분리했으며 원본을 보존했다. source와 같은 stem의 export가 보호 검사에 걸려 새 출력명으로 내보냈다. 우회 CLI는 쓰지 않았다.
4. 한국어 PDF에 Unicode minus가 공백처럼 표시돼 숫자 의미가 바뀌었다. 파생 PDF만 ASCII minus로 정규화하고 음수 텍스트 추출 검사를 추가했다. 원본 게임 수치는 바꾸지 않았다.

재사용 모드는 REUSE(기존 사건/연구) + ADAPT(PDF 구조/시계/공식 pause/atlas)다. 위4개는 Base 승격 **후보**이며 Base 규칙·공용skill 수정/승격은 수행하지 않았다. 아직 다른 프로젝트 검증이 없어 강제 규칙으로 확정하지 않는다.

## 남은 작업과 보호 경계

1. 괴이·피해자·전조의 사건별 상태 자산, 직원/루메 동작·표정, 최종 타이포와 필요 UI 상태군 제작·검토.
2. 인물 데이터 전문성 vs 사용자 참고 외형의 최종 표현 정합성, 루메 의상별 비례·pivot 정렬, 세 사건의 전체 합성 화면 검토.
3. M07 후보 세트/미니게임 행동 계약과 사건별 대가/복귀의 완전한 구현 입력 확정. 본문은 현재값·제안값·미구현을 구분하며 임의 완료를 주장하지 않는다.
4. 모든 필수 준비가 완료된 후 최종 사용자 승인. 그 전 게임 코드 적용·자산 canon 승격·Draft 병합 없음.
5. PDF/source/receipt는 명시적 작업브랜치로 동기화한다. 승인 전 원본 PNG/aseprite는 project-local `.asset-vault`이므로 원격 원본 보관 완료가 아니다. 최종 자산 승인 후 계약에 따라 project-controlled tracked 경로로 승격한다.
