from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]


def replace_once(path: str, old: str, new: str) -> None:
    target = ROOT / path
    text = target.read_text(encoding="utf-8")
    count = text.count(old)
    if count != 1:
        raise RuntimeError(f"expected one match in {path}, found {count}: {old[:100]!r}")
    target.write_text(text.replace(old, new, 1), encoding="utf-8")


replace_once(
    "docs/CURRENT_STATUS.md",
    "- 고유 스킬 3개와 공용 지원 6개",
    "- 고유 스킬 데이터 3개와 공용 지원 데이터 6개\n- 런타임 고유 스킬은 오현·박도윤 2개만 `ACTIVE`; 한세린 `교차 색인`은 데이터 보존 상태로 `DISABLED_PENDING_HYPOTHESIS_BOARD_HOOK`\n- 런타임 공용 지원은 피해·위험 계열 2개만 `ACTIVE`; 나머지 4개는 `DISABLED_PENDING_CORE_HOOK`",
)

replace_once(
    "docs/CURRENT_HANDOFF.md",
    "  unique_skills: 3\n  public_support_skills: 6",
    "  unique_skills: 3\n  active_unique_skills: 2\n  cross_index_runtime_status: DISABLED_PENDING_HYPOTHESIS_BOARD_HOOK\n  public_support_skills: 6\n  active_public_support_skills: 2",
)
replace_once(
    "docs/CURRENT_HANDOFF.md",
    "- 고유 스킬은 명시 조건 충족 시 사건당 1회 확정 발동한다.",
    "- 오현·박도윤의 런타임 `ACTIVE` 고유 스킬은 명시 조건 충족 시 사건당 1회 확정 발동한다.\n- 한세린 `교차 색인`은 데이터·이름·조건·효과를 보존하지만 `DISABLED_PENDING_HYPOTHESIS_BOARD_HOOK`이며 선택·발동·성공 로그를 금지한다.\n- 준비 화면은 `교차 색인`에 관측·가설 보드 hook 필요 사유를 표시한다.",
)

replace_once(
    "docs/qa/ANNUAL_MVP_002_AUTOMATED_QA_2026-07-26.md",
    "- 고유 스킬 3개와 공용 지원 6개",
    "- 고유 스킬 데이터 3개와 공용 지원 데이터 6개\n- 고유 스킬 런타임: 오현·박도윤 2개 `ACTIVE`, 한세린 `교차 색인` 1개 `DISABLED_PENDING_HYPOTHESIS_BOARD_HOOK`\n- 공용 지원 런타임: 피해·위험 계열 2개 `ACTIVE`, 나머지 4개 `DISABLED_PENDING_CORE_HOOK`",
)
replace_once(
    "docs/qa/ANNUAL_MVP_002_AUTOMATED_QA_2026-07-26.md",
    "## 보호 범위 확인",
    "### 한세린 `교차 색인` 런타임 경계\n\n현재 CORE snapshot과 외부 지원 hook에는 관측 기록 충돌 강조를 안전하게 적용할 관측·가설 보드가 없다. 따라서 데이터는 보존하되 `DISABLED_PENDING_HYPOTHESIS_BOARD_HOOK`으로 두고 resolver 입력, 판정, 성공 로그에서 제외한다. 준비 화면에는 비활성 사유를 표시하며, 향후 관측·가설·반박 보드 구현 시 별도 검토 후 활성화한다.\n\n## 보호 범위 확인",
)

replace_once(
    "docs/superpowers/specs/2026-07-26-annual-mvp-002-as-built.md",
    "- 고유 스킬은 조건 충족 시 사건당 1회 확정 발동",
    "- 오현·박도윤의 런타임 `ACTIVE` 고유 스킬은 조건 충족 시 사건당 1회 확정 발동\n- 한세린 `교차 색인`은 `DISABLED_PENDING_HYPOTHESIS_BOARD_HOOK`이며 resolver 입력·판정·성공 로그에서 제외",
)
replace_once(
    "docs/superpowers/specs/2026-07-26-annual-mvp-002-as-built.md",
    "- 지원 적격·확률·준비도·보장 거리\n- 동료·장비가 정답을 대신하지 않는다는 안내",
    "- 지원 적격·확률·준비도·보장 거리\n- 비활성 `교차 색인`의 관측·가설 보드 hook 필요 사유\n- 동료·장비가 정답을 대신하지 않는다는 안내",
)

log_path = ROOT / "docs/DECISION_LOG.md"
log_text = log_path.read_text(encoding="utf-8")
heading = "## 2026-07-26 — 한세린 `교차 색인` C안"
if heading not in log_text:
    entry = """

## 2026-07-26 — 한세린 `교차 색인` C안

- 상태: `APPROVED_REVIEW_DECISION / IMPLEMENTED_ON_PR_91`
- 사용자 승인: 2026-07-26, 권장안대로 진행
- 추적: Issue #90 / PR #91
- 결정: `교차 색인`의 ID·이름·조건·효과 데이터는 보존한다.
- 런타임 상태: `DISABLED_PENDING_HYPOTHESIS_BOARD_HOOK`
- 현재 금지: resolver 입력, 선택, 발동 판정, CORE 적용, 성공 로그.
- UI: 준비 화면에 `관측·가설 보드 hook 필요`를 표시한다.
- 활성화 조건: 관측·가설·반박 보드가 기존 기록만 대상으로 충돌 강조를 안전하게 지원하고, 신규 핵심 단서·정답 가설·미관측 패턴을 만들지 않는 계약과 테스트가 승인될 것.
- 사람 사용성 QA·신규 플레이어 검증: `NOT_RUN`
- `POC_PASSED`, `annual_loop_passed`, 제작 확대: 계속 미선언.
"""
    log_path.write_text(log_text.rstrip() + entry + "\n", encoding="utf-8")

print("cross-index documentation sync applied")
