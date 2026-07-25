# TEST_CHECKLIST

> 문서 위치: `TEST_CHECKLIST.md`  
> 상태: `docs/CURRENT_STATUS.md`  
> 코어: `docs/PROJECT_CORE.md`  
> 로드맵: `MVP_ROADMAP.md`

## 현재 기준

- 구현 기준선: MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A
- 화면 버전: Ver 4.2
- 저장 Schema: `mvp-039` (`mvp-038` 이관 지원)
- CORE-MVP-001: `POC_BUILD_READY`
- 연도제 설계: `APPROVED_DESIGN_BASELINE`
- 정본 전환: `COMPLETE`
- ANNUAL-MVP-001: `BUILD_READY`
- 사람 눈 QA: `NOT_RUN`
- 플레이 검증: `NOT_RUN`
- `POC_PASSED`: `NOT_DECLARED`
- 제작 확대: `NOT_APPROVED`

## 정본 전환

- [x] `PROJECT_CORE`가 육성+사건 이중 코어를 소유
- [x] GDD v3.0이 연도제 전체 설계를 소유
- [x] MVP_ROADMAP이 ANNUAL-MVP-001~004를 소유
- [x] PR #61 정본 전환 병합
- [x] 문서 계약 PASS

## CORE-MVP-001 보존 회귀

- [x] 조사 3, 단서 6, 매뉴얼 3, 선택지 4, 가설 2
- [x] 관측 가능한 근거로 선택지 배제
- [x] 지지·반박·미해결 근거를 가진 가설 카드
- [x] `unknown → clue → likely → understood`
- [x] 전조 실패 시 거짓 예측 금지
- [x] 미관측 패턴 첫 발동의 범용 대응과 피해 상한
- [x] HP 0이 아닌 포획 창 개방
- [x] 결과 비교→매뉴얼 반영 검토→기록 확정
- [x] 독립 기본 실행 유지
- [x] focused suite 4/4 PASS
- [x] 전체 Godot 회귀에 포함
- [ ] 사람 눈 장문·시각 밀도 QA
- [ ] 신규 플레이어 인과 설명

## ANNUAL-MVP-001 데이터·상태

- [x] 3주·주당 3슬롯 데이터 계약
- [x] 활동 7개와 고정 `annual001_` ID
- [x] 권나래 역량 4종의 결정론적 성장
- [x] 피로 증가·회복·0~100 상한
- [x] 기관 지원 0~3
- [x] 오현 업무 신뢰 0~3
- [x] 주간 결과 요약
- [x] 2주차 자율 출동
- [x] 3주차 출동 위험 +15
- [x] 3주차 재지연 시 긴급 출동 위험 +30
- [x] 잘못된 명령의 상태 불변
- [x] 정상·비용·긴급 포획 실패 전진 결과
- [x] 최종 엔딩이 아닌 분기 결산 모형

## 장비·연구

- [x] 기본 장비 `현장 기록기` 1개
- [x] 모듈 슬롯 1개
- [x] 신호 완충 모듈 연구
- [x] 기관 지원으로 공용 `긴급 엄호` 해금
- [x] 검증된 매뉴얼+잔향 자료로 `신호 교차 검증` 해금
- [x] 연구가 핵심 정답·가설을 자동 확정하지 않음
- [x] 사건 결과가 잔향 자료·기관 지원·연구로 환류

## 동료 자동 지원

- [x] 오현 고유 스킬 `절차 교차 확인`
- [x] 공용 보조 스킬 슬롯 1개
- [x] 적합 조건에서만 발동 판정
- [x] 조건·현재 확률·지원 준비도·남은 횟수 공개
- [x] 연속 불발 시 준비도 누적
- [x] 최대 준비도에서 다음 적합 조건 확정 발동
- [x] 신뢰 조건에서 대표 고유 스킬 전투당 보장
- [x] battle limit 적용
- [x] 동일 event key 판정 캐시
- [x] 동일 event key 효과 중복 적용 금지
- [x] 같은 seed·입력 순서 판정 재현
- [x] 테스트 고정 판정열과 production seeded RNG 분리
- [x] 허용 효과는 체력 회복·위험 완화
- [x] 정답·가설·이해도·관측 패턴·포획 표식 변경 금지

## 사건 adapter·CORE 확장

- [x] 기존 CORE-MVP-001 데이터 override
- [x] 피로→시작 체력
- [x] 출동 지연→시작 위험
- [x] 관찰→전조 판독률 보조
- [x] 분석→중립 비교 정보
- [x] 현장 대응→피해 완화
- [x] 모듈→미관측 첫 피해 상한
- [x] 핵심 단서·배제 규칙·가설·패턴·포획 조건 불변
- [x] 결과와 manual delta 반환
- [x] CORE 외부 지원 event key 멱등성
- [x] 기존 CORE F1 버튼과 독립 Scene 유지

## 저장·복원

- [x] PoC 전용 `user://annual_mvp_001_poc.json`
- [x] 원자적 temp write·rename
- [x] 잘못된 버전·깨진 JSON 안전 실패
- [x] 주간 계획 전·결과 뒤·사건 결과 뒤 저장 가능
- [x] 사건 진행 중 저장 금지
- [x] PREPARATION snapshot round-trip
- [x] 저장 seed로 동료 지원 판정 재현
- [x] 기존 `GameState` 비사용
- [x] 기존 `mvp-039`·`mvp-038` 이관 비침범

## UI·개발 진입

- [x] F1 `ANNUAL-MVP-001 육성→사건→연구 PoC` 버튼
- [x] 기존 CORE-MVP-001 버튼 보존
- [x] 현재 phase 패널 1개만 표시
- [x] 주간 계획·결과·출동·준비·사건·연구·결산 흐름
- [x] 사건 중 Save 버튼 비활성
- [x] 1280×720·1920×1080 기계적 레이아웃 계약
- [x] 분기 결산이 최종 엔딩이 아님을 텍스트로 표시
- [ ] 한국어 장문 줄바꿈·시각 밀도 사람 눈 QA
- [ ] 실제 마우스·키보드·Esc·포커스 QA

## 자동 검증 증거

ANNUAL workflow run #59:

- [x] Python 데이터·정적·활성 문서 계약 PASS
- [x] Godot 4.7.1 import PASS
- [x] CORE-MVP-001 focused 4/4 PASS
- [x] ANNUAL-MVP-001 focused 6/6 PASS
- [x] 전체 Godot 회귀 49/49 PASS
- [x] 신규 Scene 기계적 UI 계약 PASS
- [x] 보호 경로 정적 계약 PASS

## 보호 경계

- [x] `scripts/core/game_state.gd` 미변경
- [x] 기존 `data/episodes/**` 미변경
- [x] `scripts/scenes/investigation_scene.gd` 미변경
- [x] `scripts/scenes/battle_scene.gd` 미변경
- [x] `project.godot` 미변경
- [x] `knowledge/base-pack/**` 미변경

## 플레이 검증 — 미실행

- [ ] 조기 출동과 지연 출동의 차이를 플레이어가 설명
- [ ] 긴급 출동의 비용과 준비 부족을 이해
- [ ] 육성 선택이 사건 정보·위험·피해 관리에 연결됨을 설명
- [ ] 사건 결과가 연구·스킬·결산으로 환류함을 설명
- [ ] 동료 자동 지원의 조건·확률·준비도가 공정하다고 인식
- [ ] 분기 결산을 최종 엔딩이 아닌 중간 결과로 인식
- [ ] 주간 일정 반복 피로도 확인

## 최종 상태

```text
canonical_migration: COMPLETE
automated_document_validation: PASSED
annual_mvp_001: BUILD_READY
automated_verification: PASSED
human_visual_qa: NOT_RUN
player_validation: NOT_RUN
annual_loop_passed: NOT_DECLARED
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```
