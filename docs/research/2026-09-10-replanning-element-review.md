# 재기획 요소 검토 · 2026-09-10

상태: `RESEARCHED / PROVISIONAL_RECOMMENDATIONS / NOT_FINAL_DESIGN`.
승인 범위: 기존 요소의 유지·변경 검토, 인터넷·벤치마크·실무자료 조사, 개선안 작성,
프로젝트 내부 Aseprite 후보 처리 경계. 기존 그림은 새 제작에서 reference-only다.
이는 새 정답·사건·수치·저장 스키마·최종 그림체를 확정하거나 기존 runtime을 삭제하는 승인이 아니다.

## 현재 근거와 정본 경계

- 프로젝트 baseline: `c82291101bf0a2bb4d821a12bca9f14070ee2886`를 fetch 후 로컬 main과 대조했다.
- AGENTS → START_HERE → 운영/라우팅 → current canon/overlay/handoff → actual consumer 순으로 확인.
- `scripts/ui/main_menu.gd`는 archive 배경과 기존 emblem/wordmark를 소비한다.
- `scripts/ui/scene_presentation.gd`는 사건/risk별 cutout을 `ui_asset_catalog.gd`에서 조회한다.
- `scripts/ui/recovery_clock.gd`에는 0.28초 색상 피드백이 있다. 캐릭터 행동 애니메이션 증거가 아니다.
- `scripts/scenes/battle_scene.gd`에는 guided-decision 평가 consumer가 있다. 작성한 draft의 모든 의미가
  구출/회수 판정에 전달되는지는 후속 end-to-end trace 대상으로 남긴다.
- Base adoption은 v9.4.4로 유지. 최신 Base `2f93e872d9ed4fa18018ac759b01acd7d34e9b58`의
  `ART_DIRECTION_AND_ASSET_PLANNING_GUIDE.md` §11을 이번 승인 범위의 조건부 도구 method로 읽었다.
- 이전 benchmark의 `Citizen Sleeper → 안정도8/위험도6 ADOPT`는 잘못된 출처 귀속으로 읽힐 수 있다.
  그 숫자는 프로젝트의 이전 구현값이지 외부 게임이 증명한 최적값이 아니다. 재기획에서 재평가한다.
- 이전 문서의 기획 완료/시각 lock은 기존 baseline 이력이다. 현재 재검토 상태는
  `current-planning-canon.json#/replanning_review`와 Decision Overlay가 소유한다.

## 조사 방식과 증거 상한

2026-09-10에 아래 공식 제품 페이지/개발자 공개자료를 실제 읽었다.
게임 소스코드를 역공학하거나 11개 게임을 직접 플레이한 결과는 아니다.
공개 설명에서 관측한 설계 패턴과 우리 프로젝트에 대한 추론을 분리한다.
GDC 자료는 공개 세션 개요까지만 확인했으며 영상 전체를 시청한 것으로 쓰지 않는다.
판매량·수익성·전 세계 유일성·유저 선호를 이 자료만으로 증명할 수 없다.

## 11개 게임 비교

| 게임·1차 자료 | 공개 자료에서 관측한 패턴 | 프로젝트 적합성과 차이 / 판단 |
|---|---|---|
| [Golden Idol](https://store.steampowered.com/app/1677770/The_Case_of_the_Golden_Idol/) | 장면의 단서를 조사해 사건을 재구성 | `ADAPT`: 빈칸 매뉴얼을 유지 후보로 두되 입력 정답 맞히기만으로 끝나지 않게 현장 적용을 검증한다. |
| [Obra Dinn](https://obradinn.com/) | 보험 조사자의 역할과 조사 보고라는 일관된 설정 | `ADAPT`: 기관 문서와 플레이 역할을 연결. 흑백 양식·인물·정답 확인 규칙의 복제는 하지 않는다. |
| [Heaven's Vault](https://www.inklestudios.com/heavensvault/) | 해석의 오류도 서사 진행에 영향을 주며 2D 손그림과 3D 환경을 결합 | `ADAPT`: 해석과 관측을 분리하고 오답 뒤 재검토 근거를 남긴다. 3D 환경 제작은 자동 채택하지 않는다. |
| [Overboard!](https://www.inklestudios.com/overboard/) | 인물이 관측과 행동을 기억하며 제한된 시간 안에서 선택 | `ADAPT`: 보호·지시의 결과를 후일담이 기억하게 한다. 전 인물 실시간 시뮬레이션은 비용상 보류. |
| [Citizen Sleeper](https://store.steampowered.com/app/1578650/Citizen_Sleeper/) | 주사위·선택·관계를 엮는 TRPG 기반 서사 RPG | `ADAPT`: 자원 압박과 관계의 의미 연결. 주사위 및 특정 clock 수치를 그대로 가져오지 않는다. |
| [Pentiment](https://pentiment.obsidian.net/) | 공동체에 남는 선택 결과, 미술 양식을 지키는 제한 프레임 애니메이션, 쉬운 글꼴/모션 접근성 | `ADAPT`: 동작 수보다 읽히는 key pose와 결과 인과를 우선. 목판화 스타일은 복제하지 않는다. |
| [PARANORMASIGHT](https://www.square-enix-games.com/en_GB/home/paranormasight-seven-mysteries-honjo-now-available) | 지역 괴담·여러 인물의 동기·저주를 2D VN으로 결합 | `ADAPT`: 현지 장소·생활 규칙이 괴이와 연결돼야 한다. 복수 시점/저주 살인은 자동 추가하지 않는다. |
| [The Thaumaturge](https://11bitstudios.com/games/thethaumaturge/) | 문화적 장소성과 도덕적 선택, 오컬트 존재 | `ADAPT`: 동서양 요소는 장식이 아니라 기관의 대응 관점으로 구별. 전투형 RPG 확장은 보류. |
| [OXENFREE](https://nightschoolstudio.com/oxenfree/) | 대화가 관계/이야기를 바꾸고 라디오가 초자연 현상과 상호작용 | `ADAPT`: 전조 소리와 대응 입력에 의미를 부여. 핵심 정보는 청각 단독으로 주지 않는다. |
| [The Darkside Detective](https://www.akuparagames.com/game/the-darkside-detective/?presskit=1) | 사건 단위 초자연 수사와 일관된 어조 | `ADAPT`: 공용 사건 문법과 개별 괴이의 차이를 함께 유지. 코미디/픽셀아트는 자동 채택하지 않는다. |
| [The Mortuary Assistant](https://dreadxp.itch.io/the-mortuary-assistant) | 일상 업무 절차 중 괴이를 식별하고 의식을 수행 | `ADAPT`: 매뉴얼 절차와 방해의 긴장. 점프스케어·무작위 방해를 추리 피드백 대용으로 쓰지 않는다. |

Mortuary의 과거 press-kit URL은 오류여서 공식 배급사 itch 페이지로 대체했고,
PARANORMASIGHT Steam 연령 확인 페이지 대신 공식 Square Enix 본문을 읽었다.

## 실무·기술 조사

- [Jon Ingold / GDC 공개 개요](https://www.gdcvault.com/play/1027723/The-Burden-of-Proof-Narrative):
  추리를 게임에 어떻게 증명하고 창의성을 지우지 않고 피드백하는가가 설계 문제다.
  `ADAPT`: 정답 자동 공개 금지와 관측 결과 공개를 분리한다. 강연 내부 구현은 미검증.
- [Pentiment 개발·애니메이션 설명](https://pentiment.obsidian.net/): 제한 프레임이 특정 미술 방향을 보존한다.
  `ADAPT`: 모든 상태를 고프레임으로 만드는 대신 판독 가능한 자세/전환을 먼저 시험한다.
- [Blades 공식 Clock](https://bladesinthedark.com/progress-clocks): 장애물의 진척/위협을 가시화한다.
  `ADAPT`: 무엇이 채워지고 언제 움직이며 가득 차면 무엇이 생기는지를 명시한다.
  원형 모양이나 4/6/8칸 자체가 밸런스 검증은 아니다.
- [Aseprite CLI](https://www.aseprite.org/docs/cli/): 레이어·프레임·시트와 JSON export.
  `ADAPT`: 승인된 제한 서버의 허용 기능만 재사용, raw script나 새 bridge는 만들지 않는다.
- [Godot sprite animation](https://docs.godotengine.org/en/stable/tutorials/2d/2d_sprite_animation.html):
  SpriteFrames/AnimatedSprite2D와 AnimationPlayer 경로를 비교할 수 있다.
  `ADAPT`: 실제 화면 consumer 확정 후 선택. 시트 파일 존재는 엔진 적용 증거가 아니다.

## SWOT — 평가이며 사용자 테스트 결과가 아님

| 구분 | 관측/평가 | 실행 가능한 대응 |
|---|---|---|
| Strength | 조사에서 만든 규칙을 위험한 현장에서 사용한다는 핵심 약속 | 동일한 규칙 하나가 획득→추론→행동→결과까지 이어지는 trace를 최우선 제작 |
| Strength | 사람 보호와 괴이 회수를 분리한 복합 결과 | 점수 합계 대신 서로 다른 결과와 이유를 보존 |
| Weakness | 문서의 확정/완료 이력과 새 기획 권한이 혼재 | 새 review gate를 등록하고 이전 기록을 baseline으로 명시 |
| Weakness | 정답 피드백 금지가 무반응·총대입으로 오해될 위험 | 관측 가능한 반증, 재조사 경로, 오답 비용을 설계하고 사용자 테스트 |
| Opportunity | 한국 일상 공간·기관 업무·가설의 현장 적용 결합 | 소재 장식보다 공간의 생활 규칙과 보호 책임을 사건의 차별화 요소로 사용 |
| Opportunity | 제한 동작·상태 재사용으로 읽기와 제작성을 함께 확보 | 먼저 한 역할의 준비/실행/복귀 state family를 검증 |
| Threat | VN·육성·추리·미니게임·전투·대량 이미지의 범위 팽창 | 핵심 한 경로를 검증하기 전 새 사건과 전체 상태군 양산 보류 |
| Threat | 읽는 동안의 시간 벌점, 어두운 UI, 장식 글꼴이 접근성을 해침 | 읽기/조작/판정 시간 분리 대안 및 모션 감소/쉬운 글꼴 검토 |

## 요소별 유지·추가·보완·수정 판정

아래는 재기획 권장안이다. 의미 변경은 최종 승인 전 데이터/코드에 적용하지 않는다.

| 기존 요소/상태 | 판정·권장 조치 | 이유·기대효과 | trade-off / 검증 |
|---|---|---|---|
| 조사→매뉴얼→현장 검증 | 유지 후보, 직접 소비 관계 보완 | 본작 차별화 가설을 가장 분명히 전달 | draft의 실제 판정 전달 추적 필요 |
| 키워드 빈칸 추리 | 유지 후보, 출처/반증 탐색을 보완 | 암기·단어 퍼즐만으로 축소되는 위험 완화 | 답을 노출하지 않는 피드백 테스트 |
| 구출 미니게임 | 보완 후보, 매뉴얼과 관계없는 반사신경 과제는 축소 후보 | 같은 추리가 보호 행동에 쓰였음을 체감 | 실제 미니게임별 관련성 조사 미완료 |
| 안정도/위험도 clock | 재설계 검토 | 증가가 좋은 값/나쁜 값인지 모호하면 압박과 해소가 역전 | 8/6 유지 확정 아님; 시간 모델 비교 필요 |
| 현대/동양/마법 직원 | 역할·행동 중심 보완 후보 | 의상 세 종류보다 지시·억제·보호의 협업을 읽게 함 | 새 인물·능력·정답 자동 제공은 미승인 |
| 안내자 | 이름/역할 재검토 필요 | user의 루메와 기존 main의 아카/CASE01 예외를 구분해 해결 | 새 디자인에서 몰래 둘을 통합/개명하지 않음 |
| 메인 메뉴 | 기능을 재평가하고 새 visual 제작 | 과거 3-rail 구도 자체보다 시작/재개/기록의 명료성을 우선 | 기존 저장·Validation 격리는 보호 |
| 10일·반일 일정/육성 | 보조 계층으로 검토, 규모 확대 보류 | 핵심 추리 재미보다 관리 업무가 커지지 않게 함 | 삭제 또는 기간 변경은 별도 의미 결정 |
| 기존 이미지/wordmark | 새 제작의 reference-only | 과거 후보의 미감이 새 기획을 자동 고정하지 않음 | 현 runtime 참조는 후속 교체 전까지 보존 |
| 신규 이미지·모션 | state family 단위 제작 | 크기·발 위치·소품·접촉 시점의 재작업 절감 | 한 pose 승인이 모든 동작 승인 아님 |
| 과거 임시 폴더 | UNKNOWN_UNVERIFIED, 이번에 삭제 안 함 | main에 포함된 복사본도 consumer/소유권 확인 필요 | 이름/연식만으로 정리 금지 |

## 세 실질 대안 — 회수 시간 모델

| 대안 | 플레이어 가치 | 비용·위험 | 현 단계 |
|---|---|---|---|
| A. 행동마다 진행하는 턴 clock | 읽기 속도와 무관한 추리, 재현 가능한 테스트 | 실시간 압박이 약해질 수 있음 | 비교 시제품 후보 |
| B. 상시 실시간 clock | 즉각적인 현장 압박 | 매뉴얼 독해·접근성·일시정지·저장 타이밍 비용이 큼 | 비교 시제품 후보 |
| C. 판단 구간과 제한 대응 구간 분리 | 독해와 위기 대응의 리듬을 분리 | 전환 규칙을 추가로 가르쳐야 함 | 우선 검토 권장; 최종 확정 아님 |

## 독창성·창의성 검토

빈칸 추리, 도시괴담, 기관 문서, 시계, 동료 역할은 각각 이미 존재하는 문법이다.
이를 조합했다는 사실만으로 독창성을 입증하지 않는다. 차별화 가설은
**플레이어가 작성한 불완전한 현장 매뉴얼이 협업 행동과 피해자 결과를 바꾼다**는 연결에 둔다.
승인 후 명확화: 메모 자체가 세계 판정을 바꾸는 것이 아니라, 조사로 알아낸 규칙에 따라
플레이어가 실제 행동을 선택하고 그 결과로 생존한다. 방향 owner는
`docs/CURRENT_DECISION_OVERLAY.md`의 `D-2026-09-10-HIDDEN-RULE-SURVIVAL-CORE`다.

검증 질문: (1) 선택 근거를 플레이어가 설명하는가, (2) 같은 괴이에 다른 근거/방법을 시험할
여지가 있는가, (3) 오답 후 어떤 가정이 흔들렸는지 관측 가능한가, (4) 보호 결과와 회수 결과를
각각 설명할 수 있는가. 비교군 플레이테스트 전에는 차별화/창의성 PASS를 선언하지 않는다.
새로운 장식·세계관 명사·스킬 수 증가는 독창성 점수로 계산하지 않는다.

## 다음 제작 순서와 완료 증거

1. 기존 시스템을 실제 consumer별로 조사해 입력·선택·출력·반증·실패 회복 표를 완성한다.
2. 기존 사건 한 개의 규칙 하나로 조사→매뉴얼→구출/회수 연결을 trace한다. 새 답안은 발명하지 않는다.
3. 시간 모델/피드백/직원 역할의 대안을 같은 wireframe·flow로 비교하고 의미 변경을 확정한다.
4. 새 visual brief에서 화면 거리·구도·색·글꼴·레이어·상태군을 결정한다. 기존 이미지는 reference-only.
5. 첫 동작은 대기→전조 인지→준비→실행/접촉→유지→복귀와 취소/실패를 구분한다.
   duration, pivot, crop, 장비 continuity, 판정 event, 중단 정책을 원화 전에 정의한다.
6. 이미지 모델 후보 → Aseprite 필요성 판정 → 제한 stdio 패키징 → 원본 hash/시트/JSON readback.
7. 선택/승격 후 Godot 실제 consumer 연결, 두 해상도·입력·중단·모션 감소·저장회귀를 검증한다.
8. 사람용 Blueprint는 기존 상세 자료를 축약 덮어쓰기하지 않고 새 설계와 기존 구현의 상태를 구분한다.

현재 ceiling: 공식 문서 조사와 제한 도구 연결 테스트. 전체 요소 감사·새 wireframe·새 이미지·
애니메이션 품질·Godot 통합·Human QA는 아직 완료하지 않았다.
