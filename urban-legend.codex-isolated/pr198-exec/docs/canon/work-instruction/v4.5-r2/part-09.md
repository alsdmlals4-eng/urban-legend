수치가 핵심 재미·경제 구조·플레이어 약속·보호 동작과 충돌하면 `PLANNING_CONFLICT`로 승격하고 Grill Me 승인을 받는다.

질문:

- 이 기능이 핵심 재미를 강화하는가?
- 플레이어의 행동·선택·결과가 명확한가?
- 핵심 시스템과 보조 시스템을 혼동하지 않았는가?
- 기능 제거 시 프로젝트 정체성이 깨지는가?
- 단순 기능 추가보다 더 작은 해법이 있는가?

---

## 9. 벤치마킹·현업 조사

중요 결정은 최신 외부 근거를 사용한다.

우선순위:

1. 공식 문서·공식 릴리스·공식 저장소
2. 유지되는 오픈소스/업스트림
3. 현업 엔지니어링 문서·공개 postmortem
4. 유사 게임 실제 플레이·패치·개발자 설명
5. 플레이어 행동/리뷰
6. 커뮤니티 의견

앞으로 **Grill Me 질문을 만들 때와 중요한 작업 권장안을 만들 때마다** 관련 벤치마킹·현업 비교를 함께 검토한다.

```yaml
benchmark_recommendation:
  feature_or_decision_id:
  project_current_direction:
  comparable_titles_or_products: []
  official_or_professional_sources: []
  industry_pattern:
  player_response_when_available:
  what_to_copy: []
  what_not_to_copy: []
  gpt_recommendation:
  why_this_fits_project:
  uncertainty:
```

단순 유행 추종이 아니라 현재 프로젝트의 강점·비용·플랫폼·제작 규모와 비교한다.
Grill Me 선택지에는 가능한 경우 각 선택의 **벤치마크 근거 / 현업 관행 / 프로젝트 적합성 / 비용·위험**을 짧게 붙인다.

각 근거는 다음을 분리한다.

```yaml
evidence:
  source:
  date:
  claim:
  fact_or_inference: FACT | INFERENCE
  project_applicability:
  conflict_with_current_canon:
  decision_changed:
```

`BENCHMARK_ONLY_DECISION`은 금지한다.
비교 대상의 기능을 그대로 복사하지 않는다.

### 9.1 v4.5 작성 시 재확인한 공개 기준

아래는 **2026-08-11 관찰값**이며 실행 시 재검증한다.

- Godot 4.7.1-stable: 2026-07-14 maintenance stable.
- Godot 4.8: v4.5 작성 시 archive에서 dev 계열.
- GUT 9.7.1 `godot_4_7`: Godot 4.7.x 대상.
- public repository + standard GitHub-hosted runner: GitHub Actions 사용은 무료.
- GitHub Actions는 full-length commit SHA pin이 immutable 사용의 권장 안전 경계.
- Required status check는 현재 요구되는 최신 validation target에서 성공해야 한다.

공식 재검증 출발점:

```text
GitHub Actions billing
