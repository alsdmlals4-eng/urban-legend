# 로그가 공개 가능한 시스템 안내 문장과 반복 축약 문구를 제공한다.
class_name LogTutorialCatalog
extends RefCounted

const TUTORIALS := {
	"main_welcome": {
		"expression": "normal",
		"lines": [
			{"text": "괴담기록국 현장 지원 AI, 로그입니다. 새 수사는 사건과 투입 요원을 준비하는 단계부터 시작합니다.", "expression": "normal"},
			{"text": "목표는 괴이를 처치하는 것이 아니라, 확인한 규칙을 기록하고 안전하게 회수하는 것입니다.", "expression": "focus"}
		],
		"repeat_hint": "새 수사는 준비 화면에서 시작하며, 저장 기록은 이어하기로 불러옵니다."
	},
	"main_continue": {
		"expression": "focus",
		"lines": [
			{"text": "저장 지점을 확인했습니다. 이어하기는 마지막 저장 장면, 새 수사는 준비 화면으로 이동합니다.", "expression": "focus"}
		],
		"repeat_hint": "이어하기는 마지막 저장 장면을 불러옵니다."
	},
	"preparation_agents": {
		"expression": "normal",
		"lines": [
			{"text": "현장에는 요원 두세 명을 편성합니다. 사건에 필요한 역할을 서로 보완하는지 확인하세요.", "expression": "normal"},
			{"text": "요원 카드에서 능력, 장비, 기술, 면모와 이력을 확인할 수 있습니다.", "expression": "focus"}
		],
		"repeat_hint": "요원 두세 명을 편성하면 조사를 시작할 수 있습니다."
	},
	"preparation_contacts": {
		"expression": "normal",
		"lines": [
			{"text": "외부 접점에서는 기록국 밖의 정보와 장비를 확인합니다. 관계 단계에 따라 의뢰와 거래 조건이 달라집니다.", "expression": "normal"}
		],
		"repeat_hint": "관계 단계에 따라 의뢰와 거래 조건이 추가됩니다."
	},
	"market_first_visit": {
		"expression": "normal",
		"lines": [
			{"text": "소문시장에서는 잔향 파편으로 보조 장비와 소모품을 교환할 수 있습니다. 사건의 핵심 단서는 거래되지 않습니다.", "expression": "normal"},
			{"text": "영구 장비는 준비 화면에서 장착하며, 소모품은 사건마다 두 종류까지 반입할 수 있습니다.", "expression": "focus"}
		],
		"repeat_hint": "관계 단계에 따라 가격과 구매 가능 품목이 달라집니다."
	},
	"field_first_choice": {
		"expression": "focus",
		"lines": [
			{"text": "현장 기록이 동기화됐습니다. 현재 상황과 확보 기록을 확인한 뒤 행동을 선택하세요.", "expression": "focus"}
		],
		"repeat_hint": "선택지에는 관련 능력과 담당 요원이 표시됩니다."
	},
	"field_first_record_drawer": {
		"expression": "focus",
		"lines": [
			{"text": "기록 서랍에는 확보 단서, 단서 연결, 이전 오대응 기록이 저장됩니다. 미확인 연결은 확정 정보와 구분됩니다.", "expression": "focus"}
		],
		"repeat_hint": "기록 서랍에서 확보 단서와 이전 오대응 기록을 확인할 수 있습니다."
	},
	"field_first_clue": {
		"expression": "normal",
		"lines": [
			{"text": "새 단서를 등록했습니다. 단서는 이후 전조와 대응을 비교하는 근거로 사용됩니다.", "expression": "normal"}
		],
		"repeat_hint": "새 단서는 기록 서랍과 회수 단계의 비교 정보에 반영됩니다."
	},
	"recovery_first_telegraph": {
		"expression": "warning",
		"lines": [
			{"text": "전조 감지. 현재 변화와 확보 기록을 대조한 뒤 대응을 선택하세요.", "expression": "warning"}
		],
		"repeat_hint": "전조와 확보 기록을 대조해 대응을 선택하세요."
	},
	"recovery_first_prediction": {
		"expression": "focus",
		"lines": [
			{"text": "추정됨: 전조와 조사 기록이 연관될 가능성이 있습니다. 표시된 행동의 결과는 아직 미확인입니다.", "expression": "focus"}
		],
		"repeat_hint": "예상 행동은 확보 기록과 함께 대조하세요."
	},
	"recovery_first_learning": {
		"expression": "focus",
		"lines": [
			{"text": "오대응 원인을 기록했습니다. 같은 전조가 반복되면 실패 원인을 비교 정보로 표시합니다.", "expression": "focus"}
		],
		"repeat_hint": "오대응 원인은 기록 서랍과 회수 단계에 저장됩니다."
	},
	"result_first_case": {
		"expression": "normal",
		"lines": [
			{"text": "사건 보고서를 정리했습니다. 해결 등급, 구조 결과, 잔향 파편과 새 기록을 확인하세요.", "expression": "normal"}
		],
		"repeat_hint": "사건 결과와 새 기록은 기록국 DB에 보존됩니다."
	},
	"database_first_visit": {
		"expression": "focus",
		"lines": [
			{"text": "기록국 DB에 연결했습니다. 완료 사건과 확보 기록만 표시하며, 미확인 정보는 공개하지 않습니다.", "expression": "focus"}
		],
		"repeat_hint": "DB에서 완료 사건과 해금 기록을 다시 확인할 수 있습니다."
	}
}


static func get_entry(tutorial_id: String) -> Dictionary:
	return Dictionary(TUTORIALS.get(tutorial_id, {})).duplicate(true)


static func get_repeat_hint(tutorial_id: String) -> String:
	return String(TUTORIALS.get(tutorial_id, {}).get("repeat_hint", ""))
