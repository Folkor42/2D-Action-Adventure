class_name InventoryUI extends Control

const INVENTORY_SLOT =  preload("res://GUI/Pause_Menu/Inventory/inventory_slot.tscn")

var focus_index : int = 0

@export var data : InventoryData

func _ready() -> void:
	clear_inventory()
	PauseMenu.shown.connect( update_inventory )
	PauseMenu.hidden.connect( clear_inventory )
	data.changed.connect( on_inventory_changed )
	
	pass

func clear_inventory() -> void:
	for c in get_children():
		c.queue_free()
	pass
	
func update_inventory( i : int = 0) -> void:
	for s in data.slots:
		var new_slot = INVENTORY_SLOT.instantiate()
		add_child( new_slot )
		new_slot.slot_data = s
		new_slot.focus_entered.connect( item_focused )
	
	await get_tree().process_frame
	get_child( i ).grab_focus()
	pass

func on_inventory_changed() -> void:
	if PauseMenu.is_paused:
		clear_inventory()
		update_inventory( focus_index )
	pass

func item_focused() -> void:
	for i in get_child_count():
		if get_child( i ).has_focus():
			focus_index = i
			return
	pass
