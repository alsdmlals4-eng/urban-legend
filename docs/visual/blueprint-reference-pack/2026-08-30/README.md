# 괴이기록국 · 사람용 블루프린트 시각 참고 묶음

상태: `USER_APPROVED / BLUEPRINT_REFERENCE_ONLY / NOT_PRODUCT_REFERENCE_ASSET / NOT_RUNTIME_ASSET`

## 용도와 경계

이 묶음은 2026-08-30 사용자 승인으로 만든 사람용 게임 블루프린트의 장면
아틀라스 참고 이미지다. 여섯 장면은 플레이어 경험을 설명하지만, 실제 게임의
승인 자산, 새 런타임 소비자, UI 목업, 또는 구현 완료를 뜻하지 않는다.

향후 인게임 이미지 작업은 `docs/VISUAL_ANCHOR_SPEC.md`의
`2026-08-30 Human Blueprint Visual Continuity Supplement`를 함께 따른다.
기존 자산을 교체하거나 새 런타임 이미지로 승격하려면 root
`ASSET_MANIFEST.yml`의 product-asset 절차, 실제 consumer, provenance,
1280x720/1920x1080 검증, Human QA를 별도로 통과해야 한다.

## 승인한 장면

| id | 파일 | 장면과 플레이어 경험 | SHA-256 |
| --- | --- | --- | --- |
| `HGB-VIS-01` | `01-main-archive-menu.png` | 괴이 기록국의 야간 아카이브에서 사건을 시작하거나 이어 간다. | `2bfc08e60d1c514566a2000ee067d209b3a317465b179608f9054f37bc15d0bf` |
| `HGB-VIS-02` | `02-mission-preparation.png` | 인원, 메뉴얼, 장비를 비교해 현장 대응을 준비한다. | `988d4b40ed92ec5faa150e2f672671bb143855cc3b6297769e02e529ec4adcfb` |
| `HGB-VIS-03` | `03-field-investigation-manual.png` | 현장 단서를 메뉴얼의 규칙과 대조해 다음 행동을 결정한다. | `e7e2750f65b1f85f4e4fa2532c23745cb57f10f208a242c281d578370b3b627c` |
| `HGB-VIS-04` | `04-rescue-route.png` | 안전 경로와 보호 장비로 피해자를 이상 현상에서 분리한다. | `140f9eb8d62bb4e604ef28bb7633834d01b3fb33d1e0b5492b39e35ef9b67e71` |
| `HGB-VIS-05` | `05-recovery-phase.png` | 메뉴얼 지휘, 괴이 억제, 피해자 보호를 동시에 실행해 잔향을 안정화한다. | `d270604b9555bd22c29eb6c7573dc482027cd4f43be152d223498c1f48e6983c` |
| `HGB-VIS-06` | `06-composite-result.png` | 피해자 상태, 안정화한 잔향, 새 메뉴얼 기록을 각각 남긴다. | `f37e8335416855c65bb19362b0d4ad3355136b95cbb1cb2c1dd73e1bf40ddc44` |

### 추가 화면형 구현 기준

| id | 파일 | 장면과 플레이어 경험 | SHA-256 |
| --- | --- | --- | --- |
| `HGB-UI-07` | `07-manual-deduction-workbench.png` | `SUPERSEDED_LAYOUT_REFERENCE`: 카드형 대시보드 레이아웃. 출처 기반 추리의 정보 구조는 보존하되, 사용자 피드백에 따라 더 이상 현재 화면형 기준으로 쓰지 않는다. | `2b8d81f95a829ee6df21a25eedd7b7f2fa91f3b2b605af0a6119912146545d7e` |
| `HGB-UI-08` | `08-manual-deduction-dossier.png` | `GENERATED_CANDIDATE / USER_DIRECTED_REVISION`: 하나의 두꺼운 기록철 프레임 안에서 INDEX, 긴 추리문, 출처·순서가 남은 2열 후보, 기록관 아카 보조를 함께 비교하는 16:9 인게임 매뉴얼 기준. | `b939079d39005b1351c1926a56a888b1386a253f743adf58ba783dc6e885efcc` |
| `HGB-AUX-08` | `08-aka-guide-candidate.png` | `GENERATED_CANDIDATE / BLUEPRINT_ONLY`: HGB-UI-08의 기록 보조 칸에만 합성한 기록관 아카 후보 초상. 독립 제품 자산·런타임 소비자는 없다. | `06975d4d6655b7b777cb5fef205342a3a357050af9f3a3949c77fa7d23daceeb` |

`HGB-UI-07`은 정보 구조의 보존용 전임 시안이며, 이번 사용자의 “첫 번째 기록철
화면처럼”이라는 명시적 피드백으로 레이아웃 기준에서 제외했다. 현재 검수 대상은
`HGB-UI-08`이다. 이 시안은 사용자 참고 화면의 **한 장짜리 기록철, 본문 중심 밀도,
좌측 INDEX, 우측 2열 후보, 하단 기록 보조**라는 화면 문법을 참고했지만, 문구·사건
내용·기관 표식·아카 초상은 이 프로젝트용으로 새로 구성했다.

`HGB-UI-08`과 `HGB-AUX-08`은 아직 `GENERATED_CANDIDATE`이며 사람용
블루프린트에만 쓰인다. 둘 다 새 런타임 자산이 아니며, `ASSET_MANIFEST.yml`의
제품 자산·권리·소비자 절차를 통과한 파일도 아니다. 실제 Godot `Control` 화면은
이 정보 구조를 재사용하되, 별도의 저장·입력·해상도·Human QA 검증을 거친다.

## 공통 시각 규칙

- 현실적인 한국 도시 현장과 한 단계 더 애니메이션적인 인물을 한 장면 안에서
  일관되게 연결한다.
- 사건 현장 장면은 사무실 배경으로 대체하지 않는다. 사무실은 메인·기록·준비
  장면에서만 기관성을 설명하는 배경으로 사용한다.
- 메뉴얼 지시, 억제, 보호의 역할은 색만이 아니라 손동작, 도구, 대상, 공간
  배치로도 즉시 읽혀야 한다.
- 검정·남청·청록의 도시 기반 위에 메뉴얼의 금색, 분석 억제의 보랏빛, 보호의
  호박빛, 위협의 제한된 검붉은색을 사용한다.
- 가짜 UI 문자, 과도한 HUD, 범용 마법 연구실, 처치 중심 전투, 고어, 특정
  사건에만 종속되는 장식은 사용하지 않는다.

## 생성과 승인 기록

- 생성 도구: OpenAI built-in image generation.
- 생성일: 2026-08-30.
- 입력 역할: 사용자가 제공한 괴이 메뉴얼, 캐릭터 라인업, 회수 대응 화면은
  프로젝트 내부 시각 참고로만 사용했다. 화면의 문자, UI 배치, 상표, 로고를
  복사하지 않았다.
- 사용자 승인: 2026-08-30, 여섯 장면 묶음 전체 승인. `HGB-UI-08`과
  `HGB-AUX-08`은 그 뒤의 사용자 지시 기반 후속 후보이며 아직 별도 시각 승인을
  받지 않았다.
- 소비자: `docs/design/URBAN_LEGEND_HUMAN_GAME_BLUEPRINT_20260830.md`와
  로컬 파생본 `exports/urban-legend_HUMAN_GAME_BLUEPRINT_20260830.pdf`의 장면
  아틀라스, 매뉴얼 기록철 작업대, 시각 언어 페이지.
- 런타임 소비자: 없음.

## 다음 검수

1. 블루프린트 PDF에서 각 장면을 `시각 참고`로 명확히 표시한다.
2. 플로우맵과 장면별 플레이 계약은 수정 가능한 Markdown/Mermaid와 표로
   작성한다.
3. PDF 렌더 검수 뒤 사용자에게 한 번의 최종 문서 검수를 요청한다.
