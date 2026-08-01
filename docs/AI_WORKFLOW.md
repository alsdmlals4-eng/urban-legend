# 괴이기록국 AI·GitHub 작업 흐름

- `[모델 추천]`은 난도·실패 비용·재작업 위험으로 모델과 추론 단계를 제안한다. 실제 설정 변경은 사용자가 수행하고 다음 checkpoint부터 적용한다.
- 보안·권한·데이터 무결성·저장 호환성·기존 ID·에피소드 의미는 `HARD_CONSTRAINT`다.
- 일반 기술 구조는 `RECOMMENDED_DEFAULT`, 비파괴 표현 초안은 `JUDGMENT_SPACE`다.
- Prompt는 `problem / player_or_user_value / inputs / authority_and_source / output_contract / invariants / failure_conditions / validation`의 Interface-first 계약을 사용한다.
- `Example-as-Fixture`: 예시는 정상·실패·경계·회귀 Fixture 또는 Golden Set이며 정본 권위가 아니다.
- Context는 `decision_question / include_criteria / exclude_criteria / authority_level / freshness / known_conflicts / progressive_load_trigger / refresh_trigger`를 기록한다.
- 복선·반대 근거·위험 사례·실패 경로·보호 규칙은 큐레이션에서 제거하지 않는다.
- 화면·Schema·Fixture는 실제 Godot 런타임·플레이어 이해·접근성·성능을 자동 증명하지 않는다. 미실행 자동 검증은 `NOT_RUN`, 사람 검증은 `HUMAN_NOT_RUN`이다.

Base identity: `a728712cb776ec98f4875914a580fcf7d0156593` / `ef1fba11167e4da0b298123b0c85ebd268191a42` / `693a0dff3f054ecdd653079909e044211473838e73dd9aff07734d1ce5694c59`.
