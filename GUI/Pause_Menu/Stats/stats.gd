class_name StatsPanel extends PanelContainer

var inventory : InventoryData

@onready var lvl_stat: Label = %lvl_stat
@onready var xp_stat: Label = %xp_stat
@onready var atk_stat: Label = %ATK_stat
@onready var def_stat: Label = %DEF_stat
@onready var atk_change: Label = %ATK_change
@onready var def_change: Label = %DEF_change

func _ready() -> void:
	PauseMenu.shown.connect ( update_stats )
	PauseMenu.preview_stats_changed.connect( on_preview_stats_changed )
	inventory = PlayerManager.INVENTORY_DATA
	inventory.equipment_changed.connect ( update_stats )
	pass

func update_stats() -> void:
	var _p : Player = PlayerManager.player
	lvl_stat.text = str(_p.level)
	if _p.level < PlayerManager.level_requirements.size():
		xp_stat.text = str(_p.xp) + "/" + str(PlayerManager.level_requirements[PlayerManager.player.level])
	else:
		xp_stat.text = "MAX LVL"
	atk_stat.text = str(_p.atk + inventory.get_attack_bonus() )
	def_stat.text = str(_p.def + inventory.get_defense_bonus() )
	pass

func on_preview_stats_changed ( item : ItemData ) -> void:
	atk_change.text = ""
	def_change.text = ""
	
	if not item is EquipableItemData:
		return
	
	var equipment : EquipableItemData = item
	var attack_delta : int = inventory.get_attack_bonus_diff(equipment)
	var defense_delta : int = inventory.get_defense_bonus_diff(equipment)
	
	
	
	update_change_label (atk_change,attack_delta)
	update_change_label (def_change,defense_delta)
	
	pass

func update_change_label ( label : Label, value : int ) -> void:
	if value > 0:
		label.text = "+" + str( value )
		label.modulate = Color.LIGHT_GREEN
	elif value < 0:
		label.text = str( value )
		label.modulate = Color.INDIAN_RED
	pass
