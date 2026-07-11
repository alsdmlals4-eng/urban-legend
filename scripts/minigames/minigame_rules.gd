# 화면과 무관한 미니게임 타이밍과 충돌 판정을 제공한다.
class_name MinigameRules
extends RefCounted


static func is_rhythm_hit(current_radius: float, target_radius: float, tolerance: float) -> bool:
	return absf(current_radius - target_radius) <= maxf(0.0, tolerance)


static func clamp_player_position(position: Vector2, bounds: Rect2, player_size: Vector2) -> Vector2:
	return Vector2(
		clampf(position.x, bounds.position.x, bounds.end.x - player_size.x),
		clampf(position.y, bounds.position.y, bounds.end.y - player_size.y)
	)


static func rects_overlap(first: Rect2, second: Rect2) -> bool:
	return first.intersects(second)


static func is_rain_success(elapsed: float, duration: float, hits: int, max_hits: int) -> bool:
	return elapsed >= duration and hits < max_hits


static func is_rain_failure(hits: int, max_hits: int) -> bool:
	return hits >= max_hits
