# Current Codex Handoff

이 문서는 계정·채팅 교대 시 가장 먼저 읽는 짧은 작업 상태다. 실제 완료 여부는 Git과 테스트로 다시 확인한다.

```yaml
status: IN_PROGRESS
goal: Codex 이중 계정 및 저사용량 인수인계 구조 구현
branch: codex/account-handoff
completed_work_commit: ea8825c
tests: baseline workflow context PASS; multimodel contract PASS; dialogue routing contract repaired
changed_files: account handoff policy, documentation, profile tools, contract tests
external_artifacts: none
remaining_work: implement profile tools; install A/B profiles; verify; merge main; push origin/main
next_action: run tests/test_account_handoff_contract.ps1 and complete the GREEN phase
main_integrated: false
origin_pushed: false
```

## 인수 규칙

- `status: IN_PROGRESS`이면 현재 브랜치와 dirty diff를 먼저 확인한다.
- `status: CHECKPOINT`이면 실패·미검증 항목을 유지하고 같은 원격 작업 브랜치에서 이어간다.
- `status: COMPLETE`여도 `main`, `origin/main`, `completed_work_commit`을 대조한다.
- 로드맵과 구현이 다르면 실제 코드·테스트·최근 커밋을 우선하고 차이를 보고한다.
