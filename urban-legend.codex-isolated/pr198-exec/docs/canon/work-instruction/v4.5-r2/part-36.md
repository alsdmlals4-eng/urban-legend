- PowerShell 사용자 승인 프롬프트를 불필요하게 2개 초과 생성
- `-a never` 운영인데 Codex 내부 approval 의존 workflow 설계
- 이전 PowerShell/Codex/Godot session/PID를 다음 블록의 current truth로 사용
- Godot 버전 추측
- HiGodot 채택 계약을 우회한 persistent authoring
- GUT 0 test discovery를 성공 처리
- Hera QA 후 tracked source delta 존재
- clean import 미검증
- actual main scene 실행 없음

### 자산

- Draft/placeholder 최종화
- provenance/license 미검증
- shared audio 원본 무단 변경
- 외부 절대 경로 production dependency
- local-only asset 후보가 tracked production 참조

### CI·PR

- 작업 시작/배치 종료/병합 후 모든 Open/Draft PR 감사 누락
- proposal-only/reference-only/DO_NOT_MERGE PR 자동 병합
- stale/duplicate PR 후속 정리 누락
- mutable Action tag/branch를 고위험 workflow에서 사용
- 과도한 `GITHUB_TOKEN` 권한
- Required Check 실패/미실행
- wrong SHA 검증
- strict up-to-date 우회
- unresolved thread
- Draft 상태인데 merge ready 주장
- `main` 이동 후 이전 GREEN으로 병합
- 승인 범위 밖 diff
- adversarial finding 미해결

### 병합 후

- 새 main readback 없음
