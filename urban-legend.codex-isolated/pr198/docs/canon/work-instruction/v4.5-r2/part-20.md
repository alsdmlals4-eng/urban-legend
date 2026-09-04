- Template
- Test
- generated derivative
- manifest/hash

### 27.3 Static

- syntax
- schema
- import
- path
- ID
- data
- asset provenance

### 27.4 Runtime

- startup
- main scene
- interaction
- error path
- save/load
- clean import

### 27.5 UI / Accessibility

- input
- focus
- text
- resolution
- motion
- alternate path

### 27.6 Performance

적용되는 변경에서:

- frame time
- CPU/GPU
- memory
- loading
- network
- mobile thermal

### 27.7 Human/Player

BCP-020 증거층을 별도로 기록한다.

### 27.8 Regression

대표 정상·경계·반례·기존 기능.

---

## 28. 적대적 검토 루프

기본:

```text
attack
→ validate-critique
→ refine-approved-findings
→ regression-recheck
→ decision-report
```

저장소 전체 감사:

```text
repository-scope-map
→ canonical-authority-map
→ full-file-inventory
→ stale-and-duplicate-attack
→ untouched-consumer-attack
→ derivative-and-prompt-drift-attack
→ validate-critique
→ legacy-classification
→ approved-minimal-fix
→ regression-and-freshness-recheck
```

### 28.1 단계별 중요 Skill/프로세스 적용

각 주요 단계에서 필요에 따라 다음을 실제로 적용하고 실행 보고에 남긴다.

```text
brainstorming / design exploration
