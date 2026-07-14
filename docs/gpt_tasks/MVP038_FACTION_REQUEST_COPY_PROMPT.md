# GPT 작업 지시문: MVP-038 세력 의뢰 문구 검수

## 목표

`data/faction_requests.json`의 세력 의뢰 9종을 현대 오컬트 기록국의 실무 의뢰처럼 짧고 명확하게 다듬는다. 게임 시스템과 수치는 이미 구현됐으므로 문구만 편집한다.

## 첨부 파일

- `data/faction_requests.json`
- `docs/PROJECT_CONTEXT.md`
- `docs/MVP038_SEQUENTIAL_CAMPAIGN.md`

## 허용 변경

각 의뢰의 다음 문자열 필드만 수정한다.

- `title`
- `description`
- `critical_text`
- `success_text`
- `partial_text`
- `failure_text`

## 변경 금지

- 파일 추가·삭제 또는 허용 파일 밖 수정
- `id`, `faction_id`, `kind`, `ability_key`, `difficulty` 변경
- 의뢰 수, 세력, 능력, 보상, 판정식, 상태, 분기, 저장 구조 변경
- 신규 세력·괴이·필수 스토리·단서 발명
- 의뢰 문구에서 미확보 사건 정보나 회수 정답 공개
- 장문 설정 설명, 과도한 농담, 피해·후유증 희화화

## 문체

- 제목은 짧은 실무 명칭으로 쓴다.
- 설명은 플레이어가 할 일을 한 문장으로 알린다.
- 결과 문구는 판정 등급의 차이가 보이되 1~2문장 이내로 쓴다.
- 실패는 플레이어를 조롱하지 않고 현장 원인과 미완료 상태를 전달한다.
- 세 세력의 관점 차이는 기존 설정 범위에서 은은하게 드러내되 새로운 설정으로 확정하지 않는다.

## 필수 산출물

1. `faction_request_rewrite.patch`
   - 저장소 루트 기준 unified diff
   - `data/faction_requests.json`만 포함
   - 최신 첨부 원문 기준으로 `git apply --check` 가능한 형식
2. `faction_request_review.md`
   - 의뢰별 변경 이유
   - 필드·ID·수치 보존표
   - 정보 누설 검수표
   - UTF-8, JSON 파싱, `git apply --check`, `git diff --check` 결과

GitHub나 원본 저장소에 직접 적용하지 말고 두 결과 파일을 ZIP 하나로 반환한다.
