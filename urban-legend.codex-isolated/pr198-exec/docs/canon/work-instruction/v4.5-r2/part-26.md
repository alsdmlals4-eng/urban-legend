### 32.3 병합 금지 PR

다음은 자동 병합하지 않는다.

- proposal-only
- reference-only
- `DO_NOT_MERGE`
- 증거 수집용 보존 PR
- 검증 부족
- stale base인데 재검증 안 됨
- 승인 범위 밖
- 중요한 충돌 미승인
- protected behavior 침범

이유와 후속 조치를 기록한다.

### 32.4 병합 후 재감사

한 PR을 병합한 뒤:

```text
new main reread
→ all remaining Open/Draft PR reread
→ base drift
→ stale/duplicate/superseded
→ cleanup
→ required follow-up
```

### 32.5 PR 변경 단위

Google의 small change 관행과 Base의 하나의 Goal/활성 PR 원칙을 참고한다.

하나의 PR은 가능한 한:

```text
한 독립 문제
한 승인/rollback 경계
관련 regression
```

을 갖는다.

다음을 섞지 않는다.

- unrelated dependency update
- formatting/BOM cleanup
- 별도 policy
- unrelated refactor
- 새 사용자 결정

---

## 33. 병합 후

병합 성공 응답만 믿지 않는다.

```text
new main SHA
→ merged files reread
→ current decisions
→ affected canon
→ consumers/tests
→ open/recent PRs
→ branch cleanup
→ applicable Sheet readback
→ post-merge adversarial review
```

