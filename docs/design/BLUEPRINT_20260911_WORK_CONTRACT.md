# 사람용 통합 블루프린트 제작 계약

## 최신 승인/기각과 PDF 최적화

사용자 첨부는 기존 `victims-atlas.png`와 일치한다. 세 사진풍 초상 전체를 그림체 불일치로 기각하며 현재 PDF/회수 합성에서 제거한다. 나머지 기존 활성17개는 시각 선택 승인, 과거 대체된 M04 의상2개는 그대로 보존한다. 파일과 exact hash 승인 범위는 `BLUEPRINT_20260911_IMAGE_DECISIONS.json`이 소유한다. 새 `victims-atlas-anime.png`는 교체 후보이며 이전의 '나머지 승인'을 소급 적용하지 않는다. 제품 root manifest 승격·실행·전체 기획 승인은 별개다.

비교: 기존 ASCII85+Flate 유지(REJECT: 불필요한 전송 표현 비용), JPEG/다운샘플(보류: 선화·타이포 손실 가능), 기존 ReportLab의 binary Flate(ADOPT: 원본 픽셀/alpha 그대로). 공식 ReportLab 설정 문서와 설치된 pdfdoc.py useA85 분기를 실제로 확인했다. 새 압축 계층/유료 도구를 추가하지 않는다. PDF 출력은 OPTIMIZED 후속본이며 기존 열린/승인 판은 보존한다. 재사용 도구 BUILD→REVIEW의 제한된 변경으로 게임 규칙/씬/저장/사용자 runtime 변경은 제외한다.

교체 그림은 호스트 이미지 모델의 style-transfer로 생성했다. 권나래=narae.png는 선화/얼굴 명암 스타일 기준, 기각 초상은 인원·복장·셀 순서만 기준이다. 생성 원본 exec-f0e6bdde-7fd5-45dd-b062-a1d1595a6791.png, 목적은 M01/M04/M07 보호 대상 HUD와 Blueprint atlas다. Prompt: three equal square cells in one 3:1 row; chest-up worried civilians; short-bob woman in gray jacket, tousled man in navy rain jacket, brown-haired woman in brown cardigan; strong anime ink contours, simplified facial anatomy and cel shadows; near-black background; no pores/photorealism/3D/text/extra props. RGB2172×724, 각724×724. 투명도가 필요한 독립 전신 자산은 아니다.

검증 범위: PDF 전체 렌더, 수정 초상/회수/메인 페이지 검사, 기존 PDF 공통 이미지의 decoded RGB/alpha 동일성, 기각 초상 비포함, exact 승인 hash·후보 신규성, 기존 문서 회귀. 상태군 모션·실제 NinePatch·Godot·Human·권리·release는 미실행이다. Base v9.4.4와 다른 Draft PR은 유지한다. Base 승격은 하지 않는다. 롤백은 현재 변경 commit과 보존된 이전 PDF/원본을 이용한다.

최적화 결과: 54,616,521→43,575,820 bytes,69쪽 유지. 이전 PDF와 공유하는16개 이미지의 decoded pixel/alpha hash가 동일하며 기각 초상은 새 PDF image object에서 검출되지 않았다. 전체69쪽 렌더 후13/23/36/39/41쪽을 시각 확인했다. 문서/hash/경로/alpha/atlas/경계 및 기존 문서 회귀4개 PASS. 1차 검토는 기각 초상 잔존·승인 소급 위험을 교정했고, 2차 검토는 승인17/기각1/새 후보1/과거2 분리와 무손실 증거·회수3화면을 재확인했다. 이번 제한된 최적화/선택 반영은 완료이며 전체 모션·구현 준비 CLEAN은 여전히 선언하지 않는다.

상태: IN_PROGRESS / FINAL_USER_REVIEW_PENDING / NO_GAME_IMPLEMENTATION

현재 산출은 아래 참고 교정 후속판으로 갱신한다. 이전46쪽 검토 PDF와11개 후보는 역사 snapshot으로 보존한다. 이것은 전체 자산/상태 제작 완료가 아닌 부분 제작 snapshot이다. `REMAINING_WORK_COMPLETION_GATE: NOT_COMPLETE`; 게임 적용·최종 승인 없음.

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

## 이전 46쪽 판 수행·검증 영수증 (보존 이력)

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

## 이전 52쪽 판 참고 이미지 교정 — 승인된 후속 범위 (보존 이력)

최신 사용자4장과 권장안 승인을 적용한다. 추가 건별 승인은 요청하지 않는다. Work Mode는 PLAN → candidate/document BUILD → REVIEW, UI 정보구조·접근성 및 imagegen/PDF 스킬을 사용한다. 게임 코드 구현은 제외한다.

- ADOPT: 참고1의 전조/상황 대응, 참고2의 중앙 괴이 집중, 참고3의 장/긴 추리문/후보/루메, 참고4의 기록 분류/원문/지도.
- ADAPT: 회수 규칙 전문 상시 표시 대신 기록 요약과 독립 매뉴얼 버튼; 상황 대응은 정답 추천이 아닌 실제 가능한 조작; 맵은 확인된 장소/접근만 표시.
- REJECT: 참고의 HP·레벨·턴 재사용·괴이 안정도0% 처치·인물명·정답 안내 대사·미관측 다음 전조 예언.
- 기존 단순 화면 유지 / 참고 화면 통째 래스터 채택 / 신규 분리 자산+텍스트 네이티브 UI 설계의3안을 비교했다. 첫 안은 사용자 구도에 미달, 둘째는 내용·언어·입력 분리 불가, 셋째를 채택했다.
- REUSE_FIRST: 기존 배경4·루메·UI texture·직원atlas와 실제 battle_scene의 ArtLayer/TeamStrip/ActionDock/ResponseGrid/ManualQuickButton 재사용 가능성을 확인. 새 프레임워크 없이 기존 네이티브UI로 구현할 명세다. Base v9.4.4 pin 유지; unrelated Draft359/360/361/287/231 read-only.
- 최신 공식 NinePatchRect와 Aseprite sprite-sheet 문서를 확인했다. UI 코너 보존과 region/frame metadata 원칙만 적용하며 PDF 와이어프레임을 실제 NinePatch runtime 검사로 오인하지 않는다.
- 후보 원본과 네 참고 이미지는 프로젝트 `.asset-vault/blueprint-20260911` 내부. 참고 이미지의 규칙/인물/기록수는 새 정본이 아니다.
- 새 M04 빨간 루메는 실제 RGBA지만 저승역 후보보다 신체 비례가 길어 REVISION_REQUIRED다. 첫 체크무늬RGB 출력(exec-f4f45e6e-2e62-4645-bf7a-76af2c94b9f0.png)은 실사용·PDF 자산에서 제외했다. 기존 검은 방수복은 SUPERSEDED_CANDIDATE이며 삭제하지 않았다.
- M01 중앙 괴이 신규 후보는 실제 episode의 ‘역무원으로 보이는 익명의 인간형’ 외형을 바탕으로 제작했다. 새 정답/공격/인물 이름을 부여하지 않았다.
- Aseprite 루메3의상 정적atlas는 1-based 프레임으로 빈3프레임을 먼저 준비한 뒤 각각 가져왔다. 첫0-based 시도 오류는 잘못된 출력으로 분리하고 corrected 파일만 소비한다. 정적 의상집이지 모션/비례 정렬 완료가 아니다.
- 기존 PDF가 열려 있어 덮어쓰기가 거절됐다. 사용자 창을 강제로 닫지 않고 VISUAL_REVISION 후속본으로 발행한다. 이전 PDF bytes를 보존한다.

이번 후속 검증 증거는 `output/pdf/BLUEPRINT_20260911_VISUAL_REVISION_RECEIPT.json`이 소유한다. 문서 렌더와 후보 QA만 수행하며 runtime/Human/rights/release는 NOT_RUN. 새 공용 도구·유료API·Base 승격 없음. 프로젝트 교훈은 alpha 실측, 1-based 프레임, 열린PDF의 별도후속본 발행이다.

후속 결과: PDF52쪽, 화면11개, 후보 보관13개 중 활성12개/대체된 검은 M04 의상1개. 전체 PDF를 렌더하고 변경 페이지1/15~20/22~23/31/39/52 및 정적atlas를 시각 확인했다. 1차 검토에서 아틀라스 ‘아홉’ 제목, 하단 보조문구 간격, 구형 후보 상태/출처 누락을 교정했다. 2차 검토에서 변경 페이지 재렌더와 문서/PNG/source/reference hash·alpha·atlas·본문 경계 검사 및 기존4개 회귀검사를 다시 통과했다. 문서 와이어프레임과 실제 게임 UI를 구분하며 전체 production CLEAN은 선언하지 않는다.

실패한 첫 Aseprite 출력3개(10,329,667bytes)는 실제 문서/도구 참조0과 corrected 출력 보존을 확인한 뒤 삭제했다. 원본 PNG와 교정된 .aseprite/PNG/JSON으로 재생성 가능하다. 기존 사용자 파일·46쪽 PDF·제품 자산은 삭제하지 않았다. 루메 비례와 완성형 UI 장식·피해자/전조 상태/모션은 남은 미완성 항목이다.

## 현재 69쪽 CASE_PREPARATION 판 — 2026-09-11 연속 작업

최신 전달물은 `output/pdf/URBAN_LEGEND_HUMAN_BLUEPRINT_20260911_CASE_PREPARATION.pdf`이며 exact source/asset/PDF hash는 `BLUEPRINT_20260911_CASE_PREPARATION_RECEIPT.json`이 소유한다. 46쪽/52쪽 PDF는 보존 이력이다. 승인된 작업은 기획·후보 자산·문서 준비이고 제품 코드 구현과 최종 자산 LOCK은 포함하지 않는다.

- 새 후보7개: 짧고 귀여운 M04 루메, M04 괴이, M07 방송 진행자, 피해자3인 portrait atlas, 버튼6상태 board, 제목 워드마크, 회수용 방송 부스 배경. 원본 총20개 중 M04 의상2개는 superseded이며 삭제하지 않는다. RGB 체크무늬 편집 실패1개는 활성 후보에서 제외했다. 피해자 외형은 제안이며 성별/나이 정본을 추가하지 않는다.
- M07은 현행3개 단서를 출처로 3장/9슬롯/15후보를 제안하고 긴 추리문, 실제 구간 선택, 5회 입력, 실제 음성 반환, 실패/재개/저장/6개 회귀 조건까지 연결했다. 모든 새 ID는 draft_m07_이며 제품 데이터에 쓰지 않았다. 정답 노트가 세계를 바꾸지 않고 raw_hits와 valid_hits를 분리한다.
- Aseprite 정적 루메 atlas는3844×1568, 괴이 atlas는3844×1536, 각각3개 region이다. 빈 프레임3개를 먼저 생성하고 원본을 가져왔다. alpha 하단 정렬은 실제 픽셀 배치 증거이지 얼굴·머리 크기·모션 연속성 승인이 아니다.
- 새 PDF는 큰 메인 화면, 세 사건 회수 구도, M07 긴 문장형 매뉴얼을 포함한다. M01의 실제3장을 참고 이미지의5장으로 부풀리지 않는다.
- 1차 결과 검토에서 방송 진행자가 유리 밖에 뜨는 배치, M07 문장형 UI 부족, 실제 장 수 불일치, 찾아보기 용량을 발견했다. 전용 배경·유리 안 배치·M07 화면·실제3장·찾아보기 분할로 교정했다. 2차 변경 결과 재검토는 페이지13/20/37/38/41 및 최종69쪽 판33/55/56/59/60/69의 가독성·표·인과를 확인했다. 전체69쪽은 렌더했지만 모든 페이지의 새 시각 검수나 Human UX를 주장하지 않는다.
- 공식 Godot pausing 문서의 signal guard와 Aseprite sprite-sheet의 region 원칙을 재확인했다. 기존 프레임워크 재사용(ADAPT)을 선택하고 단순 원 맞추기 유지/노트 정답 보너스 부여는 핵심 규칙 사용을 훼손해 REJECT했다.
- Base v9.4.4 유지. 기존 runtime 변경·import 파일·Draft PR은 보호한다. 새 이미지 원본은 프로젝트 내부 로컬 vault에 있고 PDF만 Git 전달물에 포함된다. 원본의 원격 보관 완료를 주장하지 않는다.

REMAINING_WORK_COMPLETION_GATE: NOT_COMPLETE. 표현/동작 프레임과 전조 상태 자산, 버튼 정확한 분할·NinePatch 코너 검수, 세 의상 루메의 얼굴/비율 일관성 최종 검토가 남았다. 구현·runtime·Human·출시 검증은 NOT_RUN이며 최종 승인도 PENDING이다. IMPLEMENTATION_CORRECTION_RESCAN은 제품 코드를 변경하지 않은 이번 문서 범위에서 시행했으며 전체 CLEAN_REVIEW_EXIT는 선언하지 않는다. 기존 자산·제품 코드에는 자동 승격하지 않는다.

학습 환류: 유리 안/밖 공간 관계는 alpha 성공만으로 검증할 수 없고 실제 배경 합성이 필요하다. 정적 의상 atlas를 애니메이션으로 표시하지 않는다. 서로 다른 실제 선택/같은 노트와 같은 실제 선택/다른 노트를 별도로 시험해야 한다. 프로젝트 계약에 기록했으며 Base 강제 규칙 승격은 하지 않았다. 롤백은 이번 명시적 문서/생성기/PDF 변경만 되돌리고 보존된 원본·이전 PDF·사용자 runtime 변경은 유지한다.
