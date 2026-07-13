# AI 위임 제작 워크플로

## 목표와 책임

토큰 소모가 큰 조사·초안·창작을 작업에 맞는 모델로 보내고 Codex는 핵심 상태, 실제 diff, 충돌 조정, 실행 검증과 최종 품질을 소유한다. 초기 목표는 혼합 작업에서 Codex 토큰 40~60% 절감이며 20개 작업 뒤 실제 지표로 다시 계산한다. 이는 보장 수치가 아니라 운영 가설이다.

- DeepSeek `scout-flash`: 로컬 파일 조사, 목록, 호출 관계, 구조·누설 1차 검사
- DeepSeek `research-scout-flash`: 출처가 필요한 공개 웹 벤치마킹
- DeepSeek `builder-flash`: 1~2개 단순 비보호 파일 구현, 3~5개 응집 작업의 초안
- 외부 GPT: 대사, 튜토리얼, 감정선, 캐릭터 설정, 장문 기획, UX 문구
- 이미지 모델: 콘셉트와 게임용 래스터 자산
- Codex: 한 파일 20줄 이하의 명확한 수정, 보호 경로, 저장·경제·진행·핵심 규칙, 적용·검증

## 공통 수명 주기

명령 순서는 `route → prepare → start/status/resume → collect → verify → complete/cleanup`이다. `prepare`는 원문 전체 대신 다음 최소 묶음을 만든다.

- `TASK_CONTRACT.md`: 목표, 플레이어 가치, 포함/제외 범위, 완료·검증 기준
- `INPUT_MANIFEST.json`: 입력 경로, 크기, SHA-256
- `PROMPT.md` 또는 `IMAGE_BRIEF.md`
- 공급자별 예상 산출물 목록

DeepSeek `start`는 별도 워커를 시작하고 즉시 `running`을 반환한다. 중단 또는 일시적 API 오류만 같은 세션으로 한 차례 `resume`한다. 권한·계약·검증·품질 실패는 재실행하지 않고 Codex가 인수한다. 실패하거나 변경된 worktree는 자동 삭제하지 않는다.

## 산출물 계약과 안전

- 대사: `dialogue_rewrite.patch`, `dialogue_review.md`
- 기획·UX: `DESIGN_PROPOSAL.md`, `DESIGN_REVIEW.md`
- 문서: `document_rewrite.patch`, `document_review.md`
- 이미지: 이미지 파일, `ASSET_MANIFEST.json`
- DeepSeek: 800단어 이하 `WORKER_REPORT.txt`, 필요 시 worktree diff

모든 외부 산출물은 신뢰하지 않는 입력이다. 절대 경로, `..` 경로 이탈, 허용되지 않은 파일, 보호 경로, 원본 해시 불일치, review 누락, 신규 저장 필드·분기·단서·플래그, 미확보 정보 누설을 적용 전에 거부한다. 외부 GPT와 이미지는 한 차례의 집중 수정 라운드만 기본 허용한다. 이후 Codex가 최소 조정하거나 사용자 판단을 요청한다.

## 측정과 20건 검토

메트릭에는 provider, 입력 원문 바이트, 검토 산출물 바이트, 최초 승인 여부, 재작업 횟수, 결과 회수 여부, Codex 인수 여부, 실패 분류를 기록한다. 20건 뒤 다음을 검토한다.

- Codex 직접 작성 비율 40% 이하
- 첫 통과율 70% 이상
- 결과 회수율 95% 이상
- 보호 경로 자동 적용 0건

수치가 목표보다 나쁘면 무조건 위임량을 늘리지 않는다. 실패가 많은 작업 유형은 Codex로 되돌리고, 입력 묶음 크기·산출물 계약·검증 비용을 함께 조정한다.
