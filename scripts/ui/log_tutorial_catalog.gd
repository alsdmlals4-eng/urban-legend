# 로그가 공개 가능한 시스템 안내 문장과 반복 축약 문구를 제공한다.
class_name LogTutorialCatalog
extends RefCounted

const TUTORIALS := {
	"main_welcome": {
		"expression": "normal",
		"lines": [
			{"text": "접속 완료. 괴담기록국 안내 AI, 로그입니다. 사건은 불친절하지만 저는 비교적 친절한 편이에요.", "expression": "normal"},
			{"text": "새 수사를 시작하면 사건과 요원 팀을 먼저 준비합니다. 괴담은 없애는 게 아니라 규칙을 밝혀 회수한다는 점, 잊지 마세요.", "expression": "focus"}
		],
		"repeat_hint": "새 수사는 사건 준비로, 저장된 기록은 이어하기로 연결됩니다."
	},
	"main_continue": {
		"expression": "focus",
		"lines": [
			{"text": "저장 기록을 확인했습니다. 이어하기는 마지막 현장부터, 새 수사는 준비 단계부터 시작합니다.", "expression": "focus"}
		],
		"repeat_hint": "이어하기는 마지막으로 저장한 장면을 불러옵니다."
	},
	"preparation_agents": {
		"expression": "normal",
		"lines": [
			{"text": "현장 투입은 두 명부터 세 명까지입니다. 능력치보다 이번 사건에서 서로의 빈틈을 메울 조합을 먼저 보세요.", "expression": "normal"},
			{"text": "요원 카드를 누르면 능력, 장비, 기술, 면모와 백스토리를 확인할 수 있습니다.", "expression": "focus"}
		],
		"repeat_hint": "요원 2~3명을 편성해야 조사를 시작할 수 있습니다."
	},
	"preparation_contacts": {
		"expression": "normal",
		"lines": [
			{"text": "외부 접점은 기록국 밖의 정보와 장비를 얻는 통로입니다. 관계에 따라 의뢰와 가격이 달라집니다.", "expression": "normal"}
		],
		"repeat_hint": "세력 관계 단계가 오르면 새 의뢰와 상품 조건이 열립니다."
	},
	"market_first_visit": {
		"expression": "normal",
		"lines": [
			{"text": "소문시장 접속 확인. 잔향 파편으로 보조 장비와 소모품을 구할 수 있지만, 핵심 단서까지 거래하진 않습니다.", "expression": "normal"},
			{"text": "영구 장비는 준비 화면에서 장착하고, 소모품은 사건당 두 종류까지만 반입할 수 있어요.", "expression": "focus"}
		],
		"repeat_hint": "관계 단계가 가격과 구매 가능 여부에 영향을 줍니다."
	},
	"field_first_choice": {
		"expression": "focus",
		"lines": [
			{"text": "현장 기록을 동기화했습니다. 상황과 요원들의 대화를 들은 뒤, 확보한 근거에 맞는 행동을 고르세요.", "expression": "focus"}
		],
		"repeat_hint": "선택지는 담당 요원과 관련 능력을 함께 표시합니다."
	},
	"field_first_record_drawer": {
		"expression": "focus",
		"lines": [
			{"text": "기록 서랍에는 확보 단서, 단서 연결, 과거 오대응 학습이 모입니다. 정답표는 아니니 연결은 직접 확인해 주세요.", "expression": "focus"}
		],
		"repeat_hint": "기록 서랍에서 확보 단서와 오대응 학습을 다시 볼 수 있습니다."
	},
	"field_first_clue": {
		"expression": "normal",
		"lines": [
			{"text": "새 단서를 기록했습니다. 단서 하나는 답이 아니라, 다음 전조를 읽을 근거입니다.", "expression": "normal"}
		],
		"repeat_hint": "새 단서는 기록 서랍과 회수 예측에 연결됩니다."
	},
	"recovery_first_telegraph": {
		"expression": "warning",
		"lines": [
			{"text": "전조 감지. 공격 신호로 단정하지 마세요. 조사에서 본 규칙과 지금의 변화를 먼저 대조합니다.", "expression": "warning"}
		],
		"repeat_hint": "전조와 확보 단서를 대조해 상황형 대응을 고르세요."
	},
	"recovery_first_prediction": {
		"expression": "focus",
		"lines": [
			{"text": "전조와 조사 기록이 맞물렸습니다. 예측된 행동의 이름과 설명은 공개하지만, 실제 효과는 대응 결과로 확인해야 합니다.", "expression": "focus"}
		],
		"repeat_hint": "예측은 정답을 대신하지 않습니다. 공개된 행동과 확보 단서를 함께 대조하세요."
	},
	"recovery_first_learning": {
		"expression": "focus",
		"lines": [
			{"text": "오대응을 기록했습니다. 피해만 남긴 건 아니에요. 같은 패턴이 돌아오면 실패 이유가 다음 판단 근거가 됩니다.", "expression": "focus"}
		],
		"repeat_hint": "과거 오대응은 기록 서랍과 회수 학습 정보에 남습니다."
	},
	"result_first_case": {
		"expression": "normal",
		"lines": [
			{"text": "사건 보고서를 정리했습니다. 해결 등급, 구조 결과, 잔향 파편과 새 기록을 여기서 확인하세요.", "expression": "normal"}
		],
		"repeat_hint": "사건 결과와 새 기록은 기록국 DB에 보존됩니다."
	},
	"database_first_visit": {
		"expression": "focus",
		"lines": [
			{"text": "기록국 DB에 연결했습니다. 완료 사건과 확보 기록을 비교할 수 있지만, 아직 확인하지 못한 사실은 표시하지 않습니다.", "expression": "focus"}
		],
		"repeat_hint": "DB에서 완료 사건과 해금 기록을 다시 확인할 수 있습니다."
	}
}


static func get_entry(tutorial_id: String) -> Dictionary:
	return Dictionary(TUTORIALS.get(tutorial_id, {})).duplicate(true)


static func get_repeat_hint(tutorial_id: String) -> String:
	return String(TUTORIALS.get(tutorial_id, {}).get("repeat_hint", ""))
