from __future__ import annotations

import json
import re
import sys
from pathlib import Path
from typing import Any

REQUIRED_SOURCES = (
    "decision",
    "unresolved",
    "images",
    "github",
    "authority",
    "gut",
    "human_qa",
)
SCOPE_TO_ALLOWED_STATE = {
    "DOCS_ONLY": "ENTRY_ALLOWED_FOR_DOCS_ONLY",
    "TEST_IMPLEMENTATION": "ENTRY_ALLOWED_FOR_TEST_IMPLEMENTATION",
    "PRODUCT_IMPLEMENTATION": "ENTRY_ALLOWED_FOR_PRODUCT_IMPLEMENTATION",
    "IMAGE_GENERATION": "ENTRY_ALLOWED_FOR_IMAGE_GENERATION",
    "IMAGE_IMPLEMENTATION": "ENTRY_ALLOWED_FOR_IMAGE_IMPLEMENTATION",
}
GUT_USABLE_STATES_BY_SCOPE = {
    "DOCS_ONLY": {
        "TRIAL_APPROVED",
        "CONSUMPTION_IMPLEMENTED",
        "EXACT_HEAD_VALIDATED",
        "ADOPTED_ACTIVE",
    },
    "TEST_IMPLEMENTATION": {
        "TRIAL_APPROVED",
        "CONSUMPTION_IMPLEMENTED",
        "EXACT_HEAD_VALIDATED",
        "ADOPTED_ACTIVE",
    },
    "PRODUCT_IMPLEMENTATION": {"EXACT_HEAD_VALIDATED", "ADOPTED_ACTIVE"},
    "IMAGE_GENERATION": {
        "CONSUMPTION_IMPLEMENTED",
        "EXACT_HEAD_VALIDATED",
        "ADOPTED_ACTIVE",
    },
    "IMAGE_IMPLEMENTATION": {"EXACT_HEAD_VALIDATED", "ADOPTED_ACTIVE"},
}
PRODUCT_IMAGE_APPROVED = "PRODUCT_ASSET_APPROVED"
HEX_SHA_40 = re.compile(r"^[0-9a-fA-F]{40}$")
COUNT_FIELDS = (
    ("unresolved", "open_p0"),
    ("unresolved", "open_p1"),
    ("unresolved", "open_decisions"),
    ("github", "review_threads_open"),
)


def _blocked(state: str, *blockers: str) -> dict[str, Any]:
    return {"state": state, "blockers": list(blockers)}


def _is_nonnegative_int(value: Any) -> bool:
    return isinstance(value, int) and not isinstance(value, bool) and value >= 0


def _validate_structure(evidence: dict[str, Any]) -> list[str]:
    blockers: list[str] = []
    for name in REQUIRED_SOURCES:
        if name not in evidence:
            blockers.append(f"missing:{name}")
        elif not isinstance(evidence[name], dict):
            blockers.append(f"invalid:{name}")

    if blockers:
        return blockers

    for source, field in COUNT_FIELDS:
        value = evidence[source].get(field)
        if not _is_nonnegative_int(value):
            blockers.append(f"invalid:{source}.{field}")

    for source in ("images", "gut", "human_qa"):
        if not isinstance(evidence[source].get("required"), bool):
            blockers.append(f"invalid:{source}.required")

    return blockers


def evaluate(evidence: dict[str, Any]) -> dict[str, Any]:
    if not isinstance(evidence, dict):
        return _blocked("ENTRY_BLOCKED_MISSING_SOURCE", "evidence_must_be_object")

    structural_blockers = _validate_structure(evidence)
    if structural_blockers:
        return _blocked("ENTRY_BLOCKED_MISSING_SOURCE", *structural_blockers)

    scope = evidence.get("requested_scope")
    if not isinstance(scope, str) or scope not in SCOPE_TO_ALLOWED_STATE:
        return _blocked(
            "ENTRY_BLOCKED_MISSING_SOURCE",
            "unknown_requested_scope",
        )

    unresolved = evidence["unresolved"]
    if unresolved["open_p0"] > 0 or unresolved["open_p1"] > 0:
        return _blocked("ENTRY_BLOCKED_OPEN_P0_P1", "open_p0_or_p1")

    decision = evidence["decision"]
    if decision.get("state") != "APPROVED" or unresolved["open_decisions"] > 0:
        return _blocked(
            "ENTRY_BLOCKED_OPEN_DECISION",
            "decision_not_approved_or_open_decision",
        )

    images = evidence["images"]
    if images["required"] and images.get("review_state") != PRODUCT_IMAGE_APPROVED:
        return _blocked(
            "ENTRY_BLOCKED_IMAGE_EVIDENCE",
            "product_image_not_approved",
        )

    github = evidence["github"]
    head = github.get("head")
    evidence_head = github.get("evidence_head")
    if (
        not isinstance(head, str)
        or not HEX_SHA_40.fullmatch(head)
        or not isinstance(evidence_head, str)
        or head != evidence_head
        or github.get("checks") != "PASS"
        or github["review_threads_open"] > 0
    ):
        return _blocked(
            "ENTRY_BLOCKED_EXACT_HEAD_EVIDENCE",
            "head_checks_or_review_threads",
        )

    if evidence["authority"].get("state") != "PASS":
        return _blocked(
            "ENTRY_BLOCKED_AUTHORITY_CONFLICT",
            "authority_contract_failed",
        )

    gut = evidence["gut"]
    if gut["required"] and gut.get("state") not in GUT_USABLE_STATES_BY_SCOPE[scope]:
        return _blocked(
            "ENTRY_BLOCKED_GUT_CONSUMPTION",
            "gut_not_available_for_scope",
        )

    human = evidence["human_qa"]
    if human["required"] and human.get("state") != "PASS":
        return _blocked(
            "ENTRY_BLOCKED_HUMAN_QA",
            "human_qa_required",
        )

    return {"state": SCOPE_TO_ALLOWED_STATE[scope], "blockers": []}


def main(argv: list[str]) -> int:
    if len(argv) != 2:
        print(
            json.dumps(
                {
                    "state": "ENTRY_BLOCKED_MISSING_SOURCE",
                    "blockers": ["usage:evaluate_project_entry_gate.py <evidence.json>"],
                },
                ensure_ascii=False,
                sort_keys=True,
            )
        )
        return 2

    path = Path(argv[1])
    if not path.is_file():
        print(
            json.dumps(
                {
                    "state": "ENTRY_BLOCKED_MISSING_SOURCE",
                    "blockers": ["evidence_file"],
                },
                ensure_ascii=False,
                sort_keys=True,
            )
        )
        return 2

    try:
        evidence = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        print(
            json.dumps(
                {
                    "state": "ENTRY_BLOCKED_MISSING_SOURCE",
                    "blockers": [str(exc)],
                },
                ensure_ascii=False,
                sort_keys=True,
            )
        )
        return 2

    result = evaluate(evidence)
    print(json.dumps(result, ensure_ascii=False, sort_keys=True))
    return 0 if result["state"].startswith("ENTRY_ALLOWED_FOR_") else 1


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
