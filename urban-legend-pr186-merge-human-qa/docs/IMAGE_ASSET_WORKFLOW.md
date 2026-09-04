# 이미지 자산 제작·GPT 기획 시각화·검수 워크플로

- Base: `alsdmlals4-eng/Base@fa69a77a14f923a756064f6ae151d34cadb374f7`
- Mode: `planning-visualization`, `final-visual-candidate`, `visual-qa-and-approval`
- Sheet: `PROJECT_SHEET_CONFIGURED`
- 제품 자산 승인·의미 권위: 루트 `ASSET_MANIFEST.yml`
- Legacy inventory: `assets/ASSET_MANIFEST.json` = `LEGACY_MIGRATION_PENDING_NON_AUTHORITY`

## 역할

GPT는 프로젝트 정본과 레퍼런스를 바탕으로 기획 중 탐색 이미지·목업과 기획 종료 실사용 후보를 생성한다. Codex는 승인된 후보의 파일 규격·manifest·Godot import·실제 화면 적용을 담당한다. DeepSeek는 명시적 대량 초안 위임에서만 보조하며 이미지 생성의 기본 소유자가 아니다.

현재 제품 자산 승격은 fail-closed다. `71_이미지기획_생성목록`·`72_이미지검수_승인로그`와 GitHub 정본에서 같은 자산이 `PROJECT_ASSET_APPROVED`로 승인되고, 루트 `ASSET_MANIFEST.yml`에 승인·의미·권리·용도가 기록된 뒤에만 tracked 제품 자산 승격을 허용한다. 현재 루트 manifest의 승인 자산 목록은 비어 있으며 자동 생성·자동 승격·자동 교체를 하지 않는다.

원격 작업 환경에서 프로젝트 로컬 `.asset-vault/`를 읽지 못하면 `VAULT_LOCAL_STATE_UNVERIFIED`를 유지한다. 로컬 후보 존재를 과거 대화·이전 manifest·Repo 상태만으로 추정하지 않는다.

## 기획 중 우선 이미지

1. 연간 일정·일상·조사·회수·복귀 핵심루프 시각화.
2. 권나래와 동료·요원·기관·세력 관계·표정·대화 장면.
3. 조사 VN, 규칙 가설 카드, 단서·위험·기록물 UI 목업.
4. 에피소드별 미니게임과 회수·회복 전투의 연결 화면.
5. 현대 한국 도시괴담의 장소·조명·괴이 징후 톤 보드.

## 기획 종료 우선 후보

1. Annual Demo·Steam 키아트·캡슐·스크린샷.
2. 주요 인물 초상·표정·컷인 시트.
3. 괴이 기록 매뉴얼·규칙 카드·장비·기관 시각 체계.
4. 조사·분기·미니게임·회복 전투의 실제 16:9 UI 고도화 목업.

## 상태와 검수

`PLANNED → GENERATED_EXPLORATION → IN_REVIEW → REVISION_REQUIRED/REJECTED/APPROVED_CANDIDATE → PROJECT_ASSET_APPROVED → APPLIED_AND_RUNTIME_VERIFIED`.

기획·세계관·인물·괴이 규칙 일치, 실제 16:9 가독성, 구현 가능성, 손·표정·한글·간판·원근·광원 오류, 특정 IP·작가 스타일 유사성, 원출처·라이선스·모델·프롬프트를 검수한다. 생성 이미지는 자동 최종 자산이 아니다.

## 루트 `ASSET_MANIFEST.yml`

루트 `ASSET_MANIFEST.yml`은 최신 Base `docs/PROJECT_LOCAL_ASSET_VAULT_POLICY.md`와 `templates/project-operations/ASSET_MANIFEST.yml` 계약을 따른 tracked 승인·의미·권리 원장이다.

- `PROJECT_ASSET_APPROVED` 전 후보는 제품 자산이 아니다.
- 승인 전 로컬 후보는 `.asset-vault/`와 `assets/_vault_local/` 경계를 벗어나 tracked 제품 경로로 자동 승격하지 않는다.
- 명시적 제품 승인과 promote 경계 없이 Scene/Resource가 로컬-only 경로를 장기 참조하지 않는다.
- 실제 Godot import·16:9 적용·접근성·시각 QA를 실행하지 않았다면 manifest의 검증 상태를 통과로 쓰지 않는다.
- 승인·교체·폐기는 관련 Decision ID와 Sheet 승인 로그를 함께 남긴다.

## Legacy `assets/ASSET_MANIFEST.json`

`assets/ASSET_MANIFEST.json`은 과거 제작 재고와 생성 기록을 보존하는 `LEGACY_MIGRATION_PENDING_NON_AUTHORITY` 자료다. 그 안의 `stage: final`, 파일명, QA 문구는 현재 `PROJECT_ASSET_APPROVED` 또는 런타임 승인을 부여하지 않는다.

Legacy 항목은 다음 조건을 모두 만족한 경우에만 새 루트 manifest의 제품 자산 항목으로 개별 승격할 수 있다.

1. 실제 파일·현재 Godot 참조와 원출처를 재확인한다.
2. 권리·유사성·규격·가독성·접근성·런타임 검증 상태를 현재 증거로 다시 판정한다.
3. GitHub 정본과 Sheet에 `PROJECT_ASSET_APPROVED`가 같은 자산/Decision 단위로 기록된다.
4. 루트 `ASSET_MANIFEST.yml`에 canonical path·권리·용도·검증 증거를 기록한다.
5. 명시적 승격 이후에만 `APPLIED_AND_RUNTIME_VERIFIED`를 판정한다.

투명 컷아웃을 포함한 기존 제작 방식은 역사적 기록으로만 보존한다. 새 제작·교체 방식은 현재 Base 정책과 자산별 승인에서 다시 정한다.
