# Base → Urban Legend 보존 감사

## 기준

- 비교 Base: `eb40b912e5f5a0e4d369105a4f0a770e0a6179a9`
- 기존 기록 Base: `d2457e75a856260d309203e20262f2a2142d2dd6` — 현 원격 이력의 직접 조상으로 확인되지 않아 의미 기반 비교만 한다.
- 이주 입력: 581개 (`docs/MIGRATION_INVENTORY_BEFORE.json`)
- 연결 Issue: #37, #38, #39, #40

## 현행 인벤토리

| 대상 | 현행 계약 | 상태 |
|---|---|---|
| 프로젝트 허브 | `[기획서]/00_프로젝트_허브` | 현행 |
| 책임 문서 | 프로젝트 전체 1 + 분야별 본책 11 | 현행 |
| 분야 스킬 | `skills/disciplines/01`~`11` | 현행 |
| QA 증거 | `docs/qa/captures` | 보존 |
| 게임 구현 | `project.godot`, `scripts/`, `scenes/`, `data/` | 보호 |

## 보호 기준선

| 경로 | 기준 |
|---|---|
| `project.godot` | `efb0b9f595d142cca20d92a0555ecb793a1e440decd72dd24dbdb77c23319322` |
| `scripts/core/game_state.gd` | `dc0a8ad69e7913ecbf8b955309ea9d770f7465bce97c79d6408ebb74c362ea6f` |
| `data/episodes/**` (3 files aggregate) | `06216313bb70391f96f5b595b183e1c2c846e77e37fdc6f03c08e0a70d497815` |
| `scenes/` | 17 files, 변경 금지 |
| `assets/` | 155 files, 변경 금지 |
| `docs/qa/captures/` | 150 files, 변경 금지 |

## 보존 대조 예외

기존 네 PowerShell 계약 테스트는 새 허브 경로를 가리키도록 갱신되어 바이트 해시가 달라졌다. 원본은 기준 커밋 `dd3c9a8`에서 복구 가능하며, 이들은 `UPDATED_BY_CONTRACT`로만 허용한다. 그 외 누락은 실패다.

## 삭제·이동 판정

이번 단계에서 새 삭제·이동은 없다. `[백업]`, `[보류]`, 등록 부록, 실제 캡처와 승인 자산은 모두 보존한다. 제거 후보는 참조·고유 정보·복구·사용자 승인 검증 전까지 생성하지 않는다.
