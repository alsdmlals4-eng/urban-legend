각 승인 배치의 Decision은 같은 ID로 GitHub 정본·계획 데이터·연결 Sheet에 즉시 동기화하고 planning PR 검수·적대적 검토까지 닫는다.
모든 작업은 TDD/test-first로 진행한다.
현재 대화에서 이미 승인된 동일 범위 PR은 모든 Gate 통과 후 별도 병합 승인 없이 자동 병합한다.
모든 Open/Draft PR을 작업 시작·배치 종료·병합 후 재감사한다.
PowerShell/Codex 기본은 `codex.cmd -a never -s workspace-write`이며 사용자 수동 승인 프롬프트는 최대 2개로 억제한다.
PowerShell/Codex/Godot 실행 블록이 끝나면 세션을 닫고 다음 블록은 fresh-read부터 다시 시작한다.
수정제안서는 Base 활성 규칙을 proposal 단계에서 건드리지 않고 `[수정제안서]/BCP - [프로젝트명]` 출처형 evidence proposal로 시작한다.
Skill은 전체 채택만 보지 않고 기능·mode·checklist·reference 단위의 부분 흡수를 적극 검토한다.
모든 기능은 이미 반영됨 / 현재에도 유효 / 충돌·구형 / 부분 재사용 / 누락 필요로 분해해 판정한다.
