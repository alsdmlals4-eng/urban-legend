# TEST_CHECKLIST

> 문서 위치: `TEST_CHECKLIST.md`  
> 상태: `docs/CURRENT_STATUS.md`  
> 코어: `docs/PROJECT_CORE.md`  
> 로드맵: `MVP_ROADMAP.md`

## 목적

현행 사건 코어 CORE-MVP-001 `POC_BUILD_READY`를 회귀 기준으로 보호하면서, 승인된 연도제 설계의 정본 전환과 ANNUAL-MVP-001 격리 수직절편을 검증한다. 사건 PoC 자동 통과, 연도제 구현 완료, 플레이 통과를 혼합하지 않는다.

## 현재 기준

- 구현 기준선: MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A
- 화면 버전: Ver 4.2
- 저장 Schema: `mvp-039` (`mvp-038` 이관 지원)
- CORE-MVP-001 구현: `POC_BUILD_READY`
- 연도제 설계: `APPROVED_DESIGN_BASELINE`
- 연도제 구현: `NOT_IMPLEMENTED`
- 플레이 증거: 없음
- `POC_PASSED`: `NOT_DECLARED`
- 제작 확대: `NOT_APPROVED`

## 정본 전환 계약

- [x] 승인 설계 파일 존재
- [x] 승인 기록 파일 존재
- [x] 정본 전환 계획 존재
- [x] ANNUAL-MVP-001 구현 계획 존재
- [ ] `PROJECT_CORE`가 육성+사건 이중 코어를 소유
- [ ] GDD v3.0이 전체 상세 설계를 소유
- [ ] CURRENT_STATUS·CURRENT_HANDOFF가 병합 이력을 정확히 기록
- [ ] MVP_ROADMAP이 ANNUAL-MVP-001~004를 소유
- [ ] 문서 지도와 활성 문서가 같은 권한 순서를 사용
- [ ] 오래된 PR #57 대기 상태가 활성 문서에서 제거됨
- [ ] 정본 전환 문서 계약 Actions 통과
- [ ] 변경 범위에 코드·데이터·Scene·저장 Schema 없음

## 문서 전용 자동 검증

```text
Ubuntu
Python 3.12
python -m unittest tests/test_base_operating_sync.py tests/test_skill_package_integrity.py tests/test_active_document_references.py tests/test_core_validation_contract.py
```

- [ ] 연도제 정본 계약 PASS
- [ ] 상대 Markdown 링크 PASS
- [ ] backtick 저장소 경로 PASS
- [ ] Base 운영 동기화 PASS
- [ ] Skill package 무결성 PASS
- [ ] 기존 CORE-VALIDATION 계약 PASS
- [ ] `git diff --check` PASS
- [ ] 실행하지 않은 Godot 검증을 새 통과로 보고하지 않음

## CORE-MVP-001 보존 회귀

다음은 PR #55 통합 전 검증된 사건 코어 기준이다.

### 데이터 계약

- [x] `contract_version == core-mvp-001-v1`
- [x] 조사 장면 3, 단서 6, 매뉴얼 3, 선택지 4, 가설 2, 패턴 3, 행동 8
- [x] 모든 전용 ID가 `poc001_`로 시작하고 중복 없음
- [x] 모든 참조가 같은 JSON에서 해소
- [x] 회수 순서 5턴, 미관측 패턴 3·5턴 출현
- [x] 포획 표식 3개, 최소 포획 5턴, 최대 회수 8턴
- [x] 미관측 패턴 1개와 범용 완화 행동 존재
- [x] `enemy_hp` 계약 없음

### 조사·가설

- [x] 선택지 4개와 관련 기록 3개 표시
- [x] 올바른 기록 연결로 정확히 두 선택지 배제
- [x] 잘못된 연결은 체력·위험·단계 변화 없음
- [x] 남은 두 가설을 플레이어가 직접 선택
- [x] 지지·반박·필수 미해결 질문 직접 연결
- [x] 무관하거나 확보하지 않은 근거 제출 거부
- [x] 잘못된 가설은 반응 단서·피해·위험 사례를 남김
- [x] 실패 뒤 기존 가설 1개 + 변형 가설 1개 유지

### 이해도·전조

- [x] `unknown → clue → likely → understood` 단계만 사용
- [x] 가설 제출과 이해도 승격은 결정론적
- [x] 필수 질문 해소 뒤 `understood`
- [x] 전조 확률은 관측한 패턴의 정보 공개만 결정
- [x] 전조 실패는 정보 없음이며 거짓 예측 없음
- [x] `understood`에서 관측 패턴 확정 해석
- [x] 저장·불러오기로 PoC seed 결과 재추첨 없음

### 회수 전투

- [x] 실제 패턴을 해석 전에 고정
- [x] 미관측 패턴 첫 발동 정보 비공개
- [x] 첫 발동에 범용 대응 유효
- [x] 최초 관측 피해 상한과 체력 최저 1 보장
- [x] 첫 발동 뒤 패턴 관측 목록 등록
- [x] 포획 표식을 중복 없이 축적
- [x] 정상 포획 창은 표식 3개와 5턴 이상에서 개방
- [x] 위험·체력·최대 턴 임계에서 긴급 포획 가능
- [x] 승리 조건에 적 HP 0 없음

### 결과·매뉴얼

- [x] 회수 품질·피해 관리·지식 품질 분리
- [x] 정상·비용·긴급 포획 결과 구분
- [x] 요건 미달 시 매뉴얼 `candidate`
- [x] 요건 충족 시 `verified`
- [x] 위험 사례와 관측 패턴 보존
- [x] `RESULT_COMPARE → MANUAL_PROMOTION → COMPLETE`

### UI·접근성·저장

- [x] 현재 단계 패널만 표시
- [x] 단계별 `ScrollContainer`
- [x] Footer와 단계 스크롤 분리
- [x] 이전 단계 읽기 전용 검토
- [x] Esc·포커스 복구
- [x] 전조·성공·위험을 텍스트로 전달
- [x] 시간 제한 없음
- [x] 1280×720·1920×1080 기계적 UI 계약 PASS
- [x] 기존 접근성 설정 비침범
- [x] 기존 저장 `mvp-039` 비침범
- [x] `mvp-038` 이관 계약 비침범
- [ ] 한국어 장문 줄바꿈·시각 밀도 사람 눈 QA

### 자동 회귀 증거

- [x] 집중 CORE-MVP-001 4/4 PASS
- [x] 전체 Godot 회귀 43/43 PASS
- [x] Godot 4.7.1 import PASS
- [x] Python 데이터·정적 계약 PASS
- [x] 보호 경로 diff PASS
- [x] 플레이 증거 없음 / `POC_PASSED` 미선언

## ANNUAL-MVP-001 사전 체크리스트

### 데이터·상태

- [ ] 3주·주당 3슬롯 PoC 데이터 계약
- [ ] 권나래 역량 4종의 결정론적 성장
- [ ] 피로 증가·회복·상한
- [ ] 동료 업무 신뢰 0~3
- [ ] 주차별 자율 출동·지연 위험·긴급 출동
- [ ] 사건 진입 전 loadout 검증
- [ ] 분기 결산 phase와 완료 상태

### 장비·연구

- [ ] 기본 장비 1개 + 모듈 슬롯 1개
- [ ] 연구 프로젝트 요구 기록·잔향 자료 검증
- [ ] 기관 교육 공용 스킬 획득
- [ ] 괴이 연구 공용 스킬 획득
- [ ] 연구가 정답·가설을 자동 확정하지 않음

### 동료 자동 지원

- [ ] 동료 고유 스킬 1개
- [ ] 공용 보조 스킬 장착 1개
- [ ] 적합 조건에서만 발동 판정
- [ ] 조건·현재 확률·지원 준비도 공개
- [ ] 연속 불발 시 준비도 누적
- [ ] 최대 준비도에서 다음 적합 조건 확정 발동
- [ ] 저장 재불러오기 재추첨 금지
- [ ] 테스트 고정 판정열과 production seeded RNG 분리
- [ ] 숨은 정답·가설·이해도·포획 표식 변경 금지
- [ ] 효과는 체력 회복·위험 완화·다음 기회 생성으로 제한

### 사건 adapter

- [ ] 기존 CORE-MVP-001 입력 데이터 override
- [ ] 성장·장비가 starting health·risk·정보 표시 보조만 조정
- [ ] 핵심 단서·elimination rule·hypothesis·pattern·capture rule 불변
- [ ] 기존 CORE-MVP-001 결과와 manual delta 반환
- [ ] 사건 결과 → 잔향 자료·기관 지원·연구 해금
- [ ] 기존 CORE-MVP-001 기본 실행 회귀 유지

### 저장·복원

- [ ] PoC 전용 `user://annual_mvp_001_poc.json`
- [ ] 기존 `GameState` 비사용
- [ ] 기존 save path 비생성·비변경
- [ ] 주간 계획 전·주간 결과 뒤·사건 결과 뒤 저장
- [ ] 사건 진행 중 저장 금지
- [ ] 사건 시작 전 seed와 동일 입력 순서로 지원 판정 재현
- [ ] 깨진 save·버전 불일치 안전 실패

### UI·접근성

- [ ] F1 개발 패널 진입
- [ ] 주간 계획·결과·출동·준비·사건·연구·결산 단일 흐름
- [ ] 현재 단계 정보만 전면 표시
- [ ] 1280×720·1920×1080 viewport
- [ ] 키보드·마우스·Esc·포커스
- [ ] 확률·준비도·지연 위험을 텍스트로 전달
- [ ] 한국어 장문 줄바꿈 사람 눈 QA

### 인과 검증

- [ ] 준비하지 않은 경로와 준비한 경로의 사건 위험 차이
- [ ] 지연 출동과 조기 출동의 비용 차이
- [ ] 사건 결과가 연구·스킬·결산으로 되돌아옴
- [ ] 성장 수치가 정답을 대체하지 않음
- [ ] 플레이어가 육성 선택과 사건 결과의 연결을 설명

## 보호 경계

- [x] `scripts/core/game_state.gd` 보호
- [x] 기존 `data/episodes/**` 보호
- [x] 기존 `scripts/scenes/investigation_scene.gd` 보호
- [x] 기존 `scripts/scenes/battle_scene.gd` 보호
- [x] `project.godot` 보호
- [x] `knowledge/base-pack/**` 보호
- [x] 저장 `mvp-039`와 `mvp-038` 이관 보호

ANNUAL-MVP-001 구현 PR에서 위 경계를 다시 diff로 검사한다.

## 플레이 검증

### CORE-MVP-001

- [ ] 규칙·대응 이유 설명
- [ ] 근거 기반 배제
- [ ] 조사-회수 인과 체감
- [ ] 난수 불공정 인식
- [ ] 매뉴얼 저작감
- [ ] 미관측 패턴 무대응 인식

### ANNUAL-MVP-001

- [ ] 육성·준비 선택의 사건 차이 설명
- [ ] 사건 결과의 연구·스킬 환류 인식
- [ ] 동료 자동 지원의 공정성
- [ ] 주간 일정 반복 피로도
- [ ] 분기 결산의 중간 결과 인식

플레이 증거가 없으므로 `POC_PASSED` 또는 연도제 루프 통과를 선언하지 않는다.

## 현재 상태

```text
canonical_migration: IN_PROGRESS
automated_document_validation: PENDING
annual_mvp_001: PLAN_PENDING_APPROVAL
runtime_changes: NONE
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```
