- 해상도
- CJK
- motion

### 자산·권리
- Draft 최종화
- provenance
- license
- IP imitation
- local absolute path

### Godot·플랫폼
- clean import
- startup
- export
- Android lifecycle
- merged-main runtime

### Git·CI·보안
- 승인 범위 밖 diff
- credential/cache
- immutable Action pin
- least privilege
- Required Check target
- strict up-to-date
- unresolved thread
- main movement during review

### 외부 Process Overlay
- overlay가 canon을 덮어쓰는가
- 같은 승인을 다시 요구하는가
- Base Gate를 약화하는가
- 읽은 Skill을 실행했다고 허위 보고하는가

---

## 29. GitHub Actions·CI

public repository에서 standard GitHub-hosted runner는 `REMOTE_CI` 기본이다.

비용 절감:

```text
테스트 삭제 X
→ change risk classification
→ duplicate run cancellation
→ selective expensive dependency
→ single stable ci-gate
```

공급망:

```text
uses: owner/action@<reviewed full-length SHA>
least-privilege permissions
fork / pull_request_target / secret trust boundary review
```

Base current main이 Action pin의 정본이다.
이 thin adapter에 checkout/setup-node SHA를 복제하지 않는다.

---

## 30. Base Repository Setting 정합성 상태

