class_name StatsPanel extends PanelContainer

@onready var lvl_stat: Label = %lvl_stat
@onready var xp_stat: Label = %xp_stat
@onready var atk_stat: Label = %ATK_stat
@onready var def_stat: Label = %DEF_stat
@onready var atk_change: Label = %ATK_change
@onready var def_change: Label = %DEF_change

func _ready() -> void:
	PauseMenu.shown.connect ( update_stats )
	pass

func update_stats() -> void:
	var _p : Player = PlayerManager.player
	lvl_stat.text = str(_p.level)
	if _p.level < PlayerManager.level_requirements.size():
		xp_stat.text = str(_p.xp) + "/" + str(PlayerManager.level_requirements[PlayerManager.player.level])
	else:
		xp_stat.text = "MAX LVL"
	atk_stat.text = str(_p.atk)
	def_stat.text = str(_p.def)
	pass
