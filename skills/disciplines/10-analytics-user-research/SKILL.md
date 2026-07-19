---
name: urban-legend-analytics-user-research
description: Urban Legend의 분석·유저리서치 작업을 해당 본책, 등록 부록, 검증 경로로 라우팅한다.
---

# Urban Legend 분석·유저리서치 스킬

## 사용할 때

참고 사례, 플레이어 반응 가설, 측정·리서치 계획을 책임진다.

## 먼저 읽을 파일

1. `[기획서]/10_분석_유저리서치/10_분석_유저리서치_본책.md`
2. `[기획서]/00_프로젝트_허브/ACTIVE_CONTEXT.md`
3. `[기획서]/00_프로젝트_허브/DOCUMENTATION_MAP.md`
4. 관련 `등록_부록/` 원문과 실제 대상 파일

## 작업 계약

- 외부 비교는 방향 참고일 뿐 프로젝트 사실을 덮어쓰지 않는다.
- 본책과 등록 부록의 책임을 섞지 않는다. 실행 데이터·상태·경로·해시는 JSON Registry 또는 실제 파일을 원본으로 한다.
- 변경 뒤 본책의 현재 상태·다음 작업·검증 경로를 갱신하고, 미실행 검증은 `NOT_RUN`으로 기록한다.

## 검증

`python tools/verify_migration_inventory.py --before docs/MIGRATION_INVENTORY_BEFORE.json --after docs/MIGRATION_INVENTORY_AFTER.json`
