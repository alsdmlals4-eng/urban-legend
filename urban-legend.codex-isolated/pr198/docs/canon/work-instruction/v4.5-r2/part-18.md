Codex 자체는 `-a never`로 내부 승인 프롬프트를 만들지 않는 것을 기본으로 한다.

사용자 `[승인]` 요청은 **최대 2개**의 상위 단계 Gate로 제한한다.

```text
[승인 1/2]
기획 완료 + 최종 구현 패키지 잠금 + PowerShell/Codex BUILD 시작

[승인 2/2]
사용자 로컬에서만 가능한 privileged/manual action 또는 최종 수동 전달 Gate가 실제로 필요할 때
```

두 번째 승인이 필요하지 않으면 억지로 만들지 않는다.
GitHub PR 병합은 현재 대화의 이미 승인된 범위에서 별도 `[승인]` 횟수로 계산하지 않는다.

### 26.3 Full-auto 원칙

직접 해결 가능한 작업은 GPT/Codex가 직접 수행한다.

- 파일 조사
- 코드/문서 수정
- 테스트
- Git 작업
- PR 상태 확인
- benchmark/review
- rerun
- merged-main readback

사용자만 할 수 있는 작업을 제외하고 “직접 해주세요”로 넘기지 않는다.

### 26.4 Ephemeral execution session

PowerShell/Codex/Godot 실행 블록이 끝나면 해당 세션 상태를 영구 권위로 사용하지 않는다.

```text
finish block
→ save evidence
→ close Codex process when applicable
→ close Godot/editor/test process when applicable
