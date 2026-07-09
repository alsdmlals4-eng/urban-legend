# Benchmarking Reference Guide

이 문서는 `도시괴담 기록국` 프로젝트에서 기획, MVP 정의, 시스템 개선, UI/UX 판단을 할 때 참조할 벤치마킹 규칙과 초기 사례 목록을 정리한다.

목적은 새 채팅, 새 AI, Codex, 다른 작업자가 보더라도 동일한 기준으로 벤치마킹을 수행하게 하는 것이다.

---

## 1. 벤치마킹 기본 규칙

기획 또는 MVP 범위가 바뀔 때는 가능한 한 벤치마킹을 먼저 수행한다.

필수 조건:

- 유사 장르 게임 또는 인접 장르 게임을 최소 10개 이상 확인한다.
- 각 항목은 `게임명`, `참고한 출처`, `플레이어/평론/개발자 반응`, `우리 프로젝트에 반영할 점`, `제외할 점`을 기록한다.
- 출처 없는 일반론만으로 판단하지 않는다.
- 오래된 자료를 사용할 수는 있지만, 현재 게임 방향과 맞는지 따로 판단한다.
- Steam/스토어/커뮤니티 반응은 유용하지만 단독 근거로 쓰지 않는다. 가능하면 리뷰 매체, 개발자 인터뷰, GDC/학술 자료와 함께 본다.
- 전문가/현업 발언은 `게임 개발자`, `내러티브 디자이너`, `게임 리뷰어`, `학술 연구`를 포함할 수 있다.

---

## 2. 벤치마킹 작성 템플릿

```md
## 벤치마킹 항목

| # | 게임 / 사례 | 장르 | 참고 출처 | 관찰한 반응 / 평가 | 반영할 점 | 제외할 점 |
|---:|---|---|---|---|---|---|
| 1 |  |  |  |  |  |  |
```

추가 분석:

```md
## 반영 결론

- 반드시 반영:
- 조건부 반영:
- 제외:
- 위험:
```

---

## 3. 초기 벤치마킹 사례 목록

아래 목록은 시작점이다. 새 MVP를 설계할 때는 여기에 새 자료를 추가해도 된다.

| # | 게임 / 사례 | 참고 방향 | 출처 URL |
|---:|---|---|---|
| 1 | PARANORMASIGHT: The Seven Mysteries of Honjo | 도시괴담, 시점 전환, 플로우차트, 선택 실패 후 재추론 | https://en.wikipedia.org/wiki/Paranormasight:_The_Seven_Mysteries_of_Honjo |
| 2 | World of Horror | 단기 사건 묶음, 코즈믹 호러, 상태 압박, 반복 플레이 | https://en.wikipedia.org/wiki/World_of_Horror |
| 3 | Return of the Obra Dinn | 관찰 기반 추론, 정답 도출 만족감, 반복 조사 피로 위험 | https://as.com/meristation/2018/10/23/analisis/1540330984_171917.html |
| 4 | The Case of the Golden Idol | 단서 조합, 보고서 완성, 페어플레이와 추측 위험 | https://en.wikipedia.org/wiki/The_Case_of_the_Golden_Idol |
| 5 | The Rise of the Golden Idol | 사건별 추리와 장기 서사 연결, 단계적 난도 상승 | https://www.theguardian.com/games/2024/nov/30/the-rise-of-the-golden-idol-review-detective-sequel-color-gray-thrilling-whodunnit-takes-sleuthing-to-the-next-level |
| 6 | Disco Elysium | 대화 중심 RPG, 동료 존재감, 전투 없는 갈등 해결, 내면/스킬 대화 | https://en.wikipedia.org/wiki/Disco_Elysium |
| 7 | Scarlet Hollow | 특성 기반 선택지, 숨은 관계 변수, 호러 VN의 반복 플레이 | https://en.wikipedia.org/wiki/Scarlet_Hollow |
| 8 | Citizen Sleeper / Citizen Sleeper 2 | 자원 압박, 주사위/턴 기반 선택, 동료와 관계 | https://www.theguardian.com/games/2025/mar/01/citizen-sleeper-2-starward-vector-review-high-stakes-sci-fi-adventure |
| 9 | Cultist Simulator | 카드 기반 추상 개념 시각화, 플레이어가 직접 정리하는 서사 | https://en.wikipedia.org/wiki/Cultist_Simulator |
| 10 | Her Story | 데이터베이스 검색, 플레이어 주도 추리, 비선형 증거 탐색 | https://en.wikipedia.org/wiki/Her_Story_(video_game) |
| 11 | Immortality | 비선형 영상/기록 탐색, 단서 간 매칭, 조각난 진실 복원 | https://en.wikipedia.org/wiki/Immortality_(video_game) |
| 12 | Phoenix Wright: Ace Attorney Trilogy | 조사와 재판 분리, 증거 제시, 모순 추적 | https://en.wikipedia.org/wiki/Phoenix_Wright:_Ace_Attorney_Trilogy |
| 13 | Danganronpa: Trigger Happy Havoc | 캐릭터 관계, 조사 후 논쟁/재판, 미니게임 과잉 위험 | https://en.wikipedia.org/wiki/Danganronpa:_Trigger_Happy_Havoc |
| 14 | Deduction Game Framework and Information Set Entropy Search | 추리 게임의 정보량 변화와 설명 가능한 의사결정 | https://arxiv.org/abs/2407.21178 |
| 15 | Modeling Fair Play in Detective Stories with Language Models | 추리 서사의 페어플레이, 놀라움과 납득 가능성 균형 | https://arxiv.org/abs/2507.13841 |
| 16 | TurnaboutLLM | Ace Attorney / Danganronpa 기반 장문 추리·모순 탐지 난도 | https://arxiv.org/abs/2505.15712 |
| 17 | Why Do Urban Legends Go Viral? | 도시괴담의 믿을 만한 현실성 + 기억에 남는 비현실성 | https://arxiv.org/abs/1601.06081 |

---

## 4. 도시괴담 기록국에 반영할 공통 결론

### 반드시 반영

- 괴담은 제거 대상이 아니라 규칙을 밝혀 봉인/회수하는 대상으로 유지한다.
- 단서는 UI에 명확히 남기고, 플레이어가 직접 조합한다는 감각을 준다.
- 사건은 짧은 단위로 나누되, 기록국 DB와 연구 보상으로 장기 연결감을 만든다.
- 선택 요원은 단순 스탯이 아니라 조사 방식과 반응을 통해 존재감을 가져야 한다.
- 기록물과 장비는 전투력 상승이 아니라 조사/해석/예측 보조로 작동해야 한다.
- 미니게임은 서사와 추리의 연장이어야 하며, 분리된 액션 과제가 되면 안 된다.

### 조건부 반영

- 플로우차트는 유용하지만 초반부터 복잡하게 만들지 않는다.
- 관계 변수는 유용하지만 연애 호감도가 아닌 수사 파트너 신뢰로 제한한다.
- 랜덤 이벤트는 반복 플레이에 좋지만 단서 추리의 공정성을 깨지 않게 제한한다.
- 데이터베이스 검색은 좋지만 MVP 초기에는 필터/카드 중심으로 시작한다.

### 제외 또는 주의

- 복잡한 재판식 논쟁 시스템은 초기 MVP에서 제외한다.
- 추리 난도를 높인다는 이유로 근거 없는 찍기 구조를 만들지 않는다.
- 미니게임이 본편 추리를 방해할 정도로 길어지면 안 된다.
- 모든 NPC/요원의 장기 개인 루트를 한 번에 만들지 않는다.
- 공포 연출이 스토리 이해를 가리는 방향은 피한다.

---

## 5. MVP별 벤치마킹 적용 방식

### MVP Issue 작성 시

Issue에는 다음 중 필요한 만큼만 요약한다.

```md
## 벤치마킹 반영

- 참고 사례:
- 반영:
- 제외:
- 이유:
```

### Codex Goal 작성 시

Goal에는 긴 벤치마킹 분석을 넣지 않는다.

Codex Goal에는 다음처럼 짧게 참조한다.

```md
벤치마킹 세부 기준은 `docs/BENCHMARKING_REFERENCE_GUIDE.md`를 참고한다.
이번 Goal은 구현 지시만 포함한다.
```

### ChatGPT HTML 대시보드 작성 시

HTML 대시보드에는 벤치마킹 전체 목록을 넣기보다, 현재 MVP와 직접 관련된 3~5개 사례만 요약해서 보여준다.

---

## 6. 최신화 규칙

- 새 MVP에서 새로운 장르/시스템을 도입하면 이 문서에 벤치마킹 사례를 추가한다.
- 출처 URL은 반드시 남긴다.
- 출처가 오래되었거나 링크가 깨졌다면 새 출처로 교체한다.
- 플레이어 반응을 인용할 때는 과장하지 말고, 반복적으로 보이는 반응만 반영한다.
