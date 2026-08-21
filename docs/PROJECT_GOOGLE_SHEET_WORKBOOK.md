# 괴이기록국 프로젝트 Google Sheets Workbook · Legacy Inventory

```yaml
project: urban-legend
sheet_status: LEGACY_READ_ONLY
spreadsheet_url: https://docs.google.com/spreadsheets/d/14xtlvd90iQTKjDLcZR_b-WS5fHnBwNf-OfBruPBS6ck/edit
spreadsheet_id: 14xtlvd90iQTKjDLcZR_b-WS5fHnBwNf-OfBruPBS6ck
workbook_role: MIGRATION_ONLY
new_work_policy: DO_NOT_USE_FOR_NEW_WORK
sheet_edit_policy: NO_NEW_WRITES
base_commit: c987647d01ad2baa028a16e03d85ddfc1572a727
last_verified_at: 2026-07-29
```

이 파일은 과거 Google Sheets 탭의 발견 가능성과 이관 계보만 보존한다. 새 기획·승인·감사 작업면으로 사용하지 않는다. 사람용 전체 그림은 Notion 프로젝트 홈, 구조화 기획·구현·테스트·runtime evidence는 GitHub repository가 소유한다.

## 검증된 탭
- `00_프로젝트_허브`
- `01_작업순서`
- `02_현재_확정결정`
- `03_근거_라이브러리`
- `04_누락_충돌_감사`
- `05_GDD_요약`
- `10_제품방향`
- `11_세계관`
- `12_핵심루프`
- `13_주요인물`
- `14_조연_세력_관계`
- `15_조작_게임규칙`
- `20_코어경험_데모목표`
- `30_데모범위_품질기준_제작기반`
- `40_핵심시스템_메인콘텐츠`
- `41_성장_경제`
- `50_메인콘텐츠`
- `51_미니게임`
- `52_글쓰기_서사`
- `60_UX_UI_접근성`
- `70_아트_오디오_에셋`
- `71_이미지기획_생성목록`
- `72_이미지검수_승인로그`
- `80_데모_버티컬슬라이스_플레이테스트`
- `90_본제작_출시_사업`
- `98_Base_반영후보`
- `99_변경이력`

## 프로젝트 책임 매핑

| 의미 구조 | 프로젝트 책임 원본 |
|---|---|
| 핵심루프 | 연간 준비→현장 조사→기록·단서→가설 증명→결과 환류 |
| CORE 사건 | `CORE-MVP-001`과 에피소드 JSON·기록·가설 정본 |
| 연간 운영 | `ANNUAL-MVP-002`와 동료·장비·연구·Save 정본 |
| 미니게임·서사 | 사건별 규격과 `51_미니게임`, `52_글쓰기_서사` |
| 이미지 계획·검수 | `docs/IMAGE_ASSET_WORKFLOW.md` |

새로운 Sheet 쓰기는 금지한다. 이관이 필요한 고유 정보는 Notion 또는 Repository의 책임 원본에 흡수한 뒤 exact readback으로 확인한다.
