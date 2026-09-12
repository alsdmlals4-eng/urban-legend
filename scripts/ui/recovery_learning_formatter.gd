extends RefCounted

## Trial metadata is historical observation, never a semantic grade of the draft.
static func format_trial(entry: Dictionary) -> String:
	var draft_text := "당시 초안 기록 없음 · 이전 기록"
	if entry.has("authored_draft_lines"):
		var value: Variant = entry.get("authored_draft_lines")
		var drafts: Array[String] = []
		if value is Array:
			for line in value:
				if line is String and not line.is_empty():
					drafts.append(line)
		draft_text = "\n".join(drafts) if not drafts.is_empty() else "작성한 해석 없음"
	return "%s · 최근 대응 %d회차\n당시 매뉴얼 초안 · 별도 미검증\n%s\n실행한 대응: %s\n현장 결과: %s\n관측 결과: %s\n대응 결과는 위 초안 전체의 정답 판정이 아닙니다." % [
		String(entry.get("pattern_name", entry.get("pattern_id", "전조"))),
		int(entry.get("attempts", 1)), draft_text,
		String(entry.get("response_label", entry.get("response_id", "기록 없음"))),
		"대응 성공" if bool(entry.get("correct", false)) else "오대응",
		String(entry.get("reason", "관측 기록 없음"))]

static func format_trials(value: Variant) -> Array[String]:
	var lines: Array[String] = []
	if value is Dictionary:
		for entry in value.values():
			if entry is Dictionary:
				lines.append(format_trial(entry))
	return lines
