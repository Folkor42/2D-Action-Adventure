class_name StatsPanel extends PanelContainer

@onready var lvl_stat: Label = $VBoxContainer/LevelContainer/lvl_stat
@onready var xp_stat: Label = $VBoxContainer/XPContainer/xp_stat
@onready var atk_stat: Label = $VBoxContainer/ATKContainer/ATK_stat
@onready var def_stat: Label = $VBoxContainer/DEFContainer/DEF_stat


func _ready() -> void:
	PauseMenu.shown.connect ( update_stats )
	pass

func update_stats() -> void:
	var _p : Player = PlayerManager.player
	lvl_stat.text = str(_p.level)
	xp_stat.text = str(_p.xp) + "/" + str(PlayerManager.level_requirements[PlayerManager.player.level])
	atk_stat.text = str(_p.atk)
	def_stat.text = str(_p.def)
	pass
