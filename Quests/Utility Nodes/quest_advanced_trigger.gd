@tool
@icon ("res://Quests/Utility Nodes/Icons/quest_advance.png")
class_name QuestAdvancedTrigger extends QuestNode

@export_category( "Parent Signal Connection" )
@export var signal_name : String = ""

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	if $Sprite2D:
		$Sprite2D.queue_free()
	if signal_name != "":
		if get_parent().has_signal( signal_name ):
			get_parent().connect(signal_name, advance_quest)
	pass
	
func advance_quest()->void:
	if linked_quest == null:
		return
	await get_tree().process_frame
	var _title = linked_quest.title
	var _step : String = get_step()
	if _step == "N/A":
		_step = ""
	print ("Quest Advanced")
	QuestManager.update_quest(_title,_step,quest_complete)
	pass
	


func _on_dungeon_door_south_entered_from_here() -> void:
	pass # Replace with function body.
