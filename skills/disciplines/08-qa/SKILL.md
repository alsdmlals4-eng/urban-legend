---
name: urban-legend-qa
description: Urban Legend의 QA 작업을 해당 본책, 등록 부록, 검증 경로로 라우팅한다.
---

# Urban Legend QA 스킬

## 사용할 때

자동·수동 검증, 결함, 캡처 증거, 재현 절차와 릴리스 게이트를 책임진다.

## 먼저 읽을 파일

1. `[기획서]/08_QA/08_QA_본책.md`
2. `[기획서]/00_프로젝트_허브/ACTIVE_CONTEXT.md`
3. `[기획서]/00_프로젝트_허브/DOCUMENTATION_MAP.md`
4. 관련 `등록_부록/` 원문과 실제 대상 파일

## 작업 계약

- 47개 새 PNG와 기존 캡처는 docs/qa/captures 경로를 유지하고 로그 22개는 추적하지 않는다.
- 본책과 등록 부록의 책임을 섞지 않는다. 실행 데이터·상태·경로·해시는 JSON Registry 또는 실제 파일을 원본으로 한다.
- 변경 뒤 본책의 현재 상태·다음 작업·검증 경로를 갱신하고, 미실행 검증은 `NOT_RUN`으로 기록한다.

## 검증

`python tools/verify_migration_inventory.py --before docs/MIGRATION_INVENTORY_BEFORE.json --after docs/MIGRATION_INVENTORY_AFTER.json`
