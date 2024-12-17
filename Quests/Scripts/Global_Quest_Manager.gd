## Quest Manager - GLOBAL SCRIPT
extends Node

signal quest_updated ( q )

const QUEST_DATA_LOCATION : String = "res://Quests/"

var quests : Array [ Quest ]
var current_quests : Array = [{ title = "Recover Lost Magical Flute", is_complete = false, completed_steps = [''] },
{ title = "Long Quest", is_complete = false, compelted_steps = ['Step 1'] }]

func _ready() -> void:
	gather_quest_data()
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("test"):
		#print ( find_quest ( load ("res://Quests/Recover Lost Flute.tres") as Quest ) )
		#print (find_quest_by_title("Short Quest"))
		#print (get_quest_index_by_title("Recover Lost Magical Flute"))
		#print (get_quest_index_by_title("Short Quest"))
		print ( current_quests )
		update_quest("Short Quest")
		
		update_quest("Recover Lost Magical Flute", "Find the Magical Flute")
		
		update_quest("Long Quest", "", true)
		print ( current_quests )
	pass	
	
func gather_quest_data()->void:
	var quest_files : PackedStringArray = DirAccess.get_files_at(QUEST_DATA_LOCATION)
	quests.clear()
	for q in quest_files:
		# TODO add in validation that it is actually a quest file
		quests.append( load( QUEST_DATA_LOCATION + "/" + q) as Quest )
		pass
	print ("Quest count: ", quests.size() )
	pass

func update_quest(_title : String, _completed_step : String = "", is_complete : bool = false )->void:
	var quest_index : int = get_quest_index_by_title( _title )
	if quest_index == -1:
		var new_quest : Dictionary = { 
			title = _title, 
			is_complete = is_complete, 
			compelted_steps = []
		}
		if _completed_step != "":
			new_quest.completed_steps.append( _completed_step )
		current_quests.append( new_quest ) 
		quest_updated.emit( new_quest )
		
		# TODO Display Notification that quest was added
	else:
		var q = current_quests[ quest_index ]
		if _completed_step !="" and !q.completed_steps.has( _completed_step ):
			q.completed_steps.append( _completed_step )
			pass
		q.is_complete = is_complete
		quest_updated.emit (q)
		
		# TODO Display Notification updated or compelted.
		if q.is_complete == true:
			disperse_quest_rewards( find_quest_by_title( _title ) )
		
	pass
		
func disperse_quest_rewards( _q : Quest ) -> void:
	# Give XP and item rewards to player
	PlayerManager.reward_xp( _q.reward_xp )
	for i in _q.reward_items:
		PlayerManager.INVENTORY_DATA.add_item( i.item, i.quantity )
	pass
	
func find_quest( _quest : Quest ) -> Dictionary:
	for q in current_quests:
		if q.title.to_lower() == _quest.title.to_lower():
			return q
	return { title = "Not Found", is_complete = false, compelted_steps = [''] }
	
func find_quest_by_title( _title : String )->Quest:
	for q in quests:
		if q.title.to_lower() == _title.to_lower():
			return q
	return null
	
func get_quest_index_by_title( _title : String ) -> int:
	for i in current_quests.size():
		if current_quests[i].title.to_lower() == _title.to_lower():
			return i
	# Return -1 if not found
	return -1
	
func sort_quests()->void:
	pass
