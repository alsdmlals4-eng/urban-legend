# Current Codex Handoff

이 문서는 계정·채팅 교대 시 가장 먼저 읽는 짧은 작업 상태다. 실제 완료 여부는 Git과 테스트로 다시 확인한다.

```yaml
status: COMPLETE
goal: Codex 이중 계정 및 저사용량 인수인계 구조 구현
branch: main
completed_work_commit: 6dda0efb5ac1cde8a4243c486ea62115bfa0ce8f
tests: account handoff PASS; PowerShell parse PASS; dialogue/workflow/multimodel contracts PASS; A/B profile validation PASS; running-process guard PASS
changed_files: account handoff policy, documentation, profile tools, contract tests
external_artifacts: none
remaining_work: user must perform the first ChatGPT sign-in once inside each isolated profile; no authentication content was created or copied
next_action: close every ChatGPT/Codex process, run C:\Users\user\.codex-profiles\Start-Codex-B.ps1, sign in, then use the first-account prompt in CODEX_ACCOUNT_HANDOFF.md
main_integrated: true
origin_pushed: true
```

## 인수 규칙

- `status: IN_PROGRESS`이면 현재 브랜치와 dirty diff를 먼저 확인한다.
- `status: CHECKPOINT`이면 실패·미검증 항목을 유지하고 같은 원격 작업 브랜치에서 이어간다.
- `status: COMPLETE`여도 `main`, `origin/main`, `completed_work_commit`을 대조한다.
- 로드맵과 구현이 다르면 실제 코드·테스트·최근 커밋을 우선하고 차이를 보고한다.
