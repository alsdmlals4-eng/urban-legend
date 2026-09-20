from tools import build_monthly_ai_evidence as evidence


def test_cumulative_records_keep_old_days_and_do_not_duplicate_on_rebuild():
    old = [{"sha": "a", "commit_date": "2026-09-13T12:00:00+09:00", "subject": "old"}]
    new = [{"sha": "b", "commit_date": "2026-09-16T12:00:00+09:00", "subject": "new"}]
    result = evidence.merge_records(old, new + old)
    assert [row["sha"] for row in result] == ["a", "b"]
    assert evidence.merge_records(result, new) == result
