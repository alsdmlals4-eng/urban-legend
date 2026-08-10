개별 Scene·기능·mock 화면만 동작하는 상태는 Vertical Slice 완료가 아니다.

### 35.2 로컬 접근이 없는 에이전트

사용자 Windows 로컬에는 접근할 수 없지만 GitHub에는 접근 가능한 경우:

1. 원격 조사·PR·CI·병합·merged-main readback까지만 실제 수행한다.
2. 로컬 Fetch/Pull·PowerShell·Godot 실행을 했다고 주장하지 않는다.
3. `LOCAL_SYNC_BLOCKED_NO_LOCAL_ACCESS`, `GODOT_RUN_BLOCKED_NO_LOCAL_ACCESS`를 기록한다.
4. 정확한 사용자 작업 명령·기대 SHA·성공 판정을 **최종 User Action Required 섹션에 모아** 제공한다.
5. 사용자가 결과를 제공하면 그 증거로 후속 판정을 한다.

---

## 36. Base 승격

프로젝트에서 발견한 재사용 후보:

```text
project evidence
→ function-level classification
→ repeated/generalizable pattern
→ [수정제안서]/BCP - [프로젝트명] project-source proposal
→ evidence pack
→ proposal/index registration
→ proposal PR
→ review/approval
→ separate approved Base implementation PR when active rules must change
→ Base Registry change only when that implementation is separately authorized
→ Base tests / freshness / adversarial review
→ merge
```

