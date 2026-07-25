from pathlib import Path

path = Path("scripts/poc/annual_mvp_001/annual_mvp_001_state.gd")
text = path.read_text(encoding="utf-8")
old = 'var new_progress := max(0, old_progress + int((deltas.get("research_progress", {}) as Dictionary)[project_id]))'
new = 'var new_progress: int = maxi(0, old_progress + int((deltas.get("research_progress", {}) as Dictionary)[project_id]))'
if old in text:
    text = text.replace(old, new, 1)
elif new not in text:
    raise SystemExit("annual state progress type line not found")
path.write_text(text, encoding="utf-8")
