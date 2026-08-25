from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DECISION = ROOT / "docs" / "decisions" / "D-2026-08-25-RECOVERY-CONTEXT-ACTION-HIERARCHY.md"
HANDOFF = ROOT / "docs" / "RECOVERY_VISUAL_HANDOFF_2026-08-25.md"
CURRENT_VISUAL = ROOT / "docs" / "CURRENT_VISUAL_WORK_ORDER.md"
VISUAL_SPEC = ROOT / "docs" / "VISUAL_ANCHOR_SPEC.md"


def _text(path: Path) -> str:
    assert path.exists(), f"missing required authority: {path.relative_to(ROOT)}"
    return path.read_text(encoding="utf-8")


def test_recovery_decision_separates_stable_categories_from_context_actions():
    text = _text(DECISION)
    for token in [
        "공격 / 보호 / 보조",
        "CONTEXTUAL_TELEGRAPH_RESPONSE",
        "위로 이동",
        "좌로 이동",
        "안내판 조작",
        "조사·기록·추리문·괴이 매뉴얼",
        "정답을 색·확률·추천",
        "실패 관측 기록",
    ]:
        assert token in text


def test_current_visual_authorities_use_successor_recovery_hierarchy():
    for path in [CURRENT_VISUAL, VISUAL_SPEC]:
        text = _text(path)
        assert "공격 / 보호 / 보조" in text
        assert "CONTEXTUAL_TELEGRAPH_RESPONSE" in text
        assert "전조 대응" in text
        assert "보호 / 관찰 / 대응 / 공격 / 장비 / 봉쇄 / 후퇴" not in text


def test_handoff_preserves_evidence_ceiling_and_next_image_gate():
    text = _text(HANDOFF)
    for token in [
        "REFERENCE_MOCKUP / REVISION_REQUIRED / NOT_PRODUCT_ASSET",
        "606cb6998d4d1d08b44f96fe508b777e631786f05fdbd9a8c0d2b307dbe0e4d2",
        "1672x941",
        "HUMAN_QA_NOT_RUN",
        "PRODUCT_REFERENCE_ASSET_PENDING",
        "다음 이미지",
        "정확히 1장",
        "PR #231",
        "Google Sheet",
    ]:
        assert token in text
