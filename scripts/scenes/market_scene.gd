extends Control

const ThemeFactory = preload("res://scripts/ui/ui_theme_factory.gd")

var _catalog_box: VBoxContainer
var _detail_label: Label
var _status_label: Label
var _currency_label: Label
var _selected_item_id := ""
var _buy_button: Button


func _ready() -> void:
	theme = ThemeFactory.create_theme()
	GameState.set_current_scene_path(GameState.SCENE_MARKET)
	GameState.save_game()
	_build_ui()
	_refresh()


func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color("101821")
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)
	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "top", "right", "bottom"]:
		margin.add_theme_constant_override("margin_%s" % side, 24)
	add_child(margin)
	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 12)
	margin.add_child(root)
	var nav := HBoxContainer.new()
	root.add_child(nav)
	var back := Button.new()
	back.text = "사건 준비로 돌아가기"
	back.pressed.connect(_return_to_preparation)
	nav.add_child(back)
	_currency_label = Label.new()
	_currency_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_currency_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	nav.add_child(_currency_label)
	var title := Label.new()
	title.text = "소문시장 · 잔향 거래"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	root.add_child(title)
	var relation := Label.new()
	relation.text = "관계 단계에 따라 가격과 거래 가능 여부가 달라집니다. 단서·기록물·요원 고유 장비는 거래하지 않습니다."
	relation.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	root.add_child(relation)
	var columns := HBoxContainer.new()
	columns.size_flags_vertical = Control.SIZE_EXPAND_FILL
	columns.add_theme_constant_override("separation", 12)
	root.add_child(columns)
	var list_panel := PanelContainer.new()
	list_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	list_panel.size_flags_stretch_ratio = 1.2
	columns.add_child(list_panel)
	var scroll := ScrollContainer.new()
	list_panel.add_child(scroll)
	_catalog_box = VBoxContainer.new()
	_catalog_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(_catalog_box)
	var detail_panel := PanelContainer.new()
	detail_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	detail_panel.size_flags_stretch_ratio = 0.8
	columns.add_child(detail_panel)
	var detail_box := VBoxContainer.new()
	detail_panel.add_child(detail_box)
	_detail_label = Label.new()
	_detail_label.text = "상품을 선택하면 효과와 가격을 확인할 수 있습니다."
	_detail_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_detail_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	detail_box.add_child(_detail_label)
	_buy_button = Button.new()
	_buy_button.text = "구매"
	_buy_button.pressed.connect(_purchase_selected)
	detail_box.add_child(_buy_button)
	_status_label = Label.new()
	_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail_box.add_child(_status_label)


func _refresh() -> void:
	_currency_label.text = "잔향 파편 %d · 소문시장 %s (%d)" % [GameState.get_echo_fragments(), GameState.get_faction_tier_label("rumor_market"), GameState.get_faction_relation("rumor_market")]
	_clear_children(_catalog_box)
	for category in ["permanent", "consumable"]:
		var header := Label.new()
		header.text = "영구 장비" if category == "permanent" else "소모품"
		_catalog_box.add_child(header)
		for item in GameState.get_market_catalog():
			if String(item.get("category", "")) != category:
				continue
			var item_id := String(item.get("id", ""))
			var button := Button.new()
			var hostile := GameState.get_faction_tier("rumor_market") == "hostile"
			button.text = "%s%s · %d 파편" % ["[거래 잠금] " if hostile else "", String(item.get("name", item_id)), GameState.get_market_price(item_id)]
			button.disabled = hostile
			button.pressed.connect(_select_item.bind(item_id))
			_catalog_box.add_child(button)
	if not _selected_item_id.is_empty():
		_select_item(_selected_item_id)
	_buy_button.disabled = GameState.get_faction_tier("rumor_market") == "hostile"
	if _buy_button.disabled:
		_status_label.text = "적대 관계에서는 소문시장이 거래를 거부합니다."


func _select_item(item_id: String) -> void:
	_selected_item_id = item_id
	var item := GameState.get_market_item(item_id)
	var owned := int(GameState.get_consumable_inventory().get(item_id, 0)) if String(item.get("category", "")) == "consumable" else (1 if GameState.has_unlocked_equipment(item_id) else 0)
	_detail_label.text = "%s\n\n%s\n\n가격: %d 잔향 파편\n보유: %d\n거래 단계: %s" % [String(item.get("name", item_id)), String(item.get("description", "")), GameState.get_market_price(item_id), owned, GameState.get_faction_tier_label("rumor_market")]


func _purchase_selected() -> void:
	if _selected_item_id.is_empty():
		_status_label.text = "구매할 상품을 먼저 선택하세요."
		return
	var result := GameState.purchase_market_item(_selected_item_id)
	_status_label.text = String(result.get("message", "거래 결과를 확인하지 못했습니다."))
	_refresh()


func _return_to_preparation() -> void:
	GameState.set_current_scene_path(GameState.SCENE_PREPARATION)
	GameState.save_game()
	get_tree().change_scene_to_file(GameState.SCENE_PREPARATION)


func _clear_children(parent: Node) -> void:
	for child in parent.get_children():
		child.queue_free()
