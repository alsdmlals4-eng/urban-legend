# 런타임 정렬 블루프린트 벤치마크 · 2026-09-01

> 역할: `BENCHMARK_EVIDENCE / NON_CANONICAL_REFERENCE`
> 범위: 사람용 블루프린트의 추리·회수·메뉴·결과 정보 구조를 검증한다. 외부 게임의
> 아트, 서사, 화면 배치, 수치, 표현을 복제하거나 이 프로젝트의 새 요구사항으로
> 승격하지 않는다.
> 정본 연결: `docs/design/URBAN_LEGEND_HUMAN_GAME_BLUEPRINT_20260830.md`,
> `docs/CURRENT_PLANNING_CANON.md`, `docs/CURRENT_DECISION_OVERLAY.md`
> 증거 한계: 공식 제품 페이지에서 공개된 플레이 경험 설명과 현재 repository의
> runtime/문서 대조다. Human QA, 시장성, 접근성, 출시 권리 검토는 `NOT_RUN`이다.

## 질문

플레이어가 화면을 보고 같은 선택을 반복하지 않고 다음 행동을 다르게 고민하게 하려면,
`조사 → 매뉴얼 가설 → 보호 → 회수 → 복합 결과`를 어떤 정보 구조로 보여 주어야 하는가?

## 10개 공식 제품 비교

| # | 제품 · 공식 1차 출처 | 확인한 구조 | 이 프로젝트의 판단 | 적용 위치 |
| --- | --- | --- | --- | --- |
| 1 | [PARANORMASIGHT: The Seven Mysteries of Honjo](https://store.steampowered.com/app/2106840/_/?l=english) | 장소·저주·시점 이동을 결합한 도시 괴이 조사 | **ADAPT** — 한국 도시 현장과 기관 기록의 긴장을 살리되, 사건별 장소만 강조한다. | 조사 배경과 사건 진입 카피 |
| 2 | [The Case of the Golden Idol](https://store.steampowered.com/app/1677770/The_Case_of_the_Golden_Idol/) | 장면의 인물·동기·사실을 재구성하는 추리 인터페이스 | **ADAPT** — 출처가 남은 키워드와 빈칸 추리문은 채택하되, 즉시 정답 확정은 거절한다. | 매뉴얼 candidate/slot |
| 3 | [Citizen Sleeper](https://store.steampowered.com/app/1578650/Citizen_Sleeper/) | 시간·위험·목표를 구분한 clock형 진행 압박 | **ADOPT** — 안정도 목표 8칸과 위험도 위협 6칸을 함께 보여 준다. | M04 이중 시계 목표 UX |
| 4 | [Return of the Obra Dinn](https://obradinn.com/) | 문서와 관측을 통해 사건의 빈칸을 메우는 조사자 역할 | **ADAPT** — 기관 기록·출처·관측을 추리 근거로 삼되, 동일한 UI/미술 양식은 쓰지 않는다. | 기록철 정보 위계 |
| 5 | [Heaven's Vault](https://www.inklestudios.com/heavensvault/) | 불확실한 해석이 다음 탐색과 서사에 남는 구조 | **ADOPT** — 가설의 의미 오답을 즉시 지우지 않고 현장 검증 뒤 위험 사례로 보존한다. | 후보 규칙·결과 기록 |
| 6 | [Pentiment](https://pentiment.obsidian.net/) | 선택이 사람·시간·기록에 남는 결과 읽기 | **ADAPT** — 피해자·잔향·증거·다음 준비를 분리해 읽되, 역사극 문체·시간 구조는 채택하지 않는다. | 복합 결과 4축 |
| 7 | [The Thaumaturge](https://11bitstudios.com/games/thethaumaturge/) | 근대 도시와 오컬트가 공존하는 조사 분위기 | **ADAPT** — 현대 장비와 동서양 주술 자료의 기관성을 섞되, 전투 중심 해결은 피한다. | 메인 아카이브·시각 언어 |
| 8 | [OXENFREE](https://nightschoolstudio.com/oxenfree/) | 초자연 현상 속 맥락형 통신·선택 | **ADAPT** — 안내·방송·상황 대응의 분위기는 참고하되, 라디오 대화 선택이나 정답 힌트는 복제하지 않는다. | 전조/상황 대응 카피 |
| 9 | [The Darkside Detective](https://www.akuparagames.com/game/the-darkside-detective/?presskit=1) | 사건 단위로 읽히는 초자연 수사 에피소드 | **ADOPT** — 사건 파일의 진입·결과·기록 환류를 명료하게 유지한다. | 메인 case panel·기록실 |
| 10 | [The Mortuary Assistant](https://www.dreadxp.com/the-mortuary-assistant-press-kit/) | 절차를 지키는 긴장과 초자연적 방해의 결합 | **ADAPT** — 매뉴얼대로 억제·보호하는 감각은 참고하되, 점프스케어·공포 연출을 핵심 검증 수단으로 삼지 않는다. | 회수의 역할 분담·절차 피드백 |

## 대안 비교와 선택

| 대안 | 장점 | 위험 | 판정 |
| --- | --- | --- | --- |
| A. 단일 위험 게이지 | 구현과 읽기가 가장 단순하다. | 해소의 성취와 위협의 긴장을 한 숫자에 섞어, 올바른 대응의 이유가 약해진다. | `REJECT` |
| B. 이중 시계 + 전조 기반 행동 | 목표 전진과 위협 누적을 함께 보여 주며, 매뉴얼 근거를 실제 행동으로 연결한다. | 두 게이지를 매 행동마다 같이 움직이면 이중 처벌·노이즈가 된다. | `ADOPT` — 이 작업의 권장안 |
| C. 매뉴얼이 정답을 즉시 판정하고 자동 회수 | 학습 속도와 단기 편의가 높다. | 플레이어 작성 가설, 보호 판단, 현장 검증이라는 핵심 경험을 지운다. | `REJECT` |

## 채택 규칙

1. **시계는 행동의 정답표가 아니다.** 안정도는 목표 진행, 위험도는 실제 대가와
   시간 압박을 읽는 장치다.
2. **맞는 키워드만으로 해결되지 않는다.** 키워드·가설·전조·대응 방법이 장면에서
   연결될 때 안정도가 전진한다.
3. **위험도는 자동 벌점이 아니다.** 이미 큰 손실을 보여 준 실패에 같은 크기의
   게이지 손실을 무조건 겹치지 않는다.
4. **한 칸의 변화는 장면 변화다.** 괴이의 범위, 방송/전광판, 안전 경로, 보호 대상의
   상태 중 무엇이 변했는지 함께 보여 준다.
5. **결과는 단일 성적표가 아니다.** 사람을 보호한 결과와 잔향을 안정화한 결과를
   분리한 뒤, 확인된 규칙과 위험 사례를 다음 조사에 되돌린다.

## 미채택·보류

- 외부 제품의 고유 캐릭터·아트 스타일·문장·UI 구도·수치 모델은 `REJECT`다.
- M04 이중 시계의 세그먼트별 수치, 시간 간격, 특정 행동별 변화량은 사건 데이터와
  실제 Human QA 전까지 `UNDEFINED`다.
- 새 이미지 제작은 필요 없었다. 메인·매뉴얼·시계·행동판은 native Godot UI consumer이고,
  실제 Texture consumer가 확인될 때만 별도 candidate를 만든다.
