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
| `HGB-UI-07` | `07-manual-deduction-workbench.png` | 출처가 남은 후보 키워드를 빈 규칙 문장에 배치하고, 후보 규칙을 들고 현장 검증으로 복귀하는 전체 화면 매뉴얼 작업대. | `2b8d81f95a829ee6df21a25eedd7b7f2fa91f3b2b605af0a6119912146545d7e` |

`HGB-UI-07`은 사용자가 승인한 3열 매뉴얼 방향을 사람용 블루프린트 PDF에서
정확한 한국어 문구로 렌더한 `BLUEPRINT_DERIVED_UI_VIEW`다. 이 파일은 그림체나
문구를 생성 모델에 맡긴 새 런타임 자산이 아니며, `ASSET_MANIFEST.yml`의 제품
자산·권리·소비자 절차를 통과한 파일도 아니다. 실제 Godot `Control` 화면은 이
정보 구조를 재사용하되, 별도의 저장·입력·해상도·Human QA 검증을 거친다.

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
- 사용자 승인: 2026-08-30, 여섯 장면 묶음 전체 승인.
- 소비자: `docs/design/URBAN_LEGEND_HUMAN_GAME_BLUEPRINT_20260830.md`와
  로컬 파생본 `exports/urban-legend_HUMAN_GAME_BLUEPRINT_20260830.pdf`의 장면
  아틀라스, 매뉴얼 3열 작업대, 시각 언어 페이지.
- 런타임 소비자: 없음.

## 다음 검수

1. 블루프린트 PDF에서 각 장면을 `시각 참고`로 명확히 표시한다.
2. 플로우맵과 장면별 플레이 계약은 수정 가능한 Markdown/Mermaid와 표로
   작성한다.
3. PDF 렌더 검수 뒤 사용자에게 한 번의 최종 문서 검수를 요청한다.
