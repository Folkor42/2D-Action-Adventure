@icon ("res://NPCs/Icons/npc_behavior.svg")
class_name NPCBehavior extends Node2D

var npc : NPC

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var p = get_parent()
	if p is NPC:
		npc = p as NPC
		npc.do_behavior_enabled.connect( start )
	pass # Replace with function body.

func start () -> void:
	pass
