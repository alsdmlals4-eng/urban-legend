# GDD 상세화·추리 UX 벤치마킹 검토

## 범위와 판정

- 확인일: 2026-07-14
- 목적: 공개 GDD 구조와 유사작의 공식 정보·Steam 반응을 근거로, `괴담기록국`의 추리 UX와 사건 설계를 더 명확히 기록한다.
- 범위: 문서와 다음 MVP 검증 후보만 갱신한다. 게임 코드, 저장 스키마, 에피소드 JSON, 신규 단서·플래그는 변경하지 않는다.
- 반응 해석: 사용자 평가 한 건은 결론으로 쓰지 않는다. 공식 설명은 기능 약속, 다수 평가·토론에서 반복되는 언급은 마찰 가능성의 신호로만 사용한다.

## 공개 GDD에서 가져온 문서 원칙

| 근거 | 확인한 원칙 | 기록국 적용 |
|---|---|---|
| [Roblox Creator Hub: Core loops](https://create.roblox.com/docs/production/game-design/core-loops) | 반복 행동, 핵심 루프, 진행 동력을 분리하면 설계와 검증이 명확해진다. | 분 단위·사건 단위·캠페인 단위 루프를 GDD에 분리했다. |
| [Mainloop GDD/LDD Guide](https://mainloop.ai/en/gdd/) | GDD는 비전·루프·시스템·진행·위험·미결정을 하나의 현재 원본으로 둔다. | 상태 라벨, 수용 기준, 미확정 질문, 플레이테스트 측정을 같은 GDD에 유지한다. |
| [GDC Level Design Preproduction](https://media.gdcvault.com/gdc10/slides/2_EdByrne_LevelDesigninaDay_Preproduction.pdf) | 플레이 흐름·진행·서사 연결은 콘텐츠 생산 전에 검증 가능한 흐름으로 정리한다. | 신규 사건은 사건 약속·근거·실패·회수·보고서 카드로 승인한다. |

## 유사작과 사용자 반응

| 사례 | 공식 근거 | 반복 반응으로 읽은 신호 | 채택 판단 |
|---|---|---|---|
| [PARANORMASIGHT](https://store.steampowered.com/app/2106840/PARANORMASIGHT_The_Seven_Mysteries_of_Honjo/) | 도시괴담, 복수 관점, 저주 미스터리 | 장면 몰입은 강점이지만 후반 분기·결말의 납득성은 별도 검증이 필요하다. [Steam 토론](https://steamcommunity.com/app/2106840/discussions/0/3781373894324623367/) | 장면 중심 정보 위계 채택. 분기 구조·저주 규칙 복제 제외. |
| [The Case of the Golden Idol](https://store.steampowered.com/app/1677770/The_Case_of_the_Golden_Idol/) | 관찰·추론·이론 구성 | 스스로 조각을 맞추는 만족과 정답을 대신 말하지 않는 힌트가 호평이며, 논리 도약은 좌절 요인이다. [Steam 평가](https://steamcommunity.com/app/1677770/reviews/?browsefilter=toprated) | 힌트 단계·근거 재열람 채택. 단어 채우기 구조 제외. |
| [Return of the Obra Dinn](https://store.steampowered.com/app/653530/Return_of_the_Obra_Dinn/) | 기록을 재검토하는 탐정 게임 | 기록 재열람은 추론 만족을 만들지만 초반 탐색 부담은 온보딩으로 완화할 필요가 있다. | DB·보고서의 재열람 규칙 채택. 메뉴 은닉과 시청각 형식 복제 제외. |
| [Disco Elysium](https://store.steampowered.com/app/632470/Disco_Elysium_The_Final_Cut/) | 선택 중심 탐정 RPG | 동료 반응과 실패 서사는 기억에 남지만 과도한 정보량은 선택 피로를 만든다. [Steam 평가](https://steamcommunity.com/app/632470/Disco_Elysium_The_Final_Cut/) | 짧고 조건부인 요원 반응·학습 가능한 실패 채택. 장문 독백·스킬 인격화 제외. |
| [Lobotomy Corporation](https://store.steampowered.com/app/568220/Lobotomy_Corporation_Monster_Management_Simulation/) | 괴이 규칙·요원 적합도 학습 | 규칙 학습은 긴장을 만들지만 반복 손실과 정보 부족은 진입 장벽이 된다. | 전조·요원 기여의 설명 원칙 채택. 시설 경영·영구 손실·고유 작업명 제외. |

## DeepSeek R0 조사 검토

`research-scout-flash`가 2026-07-14에 760단어의 `WORKER_REPORT.txt`를 반환했다. 출처 형식과 읽기 전용 보고서 목적은 충족했지만, 워커 worktree에 계약 밖 임시 보고서 3개를 생성했다. 따라서 워커 파일 변경은 전부 불승인·미적용이며, 아래 판단은 Codex가 공개 근거와 프로젝트 불변 조건을 다시 대조한 결과다.

| 후보 | 결정 | 이유와 다음 검증 |
|---|---|---|
| 회수 전 근거 재확인·결과 후 패턴 학습 | 채택 | 이미 확보한 단서와 전조를 재열람하게 해 추리의 납득성을 높인다. 두 구현 사건에서 플레이어가 대응 이유를 설명하는지 확인한다. |
| 힌트 단계와 재방문 안내 | 채택 | 막힘을 줄이되 정답·다음 클릭을 공개하지 않는다. 첫 사용·재방문에서 힌트가 과도한지 수동 QA한다. |
| 조건부 요원 반응 | 조건부 채택 | 수사 파트너 감각은 유지하되, 현 저장·신뢰 규칙과 문구량을 먼저 감사한다. 이번 단계에서는 새 분기·저장값을 만들지 않는다. |
| 사건 전조를 일정 화면에 추가 | 조건부 채택 | 요원 선택에 의미를 줄 수 있으나 단서를 대체하거나 에피소드 JSON을 바꾸면 고위험이다. 다음 사건 설계 때 별도 심사한다. |
| 사건 간 DB 연결성 확대 | 보류 | 세 번째 사건과 10일 결산이 확정되기 전에는 저장·진행 의미를 바꾸지 않는다. |
| 단어 조합, 복수 시점 분기, 장기 독백, 시설 경영, 영구 손실 | 제외 | 현재의 장면 중심 조사·팀 운영·학습 가능한 실패 원칙과 범위에 맞지 않거나 고유 표현 복제 위험이 있다. |

## 다음 구현 전 확인

1. 두 구현 사건의 회수 직전에 관련 단서·전조·패턴 학습이 서로 구분되어 보이는지 확인한다.
2. 실패 직후 플레이어가 “무엇을 배웠는지”와 “다음에 무엇을 다시 볼지”를 한 문장으로 말할 수 있는지 확인한다.
3. 요원 반응이 선택 요원·조건·기여 이유와 맞는지 확인하고, 정답 힌트나 불필요한 장문이 없는지 검수한다.
4. 전조·DB 연결·새 보고서 입력 UI는 저장·에피소드 스키마 영향 분석과 사용자 승인 전에는 구현하지 않는다.
