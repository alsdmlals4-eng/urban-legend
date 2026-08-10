- autoload/InputMap 중복 등록을 막는다.
- 현재 Godot 버전에 없는 API를 추측하지 않는다.
- deprecated 제거 시 모든 active consumer를 추적한다.

### 25.5 기본 RED→GREEN 루프

모든 실질 변경은 가능한 한 다음을 따른다.

```text
RED
→ verify failure reason
→ minimal GREEN
→ refactor only if needed
→ exact regression
```

회귀 테스트가 없던 정책/계약 문제라면 먼저 failing contract를 만든다.

금지:

- 테스트를 작성했지만 RED를 확인하지 않음
- unrelated 실패를 목표 실패라고 오인
- 테스트 통과를 런타임/사람 검증으로 과장

---

## 26. PowerShell·Codex 실행 프로토콜

Codex/Godot 구현은 **PHASE A 기획 완료 + 사용자 기획 완료 선언 + PHASE B 최종 검수** 뒤에만 실행한다.

### 26.1 기본 실행 명령

사용자가 지정한 기본 명령:

```powershell
codex.cmd -a never -s workspace-write
```

이 명령은 런타임에서 설치된 Codex CLI가 실제로 지원하는지 먼저 확인한다.
지원하지 않으면 추측해서 변형하지 않고 blocker 처리한다.

### 26.2 승인 클릭 최소화

