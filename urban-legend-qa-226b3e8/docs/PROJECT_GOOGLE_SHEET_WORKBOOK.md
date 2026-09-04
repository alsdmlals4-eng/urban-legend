# 괴이기록국 프로젝트 Google Sheets Workbook

```yaml
project: urban-legend
sheet_status: PROJECT_SHEET_CONFIGURED
spreadsheet_url: https://docs.google.com/spreadsheets/d/14xtlvd90iQTKjDLcZR_b-WS5fHnBwNf-OfBruPBS6ck/edit
spreadsheet_id: 14xtlvd90iQTKjDLcZR_b-WS5fHnBwNf-OfBruPBS6ck
workbook_role: USER_FACING_GDD_WORKSPACE
sheet_edit_policy: PROPOSED_SHEET_CHANGE
base_commit: c987647d01ad2baa028a16e03d85ddfc1572a727
last_verified_at: 2026-07-29
```

Google Sheets는 CORE 사건·연간 운영·동료·장비·연구·가설 보드·미니게임·서사의 전체 흐름을 사용자가 확인·수정하고 AI가 GitHub 정본·실제 구현과 함께 읽는 GDD 작업면이다.

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

확정 상태와 `PROVISIONAL_BASELINE`을 섞지 않으며 GitHub에 없는 사용자 수정은 `PROPOSED_SHEET_CHANGE`로 보존한다.
