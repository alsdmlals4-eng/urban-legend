# 이미지 자산 제작·GPT 기획 시각화·검수 워크플로

- Base: `alsdmlals4-eng/Base@7072b9e2742a60d7548fd39df3328ad76a8dbad1`
- Mode: `planning-visualization`, `final-visual-candidate`, `visual-qa-and-approval`
- Sheet: `NOT_CONFIGURED`

## 역할

GPT는 프로젝트 정본과 레퍼런스를 바탕으로 기획 중 탐색 이미지·목업과 기획 종료 실사용 후보를 생성한다. Codex는 승인된 후보의 파일 규격·manifest·Godot import·실제 화면 적용을 담당한다. DeepSeek는 명시적 대량 초안 위임에서만 보조하며 이미지 생성의 기본 소유자가 아니다.

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

## `ASSET_MANIFEST.json`

manifest에는 단계, 상태, Image ID, 선택 콘셉트, 최종 프롬프트, 모델·버전, 용도, 파일명, 크기, 알파 여부, 참조 이미지·원출처, 교체 승인, QA와 실제 적용 결과를 기록한다.

- PNG 경로가 작업 묶음 밖으로 나가지 않는가.
- 해상도·알파·여백·파일명이 규칙에 맞는가.
- 최종 변형이 승인 후보와 정본을 참조하는가.
- 기존 파일 덮어쓰기가 승인되었는가.
- Godot import가 성공하고 16:9 화면에서 UI·플레이 요소를 가리지 않는가.
- 기존 프로젝트 스타일과 일치하는가.

투명 컷아웃은 크로마키 후처리를 기본으로 유지하며 복잡한 반투명 소재는 승인 뒤 별도 투명 출력 경로를 사용한다.
